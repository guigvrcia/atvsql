-----------------------------------------------
-- Criando o esquema universidade
-----------------------------------------------
DROP SCHEMA IF EXISTS universidade CASCADE;
CREATE SCHEMA universidade;
SET search_path TO universidade;


-- -----------------------------------------------------
-- Tabela FACULDADE
-- -----------------------------------------------------
CREATE TABLE faculdade (
  sigla CHAR(5) NOT NULL,
  nome VARCHAR(100),
  predio CHAR(5),
  orcamento DECIMAL(10,2),
  -- restrições
  CONSTRAINT pk_faculdade PRIMARY KEY (sigla)
);

-- -----------------------------------------------------
-- Tabela PROFESSOR
-- -----------------------------------------------------
CREATE TABLE professor (
  id CHAR(11) NOT NULL,
  nome VARCHAR(255) NOT NULL,
  fac_prof CHAR(5) NOT NULL,
  admissao DATE,
  -- restrições
  CONSTRAINT pk_professor PRIMARY KEY (id),
  CONSTRAINT fk_faculdade FOREIGN KEY (fac_prof) REFERENCES faculdade (sigla)
);

-- -----------------------------------------------------
-- Tabela ESTUDANTE
-- -----------------------------------------------------
CREATE TABLE estudante (
  id CHAR(11) NOT NULL,
  nome VARCHAR(255) NOT NULL,
  datanasc DATE,
  fac_est CHAR(5) NOT NULL,
  cra REAL,
  tutor CHAR(11),
  -- restrições
  CONSTRAINT pk_estudante PRIMARY KEY (id),
  CONSTRAINT fk_faculdade FOREIGN KEY (fac_est) REFERENCES faculdade (sigla),
  CONSTRAINT fk_tutor FOREIGN KEY (tutor) REFERENCES professor (id)
);

-- -----------------------------------------------------
-- Tabela DISCIPLINA
-- -----------------------------------------------------
CREATE TABLE disciplina (
  codigo CHAR(6) NOT NULL,
  nome VARCHAR(70) NOT NULL,
  fac_disc CHAR(5) NOT NULL,
  ch SMALLINT, -- carga horária
  -- restrições
  CONSTRAINT pk_disciplina PRIMARY KEY (codigo),
  CONSTRAINT fk_faculdade FOREIGN KEY (fac_disc) REFERENCES faculdade (sigla)
);

-- -----------------------------------------------------
-- Tabela PRE-REQUISITO
-- -----------------------------------------------------
CREATE TABLE pre_requisito (
  cod_disc CHAR(6) NOT NULL,
  cod_pre CHAR(6) NOT NULL,
  -- restrições
  CONSTRAINT pk_pre_requisito PRIMARY KEY (cod_disc, cod_pre),
  CONSTRAINT fk_disciplina FOREIGN KEY (cod_disc) REFERENCES disciplina (codigo),
  CONSTRAINT fk_pre_requisito FOREIGN KEY (cod_pre) REFERENCES disciplina (codigo)
);

-- -----------------------------------------------------
-- Tabela SALA
-- -----------------------------------------------------
CREATE TABLE sala (
  predio CHAR(5) NOT NULL,
  numero SMALLINT NOT NULL,
  capacidade INTEGER,
  -- restrições
  CONSTRAINT pk_sala PRIMARY KEY (predio, numero)
);

-- -----------------------------------------------------
-- Tabela TURMA
-- -----------------------------------------------------
CREATE TABLE turma (
  id INTEGER NOT NULL,
  turma CHAR(2) NOT NULL,
  semestre INTEGER NOT NULL,
  ano INTEGER NOT NULL,
  cod_disc CHAR(6) NOT NULL,
  predio_s CHAR(5),
  n_sala INTEGER,
  -- restrições
  CONSTRAINT pk_turma PRIMARY KEY (id),
  CONSTRAINT uq_turma UNIQUE (turma, semestre, ano, cod_disc),
  CONSTRAINT fk_disciplina FOREIGN KEY (cod_disc) REFERENCES disciplina (codigo),
  CONSTRAINT fk_sala FOREIGN KEY (predio_s, n_sala) REFERENCES sala (predio, numero)
);

