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

/*
  As bombas de combustível são ligadas aos tanques, cada bomba está ligada a um tanque,
  mas um tanque pode estar ligado a várias bombas. Cada bomba é identificada por um
  número de série de 10 dígitos e tem um contador que determina a quantidade de
  litros vendida desde sua instalação.
*/

DELIMITER $$
CREATE TRIGGER atualiza_contador_bomba 
AFTER INSERT ON vendas_diarias FOR EACH ROW 
BEGIN 
  UPDATE bomba
  SET litros_vendidos = litros_vendidos + NEW.qtd_litros 
  WHERE id = NEW.bomba_id; 
END $$
DELIMITER ;

/*
  Caso algum combustível fique abaixo do estoque mínimo no final
  do dia, o sistema deve gerar automaticamente um pedido de compra 
  para a empresa distribuidora. Esse pedido contém o tipo de combustível 
  e a quantidade a ser comprada (assuma sempre que o tanque deve sempre 
  estar cheio), além do valor por litro e o valor total da compra.
*/

DELIMITER $$
CREATE PROCEDURE checar_estoque(IN id_combustivel BIGINT)
BEGIN
	DECLARE done INT DEFAULT FALSE;
  DECLARE quantidade_necessaria DECIMAL(8,2) DEFAULT FALSE;
	DECLARE cursor_VAL DECIMAL(8,2);
  DECLARE cursor_ID BIGINT;
  DECLARE cursor_estoque_minimo DECIMAL(8,2);
  DECLARE cursor_capacidade_maxima DECIMAL(8,2);
  DECLARE cursor_preco_litro DECIMAL(3,2);
  DECLARE cursor_aliquota DECIMAL(2,2);
  DECLARE cursor_tipo VARCHAR(30);
	DECLARE cursor_i CURSOR FOR 
    SELECT 
		  SUM(volume_atual), combustivel_id, 
		  tipo, estoque_minimo, 
		  preco_litro, aliquota,
		  SUM(capacidade_maxima)  from tanque
		INNER JOIN tipo_combustivel ON tanque.combustivel_id = tipo_combustivel.id
		GROUP BY combustivel_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cursor_i;
	  read_loop: LOOP
		FETCH cursor_i INTO 
          cursor_VAL, cursor_ID, 
          cursor_tipo, cursor_estoque_minimo, 
          cursor_preco_litro, cursor_aliquota,
          cursor_capacidade_maxima;
        IF done THEN
			    LEAVE read_loop;
		    END IF;
		IF cursor_VAL > cursor_estoque_minimo THEN
          INSERT INTO entrega (
          combustivel_id, quantidade,
          valor_por_litro, valor_total_compra) 
          VALUES (
          cursor_ID, (cursor_capacidade_maxima - cursor_VAL),
          (cursor_preco_litro - cursor_preco_litro * cursor_aliquota), 
          (cursor_capacidade_maxima - cursor_VAL) * (cursor_preco_litro - cursor_preco_litro * cursor_aliquota)
          );
    END IF;
	  END LOOP;
	CLOSE cursor_i;
END
$$
DELIMITER ;

/*
  Quando o caminhão de distribuição chega, o Sr. Chiquinho deve colocar no
  sistema quantos litros de cada combustível foram colocados em cada tanque, além da
  data da entrega. Caso sejam colocados mais litros que o tanque é capaz de armazenar, 
  o sistema deve gerar um erro e não permitir o registro. Repare que a quantidade 
  máxima a ser colocada é a capacidade do tanque diminuída do resíduo de combustível 
  que o tanque ainda armazena.
*/

DELIMITER $$
CREATE TRIGGER atualiza_volume_tanque
BEFORE INSERT ON combustivel_tanque FOR EACH ROW 
BEGIN 
  DECLARE volume_atual_tq DECIMAL(8,2);
  DECLARE capacidade_total_tq DECIMAL(8,2);
  SELECT 
	  volume_atual, capacidade_maxima FROM tanque WHERE id = NEW.tanque_id
    INTO volume_atual_tq, capacidade_total_tq;
	IF volume_atual_tq + NEW.quantidade > capacidade_total_tq THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Excede capacidade do tanque', MYSQL_ERRNO = 1001;
	END IF;
END $$
DELIMITER ;

/*
  No final de cada dia, o sistema deve gerar uma lista de consumo de
  combustível do dia. Na sexta-feira, além do consumo do dia, o sistema deve gerar um
  relatório agregado com os últimos 7 dias. Todas essas informações devem ser persistidas no banco de dados.
*/

DELIMITER $$
CREATE PROCEDURE relatorio_semanal(IN data_inicio DATETIME, IN data_fim DATETIME)
BEGIN
	DECLARE total DECIMAL(10,2);
  DECLARE bomb_id VARCHAR(10);
  DECLARE done INT DEFAULT FALSE;
  DECLARE cursor_i CURSOR FOR 
    SELECT sum(qtd_litros), bomb_id from vendas_diarias where 
		data_venda >= data_inicio and 
		data_venda <= data_fim group by bomba_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cursor_i;
	  read_loop: LOOP
		FETCH cursor_i INTO 
          total, bomb_id;
        IF done THEN
			LEAVE read_loop;
		END IF;
	INSERT INTO consumo_semanal (inicio_semana, final_semana, qtd_litros, bomba_id)
    VALUES (data_inicio, data_fim, total, bomb_id);
    END LOOP;
	CLOSE cursor_i;
END
$$
DELIMITER ;
