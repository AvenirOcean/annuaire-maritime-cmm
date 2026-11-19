-- ============================================================
-- Mission Annuaire Maritime CMM x LP Raymond Néris — V3 (sécurisé)
-- Historisation des événements (suivi d'évolution prof)
-- À exécuter dans Supabase > SQL Editor > Run
-- ============================================================
-- SÉCURITÉ : `evenements` n'est PLUS lisible via l'API REST (aucune policy
-- SELECT). La lecture se fait UNIQUEMENT via la fonction edge `prof-data`
-- (clé service, code enseignant vérifié côté serveur — voir supabase/README.md).
-- Le code enseignant n'est plus présent dans le code client.

create table if not exists public.evenements (
  id bigint generated always as identity primary key,
  no_fiche text not null,
  auteur text not null default '',
  type text not null default 'saisie',
  points int not null default 0,
  horodatage timestamptz not null default now()
);

alter table public.evenements enable row level security;

-- Écriture : uniquement avec le code mission (élèves)
drop policy if exists "ecriture evenements code mission" on public.evenements;
create policy "ecriture evenements code mission" on public.evenements
  for insert to anon, authenticated
  with check (lower(current_setting('request.headers', true)::json->>'x-mission-code') = 'cmm-marin-2026');

-- Lecture : AUCUNE policy SELECT -> lecture interdite via REST (401/403).
-- L'ancienne policy "lecture evenements code prof" est supprimée :
-- l'Espace Prof passe par la fonction edge `prof-data` (service role).
drop policy if exists "lecture evenements code prof" on public.evenements;
