CREATE TABLE tipo_combustivel (
     id BIGINT NOT NULL AUTO_INCREMENT,
     tipo VARCHAR(30) NOT NULL,
     estoque_minimo DECIMAL(5,2) NOT NULL,
     PRIMARY KEY (id)
);

CREATE TABLE tanque (
     id VARCHAR(4) NOT NULL,
     capacidade_maxima DECIMAL(8,2) NOT NULL,
     volume_atual DECIMAL(5,2) NOT NULL,
     combustivel_id BIGINT NOT NULL,
     PRIMARY KEY (id),
     CONSTRAINT `combustivel_fk` FOREIGN KEY (`combustivel_id`) REFERENCES
     tipo_combustivel(id) ON DELETE CASCADE ON UPDATE CASCADE
);

