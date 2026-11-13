# Cahier des charges — Mission Annuaire Maritime (CMM × LP Raymond Néris)

**Version 2 — suite aux premiers retours utilisateurs · PositivBusiness SASU (Alexandrine MILESI, fondatrice) pour le Cluster Maritime de Martinique**

---

## 1. Contexte et acteurs

| Acteur | Rôle | Besoin principal |
|---|---|---|
| Élève (Terminale AGOrA) | Qualifie les fiches (téléphone, courriel, site, statut, source) | Outil simple, motivant, mobile |
| Enseignant / Prof | Encadre les groupes, suit l'avancement, anime la mission | **Voir tout, suivre l'évolution, animer des défis** |
| CMM (administrateur métier) | Propriétaire de la base, réceptionne la collecte | Suivi global, export consolidé, qualité des données |
| Administrateur technique | Gère la plateforme, les incidents, les évolutions | Supervision, FAQ, gestion des retours |

---

## 2. L'existant (inventaire de la V1 en production)

### 2.1 Application élève — https://avenirocean.github.io/annuaire-maritime-cmm/
- **Base embarquée** : 1 291 fiches intégrées (aucun fichier à télécharger), mode démo 20 fiches, bouton ♻️ Base CMM
- **Consultation** : recherche plein texte, filtres (secteur, priorité, statut, commune, plage de n° pour les groupes, actives seulement), tri
- **Carte** : Martinique géoréférencée (34 communes réelles + 6 secteurs), cercles proportionnels, couleur = secteur dominant, clic = filtrer
- **Fiche en édition** : formats contrôlés (téléphone, courriel, site), statut « Vérifié » bloqué sans date + source, sources autorisées, boutons Recherche express / Registre national, signalement de doublon (jamais de suppression ni création, colonnes CMM en lecture seule)
- **Synchronisation en ligne** : envoi instantané de chaque saisie vers la base sécurisée (Supabase), récupération du travail des autres groupes toutes les 20 s, indicateur 📡, code mission (CMM-MARIN-2026), aucune inscription élève, repli hors ligne (localStorage + export Excel)
- **Gamification** : points (+10 vérifié, +2 bonus, +3 documenté, +1 coordonnée), grades Mousse→Amiral, 9 badges, quête du jour, série 🔥, défi 10 minutes, confettis, podium des groupes, flux rapide (Ctrl+Entrée), profils élève (pseudo + emoji + statut, emojis sur la carte), mode sombre
- **Pédagogie** : guide intégré (11 sections), fiche élève imprimable

### 2.2 CRM du CMM — crm-cmm.html
Pipeline (Prospect → Cotisant), cotisations, contacts, interactions, relances, tags, notes, export Excel 30 colonnes, sauvegarde JSON

### 2.3 Transverse
- Page **Mentions légales · RGPD · Confidentialité** liée aux 3 outils
- **Logo CMM** officiel + favicon (emblème vague sur pastille bleue) partout
- Crédit fondatrice : PositivBusiness SASU — Alexandrine MILESI

### 2.4 Limites constatées (retours de terrain)
1. **Pas d'accès enseignant** : le prof ne voit que l'écran d'un poste, pas la classe entière
2. **Pas de suivi dans le temps** : on voit l'état, pas l'évolution (qui a fait quoi, quand, à quel rythme)
3. **Pas de défis prof ↔ élèves** : les enseignants veulent participer au challenge
4. **Pas de canal de retours** : pas de bouton FAQ / signaler un bug / proposer une amélioration
5. **Pas d'espace administrateur** : pas de vue globale technique ni de pilotage

---

## 3. Périmètre des améliorations (V2)

### 3.1 Espace Prof (« 👨‍🏫 Pilotage ») — priorité 1

**Accès** : même application, bouton « 👨‍🏫 Prof » ; authentification par **code enseignant** distinct du code mission (diffusé seulement aux profs et au CMM).

