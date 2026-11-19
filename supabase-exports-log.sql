-- ============================================================
-- Mission Annuaire Maritime CMM x LP Raymond Néris — V3 (sécurisé)
-- Journal des exports (suivi prof) — compteur fiable des exports
-- À exécuter dans Supabase > SQL Editor > Run
-- ============================================================
-- SÉCURITÉ : aucune policy pour anon/authenticated -> la table est
-- inaccessible via l'API REST. Seule la fonction edge `prof-data`
-- (clé service, code enseignant vérifié côté serveur) peut écrire
-- (action "export") et lire (action "log") ce journal.

create table if not exists public.exports_log (
  id bigint generated always as identity primary key,
  action text not null default 'export',
  detail text not null default '',
  horodatage timestamptz not null default now()
);

alter table public.exports_log enable row level security;
-- aucune policy : lecture/écriture REST interdites (service role uniquement)
