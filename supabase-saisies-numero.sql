-- ============================================================
-- Mission Annuaire Maritime CMM x LP Raymond Néris
-- Attribution automatique des plages individuelles
-- À exécuter dans Supabase > SQL Editor > Run
-- ============================================================

-- Le n° d'élève (1 à 24) attribué automatiquement à la création
-- du profil est synchronisé avec chaque saisie. 0 = enseignant
-- (joue les défis sans prendre de plage de fiches).
alter table public.saisies
  add column if not exists numero int not null default 0;
