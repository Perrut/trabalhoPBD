/*
 * Quando precisar, o Sr. Chiquinho deve ser capaz de alterar os impostos ou as alíquotas 
 * referentes ao relatório anterior, ou seja, a informação contida nos relatórios deve ser 
 * persistida no banco de dados de modo que possa ser modificada.
 * (quando a gente alterar a alíquota ele dá update nos relatórios anteriores)
 */

CREATE TABLE tipo_combustivel (
  id BIGINT NOT NULL AUTO_INCREMENT,
  tipo VARCHAR(30) NOT NULL UNIQUE,
  estoque_minimo DECIMAL(8,2) NOT NULL,
  aliquota DECIMAL(2,2) NOT NULL,
  preco_litro DECIMAL(2,2) NOT NULL,
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

CREATE TRIGGER atualiza_contador_bomba AFTER INSERT ON vendas_diarias (
  FOR EACH ROW
  BEGIN
    set @qtd = NEW.qtd_litros;
    set @id_bomba = NEW.bomba_id;
    UPDATE bomba SET litros_vendidos = litros_vendidos + @qtd
    WHERE id = @id_bomba;
  END
);

