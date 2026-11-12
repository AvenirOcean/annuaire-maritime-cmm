# Annuaire Maritime de Martinique — Qualification de la base

Application pédagogique réalisée pour le **Cluster Maritime de Martinique (CMM)** avec le **Lycée Professionnel Raymond Néris (Le Marin)** : qualification de la base de 1 291 contacts de la filière maritime martiniquaise par les élèves de Terminale AGOrA.

## 🚀 Utilisation

L'application est **un seul fichier** : `index.html`. Aucune installation, aucun serveur, aucune dépendance.

1. **Ouvrir** : double-cliquez sur `index.html` (PC) ou ouvrez-le dans Chrome/Edge. Elle fonctionne aussi sur tablette et téléphone.
2. **Travailler immédiatement** : la base des 1 291 fiches du CMM est **déjà intégrée** dans l'application — aucun téléchargement n'est nécessaire pour commencer. Le bouton « Mettre à jour (Excel/CSV) » sert uniquement si le CMM fournit une nouvelle version du fichier, ou pour fusionner le travail d'un camarade.
3. **Travailler** : filtrez la liste, ouvrez une fiche, vérifiez les coordonnées (boutons Recherche express / Registre national), saisissez, passez le statut à « Vérifié » avec date + source.
4. **Échanger avec le CMM** : bouton « Export complet » → fichier Excel à la structure identique à l'import.

## 👤 Profils élèves et récompenses

- Chaque élève crée son profil (pseudo + emoji + statut) via le bouton « 👤 Élève ».
- Chaque fiche « Vérifiée » fait apparaître son emoji sur la carte de la Martinique, sur la commune concernée.
- Points, grades maritimes (Mousse → Amiral) et badges motivent la complétude ; le tableau de bord affiche le classement de l'équipage du poste.

## 💾 Où sont stockées les données ?

**Uniquement dans le navigateur** (localStorage) : aucune donnée n'est envoyée sur Internet. Chaque poste/appareil garde son propre travail — le fichier exporté sert de pont entre postes (l'import fusionne les saisies sans rien écraser). Ne pas utiliser la navigation privée.

## 🌐 Mise en ligne optionnelle (GitHub Pages)

Pour que les élèves ouvrent l'application par simple URL :

1. Sur GitHub : **Settings → Pages** ;
2. Source : *Deploy from a branch* → branche `main`, dossier `/ (root)` ;
3. L'application sera servie sur `https://avenirocean.github.io/annuaire-maritime-cmm/`.

Les données saisies restent dans le navigateur de chaque élève, même en version hébergée.

## ✅ Règles métier garanties

- Aucune création ni suppression de fiche ; colonnes CMM en lecture seule (corrections en Observations).
- Statut « Vérifié » bloqué sans date + source de vérification.
- Validation des formats : téléphone (+596/0596/0696…), email (minuscules, avertissement sur adresses personnelles), site (https:// ajouté automatiquement).
- Signalement de doublons noté en Observations, sans fusion ni suppression.
- Export strictement conforme à la structure importée (21 colonnes, feuille « Base à qualifier »).

## 🧭 CRM du Cluster Maritime (usage CMM)

Le fichier **`crm-cmm.html`** est un CRM complet, hors ligne, destiné au CMM (pas aux élèves). Il s'appuie sur la base qualifiée :

1. Ouvrez `crm-cmm.html` (ou `https://avenirocean.github.io/annuaire-maritime-cmm/crm-cmm.html`).
2. Importez le fichier Excel **qualifié par les élèves** (structure « Base à qualifier ») : les 1 291 organisations deviennent les fiches du CRM (priorité 1 → « Cotisant », structures introuvables → « Inactif », autres → « Prospect »).
3. Gérez chaque organisation : pipeline de prospection (Prospect / À contacter / En discussion / Cotisant / Inactif), cotisations (année, montant), contacts nominatifs, historique des interactions (appels, emails, rendez-vous…), relances planifiées, étiquettes et notes.
4. Tableau de bord : compteurs, répartition du pipeline, relances en retard/sous 7 jours, dernières interactions.

**Sauvegardes** : automatique dans le navigateur ; « Sauvegarde complète (JSON) » pour tout emporter d'un poste à l'autre (« Restaurer une sauvegarde ») ; « Export Excel » produit la base (21 colonnes) enrichie de 9 colonnes CRM. Ré-importer une nouvelle version de la base conserve tout le travail CRM (fusion par n° de fiche).