-- -----------------------------------------------------
-- Tabela ENSINA
-- -----------------------------------------------------
CREATE TABLE ensina (
  id_prof CHAR(11) NOT NULL,
  id_turma INTEGER NOT NULL,
  -- restrições
  CONSTRAINT pk_ensina PRIMARY KEY (id_prof, id_turma),
  CONSTRAINT fk_prof_ensina FOREIGN KEY (id_prof) REFERENCES professor (id),
  CONSTRAINT fk_ensina_turma FOREIGN KEY (id_turma) REFERENCES turma (id)
);

-- -----------------------------------------------------
-- Tabela FREQUENTA
-- -----------------------------------------------------
CREATE TABLE frequenta (
  id_est CHAR(11) NOT NULL,
  id_turma INTEGER NOT NULL,
  nota REAL,
  -- restrições
  CONSTRAINT pk_frequenta PRIMARY KEY (id_est, id_turma),
  CONSTRAINT fk_est_frequenta FOREIGN KEY (id_est) REFERENCES estudante (id),
  CONSTRAINT fk_frequenta_turma FOREIGN KEY (id_turma) REFERENCES turma (id)
);

-- -----------------------------------------------------
-- Tabela HORARIO
-- -----------------------------------------------------
CREATE TABLE horario (
  id_hora CHAR(1) NOT NULL,   
  hora_inicio TIME,
  hora_fim TIME,
  -- restrições
  CONSTRAINT pk_horario PRIMARY KEY (id_hora)
);


-- -----------------------------------------------------
-- Tabela SEMANA
-- -----------------------------------------------------
CREATE TABLE semana (
  id_sem CHAR(1) NOT NULL,   
  descricao VARCHAR(13),
  -- restrições
  CONSTRAINT pk_semana PRIMARY KEY (id_sem)
);

-- -----------------------------------------------------
-- Tabela HORARIO_AULA
-- -----------------------------------------------------
CREATE TABLE horario_aula (
  id_sem CHAR(1) NOT NULL,
  id_hora CHAR(1) NOT NULL,
  id_turma INTEGER NOT NULL,

  -- restrições
  CONSTRAINT pk_horario_aula PRIMARY KEY (id_sem,id_hora, id_turma),
  CONSTRAINT fk_horario_aula FOREIGN KEY (id_hora) REFERENCES horario (id_hora),
  CONSTRAINT fk_semana_aula FOREIGN KEY (id_sem) REFERENCES semana (id_sem),
  CONSTRAINT fk_aula_turma FOREIGN KEY (id_turma) REFERENCES turma (id)
);

-- Dados da tabela faculdade
INSERT INTO faculdade (sigla, nome, predio, orcamento) VALUES ('ICBIM', 'Instituto de Ciências Biomédicas', '2B211', '85000.00');

-- Inserindo dados dos professores
INSERT INTO professor (id, nome, fac_prof, admissao) VALUES 
('12345678900', 'Disney Oliver Sívieri Júnior', 'ICBIM', '2019-01-01'),
('00987654321', 'Ana Paula Coelho Balbi', 'ICBIM', '2008-10-29'),
('12300456789', 'Bellisa de Freitas Barbosa', 'ICBIM', '2012-10-11'),
('00123456789', 'Claudemir Kuhn Faccioli', 'ICBIM', '2016-01-26'),
('12003456789', 'Cláudio Vieira da Sulva', 'ICBIM', '2008-10-30');