**Fonctions demandées :**
- **Tableau de bord classe en direct** : taux de vérification global, par groupe (plages de n°), par élève ; rafraîchissement 20 s comme les élèves
- **Classement live** : podium individuel (points, badges) et par groupe — projeté en classe pour motiver
- **Historique d'activité** : n dernières saisies de la classe (n° fiche, élève, statut, heure)
- **Vue « qui travaille où »** : répartition des élèves sur les plages de fiches (éviter les doublons d'effort)
- **Participation du prof au challenge** : le prof peut créer son propre profil « équipage » et jouer les défis (quête du jour, défi 10 min) ; son score apparaît au classement comme un concurrent

### 3.2 Suivi d'évolution (groupes et individuel) — priorité 1

- **Historisation** : chaque événement (saisie, badge, défi) est horodaté et stocké côté serveur (nouvelle table `evenements`)
- **Graphiques d'évolution** : courbe des fiches vérifiées par jour (classe, groupe, élève) ; vitesse de travail (fiches/heure de séance)
- **Fiche élève de suivi** : points cumulés, grades franchis, badges obtenus, série, participation aux défis
- **Fiche groupe** : avancement de sa plage de n° (ex. groupe A : 34/100), temps moyen par fiche, qualité (taux de fiches « À valider » ou « Introuvable » bien documentées)
- **Export prof** : impression/PDF du tableau de suivi de séance

### 3.3 Défis prof ↔ élèves — priorité 2

- **Défi flash lancé par le prof** : le prof choisit une durée (5/10/15 min) et un objectif (ex. « le plus de téléphones confirmés ») ; les élèves en sont notifiés dans l'app (bandeau + son)
- **Défi inter-groupes programmé** : objectif hebdomadaire affiché au tableau de bord (ex. « cette semaine : 100 fiches vérifiées, le groupe gagnant choisit la prochaine quête »)
- **Le prof joue aussi** : son score entre au classement (statut « 👨‍🏫 » distinct)

### 3.4 Bouton FAQ / Retours — priorité 2

Bouton « ❓ Aide & retours » visible en permanence dans l'app et le CRM :
- **FAQ** : questions fréquentes (formats, statuts, code mission, synchronisation) — contenu maintenu par le CMM
- **Signaler un bug** : formulaire court (description, fiche concernée, appareil) → table `retours`
- **Proposer une amélioration** : même formulaire, catégorie « idée »
- **Statut visible** : l'élève voit « reçu / en cours / traité » sur ses retours
- Côté admin : file de retours avec tri par type, statut et réponse

### 3.5 Espace Administrateur — priorité 2

**Accès** : code administrateur (CMM + admin technique uniquement).

**Fonctions :**
- **Vue globale** : santé de la synchronisation (nb d'envois, erreurs), nb d'appareils actifs, activité par jour
- **Modération** : voir toutes les saisies, corriger/annuler une saisie erronée (journalisée), gérer les retours FAQ
- **Gestion des accès** : rotation du code mission et du code enseignant (saisie nouvelle valeur, invalidation immédiate)
- **Pilotage qualité** : fiches « À valider » et doublons signalés, prêtes pour arbitrage CMM
- **Export consolidé** : Excel de la collecte complète à la demande (existant à refaire côté admin : bouton « Export collecte »)

---

## 4. Architecture technique

**Contraintes conservées** : aucune inscription élève, application monopage sur GitHub Pages, données dans Supabase (RLS), codes d'accès, RGPD.

### 4.1 Nouvelles tables Supabase

| Table | Contenu | Accès |
|---|---|---|
| `evenements` | no_fiche, auteur, type (saisie/badge/defi), points, horodatage | écriture : code mission ; lecture : code prof |
| `defis` | id, type, objectif, durée, créé_par, état, horodatage | écriture : code prof ; lecture : code mission |
| `retours` | id, auteur, type (bug/idee/question), texte, fiche?, statut, réponse, horodatage | écriture : code mission ; gestion : code admin |
| `parametres` | clé/valeur (codes actifs, quête courante, textes FAQ) | écriture : code admin |

### 4.2 Sécurité (RLS)
- Élèves (code mission) : écrivent leurs saisies/événements/retours, lisent les défis actifs
- Profs (code enseignant) : lisent tout, écrivent les défis
- Admin (code admin) : tout, y compris rotation des codes
- Les codes sont vérifiés dans les règles RLS via l'en-tête `X-Mission-Code` (mécanisme éprouvé en V1)

### 4.3 RGPD
Aucune donnée personnelle : pseudos libres non nominatifs, aucune donnée de navigation, hébergement inchangé (GitHub Pages + Supabase), page mentions légales mise à jour avec les nouveaux traitements.

---

## 5. Planning proposé

| Vague | Contenu | Effort estimé |
|---|---|---|
| V2.1 | Espace Prof : dashboard classe en direct + classement live + participation prof aux défis existants | ~2 jours |
| V2.2 | ✅ **Livré** — Historisation (table `evenements`, script `supabase-evenements.sql`) + graphiques d'évolution (courbe classe, top 5 élèves) dans l'Espace Prof + export suivi CSV | ~2 jours |
| V2.3 | Bouton FAQ/Retours + file admin + modération | ~1,5 jour |
| V2.4 | Défis flash prof ↔ élèves + défis inter-groupes programmés | ~2 jours |
| V2.5 | Espace administrateur complet (pilotage qualité, rotation des codes, export consolidé) | ~1,5 jour |

---

## 6. Critères d'acceptation

1. Le prof ouvre l'app, entre son code : il voit en direct l'avancement de tous les groupes sans rien installer.
2. Le prof crée son profil et lance un défi 10 min : son score apparaît au classement face aux élèves.
3. Un élève clique « ❓ », signale un bug : le prof/admin le voit dans la file, répond, l'élève voit la réponse.
4. Les courbes d'évolution montrent, jour par jour, la progression de chaque groupe et de chaque élève.
5. L'admin exporte la collecte consolidée en un clic et peut changer le code mission en cours d'année.
6. Aucune inscription élève ; RGPD et sécurité inchangés (RLS, codes, aucune donnée personnelle).
