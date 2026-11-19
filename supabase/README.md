# Protection de l'application (Supabase)

## Objectif

Les élèves ne doivent pouvoir ni lire l'Espace Prof, ni exporter la base :
travail uniquement sur la plateforme, synchronisé via le serveur.
L'enseignant, lui, peut exporter le suivi des élèves (Excel/CSV) depuis
l'Espace Prof pour analyse — et chaque export est journalisé côté serveur.

## Ce qui a changé

- Le **code enseignant n'est plus dans le code client** (`index.html`) :
  il est vérifié côté serveur par la fonction edge `prof-data`.
- La table `evenements` **n'est plus lisible via l'API REST** (plus de
  policy SELECT — voir `supabase-evenements.sql`). Lecture uniquement via
  `prof-data` (clé service, côté serveur).
- **Côté élève, aucun export n'est possible** : les boutons « Export complet » /
  « Export ma sélection » ont été supprimés de `index.html`, et « Export Excel » /
  « Sauvegarde complète JSON » supprimés de `crm-cmm.html`. La fonction
  d'export générique a été retirée du JS élève (rien à cliquer, même en console).
- **Côté prof uniquement** : la modale Espace Prof (code vérifié côté serveur)
  propose « Export suivi (CSV) » et « Export suivi (Excel protégé) ».
  La feuille Excel générée porte `sheetProtection` (lecture seule ; sans mot
  de passe, car un mot de passe embarqué dans le JS client serait lisible —
  la vraie protection est que seul le prof peut générer le fichier).
- **Journal des exports** : table `exports_log` (voir `supabase-exports-log.sql`),
  écrite uniquement via `prof-data` à chaque export → nombre d'exports fiable
  (consultable avec action `log`).

## Déploiement

```bash
# 1. Secret du code enseignant (côté serveur uniquement, jamais dans le client)
#    À ROTATER : l'ancien code a été diffusé dans un message aux parents.
supabase secrets set PROF_CODE="NOUVEAU-CODE-PROF-LONG-ALEATOIRE"
# SUPABASE_URL et SUPABASE_SERVICE_ROLE_KEY sont déjà fournis automatiquement
# aux fonctions edge : ne jamais les mettre dans le code client.

# 2. Déployer la fonction edge qui sert l'Espace Prof
supabase functions deploy prof-data --no-verify-jwt

# 3. Appliquer le RLS renforcé et créer le journal des exports
#    Supabase > SQL Editor > Run :
#    - supabase-evenements.sql   (supprime la lecture REST de `evenements`)
#    - supabase-exports-log.sql  (table `exports_log`, aucun accès REST)
```

## Limites restantes (design)

- Le **code mission** (élèves) reste côté client : c'est le passe qui autorise
  l'écriture (INSERT) dans `saisies` / `evenements`. Toute personne ayant ce
  code peut écrire des saisies — c'est le fonctionnement prévu de la mission.
  Pour aller plus loin (comptes individuels, droits par élève), il faudrait
  Supabase Auth : à étudier si le besoin se confirme.
- La clé publishable Supabase dans le client est volontairement publique :
  la protection réelle est assurée par la RLS + la vérification serveur ci-dessus.
- La base (1 291 fiches) est embarquée dans le JS public de la mission :
  elle est considérée comme non sensible (données professionnelles publiques
  du secteur). Ce qui est protégé : l'Espace Prof, le journal, et l'export.
