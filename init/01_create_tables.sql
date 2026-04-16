-- ============================================================
-- HOSPICONNECT - CRÉATION DES TABLES
-- Version : 1.0
-- Date    : 2026-04-15
-- ============================================================


-- ------------------------------------------------------------
-- SECTION 1 : RÉFÉRENTIEL ANS (données statiques)
-- ------------------------------------------------------------

CREATE TABLE domaines (
    id          INT             NOT NULL AUTO_INCREMENT,
    code        VARCHAR(10)     NOT NULL,
    libelle     VARCHAR(100)    NOT NULL,
    ordre       INT             NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_domaines_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Domaines du référentiel ANS HospiConnect';


CREATE TABLE rubriques (
    id          INT             NOT NULL AUTO_INCREMENT,
    id_domaine  INT             NOT NULL,
    code        VARCHAR(10)     NOT NULL,
    libelle     VARCHAR(200)    NOT NULL,
    description TEXT,
    ordre       INT             NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_rubriques_code (code),
    CONSTRAINT fk_rubriques_domaine FOREIGN KEY (id_domaine) REFERENCES domaines(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Rubriques du référentiel ANS';


CREATE TABLE points_cles (
    id          INT             NOT NULL AUTO_INCREMENT,
    id_rubrique INT             NOT NULL,
    numero      INT             NOT NULL,
    libelle     VARCHAR(200)    NOT NULL,
    ordre       INT             NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_points_cles_rubrique FOREIGN KEY (id_rubrique) REFERENCES rubriques(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Points clés du référentiel ANS';


CREATE TABLE indicateurs (
    id              INT             NOT NULL AUTO_INCREMENT,
    id_point_cle    INT             NOT NULL,
    code            VARCHAR(20)     NOT NULL,
    lettre          CHAR(1)         NOT NULL,
    titre           VARCHAR(255)    NOT NULL,
    definition      TEXT,
    perimetre       TEXT,
    objectif        TEXT,
    type            ENUM('PROCESS','COUVERTURE','PILOTAGE','GOUVERNANCE') NOT NULL,
    mode_saisie     VARCHAR(100),
    inverse         BOOLEAN         NOT NULL DEFAULT FALSE COMMENT 'TRUE si palier plus élevé = moins bon (indicateurs de risque)',
    has_typologies  BOOLEAN         NOT NULL DEFAULT FALSE COMMENT 'TRUE si saisie par typologie (ex: COUV-22D)',
    porteur         ENUM('ETABLISSEMENT','GROUPE') NOT NULL DEFAULT 'ETABLISSEMENT',
    PRIMARY KEY (id),
    UNIQUE KEY uk_indicateurs_code (code),
    CONSTRAINT fk_indicateurs_point_cle FOREIGN KEY (id_point_cle) REFERENCES points_cles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Indicateurs du référentiel ANS';


CREATE TABLE paliers (
    id              INT             NOT NULL AUTO_INCREMENT,
    id_indicateur   INT             NOT NULL,
    valeur          TINYINT         NOT NULL COMMENT 'Valeur du palier : 0 à 4',
    description     TEXT            NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_paliers_indicateur_valeur (id_indicateur, valeur),
    CONSTRAINT fk_paliers_indicateur FOREIGN KEY (id_indicateur) REFERENCES indicateurs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Paliers de notation des indicateurs';


CREATE TABLE indicateur_typologies (
    id              INT             NOT NULL AUTO_INCREMENT,
    id_indicateur   INT             NOT NULL,
    code_typo       VARCHAR(50)     NOT NULL,
    libelle_typo    VARCHAR(100)    NOT NULL,
    ordre           INT             NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uk_typo_indicateur_code (id_indicateur, code_typo),
    CONSTRAINT fk_typologies_indicateur FOREIGN KEY (id_indicateur) REFERENCES indicateurs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Typologies pour les indicateurs à saisie multi-catégories';


-- ------------------------------------------------------------
-- SECTION 2 : DONNÉES OPÉRATIONNELLES (données dynamiques)
-- ------------------------------------------------------------

CREATE TABLE etablissements (
    id      INT             NOT NULL AUTO_INCREMENT,
    code    VARCHAR(20)     NOT NULL,
    nom     VARCHAR(100)    NOT NULL,
    actif   BOOLEAN         NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id),
    UNIQUE KEY uk_etablissements_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Établissements du groupe Hospitalité';


CREATE TABLE campagnes (
    id          INT             NOT NULL AUTO_INCREMENT,
    libelle     VARCHAR(50)     NOT NULL COMMENT 'Ex : S1 2026',
    date_debut  DATE            NOT NULL,
    date_fin    DATE            NOT NULL,
    statut      ENUM('OUVERTE','FERMEE') NOT NULL DEFAULT 'OUVERTE',
    PRIMARY KEY (id),
    UNIQUE KEY uk_campagnes_libelle (libelle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Campagnes semestrielles d évaluation';


CREATE TABLE sessions (
    id                  INT             NOT NULL AUTO_INCREMENT,
    id_etablissement    INT             NOT NULL,
    id_campagne         INT             NOT NULL,
    nom_referent        VARCHAR(100)    NOT NULL,
    date_creation       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modif          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    statut              ENUM('EN_COURS','SOUMISE') NOT NULL DEFAULT 'EN_COURS',
    PRIMARY KEY (id),
    UNIQUE KEY uk_sessions_etab_campagne_referent (id_etablissement, id_campagne, nom_referent),
    CONSTRAINT fk_sessions_etablissement FOREIGN KEY (id_etablissement) REFERENCES etablissements(id),
    CONSTRAINT fk_sessions_campagne FOREIGN KEY (id_campagne) REFERENCES campagnes(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Sessions de saisie par établissement et campagne';


CREATE TABLE reponses (
    id              INT             NOT NULL AUTO_INCREMENT,
    id_session      INT             NOT NULL,
    id_indicateur   INT             NOT NULL,
    valeur          TINYINT         NOT NULL COMMENT 'Palier choisi : 0 à 4',
    commentaire     TEXT,
    date_saisie     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_reponses_session_indicateur (id_session, id_indicateur),
    CONSTRAINT fk_reponses_session FOREIGN KEY (id_session) REFERENCES sessions(id),
    CONSTRAINT fk_reponses_indicateur FOREIGN KEY (id_indicateur) REFERENCES indicateurs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Réponses aux indicateurs standards';


CREATE TABLE reponses_typologies (
    id              INT             NOT NULL AUTO_INCREMENT,
    id_session      INT             NOT NULL,
    id_indicateur   INT             NOT NULL,
    id_typo         INT             NOT NULL,
    valeur          TINYINT         NOT NULL COMMENT 'Palier choisi : 0 à 4',
    commentaire     TEXT,
    date_saisie     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_reponses_typo_session_ind_typo (id_session, id_indicateur, id_typo),
    CONSTRAINT fk_reponses_typo_session FOREIGN KEY (id_session) REFERENCES sessions(id),
    CONSTRAINT fk_reponses_typo_indicateur FOREIGN KEY (id_indicateur) REFERENCES indicateurs(id),
    CONSTRAINT fk_reponses_typo_typo FOREIGN KEY (id_typo) REFERENCES indicateur_typologies(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Réponses aux indicateurs à saisie par typologie';
