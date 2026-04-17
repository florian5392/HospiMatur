-- ============================================================
-- HOSPICONNECT - INITIALISATION DU RÉFÉRENTIEL ANS
-- Version : 1.0
-- Date    : 2026-04-15
-- Source  : Indicateurs de maturité Identification Electronique v1.0
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- SECTION 1 : DOMAINES
-- ============================================================

INSERT INTO domaines (code, libelle, ordre) VALUES
('DOM-01', 'Cycle de vie des identités',            1),
('DOM-02', 'Services numériques',                   2),
('DOM-03', 'Droits et accès des identités',         3),
('DOM-04', 'Moyens d\'identification électronique', 4),
('DOM-05', 'Gouvernance & Sensibilisation',         5);


-- ============================================================
-- SECTION 2 : RUBRIQUES
-- ============================================================

INSERT INTO rubriques (id_domaine, code, libelle, description, ordre) VALUES
-- DOM-01
(1, 'RUB-01', 'Référencement des identités',
 'Comprendre comment est répertoriée l\'identité du professionnel et si ce processus couvre l\'ensemble des professionnels quelle que soit la nature de leur contrat.', 1),
(1, 'RUB-02', 'Gestion du cycle de vie des identités professionnelles',
 'Identifier si la gestion du cycle de vie de l\'identité est maîtrisée au travers d\'une procédure couvrant l\'ensemble des étapes depuis l\'arrivée jusqu\'à la sortie du professionnel.', 2),
(1, 'RUB-03', 'Gestion des comptes',
 'Comprendre les pratiques liées à l\'attribution des comptes informatiques et déterminer si chaque identité dispose d\'un compte nominatif dédié.', 3),
(1, 'RUB-04', 'Outillage IAM',
 'Identifier si la structure dispose d\'une solution IAM permettant d\'industrialiser le cycle de vie des identités et le provisioning.', 4),
-- DOM-02
(2, 'RUB-05', 'Inventaire & qualification des services numériques',
 'Disposer d\'un cadre pour recenser les services numériques, définir les critères de qualification et piloter l\'évolution du périmètre dans le temps.', 1),
(2, 'RUB-06', 'Cartographie des modes d\'authentification',
 'Cartographier les modes d\'authentification disponibles et la compatibilité des services avec la délégation d\'authentification.', 2),
-- DOM-03
(3, 'RUB-07', 'Gestion des habilitations applicatives',
 'Évaluer si la structure met en œuvre une gestion maîtrisée des habilitations et des accès applicatifs.', 1),
(3, 'RUB-08', 'Mode d\'authentification multi-facteurs (MFA)',
 'Évaluer si la structure a mis en place des mécanismes d\'authentification multi-facteurs pour sécuriser l\'accès aux services numériques.', 2),
(3, 'RUB-09', 'eSSO',
 'Évaluer si la structure utilise un eSSO comme solution transitoire dans l\'attente d\'une trajectoire cible de délégation d\'authentification.', 3),
(3, 'RUB-10', 'Délégation d\'authentification au fournisseur d\'identité local',
 'Évaluer si la structure a mis en place ou prévoit de déployer une délégation d\'authentification vers un fournisseur d\'identité local.', 4),
(3, 'RUB-11', 'Délégation d\'authentification à Pro Santé Connect',
 'Évaluer si la structure a mis en place ou prévoit de déployer une délégation d\'authentification vers PSC.', 5),
(3, 'RUB-12', 'Raccordement FI Tiers PSC',
 'Évaluer si la structure dispose d\'un fournisseur d\'identité local reconnu comme FI tiers de confiance par Pro Santé Connect.', 6),
-- DOM-04
(4, 'RUB-13', 'Conformité aux cadres réglementaires eIDAS / PGSSI-S-RIE',
 'Vérifier si les MIE déjà en place sont conformes aux exigences des référentiels en vigueur.', 1),
(4, 'RUB-14', 'Trajectoire de déploiement des MIE',
 'Identifier la trajectoire mise en place par la structure concernant les Moyens d\'Identification Électronique.', 2),
-- DOM-05
(5, 'RUB-15', 'Sensibilisation',
 'Identifier si une conduite du changement autour des services numériques a été mise en place et est alimentée.', 1),
(5, 'RUB-16', 'Gouvernance et Stratégie',
 'Identifier si l\'identité électronique des professionnels est intégrée dans les instances de pilotage stratégique.', 2);


-- ============================================================
-- SECTION 3 : POINTS CLÉS
-- ============================================================

INSERT INTO points_cles (id_rubrique, numero, libelle, ordre) VALUES
-- RUB-01
(1,  1, 'Centralisation des identités des professionnels dans un répertoire de référence (AD, IAM, RH)', 1),
-- RUB-02
(2,  2, 'Création des identités professionnelles', 1),
(2,  3, 'Association de l\'identifiant RPPS à l\'identité locale des professionnels', 2),
(2,  4, 'Désactivation ou suppression systématique des accès à la fin de l\'activité', 3),
-- RUB-03
(3,  5, 'Usage de comptes génériques (non nominatifs) pour l\'accès aux services numériques', 1),
(3,  6, 'Réalisation d\'une revue régulière des comptes utilisateurs', 2),
-- RUB-04
(4,  7, 'Disponibilité d\'une solution d\'IAM pour outiller la gestion du cycle de vie des identités et le provisioning', 1),
-- RUB-05
(5,  8, 'Inventaire et qualification des services numériques', 1),
-- RUB-06
(6,  9, 'Cartographie des modes d\'authentification des services numériques', 1),
(6, 10, 'Compatibilité avec la délégation d\'authentification au fournisseur d\'identité local', 2),
(6, 11, 'Compatibilité avec la délégation d\'authentification à Pro Santé Connect', 3),
-- RUB-07
(7, 12, 'Gestion des accès aux services numériques via une matrice d\'habilitation fondée sur les profils métiers ou rôles', 1),
(7, 13, 'Revue périodique des habilitations', 2),
-- RUB-08
(8, 14, 'Mise en place d\'une authentification multifacteur pour l\'accès aux services numériques', 1),
(8, 15, 'Mise en place d\'une authentification multifacteur pour les comptes à privilège', 2),
-- RUB-09
(9, 16, 'Mise en place d\'une fonctionnalité d\'eSSO comme solution transitoire', 1),
-- RUB-10
(10, 17, 'Mise en place d\'une délégation d\'authentification des services numériques vers un fournisseur d\'identité local', 1),
-- RUB-11
(11, 18, 'Mise en place du mode d\'authentification via Pro Santé Connect', 1),
-- RUB-12
(12, 19, 'Disponibilité d\'un fournisseur d\'identité local reconnu comme FI tiers de confiance par Pro Santé Connect', 1),
-- RUB-13
(13, 20, 'Prise en compte des référentiels réglementaires applicables à l\'identification électronique', 1),
(13, 21, 'Conformité des schémas d\'identification électronique au RIE PGSSI-S', 2),
-- RUB-14
(14, 22, 'Choix et déploiement de MIE conformes à la PGSSI-S-RIE pour l\'accès aux services numériques en santé', 1),
(14, 23, 'Compatibilité des MIE avec l\'authentification via Pro Santé Connect', 2),
(14, 24, 'Choix et déploiement de MIE MFA pour l\'accès aux services numériques critiques locaux hors santé', 3),
-- RUB-15
(15, 25, 'Existence d\'un programme de sensibilisation continue aux enjeux de sécurité des services numériques', 1),
(15, 26, 'Organisation de campagnes d\'information sur les services numériques', 2),
(15, 27, 'Mise en place d\'un dispositif de remontée des retours utilisateurs et incidents', 3),
-- RUB-16
(16, 28, 'Intégration de la gestion de l\'identité électronique dans les instances de pilotage stratégique', 1);


-- ============================================================
-- SECTION 4 : INDICATEURS
-- Format : (id_point_cle, code, lettre, titre, definition, perimetre, objectif, type, mode_saisie, inverse, has_typologies, porteur)
-- ============================================================

INSERT INTO indicateurs (id_point_cle, code, lettre, titre, definition, perimetre, objectif, type, mode_saisie, inverse, has_typologies, porteur) VALUES

-- -------------------------------------------------------
-- POINT CLÉ 01
-- -------------------------------------------------------
(1, 'PROC-01A', 'A',
 'Répertoire(s) des identités professionnelles',
 'Existence et maturité d\'un cadre où un répertoire est défini pour créer et mettre à jour les identités des professionnels, internes comme externes, nécessitant un accès aux services numériques.',
 'Identités "personnes" (internes + externes) ; AD/IAM/RH ; périmètre accès SIH/numérique.',
 'Capacité de la structure à gouverner l\'identité professionnelle via un référentiel maître.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(1, 'PROC-01B', 'B',
 'Répertoire défini comme source de vérité des identités professionnelles',
 'Existence et maturité d\'un cadre par lequel un répertoire est explicitement défini comme source de vérité pour la création, la mise à jour et la fiabilisation des identités professionnelles.',
 'Identités professionnelles ; répertoire(s) (AD/IAM/RH) ; professionnels nécessitant un accès au SIH.',
 'Capacité à définir un répertoire comme source de vérité pour les identités professionnelles.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(1, 'COUV-01C', 'C',
 'Couverture du référencement des professionnels dans le répertoire central',
 'Proportion des professionnels nécessitant un accès aux services numériques et effectivement référencés dans le répertoire central.',
 'Professionnels nécessitant un accès au SIH ; populations internes et externes, hors comptes techniques.',
 'Capacité de la structure à couvrir opérationnellement le périmètre utilisateurs.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(1, 'COUV-01D', 'D',
 'Couverture du référencement des professionnels externes dans le répertoire central',
 'Proportion des professionnels externes nécessitant un accès aux services numériques et effectivement référencés dans le répertoire central.',
 'Professionnels externes nécessitant un accès au SIH : intérimaires, vacataires, étudiants, prestataires, intervenants libéraux.',
 'Capacité de la structure à couvrir de façon nominative les professionnels externes ayant besoin d\'un accès.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(1, 'COUV-01E', 'E',
 'Part des accès non nominatifs / indirects',
 'Proportion d\'accès ou d\'utilisateurs recourant à des modalités non nominatives (comptes partagés, contournements).',
 'Accès SIH ; pratiques d\'accès non nominatives ; identités professionnelles internes et externes.',
 'Capacité à objectiver la dette qui empêche la traçabilité et l\'authentification nominative.',
 'COUVERTURE', '% → Palier 0-4 inversé', TRUE, FALSE, 'ETABLISSEMENT'),