-- Inserido dados dos estudantes
INSERT INTO estudante (id, nome, datanasc, fac_est, cra, tutor) VALUES
('12311ICB207', 'Harry Styles', '1994-02-01', 'ICBIM', '90.0', '12345678900'),
('12311ICB267', 'Aghata Nunes', '2001-11-16', 'ICBIM', '85.7', NULL),
('12311ICB352', 'Jessyca Teodoro', '2002-10-04', 'ICBIM', '90.0', '12300456789'),
('12311ICB234', 'Rodrigo Souza', '2003-07-14', 'ICBIM', '83.0', NULL),
('12311ICB145', 'Oliver Rossini', '2004-02-15', 'ICBIM', '95.0', NULL);

-- Inserindo dados da disciplina
INSERT INTO disciplina (codigo, nome, fac_disc, ch) VALUES 
('I31106', 'Anatomia Humana', 'ICBIM', '120'),
('I31109', 'Biossegurança', 'ICBIM', '30'),
('I3108', 'Biologia Celular', 'ICBIM', '60'),
('I31209', 'Biofísica Celular e de Sistemas', 'ICBIM', '75'),
('I31210', 'Histologia Básica e de Sistemas', 'ICBIM', '105');

--Inserindo dados de pre-requisito
INSERT INTO pre-requisito(cod_disc, cod_pre) VALUES ('I31210', 'I31106'), ('I31209', '13108');

--salas
--disciplinas na ordem: Anatomia, Anatomia-extra, Biossegurança, biologia celular,Biofisica celular e de sistemas, histologia básica de sistemas;
INSERT INTO sala (predio, numero, capacidade) VALUES 
('8C', '308', '60'),
('8C', '306', '60'), 
('8C', '125', '70'), 
('2B', '236', '60'), 
('8C', '309', '60'),
('8C', '321', '60') ;
--Inserido dados das turmas
INSERT INTO turma (id, turma, semestre, ano, cod_disc, predio_s, n_sala) VALUES 
('20', 'PR', '1', '2024', 'I31106', '8C', '308'),
('19', 'EX', '2', '2024', 'I31106', '8C', '306'), 
('20', 'PR', '1', '2024', 'I31109', '8C', '125'), 
('20', 'PR', '1', '2024', 'I3108', '2B', '235'), 
('19', 'PR', '2', '2024', 'I31209', '8C', '309'), 
('19', 'PR', '2', '2024', 'I31210', '8C', '321'); 
-- ensina
INSERT INTO ensina (id_prof, id_turma) VALUES 
('12345678900', '20'), 
('12345678900', '19'), 
('00987654321', '20'), 
('12300456789', '20'), 
('00123456789', '19'),
('12003456789', '19');   
--Inserindo dados de frequenta
INSERT INTO frequenta (id_est, id_turma, nota) VALUES 
('12311ICB207', '20', NULL), 
('12311ICB267', '20', NULL), 
('12311ICB352', '20', NULL),
('12311ICB234', '19', NULL), 
('12311ICB145', '19', NULL);

--Inserindo dados do horario

INSERT INTO horario (id_hora, hora_inicio, horario_fim) VALUES  
('a', '07:10:00', '08:00:00'),
('b', '08:00:00', '08:50:00'),
('c', '08:50:00', '09:40:00'),
('d', '09:50:00', '10:40:00'),
('e', '10:40:00', '11:30:00'),
('q', '11:30:00', '12:20:00'),
('f', '13:10:00', '14:00:00'),
('g', '14:00:00', '14:50:00'),
('h', '14:50:00', '15:40:00'),
('i', '16:00:00', '16:50:00'),
('j', '16:50:00', '17:40:00');

--Inserindo dados das Semanas

INSERT INTO semana (id_sem, descricao) VALUES
(2, 'Segunda'),
(3, 'Terça'),
(4, 'Quarta'),
(5, 'Quinta'),
(6, 'Sexta');

--Inserindo dados horario-semana

INSERT INTO horario_aula (id_sem, id_hora, id_turma) VALUES
(2, 'g', '20'), (4, 'g', '20'),
(3, 'd', '20'),
(2, 'b', '20'),
(5, 'f', '19'),
(2, 'g', '19');

