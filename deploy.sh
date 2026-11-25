#!/usr/bin/env bash
# ============================================================
# Déploiement complet de l'app Annuaire CMM (une seule commande)
#   ./deploy.sh
# Prérequis : supabase CLI + mistral CLI + gh CLI installés,
# et une connexion Internet. Aucun secret n'est écrit dans ce
# script : le code prof est généré localement et stocké dans
# ~/.cmm-prof-code.txt (chmod 600).
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

PROJECT_REF="gjbglgegjlfhwkeniaal"   # projet Supabase de l'app (dans index.html)
CODE_FILE="$HOME/.cmm-prof-code.txt"

echo "== 1/5 Supabase : lien projet + secret + fonction edge =="
command -v supabase >/dev/null 2>&1 || { echo "Installe d'abord le CLI : npm i -g supabase  (ou brew install supabase/tap/supabase)"; exit 1; }
supabase link --project-ref "$PROJECT_REF" 2>/dev/null || echo "(projet déjà lié, on continue)"

if [ ! -s "$CODE_FILE" ]; then
  umask 077
  openssl rand -base64 24 > "$CODE_FILE"
  echo ">> Nouveau code prof généré et enregistré dans $CODE_FILE (chmod 600)."
  echo ">> Donne-le DE VIVE VOIX aux profs uniquement. Ne le colle nulle part."
fi
supabase secrets set PROF_CODE="$(cat "$CODE_FILE")"
supabase functions deploy prof-data --no-verify-jwt

CODE_HTTP=$(curl -s -o /dev/null -w '%{http_code}' "https://$PROJECT_REF.supabase.co/functions/v1/prof-data")
echo ">> Test fonction prof-data : HTTP $CODE_HTTP (attendu 405 ; 404 = déploiement échoué)"
[ "$CODE_HTTP" = "405" ] || { echo "!! La fonction ne répond pas 405 — vérifie 'supabase functions list' et 'supabase secrets list'."; exit 1; }

echo "== 2/5 SQL (une seule fois, dans Supabase > SQL Editor) =="
echo ">> Colle le contenu de supabase/apply-all.sql dans SQL Editor puis Run."
read -r -p "SQL appliqué dans le dashboard ? [o/N] " ans
[ "$ans" = "o" ] || [ "$ans" = "O" ] || { echo "OK, fais-le plus tard puis relance ./deploy.sh"; }

echo "== 3/5 Branche de déploiement =="
git checkout app-online-v2
git pull --ff-only

echo "== 4/5 App Mistral =="
command -v mistral >/dev/null 2>&1 || { echo "Installe d'abord le CLI mistral (mistral.ai)"; exit 1; }
mistral apps list >/dev/null 2>&1 || mistral login
mistral apps deploy

echo "== 5/5 Vérifications =="
echo -n ">> Visibilité du dépôt GitHub : "
gh api repos/AvenirOcean/annuaire-maritime-cmm --jq '.visibility'
echo ">> Si 'public', rends-le privé maintenant :"
echo "     gh repo edit AvenirOcean/annuaire-maritime-cmm --visibility private --accept-visibility-change-consequences"
echo "     (ou depuis le téléphone : github.com → dépôt → Settings → Danger Zone → Private)"
echo "== Terminé. =="