(1, 'PILOT-01F', 'F',
 'Pilotage de la complétude du répertoire central des identités professionnelles',
 'Existence et maturité d\'un dispositif de suivi périodique de la complétude du répertoire central sur les identités professionnelles.',
 'Répertoire central ; identités professionnelles internes et externes ; gouvernance.',
 'Capacité de la structure à maintenir dans le temps un répertoire d\'identités professionnelles exhaustif.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 02
-- -------------------------------------------------------
(2, 'PROC-02A', 'A',
 'Procédure de création des identités professionnelles applicable aux internes',
 'Existence et maturité d\'une procédure couvrant la création des identités professionnelles internes, avec rôles/circuit rendant le processus applicable.',
 'Identités professionnelles internes ; accès SIH ; répertoire d\'identité.',
 'Capacité de la structure à encadrer et rendre applicable la création des identités professionnelles internes.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(2, 'PROC-02B', 'B',
 'Procédure de création des identités professionnelles applicable aux externes',
 'Existence et maturité d\'une déclinaison "externes" de la procédure couvrant la création des identités professionnelles.',
 'Identités professionnelles externes ; accès SIH ; répertoire d\'identité.',
 'Capacité de la structure à encadrer et rendre applicable la création des identités professionnelles externes.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(2, 'COUV-02C', 'C',
 'Couverture d\'application de la procédure de création des identités professionnelles',
 'Proportion des opérations de création des identités professionnelles réalisées conformément au processus défini.',
 'Opérations de création observées sur une période définie ; professionnels internes et externes.',
 'Capacité de la structure à appliquer réellement la procédure sur le terrain.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(2, 'PILOT-02D', 'D',
 'Traçabilité des demandes et actions de création des identités professionnelles',
 'Existence et maturité d\'un dispositif permettant de tracer les demandes, validations et exécutions des opérations de création des identités professionnelles.',
 'Workflow ITSM/IAM ; logs ; opérations de création ; professionnels internes et externes.',
 'Capacité de la structure à démontrer la maîtrise de la procédure de création (auditabilité / conformité).',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(2, 'PILOT-02E', 'E',
 'Pilotage des écarts "hors-process" et actions correctives',
 'Existence et maturité d\'un dispositif de suivi des créations hors procédure, incluant analyse des causes, actions correctives et suivi.',
 'Écarts identifiés vs procédure ; ITSM ; identités professionnelles internes ; accès SIH.',
 'Capacité à améliorer le respect du processus.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 03
-- -------------------------------------------------------
(3, 'PROC-03A', 'A',
 'Procédure de rapprochement de l\'identité locale avec l\'identité nationale sectorielle santé (RPPS)',
 'Existence et maturité d\'un dispositif permettant d\'associer un identifiant RPPS à une identité locale unique.',
 'Professionnels immatriculés au RPPS ; identités locales ; répertoire d\'identité.',
 'Capacité de la structure à mettre en place un rapprochement fiable entre l\'identité nationale RPPS et l\'identité locale.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(3, 'PROC-03B', 'B',
 'Recours à un service national pour le rapprochement de l\'identité locale avec l\'identité nationale RPPS',
 'Existence et maturité du recours à un service national facilitant le rapprochement avec l\'identité nationale RPPS (ex. PSI, AIR Simplifié).',
 'Rapprochement identité locale / RPPS ; services nationaux mobilisables.',
 'Capacité à s\'appuyer sur des services nationaux pour sécuriser le rapprochement RPPS.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(3, 'COUV-03C', 'C',
 'Couverture du rapprochement de l\'identité locale avec l\'identité nationale RPPS',
 'Proportion des professionnels immatriculés au RPPS pour lesquels un rapprochement est établi et exploitable.',
 'Professionnels immatriculés au RPPS ; répertoire d\'identité.',
 'Capacité à rapprocher l\'identité locale avec l\'identité nationale RPPS.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(3, 'PILOT-03D', 'D',
 'Détection et traitement des anomalies de rapprochement RPPS',
 'Existence et maturité d\'un dispositif de détection des anomalies de rapprochement RPPS et de traitement formalisé.',
 'Professionnels immatriculés au RPPS ; répertoire d\'identité ; workflows de correction.',
 'Capacité à garantir le rapprochement RPPS.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(3, 'PILOT-03E', 'E',
 'Pilotage de la dette de rapprochement RPPS',
 'Existence et maturité d\'un dispositif de suivi des identités locales non rapprochées avec l\'identité nationale RPPS.',
 'Professionnels immatriculés au RPPS ; cas non rapprochés ; répertoire d\'identité.',
 'Capacité à tenir une trajectoire de fiabilisation du rapprochement RPPS.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 04
-- -------------------------------------------------------
(4, 'PROC-04A', 'A',
 'Procédure de gestion de la fin d\'activité des identités professionnelles incluant désactivation/suppression des accès',
 'Existence et maturité d\'une procédure permettant de gérer la fin d\'activité des identités professionnelles.',
 'Identités professionnelles internes et externes ; accès SIH ; répertoire d\'identité.',
 'Capacité de la structure à définir une procédure de gestion de la fin d\'activité.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(4, 'PROC-04B', 'B',
 'Déclencheur fiable de fin d\'activité (RH / métier / tiers)',
 'Existence et maturité d\'un ou plusieurs déclencheurs permettant d\'initier la procédure de gestion de la fin d\'activité sans dépendre uniquement d\'actions manuelles.',
 'Déclencheurs/évènements ; IAM/ITSM ; périmètre SIH.',
 'Capacité de la structure à détecter automatiquement ou systématiquement les fins d\'activité.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(4, 'PROC-04C', 'C',
 'Outillage de la procédure de gestion de la fin d\'activité des identités professionnelles',
 'Existence et maturité d\'un outillage (IAM, connecteurs, workflows ITSM) permettant d\'exécuter la procédure de façon industrialisable.',
 'Identités professionnelles internes et externes ; IAM/ITSM ; connecteurs applicatifs ; répertoire d\'identité.',
 'Capacité de la structure à industrialiser la désactivation des accès.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(4, 'COUV-04D', 'D',
 'Couverture de la désactivation des accès en fin d\'activité',
 'Proportion des fins d\'activité ayant donné lieu à une désactivation effective des accès conformément à la procédure définie.',
 'Identités professionnelles internes et externes ; déclencheurs de fin d\'activité ; répertoire d\'identité.',
 'Capacité à appliquer réellement la procédure de gestion de fin d\'activité.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(4, 'COUV-04E', 'E',
 'Part d\'accès encore actifs au-delà d\'un délai cible après fin d\'activité',
 'Proportion des accès toujours actifs au-delà d\'un délai cible après une fin d\'activité.',
 'Identités professionnelles internes et externes ; déclencheurs de fin d\'activité ; répertoire d\'identité ; seuil temporel.',
 'Capacité à mesurer le risque résiduel d\'accès non gérés.',
 'COUVERTURE', '% → Palier 0-4 inversé', TRUE, FALSE, 'ETABLISSEMENT'),

(4, 'PILOT-04F', 'F',
 'Délai moyen de désactivation des accès après fin d\'activité',
 'Mesure du délai entre l\'événement de fin d\'activité et la désactivation effective des accès.',
 'Identités professionnelles internes et externes ; déclencheurs de fin d\'activité ; répertoire d\'identité.',
 'Capacité à réduire la fenêtre de risque pendant laquelle les accès restent actifs après fin d\'activité.',
 'PILOTAGE', 'Délai → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(4, 'PILOT-04G', 'G',
 'Pilotage des accès non désactivés ou désactivés tardivement',
 'Existence et maturité d\'un dispositif de suivi des accès non désactivés ou désactivés tardivement.',
 'Identités professionnelles internes et externes ; déclencheurs de fin d\'activité ; cas en écart.',
 'Capacité à tenir une trajectoire d\'amélioration de la procédure de fin d\'activité.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 05
-- -------------------------------------------------------
(5, 'PROC-05A', 'A',
 'Politique de gestion des comptes génériques utilisés par des personnes physiques',
 'Existence et maturité d\'une politique encadrant les comptes génériques (création exceptionnelle, justification formalisée, responsable identifié, durée limitée).',
 'Comptes utilisateurs non nominatifs ; accès SIH ; répertoire d\'identité.',
 'Capacité de la structure à encadrer et limiter les comptes génériques.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(5, 'PROC-05B', 'B',
 'Plan de réduction des comptes génériques utilisés par des personnes physiques',
 'Existence et maturité d\'un plan structuré visant à réduire progressivement le recours aux comptes génériques.',
 'Comptes utilisateurs non nominatifs ; accès SIH ; répertoire d\'identité.',
 'Capacité à organiser une trajectoire de résorption.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(5, 'COUV-05C', 'C',
 'Taux de comptes génériques utilisés par des personnes physiques',
 'Proportion de comptes génériques par rapport au nombre total de comptes nominatifs actifs.',
 'Comptes utilisateurs non nominatifs ; accès SIH ; répertoire d\'identité.',
 'Capacité à objectiver la dette non nominative.',
 'COUVERTURE', '% → Palier 0-4 inversé', TRUE, FALSE, 'ETABLISSEMENT'),

(5, 'PILOT-05D', 'D',
 'Pilotage de la réduction des comptes génériques',
 'Existence et maturité d\'un dispositif de suivi du taux de comptes génériques dans le temps.',
 'Comptes utilisateurs non nominatifs ; accès SIH ; répertoire d\'identité ; gouvernance.',
 'Capacité à transformer la mesure en trajectoire réelle.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(5, 'PROC-05E', 'E',
 'Gestion des comptes techniques / de service',
 'Existence et maturité d\'un dispositif encadrant les comptes techniques : inventaire, responsable identifié, justification d\'usage, règles de cycle de vie.',
 'Comptes techniques / de service ; applications et composants techniques nécessitant des accès non humains.',
 'Capacité à encadrer les comptes non humains et à maîtriser leur cycle de vie.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 06
-- -------------------------------------------------------
(6, 'PROC-06A', 'A',
 'Procédure de revue périodique des comptes',
 'Existence et maturité d\'une procédure de revue périodique couvrant comptes personnes physiques, génériques et à privilèges.',
 'Comptes personnes + génériques + à privilèges ; répertoire d\'identité.',
 'Capacité à mettre en place un contrôle transverse des comptes.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(6, 'PROC-06B', 'B',
 'Règles spécifiques de revue des comptes à privilèges',
 'Existence de règles renforcées pour la revue des comptes à privilèges (fréquence accrue, validation RSSI/DSI, traçabilité dédiée).',
 'Comptes administrateurs / techniques à privilèges.',
 'Capacité à sécuriser les comptes à impact critique.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(6, 'PROC-06C', 'C',
 'Règles spécifiques de revue des comptes génériques',
 'Existence de règles spécifiques pour les comptes génériques (justification, durée, revue ciblée).',
 'Comptes génériques.',
 'Capacité à maîtriser les comptes non nominatifs dans la durée.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(6, 'COUV-06D', 'D',
 'Couverture de la revue des comptes personnes',
 'Proportion des comptes personnes physiques effectivement revus lors de la dernière campagne.',
 'Comptes personnes physiques.',
 'Capacité à contrôler les accès utilisateurs classiques.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(6, 'COUV-06E', 'E',
 'Couverture de la revue des comptes génériques',
 'Proportion des comptes génériques effectivement revus.',
 'Comptes génériques.',
 'Capacité à ne pas laisser les comptes génériques hors contrôle.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(6, 'COUV-06F', 'F',
 'Couverture de la revue des comptes à privilèges',
 'Proportion des comptes à privilèges effectivement revus.',
 'Comptes à privilèges.',
 'Capacité à sécuriser les comptes à impact critique.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(6, 'PILOT-06G', 'G',
 'Traitement des écarts issus des revues',
 'Existence et maturité d\'un dispositif permettant de traiter les anomalies détectées lors des revues, avec preuves.',
 'Tous types de comptes.',
 'Capacité à transformer la revue en actions concrètes.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 07
-- -------------------------------------------------------
(7, 'PROC-07A', 'A',
 'IAM en place pour la gestion du cycle de vie des identités',
 'Existence et utilisation d\'un outil IAM pour gérer le cycle de vie des identités.',
 'Identités professionnelles internes et externes ; répertoire d\'identité ; connecteurs applicatifs.',
 'Capacité de la structure à s\'appuyer sur une solution d\'IAM.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(7, 'PROC-07B', 'B',
 'Automatisation du provisioning / deprovisioning via l\'IAM',
 'Niveau d\'automatisation des opérations de création/suppression/modification des comptes et accès.',
 'Identités professionnelles internes et externes ; répertoire d\'identité ; connecteurs applicatifs.',
 'Capacité à réduire les traitements manuels et sécuriser le cycle de vie des identités.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(7, 'PROC-07C', 'C',
 'Automatisation spécifique de la gestion de la fin d\'activité incluant désactivation/suppression des accès',
 'Niveau d\'automatisation de la procédure de gestion de la fin d\'activité à partir d\'un déclencheur fiable.',
 'Identités professionnelles internes et externes ; répertoire d\'identité ; connecteurs applicatifs.',
 'Capacité à automatiser la désactivation des accès.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(7, 'COUV-07D', 'D',
 'Couverture applicative du provisioning automatisé',
 'Proportion des services numériques pour lesquels les comptes et accès sont gérés automatiquement via l\'IAM.',
 'Services numériques.',
 'Capacité à généraliser le provisioning/déprovisioning sur l\'ensemble du parc applicatif.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'GROUPE'),

(7, 'COUV-07E', 'E',
 'Couverture des identités dont l\'automatisation du provisioning/déprovisioning est réalisée via l\'IAM',
 'Proportion des identités dont le cycle de vie est géré dans l\'IAM pour lesquelles l\'automatisation est effective.',
 'Identités professionnelles internes et externes ; répertoire d\'identité ; connecteurs applicatifs.',
 'Capacité à généraliser le provisioning/déprovisioning pour l\'ensemble des identités.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'GROUPE'),

(7, 'PILOT-07F', 'F',
 'Pilotage et maintien de la solution IAM',
 'Existence et maturité d\'un dispositif de suivi et de déploiement de la solution d\'IAM.',
 'Identités professionnelles internes et externes ; répertoire d\'identité ; connecteurs applicatifs.',
 'Capacité à maîtriser et maintenir la solution d\'IAM dans la durée.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

-- -------------------------------------------------------
-- POINT CLÉ 08
-- -------------------------------------------------------
(8, 'PROC-08A', 'A',
 'Existence d\'un inventaire des services numériques de la structure',
 'Existence et maturité d\'un inventaire des services numériques utilisés par les professionnels, avec responsable identifié et règles de mise à jour.',
 'Périmètre des services numériques utilisés par les professionnels.',
 'Capacité à disposer d\'un inventaire exploitable des services numériques.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(8, 'PROC-08B', 'B',
 'Définition des critères de qualification des services numériques',
 'Existence et maturité d\'un cadre définissant les critères permettant de qualifier les services numériques.',
 'Périmètre des services numériques utilisés par les professionnels.',
 'Capacité à définir un cadre de qualification des services numériques.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(8, 'COUV-08C', 'C',
 'Couverture de la qualification des services numériques inventoriés',
 'Proportion des services numériques inventoriés pour lesquels une qualification a été réalisée.',
 'Inventaire des services numériques ; qualification réalisée selon les critères définis.',
 'Capacité à qualifier effectivement les services numériques inventoriés.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(8, 'PILOT-08D', 'D',
 'Pilotage des services numériques',
 'Existence et maturité d\'un dispositif de revue périodique des services numériques permettant d\'actualiser l\'inventaire et la qualification.',
 'Périmètre des services numériques utilisés par les professionnels.',
 'Capacité à maintenir dans le temps l\'inventaire des services numériques.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 09
-- -------------------------------------------------------
(9, 'PROC-09A', 'A',
 'Identification des modes d\'authentification disponibles pour les services numériques en santé',
 'Existence et maturité d\'une cartographie des modes d\'authentification disponibles pour chaque service numérique en santé.',
 'Services numériques en santé.',
 'Capacité à cartographier les modalités d\'authentification disponibles pour les services numériques en santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(9, 'PROC-09B', 'B',
 'Identification des modes d\'authentification disponibles pour les services numériques critiques locaux hors santé',
 'Existence et maturité d\'une cartographie des modes d\'authentification disponibles pour chaque service numérique critique local hors santé.',
 'Services numériques critiques locaux hors santé.',
 'Capacité à cartographier les modalités d\'authentification disponibles pour les services numériques critiques locaux hors santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(9, 'COUV-09C', 'C',
 'Couverture de l\'identification des modes d\'authentification disponibles pour les services numériques',
 'Proportion des services numériques pour lesquels les modes d\'authentification disponibles sont renseignés.',
 'Services numériques en santé et services numériques critiques locaux hors santé.',
 'Capacité à disposer d\'une cartographie exploitable et complète des modes d\'authentification.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 10
-- -------------------------------------------------------
(10, 'PROC-10A', 'A',
 'Identification des services numériques en santé en capacité de déléguer l\'authentification au FI local',
 'Existence et maturité d\'un dispositif permettant d\'identifier la capacité de déléguer l\'authentification au FI local pour chaque service numérique en santé.',
 'Services numériques en santé ; capacité de délégation au FI local ; trajectoire de convergence.',
 'Capacité à préparer la convergence vers la délégation d\'authentification au FI local sur le périmètre santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(10, 'PROC-10B', 'B',
 'Identification des services numériques critiques locaux hors santé en capacité de déléguer l\'authentification au FI local',
 'Existence et maturité d\'un dispositif permettant d\'identifier la capacité de déléguer l\'authentification au FI local pour chaque service numérique critique local hors santé.',
 'Services numériques critiques locaux hors santé ; capacité de délégation au FI local.',
 'Capacité à préparer la convergence vers la délégation d\'authentification au FI local sur le périmètre critique hors santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(10, 'COUV-10C', 'C',
 'Part des services numériques en santé en capacité de déléguer l\'authentification au FI local',
 'Proportion des services numériques en santé pour lesquels la capacité de déléguer l\'authentification au FI local est connue ou documentée.',
 'Services numériques en santé compatibles.',
 'Capacité à qualifier la délégation au FI local du périmètre santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(10, 'COUV-10D', 'D',
 'Part des services numériques critiques locaux hors santé en capacité de déléguer l\'authentification au FI local',
 'Proportion des services numériques critiques locaux hors santé pour lesquels la capacité de déléguer l\'authentification au FI local est connue ou documentée.',
 'Services numériques critiques locaux hors santé compatibles.',
 'Capacité à qualifier la délégation au FI local du périmètre critique hors santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 11
-- -------------------------------------------------------
(11, 'PROC-11A', 'A',
 'Identification des services numériques en santé en capacité de déléguer l\'authentification à PSC',
 'Existence et maturité d\'un dispositif permettant d\'identifier la capacité de déléguer l\'authentification à PSC pour chaque service numérique en santé.',
 'Services numériques en santé ; capacité de délégation à PSC.',
 'Capacité à préparer la convergence vers PSC sur le périmètre santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(11, 'PROC-11B', 'B',
 'Identification des services numériques critiques locaux hors santé en capacité de déléguer l\'authentification à PSC',
 'Existence et maturité d\'un dispositif permettant d\'identifier la capacité de déléguer l\'authentification à PSC pour chaque service numérique critique local hors santé.',
 'Services numériques critiques locaux hors santé ; capacité de délégation à PSC.',
 'Capacité à préparer la convergence vers PSC sur le périmètre critique hors santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(11, 'COUV-11C', 'C',
 'Part des services numériques en santé en capacité de déléguer l\'authentification à PSC',
 'Proportion des services numériques en santé pour lesquels la capacité de déléguer l\'authentification à PSC est connue ou documentée.',
 'Services numériques en santé compatibles PSC.',
 'Capacité à qualifier la délégation à PSC du périmètre santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(11, 'COUV-11D', 'D',
 'Part des services numériques critiques locaux hors santé en capacité de déléguer l\'authentification à PSC',
 'Proportion des services numériques critiques locaux hors santé pour lesquels la capacité de déléguer l\'authentification à PSC est connue ou documentée.',
 'Services numériques critiques locaux hors santé compatibles PSC.',
 'Capacité à qualifier la délégation à PSC du périmètre critique hors santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 12
-- -------------------------------------------------------
(12, 'PROC-12A', 'A',
 'Modèle d\'habilitation structuré par rôles ou profils',
 'Existence et maturité d\'un modèle formalisé d\'habilitation permettant d\'attribuer les droits applicatifs de manière standardisée.',
 'Services numériques en santé + services numériques critiques locaux hors santé.',
 'Capacité à encadrer l\'attribution des droits applicatifs.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(12, 'PROC-12B', 'B',
 'Mise à jour des habilitations au cours du cycle de vie des identités',
 'Existence et maturité d\'un dispositif garantissant que les habilitations applicatives sont créées, modifiées et supprimées en cohérence avec le cycle de vie des identités.',
 'Services numériques en santé + services numériques critiques locaux hors santé ; cycle de vie.',
 'Capacité à assurer la cohérence entre identité et habilitations.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(12, 'PILOT-12C', 'C',
 'Pilotage des habilitations applicatives',
 'Existence et maturité d\'un dispositif de suivi des habilitations incluant revue périodique et traitement des droits excessifs.',
 'Services numériques en santé + services numériques critiques locaux hors santé.',
 'Capacité à maintenir la pertinence des habilitations dans le temps.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(12, 'PROC-12D', 'D',
 'Gestion des exceptions d\'habilitation',
 'Niveau d\'encadrement des exceptions d\'habilitation (droits attribués hors profils/rôles standards).',
 'Services numériques en santé + services numériques critiques locaux hors santé ; demandes d\'accès hors profils.',
 'Capacité à maîtriser les habilitations hors standard.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(12, 'PROC-12E', 'E',
 'Prise en compte des externes dans les profils/rôles et habilitations applicatives',
 'Existence et maturité d\'un dispositif permettant de définir et appliquer des profils/rôles adaptés aux intervenants externes.',
 'Identités professionnelles externes ; accès aux services numériques en santé + critiques locaux hors santé.',
 'Capacité à intégrer les externes dans le modèle d\'habilitation.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(12, 'COUV-12F', 'F',
 'Couverture des services numériques pour lesquels est appliqué le modèle d\'habilitation',
 'Proportion des services numériques dont les habilitations sont gérées via le modèle structuré.',
 'Services numériques en santé + services numériques critiques locaux hors santé.',
 'Capacité à déployer le modèle d\'habilitation sur le périmètre applicatif.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 13
-- -------------------------------------------------------
(13, 'PROC-13A', 'A',
 'Règles de traitement des droits excessifs',
 'Existence et maturité d\'un cadre définissant les règles de détection et de traitement des droits excessifs ou non conformes.',
 'Services numériques en santé + services numériques critiques locaux hors santé ; habilitations applicatives.',
 'Capacité à encadrer la correction des habilitations non conformes.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(13, 'COUV-13B', 'B',
 'Couverture du traitement des droits excessifs',
 'Proportion des écarts d\'habilitation identifiés ayant fait l\'objet d\'un traitement effectif.',
 'Services numériques en santé + critiques locaux hors santé ; écarts d\'habilitation identifiés.',
 'Capacité à corriger réellement les écarts d\'habilitation.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(13, 'PILOT-13C', 'C',
 'Pilotage des écarts d\'habilitation',
 'Existence et maturité d\'un dispositif de suivi des écarts d\'habilitation incluant backlog, priorisation et preuves de clôture.',
 'Services numériques en santé + critiques locaux hors santé ; écarts d\'habilitation.',
 'Capacité à piloter durablement la réduction des droits excessifs.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 14
-- -------------------------------------------------------
(14, 'PROC-14A', 'A',
 'Mise en œuvre technique du MFA pour les services numériques en santé compatibles',
 'Existence et maturité d\'un dispositif de mise en place du MFA pour les services numériques en santé.',
 'Services numériques en santé identifiés compatibles.',
 'Capacité à mettre en œuvre le MFA sur le périmètre santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(14, 'PROC-14B', 'B',
 'Mise en œuvre du MFA pour les services numériques critiques locaux hors santé compatibles',
 'Existence et maturité d\'un dispositif de mise en place du MFA pour les services numériques critiques locaux hors santé.',
 'Services numériques critiques locaux hors santé identifiés compatibles.',
 'Capacité à mettre en œuvre le MFA sur le périmètre critique local hors santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(14, 'COUV-14C', 'C',
 'Services numériques en santé permettant un mode d\'accès MFA',
 'Proportion des services numériques en santé dont un mode d\'accès MFA est opérationnel.',
 'Services numériques en santé identifiés compatibles.',
 'Capacité à mesurer le déploiement réel du MFA sur le périmètre santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(14, 'COUV-14D', 'D',
 'Services numériques critiques locaux hors santé permettant un mode d\'accès MFA',
 'Proportion des services numériques critiques locaux hors santé dont un mode d\'accès MFA est opérationnel.',
 'Services numériques critiques locaux hors santé identifiés compatibles.',
 'Capacité à mesurer le déploiement réel du MFA sur le périmètre critique hors santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(14, 'COUV-14E', 'E',
 'Taux d\'authentifications réalisées avec MFA pour les services numériques en santé',
 'Proportion des authentifications aux services numériques en santé réalisées via MFA.',
 'Services numériques en santé ayant le MFA actif.',
 'Capacité à faire appliquer réellement le MFA dans l\'usage quotidien (vue services).',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(14, 'COUV-14F', 'F',
 'Taux d\'authentifications réalisées avec MFA pour les services numériques critiques locaux hors santé',
 'Proportion des authentifications aux services numériques critiques locaux hors santé réalisées via MFA.',
 'Services numériques critiques locaux hors santé ayant le MFA actif.',
 'Capacité à faire appliquer réellement le MFA dans l\'usage quotidien (vue services critiques hors santé).',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(14, 'COUV-14G', 'G',
 'Couverture des professionnels utilisant le MFA sur les services numériques en santé',
 'Proportion des utilisateurs accédant aux services numériques en santé pour lesquels une MFA est effectivement appliquée.',
 'Services numériques en santé ; identités professionnelles internes + externes.',
 'Capacité à faire appliquer réellement le MFA dans l\'usage quotidien (vue utilisateurs).',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(14, 'COUV-14H', 'H',
 'Couverture des professionnels utilisant le MFA sur les services numériques critiques locaux hors santé',
 'Proportion des utilisateurs accédant aux services numériques critiques locaux hors santé pour lesquels le MFA est appliqué.',
 'Services numériques critiques locaux hors santé ; identités professionnelles internes + externes.',
 'Capacité à faire appliquer réellement le MFA dans l\'usage quotidien (vue utilisateurs critiques hors santé).',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(14, 'COUV-14I', 'I',
 'Couverture du MFA pour les intervenants externes',
 'Proportion des intervenants externes accédant aux services numériques pour lesquels le MFA est appliqué.',
 'Population = externes ; services numériques en santé + critiques locaux hors santé.',
 'Capacité à sécuriser les accès externes.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(14, 'COUV-14J', 'J',
 'Couverture du MFA pour l\'accès distant',
 'Proportion des utilisateurs disposant d\'un accès distant au SIH pour lesquels le MFA est appliqué.',
 'Canal = accès distant (VPN/VDI/Bastion/Portail) ; populations interne + externe.',
 'Capacité à sécuriser les accès distants.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(14, 'PILOT-14K', 'K',
 'Pilotage du déploiement et des exceptions MFA',
 'Existence et maturité d\'un dispositif de suivi du déploiement MFA incluant couverture, exceptions, incidents et trajectoire.',
 'Services numériques en santé + critiques locaux hors santé.',
 'Capacité à maintenir le MFA comme standard de sécurité.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 15
-- -------------------------------------------------------
(15, 'PROC-15A', 'A',
 'Mise en œuvre du MFA sur les comptes à privilège',
 'Existence et maturité d\'un dispositif de gouvernance et de maintien du MFA sur les comptes à privilège.',
 'Services numériques en santé + critiques locaux hors santé ; comptes à privilèges.',
 'Capacité à gouverner durablement le MFA sur les comptes à privilège.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(15, 'COUV-15B', 'B',
 'Couverture de l\'authentification MFA sur les comptes à privilège',
 'Proportion des comptes à privilège protégés par une authentification multifacteur.',
 'Comptes d\'administration (annuaire, systèmes, SIH, sécurité, bases de données, virtualisation, sauvegarde).',
 'Capacité à sécuriser les comptes à privilège.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(15, 'COUV-15C', 'C',
 'MFA actif pour les accès distants des comptes à privilège',
 'Proportion des comptes à privilège utilisés via un canal d\'accès distant pour lesquels le MFA est appliqué.',
 'Comptes à privilège ; canal = accès distant (VPN/VDI/Bastion/Portail).',
 'Capacité à sécuriser les accès distants des comptes à privilèges.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 16
-- -------------------------------------------------------
(16, 'PROC-16A', 'A',
 'eSSO / gestionnaire de mots de passe en place comme solution transitoire',
 'Existence et maturité d\'un dispositif de mise en place du eSSO comme solution transitoire pour les services ne déléguant pas l\'authentification au FI.',
 'Postes / utilisateurs ; services numériques ; stratégie de transition vers la délégation au FI.',
 'Capacité à sécuriser provisoirement les accès avant généralisation de la délégation au FI.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(16, 'COUV-16B', 'B',
 'Couverture des utilisateurs disposant d\'un eSSO / gestionnaire de mots de passe',
 'Proportion des utilisateurs du périmètre cible disposant du eSSO dans le cadre de la solution transitoire.',
 'Population utilisateur ciblée (interne + externe si concerné).',
 'Capacité à déployer la solution transitoire eSSO auprès des utilisateurs concernés.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(16, 'COUV-16C', 'C',
 'Part des services numériques en santé compatibles FI utilisant encore l\'eSSO',
 'Proportion des services numériques en santé capables de déléguer l\'authentification au FI pour lesquels l\'authentification passe encore par l\'eSSO.',
 'Services numériques en santé ; services en capacité de déléguer l\'authentification au FI.',
 'Capacité à faire converger les services compatibles vers la délégation d\'authentification au FI.',
 'COUVERTURE', '% → Palier 0-4 inversé', TRUE, FALSE, 'ETABLISSEMENT'),

(16, 'COUV-16D', 'D',
 'Part des services numériques critiques locaux hors santé compatibles FI utilisant encore l\'eSSO',
 'Proportion des services numériques critiques locaux hors santé capables de déléguer l\'authentification au FI pour lesquels l\'authentification passe encore par l\'eSSO.',
 'Services numériques critiques locaux hors santé ; services en capacité de déléguer l\'authentification au FI.',
 'Capacité à faire converger les services critiques locaux compatibles vers la délégation au FI.',
 'COUVERTURE', '% → Palier 0-4 inversé', TRUE, FALSE, 'ETABLISSEMENT'),

(16, 'PILOT-16E', 'E',
 'Suivi de la trajectoire eSSO → délégation d\'authentification au FI local',
 'Existence et maturité d\'un dispositif de suivi de la bascule des services vers la délégation au FI local.',
 'Services numériques en santé + critiques locaux hors santé ; trajectoire vers la délégation au FI local.',
 'Capacité à piloter la sortie progressive de l\'eSSO au profit de la délégation au FI local.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 17
-- -------------------------------------------------------
(17, 'PROC-17A', 'A',
 'Mise en œuvre technique de la délégation d\'authentification vers le FI local pour les services numériques en santé',
 'Existence et maturité d\'un dispositif de mise en place de la délégation d\'authentification des services numériques en santé vers un FI local.',
 'Services numériques en santé identifiés compatibles.',
 'Capacité à mettre en œuvre la délégation d\'authentification au FI sur le périmètre santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(17, 'PROC-17B', 'B',
 'Mise en œuvre technique de la délégation d\'authentification vers le FI local pour les services numériques critiques locaux hors santé',
 'Existence et maturité d\'un dispositif de mise en place de la délégation d\'authentification des services numériques critiques locaux hors santé vers un FI local.',
 'Services numériques critiques locaux hors santé identifiés compatibles.',
 'Capacité à mettre en œuvre la délégation d\'authentification au FI sur le périmètre critique hors santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(17, 'COUV-17C', 'C',
 'Part des services numériques en santé déléguant l\'authentification au FI local',
 'Proportion des services numériques en santé dont la délégation d\'authentification au FI local est opérationnelle.',
 'Services numériques en santé identifiés compatibles.',
 'Capacité à mesurer le déploiement réel de la délégation au FI sur le périmètre santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(17, 'COUV-17D', 'D',
 'Part des services numériques critiques locaux hors santé déléguant l\'authentification au FI local',
 'Proportion des services numériques critiques locaux hors santé dont la délégation d\'authentification au FI local est opérationnelle.',
 'Services numériques critiques locaux hors santé identifiés compatibles.',
 'Capacité à mesurer le déploiement réel de la délégation au FI sur le périmètre critique hors santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(17, 'COUV-17E', 'E',
 'Taux d\'authentifications réalisées via le FI local',
 'Proportion des authentifications aux services numériques réalisées via le FI local.',
 'Services numériques en santé + critiques locaux hors santé ; populations interne + externe.',
 'Capacité à faire adopter l\'usage au quotidien.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 18
-- -------------------------------------------------------
(18, 'PROC-18A', 'A',
 'Mise en œuvre technique de la délégation d\'authentification vers PSC pour les services numériques en santé',
 'Existence et maturité d\'un dispositif de mise en œuvre effective de l\'authentification via PSC sur les services numériques en santé.',
 'Services numériques en santé compatibles PSC.',
 'Capacité à mettre en œuvre la délégation d\'authentification à PSC sur le périmètre santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(18, 'PROC-18B', 'B',
 'Mise en œuvre technique de la délégation d\'authentification vers PSC pour les services numériques critiques locaux hors santé',
 'Existence et maturité d\'un dispositif de mise en œuvre effective de l\'authentification via PSC sur les services numériques critiques locaux hors santé.',
 'Services numériques critiques locaux hors santé compatibles PSC.',
 'Capacité à mettre en œuvre la délégation d\'authentification à PSC sur le périmètre critique hors santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(18, 'COUV-18C', 'C',
 'Part des services numériques en santé raccordés à PSC',
 'Proportion des services numériques en santé dont la délégation d\'authentification à PSC est opérationnelle.',
 'Services numériques en santé raccordés PSC.',
 'Capacité à mesurer le déploiement réel de la délégation à PSC sur le périmètre santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'GROUPE'),

(18, 'COUV-18D', 'D',
 'Part des services numériques critiques locaux hors santé raccordés à PSC',
 'Proportion des services numériques critiques locaux hors santé dont la délégation d\'authentification à PSC est opérationnelle.',
 'Services numériques critiques locaux hors santé raccordés PSC.',
 'Capacité à mesurer le déploiement réel de la délégation à PSC sur le périmètre critique hors santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'GROUPE'),

-- -------------------------------------------------------
-- POINT CLÉ 19
-- -------------------------------------------------------
(19, 'PROC-19A', 'A',
 'Fournisseur d\'identité local qualifié pour mettre en œuvre la délégation PSC vers le FI local',
 'Existence et maturité d\'un dispositif permettant de qualifier le FI local comme FI tiers de confiance PSC.',
 'Fournisseur d\'identité local ; exigences PSC ; sécurité ; exploitation.',
 'Capacité à rendre son IdP compatible avec l\'écosystème PSC.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(19, 'PILOT-19B', 'B',
 'Pilotage de la conformité PSC du FI local',
 'Existence et maturité d\'un dispositif de pilotage de la conformité PSC du FI local : revues périodiques, suivi des écarts, gestion des dérogations.',
 'FI local ; conformité PSC ; revues ; écarts/dérogations.',
 'Capacité à maintenir la conformité PSC dans la durée.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

-- -------------------------------------------------------
-- POINT CLÉ 20
-- -------------------------------------------------------
(20, 'PROC-20A', 'A',
 'Connaissance et compréhension d\'eIDAS et de son lien avec le RIE',
 'Niveau de connaissance d\'eIDAS et d\'appropriation interne du lien eIDAS → déclinaison nationale RIE dans le contexte santé.',
 'Compréhension, partage interne, appropriation par MOA/MOE/sécurité.',
 'Capacité à disposer d\'un socle commun de compréhension eIDAS/RIE pour cadrer la trajectoire d\'identification électronique.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(20, 'PILOT-20B', 'B',
 'Traduction des exigences RIE (PGSSI-S) en trajectoire et suivi',
 'Existence et maturité d\'un dispositif permettant de traduire les exigences du RIE en trajectoire opérationnelle et d\'en assurer le suivi.',
 'RIE (PGSSI-S) ; analyse d\'écarts ; plan d\'action ; trajectoire projet ; gouvernance.',
 'Capacité à piloter la mise en conformité RIE de façon démontrable et durable.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

-- -------------------------------------------------------
-- POINT CLÉ 21
-- -------------------------------------------------------
(21, 'PROC-21A', 'A',
 'Conformité des schémas d\'identification électronique au cadre réglementaire applicable',
 'Existence et maturité d\'un dispositif permettant d\'évaluer, documenter et maintenir la conformité des schémas d\'identification électronique.',
 'Schéma d\'identification électronique ; processus ; authentification ; composants techniques ; MIE.',
 'Capacité à démontrer la conformité du dispositif global d\'identification électronique.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(21, 'PROC-21B', 'B',
 'Attestation de conformité produite pour les schémas d\'identification électronique',
 'Existence et maturité d\'un dispositif permettant de produire et maintenir une attestation de conformité relative aux schémas d\'identification électronique.',
 'Schéma d\'identification électronique ; attestation / justificatif / dossier documentaire.',
 'Capacité à documenter et justifier la conformité du schéma d\'identification électronique.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 22
-- -------------------------------------------------------
(22, 'PROC-22A', 'A',
 'Dispositif de choix des MIE conformes à la PGSSI-S-RIE en adéquation avec les usages locaux',
 'Existence et maturité d\'un dispositif de sélection d\'un ou plusieurs MIE conformes à la PGSSI-S-RIE au regard de l\'analyse des usages locaux.',
 'Identités professionnelles internes et externes ; services numériques en santé ; répertoire d\'identité.',
 'Capacité à choisir les MIE conformes adaptés aux usages.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(22, 'PROC-22B', 'B',
 'Procédure de distribution des MIE conformes à la PGSSI-S-RIE',
 'Existence et maturité d\'une procédure garantissant la distribution du MIE conforme à la PGSSI-S-RIE à la bonne identité.',
 'Identités professionnelles internes et externes ; services numériques en santé ; répertoire d\'identité.',
 'Capacité à délivrer les MIE conformes en garantissant la distribution à la bonne identité.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(22, 'COUV-22C', 'C',
 'Couverture des professionnels utilisateurs de services numériques en santé équipés d\'un MIE conforme à la PGSSI-S-RIE',
 'Proportion des professionnels ayant besoin d\'accès aux services numériques en santé équipés d\'un MIE conforme à la PGSSI-S-RIE.',
 'Identités professionnelles internes et externes ayant accès aux services numériques en santé.',
 'Capacité à équiper les professionnels d\'un MIE conforme.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(22, 'COUV-22D', 'D',
 'Couverture par typologie des professionnels équipés d\'un MIE conforme à la PGSSI-S-RIE',
 'Proportion par typologie des professionnels équipés d\'un MIE conforme à la PGSSI-S-RIE.',
 'Identités professionnelles internes et externes ayant accès aux services numériques en santé.',
 'Capacité à équiper les professionnels d\'un MIE conforme, par catégorie.',
 'COUVERTURE', '% par typologie', FALSE, TRUE, 'ETABLISSEMENT'),

(22, 'COUV-22E', 'E',
 'Couverture des professionnels équipés d\'un MIE conforme utilisant ce MIE pour accéder aux services numériques en santé',
 'Proportion des professionnels accédant aux services numériques en santé réalisant une authentification MFA via un MIE conforme.',
 'Identités professionnelles internes et externes ; professionnels utilisant le MFA sur les services numériques en santé.',
 'Capacité à déployer l\'usage d\'un MIE conforme auprès des professionnels accédant aux services numériques en santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(22, 'COUV-22F', 'F',
 'Couverture par typologie des professionnels utilisant un MIE conforme pour accéder aux services numériques en santé',
 'Proportion par typologie des professionnels réalisant une authentification MFA via un MIE conforme pour accéder aux services numériques en santé.',
 'Identités professionnelles internes et externes ; professionnels utilisant le MFA sur les services numériques en santé.',
 'Capacité à déployer l\'usage d\'un MIE conforme par catégorie de professionnels.',
 'COUVERTURE', '% par typologie', FALSE, TRUE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 23
-- -------------------------------------------------------
(23, 'PROC-23A', 'A',
 'Compatibilité des MIE MFA avec PSC',
 'Existence et maturité d\'un dispositif permettant de vérifier et documenter que les MIE choisis sont compatibles avec PSC.',
 'MIE sélectionnés.',
 'Capacité à sécuriser une trajectoire MIE compatible PSC.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(23, 'COUV-23B', 'B',
 'Couverture des professionnels équipés d\'un MIE compatible PSC',
 'Proportion des professionnels ayant besoin d\'accès aux services numériques en santé équipés d\'un MIE compatible PSC.',
 'MIE sélectionnés ; professionnels ayant besoin d\'accès.',
 'Capacité à déployer effectivement des MIE compatibles PSC.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 24
-- -------------------------------------------------------
(24, 'PROC-24A', 'A',
 'Dispositif de choix des MIE MFA en adéquation avec les usages locaux pour les services numériques critiques',
 'Existence et maturité d\'un dispositif de sélection d\'un ou plusieurs MIE MFA au regard de l\'analyse des usages pour les services critiques locaux hors santé.',
 'Identités professionnelles internes et externes ; services numériques critiques locaux hors santé ; répertoire d\'identité.',
 'Capacité à choisir les MIE MFA adaptés aux usages pour le périmètre critique hors santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'GROUPE'),

(24, 'PROC-24B', 'B',
 'Procédure de distribution des MIE MFA',
 'Existence et maturité d\'une procédure garantissant la distribution du MIE MFA à la bonne identité.',
 'Identités professionnelles internes et externes ; services numériques critiques locaux hors santé ; répertoire d\'identité.',
 'Capacité à délivrer les MIE MFA en garantissant la distribution à la bonne identité.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(24, 'COUV-24C', 'C',
 'Couverture des professionnels utilisateurs de services numériques critiques locaux hors santé équipés d\'un MIE MFA',
 'Proportion des professionnels ayant besoin d\'accès aux services numériques critiques locaux hors santé équipés d\'un MIE MFA.',
 'Identités professionnelles internes et externes ayant accès aux services numériques critiques locaux hors santé.',
 'Capacité à équiper les professionnels d\'un MIE MFA pour le périmètre critique hors santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(24, 'COUV-24D', 'D',
 'Couverture des professionnels équipés d\'un MIE MFA utilisant ce MIE pour accéder aux services numériques critiques locaux hors santé',
 'Proportion des professionnels accédant aux services numériques critiques locaux hors santé réalisant une authentification MFA via un MIE MFA.',
 'Identités professionnelles internes et externes ayant accès aux services numériques critiques locaux hors santé.',
 'Capacité à déployer l\'usage d\'un MIE MFA auprès des professionnels accédant aux services critiques hors santé.',
 'COUVERTURE', '% → Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 25
-- -------------------------------------------------------
(25, 'PROC-25A', 'A',
 'Programme de sensibilisation continue aux services numériques en santé',
 'Existence et maturité d\'un programme de sensibilisation continue des utilisateurs sur les enjeux de sécurité liés aux services numériques en santé.',
 'Identités professionnelles internes et externes ; services numériques en santé ; répertoire d\'identité.',
 'Capacité à ancrer durablement les bonnes pratiques de sécurité pour les accès aux services numériques en santé.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 26
-- -------------------------------------------------------
(26, 'PROC-26A', 'A',
 'Sensibilisation spécifique à l\'identification électronique et aux MIE',
 'Existence et maturité d\'actions de sensibilisation spécifiques portant sur l\'identification électronique, les MIE et les règles d\'usage associées.',
 'Identités professionnelles internes et externes ; services numériques en santé ; répertoire d\'identité.',
 'Capacité à accompagner les professionnels dans l\'appropriation des dispositifs d\'identification électronique.',
 'PROCESS', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 27
-- -------------------------------------------------------
(27, 'PILOT-27A', 'A',
 'Évaluation et suivi de l\'efficacité des actions de sensibilisation IE',
 'Existence et maturité d\'un dispositif permettant d\'évaluer et de suivre l\'efficacité des actions de sensibilisation liées à l\'identification électronique.',
 'Identités professionnelles internes et externes ; services numériques en santé ; répertoire d\'identité.',
 'Capacité à mesurer et améliorer l\'impact réel des actions de sensibilisation IE.',
 'PILOTAGE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

-- -------------------------------------------------------
-- POINT CLÉ 28
-- -------------------------------------------------------
(28, 'GOUV-28A', 'A',
 'Intégration de l\'identité électronique dans les instances de pilotage stratégique',
 'Niveau d\'intégration formalisée des sujets d\'identité électronique dans les instances de pilotage stratégique, avec participation des parties prenantes concernées.',
 'Instances stratégiques ; membres du comité de direction ; décisions/CR.',
 'Capacité à assurer un pilotage stratégique de l\'IE avec arbitrages.',
 'GOUVERNANCE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(28, 'GOUV-28B', 'B',
 'Responsabilités formalisées (RACI) sur la sécurisation de la chaîne d\'identification électronique',
 'Niveau de formalisation des rôles et responsabilités sur l\'ensemble de la chaîne d\'identité électronique, incluant les modalités d\'escalade et d\'arbitrage.',
 'Instances stratégiques ; membres du comité de direction ; décisions/CR.',
 'Capacité à clarifier et sécuriser la répartition des responsabilités IE.',
 'GOUVERNANCE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(28, 'GOUV-28C', 'C',
 'Pilotage par indicateurs et plan d\'actions sur la sécurisation de la chaîne d\'identification électronique',
 'Niveau de mise en place d\'un pilotage consolidé de l\'identité électronique reposant sur un tableau de bord d\'indicateurs et un plan d\'actions.',
 'Instances stratégiques ; membres du comité de direction ; décisions/CR.',
 'Capacité à piloter de façon mesurable la trajectoire IE.',
 'GOUVERNANCE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT'),

(28, 'GOUV-28D', 'D',
 'Promotion et accompagnement de l\'auto-enrôlement des professionnels dans Pro Santé Identité',
 'Niveau d\'organisation et de portage d\'actions de communication et d\'accompagnement visant l\'auto-enrôlement PSI des professionnels.',
 'Professionnels concernés ; PSI ; supports ; relais ; appui.',
 'Capacité à promouvoir l\'auto-enrôlement des professionnels dans Pro Santé Identité.',
 'GOUVERNANCE', 'Palier 0-4', FALSE, FALSE, 'ETABLISSEMENT');


-- ============================================================
-- SECTION 5 : PALIERS
-- ============================================================

-- Paliers génériques réutilisables par type
-- PROCESS standard (0-4)
-- Note : les paliers sont insérés indicateur par indicateur
-- pour garantir l\'intégrité référentielle

-- Macro paliers PROCESS standard
SET @proc_0 = 'Dispositif inexistant : Aucun dispositif ou aucune procédure n\'est défini sur le sujet concerné.';
SET @proc_1 = 'Dispositif amorcé : Des pratiques existent, mais elles reposent principalement sur des usages non stabilisés ; elles ne constituent pas encore un cadre opératoire clairement établi.';
SET @proc_2 = 'Dispositif formalisé : Le dispositif est défini, rédigé, cadré ou validé, mais son application reste partielle, incomplète ou inégale.';
SET @proc_3 = 'Dispositif appliqué : Le dispositif est effectivement mis en œuvre par les acteurs concernés sur le périmètre attendu.';
SET @proc_4 = 'Dispositif maîtrisé : Le dispositif est appliqué, suivi, revu et ajusté dans le temps ; les écarts sont identifiés et font l\'objet d\'actions d\'amélioration.';

-- Macro paliers PILOTAGE standard
SET @pilot_0 = 'Pilotage inexistant : Aucun dispositif de suivi ou de pilotage n\'est mis en place sur le sujet concerné.';
SET @pilot_1 = 'Pilotage amorcé : Quelques éléments de suivi existent, mais ils sont fragmentaires, peu structurés ou mobilisés de manière limitée.';
SET @pilot_2 = 'Pilotage formalisé : Les modalités de pilotage sont définies (objets de suivi, indicateurs, responsabilités, fréquence de revue) ; leur mise en œuvre reste partielle ou irrégulière.';
SET @pilot_3 = 'Pilotage déployé : Le pilotage est effectivement mis en œuvre ; les données sont suivies, exploitées et partagées pour éclairer l\'action et la décision.';
SET @pilot_4 = 'Pilotage maîtrisé : Le pilotage est pérenne, fiabilisé et utilisé pour orienter les priorités, mesurer les écarts, décider des actions correctrices et améliorer le dispositif.';

-- Macro paliers COUVERTURE standard (%)
SET @couv_0 = '0–9%';
SET @couv_1 = '10–39%';
SET @couv_2 = '40–69%';
SET @couv_3 = '70–89%';
SET @couv_4 = '90–100%';

-- Macro paliers COUVERTURE inversée (risque)
SET @risk_0 = '> 20%';
SET @risk_1 = '10–20%';
SET @risk_2 = '5–9%';
SET @risk_3 = '1–4%';
SET @risk_4 = '0%';

-- Macro paliers GOUVERNANCE
SET @gouv_0 = 'Gouvernance inexistante : Aucune gouvernance identifiable n\'est mise en place sur le sujet concerné.';
SET @gouv_1 = 'Gouvernance amorcée : Des rôles ou arbitrages existent de manière informelle, ponctuelle ou non structurée.';
SET @gouv_2 = 'Gouvernance formalisée : Les rôles, responsabilités et modalités de décision sont définis, mais leur fonctionnement reste partiel ou inégalement appliqué.';
SET @gouv_3 = 'Gouvernance déployée : La gouvernance fonctionne effectivement ; les rôles sont tenus, les décisions sont prises et relayées.';
SET @gouv_4 = 'Gouvernance maîtrisée : La gouvernance est installée dans la durée, animée, évaluée et ajustée ; elle permet un pilotage cohérent et une amélioration continue.';


-- -------------------------------------------------------
-- Insertion des paliers par indicateur
-- -------------------------------------------------------

-- PROC-01A
INSERT INTO paliers (id_indicateur, valeur, description)
SELECT id, 0, 'Aucun répertoire identifié (identités gérées dans les applications métiers sans notion de répertoire d\'identité).' FROM indicateurs WHERE code = 'PROC-01A';
INSERT INTO paliers (id_indicateur, valeur, description)
SELECT id, 1, 'Un ou plusieurs répertoire(s) identifié(s), sans décision ni définition claire du référentiel.' FROM indicateurs WHERE code = 'PROC-01A';
INSERT INTO paliers (id_indicateur, valeur, description)
SELECT id, 2, 'Répertoire(s) défini(s) et documenté(s) (périmètre, données minimales, règles de nommage/qualité).' FROM indicateurs WHERE code = 'PROC-01A';
INSERT INTO paliers (id_indicateur, valeur, description)
SELECT id, 3, 'Répertoire(s) applicable(s) : responsabilités définies, règles d\'alimentation/mise à jour décrites, modalités d\'accès/usage clarifiées.' FROM indicateurs WHERE code = 'PROC-01A';
INSERT INTO paliers (id_indicateur, valeur, description)
SELECT id, 4, 'Répertoire(s) stabilisé(s) : modèle de données et règles de gestion nominales complètes, cohérentes et utilisables de manière homogène.' FROM indicateurs WHERE code = 'PROC-01A';

-- PROC-01B
INSERT INTO paliers (id_indicateur, valeur, description)
SELECT id, 0, 'Pas de répertoire identifié comme référence ; chaque système gère ses identités.' FROM indicateurs WHERE code = 'PROC-01B';
INSERT INTO paliers (id_indicateur, valeur, description)
SELECT id, 1, 'Intention d\'en faire la référence, mais règles non définies (création/mise à jour restent locales).' FROM indicateurs WHERE code = 'PROC-01B';
INSERT INTO paliers (id_indicateur, valeur, description)
SELECT id, 2, 'Principe "source de vérité" formalisé : règles d\'alignement/synchronisation décrites, responsabilités identifiées.' FROM indicateurs WHERE code = 'PROC-01B';
INSERT INTO paliers (id_indicateur, valeur, description)
SELECT id, 3, 'Principe applicable : processus d\'alimentation et modalités de diffusion vers les systèmes cibles définis pour les cas nominaux.' FROM indicateurs WHERE code = 'PROC-01B';
INSERT INTO paliers (id_indicateur, valeur, description)
SELECT id, 4, 'Principe stabilisé : règles nominales complètes et opérationnalisables pour la synchronisation (création, mise à jour, désactivation).' FROM indicateurs WHERE code = 'PROC-01B';

-- COUV-01C, COUV-01D : couverture standard
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, @couv_0 FROM indicateurs WHERE code = 'COUV-01C';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, @couv_1 FROM indicateurs WHERE code = 'COUV-01C';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, @couv_2 FROM indicateurs WHERE code = 'COUV-01C';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, @couv_3 FROM indicateurs WHERE code = 'COUV-01C';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, @couv_4 FROM indicateurs WHERE code = 'COUV-01C';

INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, @couv_0 FROM indicateurs WHERE code = 'COUV-01D';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, @couv_1 FROM indicateurs WHERE code = 'COUV-01D';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, @couv_2 FROM indicateurs WHERE code = 'COUV-01D';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, @couv_3 FROM indicateurs WHERE code = 'COUV-01D';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, @couv_4 FROM indicateurs WHERE code = 'COUV-01D';

-- COUV-01E : inversé
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, @risk_0 FROM indicateurs WHERE code = 'COUV-01E';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, @risk_1 FROM indicateurs WHERE code = 'COUV-01E';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, @risk_2 FROM indicateurs WHERE code = 'COUV-01E';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, @risk_3 FROM indicateurs WHERE code = 'COUV-01E';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, @risk_4 FROM indicateurs WHERE code = 'COUV-01E';

-- PILOT-01F : pilotage standard
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, @pilot_0 FROM indicateurs WHERE code = 'PILOT-01F';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, @pilot_1 FROM indicateurs WHERE code = 'PILOT-01F';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, @pilot_2 FROM indicateurs WHERE code = 'PILOT-01F';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, @pilot_3 FROM indicateurs WHERE code = 'PILOT-01F';
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, @pilot_4 FROM indicateurs WHERE code = 'PILOT-01F';

-- Points clés 02 à 07 : paliers standards par type
-- (PROCESS standard, COUVERTURE standard, PILOTAGE standard)
-- Application en masse pour tous les indicateurs restants par type

INSERT INTO paliers (id_indicateur, valeur, description)
SELECT i.id, p.valeur, p.desc_val FROM indicateurs i
JOIN (
  SELECT 0 valeur, @proc_0 desc_val UNION ALL
  SELECT 1, @proc_1 UNION ALL SELECT 2, @proc_2 UNION ALL
  SELECT 3, @proc_3 UNION ALL SELECT 4, @proc_4
) p
WHERE i.type = 'PROCESS'
  AND i.code NOT IN ('PROC-01A','PROC-01B')
  AND NOT EXISTS (SELECT 1 FROM paliers WHERE id_indicateur = i.id AND valeur = p.valeur);

INSERT INTO paliers (id_indicateur, valeur, description)
SELECT i.id, p.valeur, p.desc_val FROM indicateurs i
JOIN (
  SELECT 0 valeur, @pilot_0 desc_val UNION ALL
  SELECT 1, @pilot_1 UNION ALL SELECT 2, @pilot_2 UNION ALL
  SELECT 3, @pilot_3 UNION ALL SELECT 4, @pilot_4
) p
WHERE i.type = 'PILOTAGE'
  AND NOT EXISTS (SELECT 1 FROM paliers WHERE id_indicateur = i.id AND valeur = p.valeur);

INSERT INTO paliers (id_indicateur, valeur, description)
SELECT i.id, p.valeur, p.desc_val FROM indicateurs i
JOIN (
  SELECT 0 valeur, @couv_0 desc_val UNION ALL
  SELECT 1, @couv_1 UNION ALL SELECT 2, @couv_2 UNION ALL
  SELECT 3, @couv_3 UNION ALL SELECT 4, @couv_4
) p
WHERE i.type = 'COUVERTURE' AND i.inverse = FALSE AND i.has_typologies = FALSE
  AND NOT EXISTS (SELECT 1 FROM paliers WHERE id_indicateur = i.id AND valeur = p.valeur);

INSERT INTO paliers (id_indicateur, valeur, description)
SELECT i.id, p.valeur, p.desc_val FROM indicateurs i
JOIN (
  SELECT 0 valeur, @risk_0 desc_val UNION ALL
  SELECT 1, @risk_1 UNION ALL SELECT 2, @risk_2 UNION ALL
  SELECT 3, @risk_3 UNION ALL SELECT 4, @risk_4
) p
WHERE i.type = 'COUVERTURE' AND i.inverse = TRUE
  AND NOT EXISTS (SELECT 1 FROM paliers WHERE id_indicateur = i.id AND valeur = p.valeur);

INSERT INTO paliers (id_indicateur, valeur, description)
SELECT i.id, p.valeur, p.desc_val FROM indicateurs i
JOIN (
  SELECT 0 valeur, @gouv_0 desc_val UNION ALL
  SELECT 1, @gouv_1 UNION ALL SELECT 2, @gouv_2 UNION ALL
  SELECT 3, @gouv_3 UNION ALL SELECT 4, @gouv_4
) p
WHERE i.type = 'GOUVERNANCE'
  AND NOT EXISTS (SELECT 1 FROM paliers WHERE id_indicateur = i.id AND valeur = p.valeur);

-- Paliers spécifiques PILOT-04F (délai) — remplacent les paliers PILOTAGE génériques
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, 'Non mesuré.' FROM indicateurs WHERE code = 'PILOT-04F'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, '> 30 jours.' FROM indicateurs WHERE code = 'PILOT-04F'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, '15–30 jours.' FROM indicateurs WHERE code = 'PILOT-04F'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, '8–14 jours.' FROM indicateurs WHERE code = 'PILOT-04F'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, '0–7 jours.' FROM indicateurs WHERE code = 'PILOT-04F'
  ON DUPLICATE KEY UPDATE description = VALUES(description);

-- Paliers PROC-08A spécifiques
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, 'Aucun inventaire des services numériques.' FROM indicateurs WHERE code = 'PROC-08A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, 'Inventaire partiel ou informel : listes éclatées, non consolidées.' FROM indicateurs WHERE code = 'PROC-08A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, 'Inventaire formalisé : responsable identifié, sources mobilisées précisées.' FROM indicateurs WHERE code = 'PROC-08A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, 'Inventaire exploitable : le contenu permet de qualifier les services numériques.' FROM indicateurs WHERE code = 'PROC-08A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, 'Inventaire stabilisé : complet, documenté et utilisable comme base commune.' FROM indicateurs WHERE code = 'PROC-08A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);

-- Paliers PROC-09A / PROC-09B spécifiques (cartographie)
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, 'Aucune cartographie des modes d\'authentification.' FROM indicateurs WHERE code = 'PROC-09A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, 'Cartographie informelle/partielle : informations dispersées.' FROM indicateurs WHERE code = 'PROC-09A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, 'Cartographie formalisée pour une partie des services.' FROM indicateurs WHERE code = 'PROC-09A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, 'Cartographie applicable : informations exploitables pour la majorité des services.' FROM indicateurs WHERE code = 'PROC-09A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, 'Cartographie stabilisée : informations exploitables pour l\'ensemble des services.' FROM indicateurs WHERE code = 'PROC-09A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);

INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, 'Aucune cartographie des modes d\'authentification.' FROM indicateurs WHERE code = 'PROC-09B'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, 'Cartographie informelle/partielle : informations dispersées.' FROM indicateurs WHERE code = 'PROC-09B'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, 'Cartographie formalisée pour une partie des services.' FROM indicateurs WHERE code = 'PROC-09B'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, 'Cartographie applicable : informations exploitables pour la majorité des services.' FROM indicateurs WHERE code = 'PROC-09B'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, 'Cartographie stabilisée : informations exploitables pour l\'ensemble des services.' FROM indicateurs WHERE code = 'PROC-09B'
  ON DUPLICATE KEY UPDATE description = VALUES(description);

-- Paliers PROC-12A spécifiques (modèle habilitation)
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, 'Aucun modèle rôles/profils : habilitations gérées au cas par cas.' FROM indicateurs WHERE code = 'PROC-12A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, 'Structuration partielle/informelle : quelques rôles/profils sans référentiel commun.' FROM indicateurs WHERE code = 'PROC-12A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, 'Modèle formalisé : rôles/profils définis et documentés pour une partie des services.' FROM indicateurs WHERE code = 'PROC-12A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, 'Modèle applicable : modalités opérationnelles décrites pour la majorité des services.' FROM indicateurs WHERE code = 'PROC-12A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, 'Modèle stabilisé : référentiel cohérent et homogène utilisable pour l\'ensemble des services.' FROM indicateurs WHERE code = 'PROC-12A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);

-- Paliers PROC-20A spécifiques (connaissance eIDAS)
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, 'eIDAS et RIE non connus / non pris en compte.' FROM indicateurs WHERE code = 'PROC-20A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, 'eIDAS et RIE peu connus.' FROM indicateurs WHERE code = 'PROC-20A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, 'eIDAS et RIE connus : synthèse disponible, lien eIDAS→RIE expliqué, diffusion au noyau projet.' FROM indicateurs WHERE code = 'PROC-20A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, 'eIDAS et RIE applicable : compréhension partagée permettant de cadrer concrètement la trajectoire.' FROM indicateurs WHERE code = 'PROC-20A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, 'eIDAS et RIE maîtrisé : compris par l\'ensemble des parties prenantes clés, utilisé pour arbitrer les choix.' FROM indicateurs WHERE code = 'PROC-20A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);

-- Paliers PROC-07A spécifiques (IAM)
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 0, 'Aucune solution IAM.' FROM indicateurs WHERE code = 'PROC-07A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 1, 'Solution IAM identifiée / à l\'étude : périmètre et cible non cadrés.' FROM indicateurs WHERE code = 'PROC-07A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 2, 'Solution IAM choisie et cadrée : périmètre défini, rôles et règles de cycle de vie décrits.' FROM indicateurs WHERE code = 'PROC-07A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 3, 'Solution IAM applicable : modèle d\'identités, workflows nominaux et sources amont définis.' FROM indicateurs WHERE code = 'PROC-07A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);
INSERT INTO paliers (id_indicateur, valeur, description) SELECT id, 4, 'Solution IAM stabilisée : dispositif complet et cohérent sur les cas nominaux et aux limites.' FROM indicateurs WHERE code = 'PROC-07A'
  ON DUPLICATE KEY UPDATE description = VALUES(description);


-- ============================================================
-- SECTION 6 : TYPOLOGIES (indicateurs COUV-22D et COUV-22F)
-- ============================================================

INSERT INTO indicateur_typologies (id_indicateur, code_typo, libelle_typo, ordre)
SELECT id, 'MEDECINS', 'Médecins', 1 FROM indicateurs WHERE code = 'COUV-22D';
INSERT INTO indicateur_typologies (id_indicateur, code_typo, libelle_typo, ordre)
SELECT id, 'IDE', 'IDE', 2 FROM indicateurs WHERE code = 'COUV-22D';
INSERT INTO indicateur_typologies (id_indicateur, code_typo, libelle_typo, ordre)
SELECT id, 'AUTRES', 'Autres professionnels', 3 FROM indicateurs WHERE code = 'COUV-22D';

INSERT INTO indicateur_typologies (id_indicateur, code_typo, libelle_typo, ordre)
SELECT id, 'MEDECINS', 'Médecins', 1 FROM indicateurs WHERE code = 'COUV-22F';
INSERT INTO indicateur_typologies (id_indicateur, code_typo, libelle_typo, ordre)
SELECT id, 'IDE', 'IDE', 2 FROM indicateurs WHERE code = 'COUV-22F';
INSERT INTO indicateur_typologies (id_indicateur, code_typo, libelle_typo, ordre)
SELECT id, 'AUTRES', 'Autres professionnels', 3 FROM indicateurs WHERE code = 'COUV-22F';


SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- FIN DU SCRIPT D'INITIALISATION
-- ============================================================
