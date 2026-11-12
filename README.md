# Annuaire Maritime de Martinique — Qualification de la base

Application pédagogique réalisée pour le **Cluster Maritime de Martinique (CMM)** avec le **Lycée Professionnel Raymond Néris (Le Marin)** : qualification de la base de 1 291 contacts de la filière maritime martiniquaise par les élèves de 1ère Bac Pro AGOrA.

## 🚀 Utilisation

L'application est **un seul fichier** : `index.html`. Aucune installation, aucun serveur, aucune dépendance.

1. **Ouvrir** : double-cliquez sur `index.html` (PC) ou ouvrez-le dans Chrome/Edge. Elle fonctionne aussi sur tablette et téléphone.
2. **Importer** : glissez-déposez le fichier Excel « Base à qualifier » (1 291 fiches) sur l'écran d'accueil. Un mode démo de 20 fiches fictives est disponible pour essayer.
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
