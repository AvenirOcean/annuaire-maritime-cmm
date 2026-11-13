-- ============================================================
-- Mission Annuaire Maritime CMM x LP Raymond Néris — V2.2
-- Historisation des événements (suivi d'évolution prof)
-- À exécuter dans Supabase > SQL Editor > Run
-- ============================================================

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

-- Lecture : uniquement avec le code enseignant (Espace Prof)
drop policy if exists "lecture evenements code prof" on public.evenements;
create policy "lecture evenements code prof" on public.evenements
  for select to anon, authenticated
  using (lower(current_setting('request.headers', true)::json->>'x-prof-code') = 'cmm-prof-2026');
