# Guide d'utilisation — HospiConnect Maturité

Ce guide explique comment utiliser l'application de collecte et de pilotage des indicateurs de maturité HospiConnect, basée sur le référentiel ANS v1.0.

---

## Table des matières

1. [Vue d'ensemble](#1-vue-densemble)
2. [Navigation](#2-navigation)
3. [Espace Administration](#3-espace-administration)
   - 3.1 [Connexion](#31-connexion)
   - 3.2 [Gérer les établissements](#32-gérer-les-établissements)
   - 3.3 [Gérer les campagnes](#33-gérer-les-campagnes)
   - 3.4 [Suivre les sessions](#34-suivre-les-sessions)
   - 3.5 [Saisir les indicateurs GROUPE](#35-saisir-les-indicateurs-groupe)
4. [Espace Référent](#4-espace-référent)
   - 4.1 [S'identifier](#41-sidentifier)
   - 4.2 [Naviguer par domaine](#42-naviguer-par-domaine)
   - 4.3 [Saisir un indicateur](#43-saisir-un-indicateur)
   - 4.4 [Types d'indicateurs](#44-types-dindicateurs)
   - 4.5 [Indicateurs GROUPE (lecture seule)](#45-indicateurs-groupe-lecture-seule)
   - 4.6 [Indicateurs inversés](#46-indicateurs-inversés)
   - 4.7 [Indicateurs par typologie](#47-indicateurs-par-typologie)
   - 4.8 [Soumettre la session](#48-soumettre-la-session)
5. [Dashboard](#5-dashboard)
   - 5.1 [Vue établissement](#51-vue-établissement)
   - 5.2 [Vue groupe consolidée](#52-vue-groupe-consolidée)
6. [Comprendre le score de maturité](#6-comprendre-le-score-de-maturité)

---

## 1. Vue d'ensemble

L'application couvre le cycle complet d'une campagne d'évaluation :

```
Admin                          Référent établissement          Admin / Dashboard
  │                                    │                              │
  ├─ Créer les établissements           │                              │
  ├─ Créer la campagne                  │                              │
  ├─ Ouvrir la campagne ──────────────►│                              │
  ├─ Saisir les indicateurs GROUPE      │                              │
  │                              ┌─────┘                              │
  │                              ├─ S'identifier                      │
  │                              ├─ Saisir domaine par domaine         │
  │                              └─ Soumettre ───────────────────────►│
  │                                                             ┌──────┘
  │                                                             ├─ Vue établissement
  │                                                             └─ Vue groupe
```

**Prérequis** : l'application doit être démarrée (voir `README.md`) et la base de données accessible. La barre latérale affiche un message d'erreur si la connexion échoue.

---

## 2. Navigation

La barre latérale (toujours visible) donne accès aux trois espaces :

| Bouton | Espace | Accès |
|---|---|---|
| 📝 Formulaire référent | Saisie des indicateurs | Libre |
| 📊 Dashboard | Consultation des scores | Libre (sessions soumises uniquement) |
| ⚙️ Administration | Gestion et paramétrage | Mot de passe requis |

En bas de la barre latérale, une info-bulle affiche la session référent active (établissement, campagne, nom du référent) si une session est en cours.

---

## 3. Espace Administration

### 3.1 Connexion

1. Cliquer sur **⚙️ Administration** dans la barre latérale.
2. Saisir le mot de passe administrateur (défini dans la variable d'environnement `ADMIN_PASSWORD`).
3. Cliquer sur **Se connecter**.

Une fois connecté, la mention **Admin connecté** apparaît dans la barre latérale. La déconnexion se fait via le bouton **Se déconnecter** en haut de la page Administration.

---

### 3.2 Gérer les établissements

Onglet **Établissements**.

#### Créer un établissement

1. Remplir les champs **Code** (ex : `MAISON-A`) et **Nom** dans le formulaire de création.
2. Cliquer sur **Créer l'établissement**.

L'établissement est créé avec le statut **Actif** par défaut.

#### Activer / désactiver un établissement

Dans l'expander **Activer / désactiver un établissement** :
1. Sélectionner l'établissement dans la liste déroulante.
2. Cliquer sur **Activer** ou **Désactiver**.

> Un établissement désactivé n'apparaît plus dans le formulaire référent ni dans les sélecteurs de campagne. Il ne peut pas être désactivé s'il possède une session **EN_COURS** sur une campagne ouverte.

---

### 3.3 Gérer les campagnes

Onglet **Campagnes**.

#### Créer une campagne

1. Saisir le libellé de la campagne (ex : `S1 2026`).
2. Cliquer sur **Créer la campagne**.

La campagne est créée avec le statut **PLANIFIEE**.

#### Cycle de vie d'une campagne

| Statut | Description | Action disponible |
|---|---|---|
| `PLANIFIEE` | En préparation | Ouvrir |
| `OUVERTE` | Référents peuvent saisir | Fermer |
| `FERMEE` | Collecte terminée | — |

- **Ouvrir** : active la campagne pour la saisie des référents.
- **Fermer** : clôture la collecte. Les sessions encore en cours sont bloquées.

> Une seule campagne peut être **OUVERTE** à la fois. Tenter d'en ouvrir une seconde échoue avec un message d'erreur.

---

### 3.4 Suivre les sessions

Onglet **Sessions**.

Ce tableau liste toutes les sessions toutes campagnes confondues (ou filtrées par campagne) avec :
- Le nom du référent, l'établissement et la campagne
- Le statut : `EN_COURS` ou `SOUMISE`
- Le taux d'avancement (indicateurs ÉTABLISSEMENT remplis / total)
- Un score global indicatif pour les sessions soumises

Un **export CSV** est disponible pour extraire la liste complète.

---

### 3.5 Saisir les indicateurs GROUPE

Onglet **Indicateurs Groupe**.

Les indicateurs de porteur **GROUPE** sont des indicateurs communs à tous les établissements (par exemple, les taux de couverture des systèmes centraux gérés par la DSI). Ils doivent être saisis **une seule fois par campagne** par l'administrateur.

1. Sélectionner la campagne dans la liste déroulante.
2. Pour chaque indicateur GROUPE listé :
   - Choisir le **palier** (0 à 4) via le curseur.
   - Ajouter un **commentaire** optionnel.
3. Les valeurs sont sauvegardées immédiatement à chaque modification.

> Ces valeurs sont ensuite affichées en lecture seule dans le formulaire de chaque référent et contribuent au score global de leur établissement.

---

## 4. Espace Référent

### 4.1 S'identifier

1. Cliquer sur **📝 Formulaire référent**.
2. Remplir le formulaire d'identification :
   - **Campagne** : choisir la campagne en cours (seules les campagnes `OUVERTE` sont proposées).
   - **Établissement** : choisir son établissement dans la liste.
   - **Nom du référent** : saisir son prénom et nom.
3. Cliquer sur **Créer / reprendre ma session**.

Si une session existe déjà pour cette combinaison (établissement + campagne + nom), elle est **reprise** avec toutes les réponses déjà saisies. Sinon, une nouvelle session est créée.

> La session reste active tant que la fenêtre du navigateur est ouverte. Toutes les réponses sont sauvegardées en base au fur et à mesure — il est possible de fermer et reprendre plus tard sans perdre de données.

---

### 4.2 Naviguer par domaine

Le référentiel ANS est structuré en **5 domaines**. La saisie se fait domaine par domaine via les onglets affichés en haut de la page.

Chaque onglet affiche :
- Un badge de statut : ✅ Complet / 🟡 En cours / ⬜ Non commencé
- Le nombre d'indicateurs remplis sur le total du domaine

Une **barre de progression globale** en haut indique l'avancement total (indicateurs ÉTABLISSEMENT uniquement).

> Les indicateurs de porteur **GROUPE** ne comptent pas dans la progression du référent : ils sont la responsabilité de l'administrateur.

---

### 4.3 Saisir un indicateur

Chaque indicateur est présenté avec :
- Son **code** (ex : `PROC-01A`) et son **titre**
- Sa **définition**, son **périmètre** et son **objectif** (dépliables)
- Les **descriptions des paliers 0 à 4** pour guider la notation
- Un **curseur de saisie** (select slider) de 0 à 4
- Un champ **commentaire** optionnel

La valeur est sauvegardée en base **immédiatement** après chaque modification du curseur ou du commentaire. Aucune action de validation intermédiaire n'est nécessaire.

---

### 4.4 Types d'indicateurs

Chaque indicateur porte un badge de type :

| Badge | Type | Signification |
|---|---|---|
| `PROCESS` | Processus | Indicateur de maturité des processus opérationnels |
| `COUVERTURE` | Couverture | Taux de déploiement d'un dispositif |
| `PILOTAGE` | Pilotage | Indicateur de suivi et de gouvernance |
| `GOUVERNANCE` | Gouvernance | Dispositifs de décision et d'organisation |

Le type n'influe pas sur la saisie mais permet de comprendre la nature de l'évaluation.

---

### 4.5 Indicateurs GROUPE (lecture seule)

Les indicateurs portant le badge **GROUPE** (fond gris) sont pré-remplis par l'administrateur. Ils sont affichés à titre informatif mais **ne peuvent pas être modifiés** par le référent.

Si la valeur n'a pas encore été saisie par l'administrateur, l'indicateur affiche un message "Valeur non encore renseignée par la DSI" et est exclu du calcul de score jusqu'à sa saisie.

---

### 4.6 Indicateurs inversés

Certains indicateurs portent le badge **INVERSÉ**. Pour ces indicateurs de risque, l'échelle est inversée :

| Palier | Signification |
|---|---|
| 0 | Situation la **plus risquée** / la moins maîtrisée |
| 4 | Situation la **plus sûre** / la mieux maîtrisée |

L'interface signale visuellement ce comportement pour éviter les erreurs de notation.

---

### 4.7 Indicateurs par typologie

Deux indicateurs (`COUV-22D` et `COUV-22F`) nécessitent une saisie **séparée par catégorie professionnelle** :

- **Médecins**
- **IDE** (Infirmiers Diplômés d'État)
- **Autres professionnels**

Chaque catégorie dispose de son propre curseur 0–4. Le score de l'indicateur est la **moyenne des trois valeurs**. Les trois valeurs doivent être renseignées pour que l'indicateur contribue au score.

---

### 4.8 Soumettre la session

Lorsque **tous les indicateurs ÉTABLISSEMENT** de tous les domaines sont renseignés, un bouton **Soumettre ma session** devient disponible en bas de page.

1. Vérifier que la barre de progression affiche **100 %**.
2. Cliquer sur **Soumettre ma session**.
3. Confirmer la soumission dans la boîte de dialogue.

La session passe en statut **SOUMISE**. Elle n'est plus modifiable et devient visible dans le Dashboard.

> Si tous les indicateurs ne sont pas encore remplis, le bouton de soumission est désactivé avec un message indiquant le nombre d'indicateurs manquants.

---

## 5. Dashboard

Le Dashboard est accessible librement depuis la barre latérale. Il affiche uniquement les sessions au statut **SOUMISE**.

---

### 5.1 Vue établissement

1. Sélectionner une **campagne** dans le premier sélecteur.
2. Sélectionner un **établissement** dans le second sélecteur.
3. Si plusieurs référents ont soumis pour le même établissement sur la même campagne, choisir la session souhaitée.

Le tableau de bord affiche :

| Élément | Description |
|---|---|
| **Score global** | Moyenne de tous les indicateurs renseignés (sur 4) |
| **Graphique radar** | Score par domaine sur 5 axes |
| **Tableau par rubrique** | Score, nombre d'indicateurs répondus / total par rubrique |
| **Tableau détaillé** | Valeur indicateur par indicateur avec commentaires |
| **Export CSV** | Extraction complète des données de la session |

**Code couleur des scores** :

| Couleur | Plage | Interprétation |
|---|---|---|
| 🔴 Rouge | < 1 / 4 | Maturité initiale |
| 🟠 Orange | 1 – 2 / 4 | Maturité en développement |
| 🟡 Jaune | 2 – 3 / 4 | Maturité définie |
| 🟢 Vert | ≥ 3 / 4 | Maturité maîtrisée |

---

### 5.2 Vue groupe consolidée

Onglet **Vue groupe** dans le Dashboard.

Cette vue compare tous les établissements ayant soumis sur une campagne donnée.

| Élément | Description |
|---|---|
| **Tableau de synthèse** | Score par domaine pour chaque établissement, colonnes côte à côte |
| **Graphique en barres** | Comparaison visuelle des scores par domaine |
| **Alertes** | Indicateurs dont la moyenne groupe est inférieure à un seuil configurable |
| **Export CSV** | Tableau complet multi-établissements |

> Pour afficher des données, au moins une session doit être en statut **SOUMISE** pour la campagne sélectionnée.

---

## 6. Comprendre le score de maturité

Le score est calculé comme la **moyenne arithmétique des paliers renseignés**, exprimé sur une échelle de **0 à 4**.

### Règles de calcul

| Situation | Comportement |
|---|---|
| Indicateur non renseigné | **Exclu** du calcul (ne compte pas comme 0) |
| Indicateur GROUPE non saisi par l'admin | **Exclu** jusqu'à saisie |
| Indicateur `has_typologies` (COUV-22D/F) | Contribue avec la **moyenne des typologies** seulement si les 3 sont renseignées |
| Indicateur inversé | La valeur du palier est utilisée telle quelle dans la moyenne |

### Niveaux de score

| Score | Niveau ANS |
|---|---|
| 0 – 0,9 | **Niveau 0** — Inexistant ou non maîtrisé |
| 1 – 1,9 | **Niveau 1** — Initial / ad hoc |
| 2 – 2,9 | **Niveau 2** — Reproductible / défini |
| 3 – 3,9 | **Niveau 3** — Maîtrisé / mesuré |
| 4 | **Niveau 4** — Optimisé |

### Périmètres de calcul disponibles

- **Score global** : tous les indicateurs renseignés de la session
- **Score par domaine** : indicateurs du domaine considéré
- **Score par rubrique** : indicateurs de la rubrique considérée

Les scores sont recalculés à chaque consultation du Dashboard (pas de mise en cache au niveau applicatif pour les scores).
