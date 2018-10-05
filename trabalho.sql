/*
 * Quando precisar, o Sr. Chiquinho deve ser capaz de alterar os impostos ou as alíquotas 
 * referentes ao relatório anterior, ou seja, a informação contida nos relatórios deve ser 
 * persistida no banco de dados de modo que possa ser modificada.
 * (quando a gente alterar a alíquota ele dá update nos relatórios anteriores)
 */

create database PostoDoChiquinho;

use PostoDoChiquinho;

CREATE TABLE tipo_combustivel (
  id BIGINT NOT NULL AUTO_INCREMENT,
  tipo VARCHAR(30) NOT NULL UNIQUE,
  estoque_minimo DECIMAL(8,2) NOT NULL,
  aliquota DECIMAL(2,2) NOT NULL,
  preco_litro DECIMAL(3,2) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE tanque (
  id VARCHAR(4) NOT NULL,
  capacidade_maxima DECIMAL(8,2) NOT NULL,
  volume_atual DECIMAL(8,2) NOT NULL,
  combustivel_id BIGINT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT `combustivel_fk` FOREIGN KEY (`combustivel_id`) REFERENCES
  tipo_combustivel(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE bomba (
  id VARCHAR(10) NOT NULL,
  tanque_id VARCHAR(4) NOT NULL,
  litros_vendidos DECIMAL(15, 2) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  CONSTRAINT `tanque_fk` FOREIGN KEY (`tanque_id`) REFERENCES
  tanque(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE vendas_diarias (
  id BIGINT NOT NULL AUTO_INCREMENT,
  data_venda DATETIME NOT NULL,
  qtd_litros DECIMAL(10,2) NOT NULL,
  bomba_id VARCHAR(10) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT `bomba_fk` FOREIGN KEY (`bomba_id`) REFERENCES
  bomba(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE entrega (
  id BIGINT NOT NULL AUTO_INCREMENT,
  combustivel_id BIGINT NOT NULL,
  quantidade DECIMAL(8,2) NOT NULL,
  valor_por_litro DECIMAL(3,2) NOT NULL,
  valor_total_compra DECIMAL(8,2) NOT NULL,
  data_entrega DATETIME,
  PRIMARY KEY (id),
  CONSTRAINT `combustivel_tip_fk` FOREIGN KEY (`combustivel_id`) REFERENCES
  tipo_combustivel(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE combustivel_tanque (
  id BIGINT NOT NULL AUTO_INCREMENT,
  entrega_id BIGINT NOT NULL,
  tanque_id VARCHAR(4) NOT NULL,
  quantidade DECIMAL(8,2) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT `entrega_fk` FOREIGN KEY (`entrega_id`) REFERENCES
  entrega(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tanque_ct_fk` FOREIGN KEY (`tanque_id`) REFERENCES
  tanque(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE consumo_semanal (
  id BIGINT NOT NULL AUTO_INCREMENT,
  inicio_semana DATETIME NOT NULL,
  final_semana DATETIME NOT NULL,
  qtd_litros DECIMAL(10,2) NOT NULL,
  bomba_id VARCHAR(10) NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT `bomba_cs_fk` FOREIGN KEY (`bomba_id`) REFERENCES
  bomba(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO tipo_combustivel (tipo, estoque_minimo, aliquota, preco_litro)
VALUES ('etanol' , 500 , 0.3 , 3.29);

INSERT INTO tipo_combustivel (tipo, estoque_minimo, aliquota, preco_litro)
VALUES ('etanol aditivado',500,0.3,3.49);

INSERT INTO tipo_combustivel (tipo, estoque_minimo, aliquota, preco_litro)
VALUES ('gasolina',500,0.3,4.29);

INSERT INTO tipo_combustivel (tipo, estoque_minimo, aliquota, preco_litro)
VALUES ('gasolina aditivada',500,0.3,4.49);

INSERT INTO tipo_combustivel (tipo, estoque_minimo, aliquota, preco_litro)
VALUES ('diesel',500,0.3,2.99);


INSERT INTO tanque (id, capacidade_maxima, volume_atual, combustivel_id) 
VALUES ('EC01', 1000, 1000, 1);

INSERT INTO tanque (id, capacidade_maxima, volume_atual, combustivel_id) 
VALUES ('EC02',2000, 2000, 1);

INSERT INTO tanque (id, capacidade_maxima, volume_atual, combustivel_id) 
VALUES ('EA01',2000, 2000, 2);

INSERT INTO tanque (id, capacidade_maxima, volume_atual, combustivel_id) 
VALUES ('GC01', 1000, 1000, 3);

INSERT INTO tanque (id, capacidade_maxima, volume_atual, combustivel_id) 
VALUES ('GC02',2000, 2000, 3);

INSERT INTO tanque (id, capacidade_maxima, volume_atual, combustivel_id) 
VALUES ('GA01', 2000, 2000, 4);

INSERT INTO tanque (id, capacidade_maxima, volume_atual, combustivel_id) 
VALUES ('DC01', 2000, 2000, 5);

INSERT INTO tanque (id, capacidade_maxima, volume_atual, combustivel_id) 
VALUES ('DC02',1000, 1000, 5);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('0101010101', 'DC01', 249765);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('0202020202', 'DC01', 76543);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('0303030303', 'EC01', 90675);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('0404040404', 'EC01', 23456);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('0505050505', 'EC02', 846321);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('0606060606', 'EC02', 7623321);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('0707070707', 'EA01', 356775);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('0808080808', 'GC01', 349765);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('0909090909', 'GC01', 3574223);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('1010101010', 'GC01', 2342);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('1111111111', 'GC02', 34153);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('1212121212', 'GC02', 231532);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('1313131313', 'GA01', 2342342);

INSERT INTO bomba (id, tanque_id, litros_vendidos)
VALUES ('1414141414', 'GA01', 2312);


