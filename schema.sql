-- ==================================================================================
-- DDL (Data Definition Language) - Criação das Tabelas
-- Sistema de Cursos Online (EAD)
-- ==================================================================================

-- 1. Tabela ALUNO
CREATE TABLE ALUNO (
    id_aluno        INT PRIMARY KEY AUTO_INCREMENT,
    nome            VARCHAR(100) NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    cpf             CHAR(11)     NOT NULL UNIQUE,
    data_cadastro   DATE         NOT NULL
);

-- 2. Tabela CURSO
CREATE TABLE CURSO (
    id_curso        INT PRIMARY KEY AUTO_INCREMENT,
    titulo          VARCHAR(100) NOT NULL,
    descricao       TEXT,
    carga_horaria   INT          NOT NULL
);

-- 3. Tabela TURMA
CREATE TABLE TURMA (
    id_turma        INT PRIMARY KEY AUTO_INCREMENT,
    id_curso        INT          NOT NULL,
    data_inicio     DATE         NOT NULL,
    data_fim        DATE         NOT NULL,
    status          VARCHAR(20)  NOT NULL, -- Ex: 'ABERTA', 'EM ANDAMENTO', 'CONCLUIDA'
    
    FOREIGN KEY (id_curso) REFERENCES CURSO(id_curso)
);

-- 4. Tabela MATRICULA (Tabela de relacionamento N:N entre ALUNO e TURMA)
CREATE TABLE MATRICULA (
    id_matricula    INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno        INT          NOT NULL,
    id_turma        INT          NOT NULL,
    data_matricula  DATE         NOT NULL,
    situacao        VARCHAR(20)  NOT NULL, -- Ex: 'ATIVA', 'CONCLUIDA', 'TRANCADA'
    
    FOREIGN KEY (id_aluno) REFERENCES ALUNO(id_aluno),
    FOREIGN KEY (id_turma) REFERENCES TURMA(id_turma),
    
    -- Restrição para garantir que um aluno não se matricule na mesma turma mais de uma vez
    UNIQUE (id_aluno, id_turma)
);

-- 5. Tabela ACESSO (Registros de acesso do aluno ao ambiente virtual)
CREATE TABLE ACESSO (
    id_acesso       INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno        INT          NOT NULL,
    id_turma        INT          NOT NULL,
    data_hora       DATETIME     NOT NULL,
    tipo_acao       VARCHAR(50)  NOT NULL, -- Ex: 'LOGIN', 'LOGOUT', 'VISUALIZACAO_AULA', 'DOWNLOAD_MATERIAL'
    
    FOREIGN KEY (id_aluno) REFERENCES ALUNO(id_aluno),
    FOREIGN KEY (id_turma) REFERENCES TURMA(id_turma)
);

-- ==================================================================================
-- Restrições Adicionais (CHECK)
-- ==================================================================================

-- Adicionar restrição CHECK para carga_horaria (deve ser positiva)
ALTER TABLE CURSO
ADD CONSTRAINT chk_carga_horaria CHECK (carga_horaria > 0);

-- Adicionar restrição CHECK para status da TURMA
ALTER TABLE TURMA
ADD CONSTRAINT chk_turma_status CHECK (status IN ('ABERTA', 'EM ANDAMENTO', 'CONCLUIDA', 'CANCELADA'));

-- Adicionar restrição CHECK para situacao da MATRICULA
ALTER TABLE MATRICULA
ADD CONSTRAINT chk_matricula_situacao CHECK (situacao IN ('ATIVA', 'CONCLUIDA', 'TRANCADA', 'CANCELADA'));

-- Adicionar restrição CHECK para data_fim ser posterior a data_inicio
ALTER TABLE TURMA
ADD CONSTRAINT chk_datas_turma CHECK (data_fim >= data_inicio);
