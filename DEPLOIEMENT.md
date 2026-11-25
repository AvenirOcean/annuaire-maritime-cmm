# Déploiement — mémo rapide

Tout le code est déjà mergé (`main`) et la branche de déploiement `app-online-v2` est prête.

## Sur un ordinateur : UNE commande
```bash
git pull
./deploy.sh
```
Le script fait tout : lien Supabase, **génère le nouveau code prof** (stocké dans `~/.cmm-prof-code.txt`, chmod 600 — à donner de vive voix aux profs), déploie la fonction `prof-data`, vérifie qu’elle répond 405, prépare la branche `app-online-v2`, et lance `mistral apps deploy`.

⚠️ Le script pause pour le SQL : colle **une seule fois** le contenu de `supabase/apply-all.sql` dans Supabase → SQL Editor → Run, puis réponds `o`.

## Sur le téléphone : 30 s
Rendre le dépôt privé : github.com → dépôt `annuaire-maritime-cmm` → Settings → Danger Zone → Change visibility → **Private**
(ou sur ordi : `gh repo edit AvenirOcean/annuaire-maritime-cmm --visibility private --accept-visibility-change-consequences`)

⚠️ Si les liens `avenirocean.github.io/...` (documents parents) doivent rester publics : mets les PDF/HTML dans un **dépôt public séparé, sans aucun code**.

## Après déploiement
- Élèves : tableau de bord → « Classement de la classe » (individuel #N + 6 équipes), aucun export.
- Profs : ☰ → 👨‍🏫 Espace Prof → **nouveau code** → classement live + export Excel protégé (journalisé).
- Données vérifiées : 272 saisies enregistrées depuis le 16/11, rien perdu côté serveur.
