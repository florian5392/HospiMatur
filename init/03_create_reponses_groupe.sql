-- ============================================================
-- HospiConnect Maturité — Table des réponses GROUPE
-- Script 03 : Saisie admin des indicateurs de porteur GROUPE
-- ============================================================

SET NAMES utf8mb4;
SET foreign_key_checks = 0;

CREATE TABLE IF NOT EXISTS reponses_groupe (
    id            INT NOT NULL AUTO_INCREMENT,
    id_campagne   INT NOT NULL,
    id_indicateur INT NOT NULL,
    valeur        TINYINT NOT NULL,   -- 0-4, jamais NULL (saisie obligatoire par admin)
    commentaire   TEXT,
    date_saisie   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_rg_campagne_indicateur (id_campagne, id_indicateur),
    CONSTRAINT fk_rg_campagne   FOREIGN KEY (id_campagne)   REFERENCES campagnes(id),
    CONSTRAINT fk_rg_indicateur FOREIGN KEY (id_indicateur) REFERENCES indicateurs(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET foreign_key_checks = 1;
