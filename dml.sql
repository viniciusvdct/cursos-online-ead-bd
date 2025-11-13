-- ==================================================================================
-- DML (Data Manipulation Language) - Operações de Manipulação de Dados
-- Sistema de Cursos Online (EAD)
-- ==================================================================================

-- ----------------------------------------------------------------------------------
-- 1. INSERÇÃO DE DADOS (Povoamento)
-- ----------------------------------------------------------------------------------

-- Inserir ALUNOS
INSERT INTO ALUNO (nome, email, cpf, data_cadastro) VALUES
('Vinicius Costa', 'vinicius@email.com', '11122233344', '2023-10-01'),
('Maria Oliveira', 'maria@email.com', '55566677788', '2023-10-05'),
('Carlos Pereira', 'carlos@email.com', '99900011122', '2023-10-10');

-- Inserir CURSOS
INSERT INTO CURSO (titulo, descricao, carga_horaria) VALUES
('Introdução ao SQL', 'Curso básico sobre a linguagem SQL e bancos de dados relacionais.', 40),
('Modelagem de Dados Avançada', 'Técnicas de modelagem conceitual e lógica.', 60),
('Git e GitHub para Desenvolvedores', 'Controle de versão essencial para projetos.', 20);

-- Inserir TURMAS
-- Turma 1: Introdução ao SQL
INSERT INTO TURMA (id_curso, data_inicio, data_fim, status) VALUES
(1, '2023-11-01', '2023-12-01', 'EM ANDAMENTO');
-- Turma 2: Modelagem de Dados Avançada
INSERT INTO TURMA (id_curso, data_inicio, data_fim, status) VALUES
(2, '2024-01-15', '2024-03-15', 'ABERTA');
-- Turma 3: Git e GitHub para Desenvolvedores (Concluída)
INSERT INTO TURMA (id_curso, data_inicio, data_fim, status) VALUES
(3, '2023-09-01', '2023-09-30', 'CONCLUIDA');

-- Inserir MATRICULAS
-- Vinicius (id_aluno=1) se matricula em SQL (id_turma=1) e Git (id_turma=3)
INSERT INTO MATRICULA (id_aluno, id_turma, data_matricula, situacao) VALUES
(1, 1, '2023-10-25', 'ATIVA'),
(1, 3, '2023-09-01', 'CONCLUIDA');
-- Maria (id_aluno=2) se matricula em SQL (id_turma=1)
INSERT INTO MATRICULA (id_aluno, id_turma, data_matricula, situacao) VALUES
(2, 1, '2023-10-28', 'ATIVA');
-- Carlos (id_aluno=3) se matricula em Modelagem (id_turma=2)
INSERT INTO MATRICULA (id_aluno, id_turma, data_matricula, situacao) VALUES
(3, 2, '2023-11-10', 'ATIVA');

-- Inserir ACESSOS
INSERT INTO ACESSO (id_aluno, id_turma, data_hora, tipo_acao) VALUES
(1, 1, '2023-11-13 10:00:00', 'LOGIN'),
(1, 1, '2023-11-13 10:15:00', 'VISUALIZACAO_AULA'),
(2, 1, '2023-11-13 11:00:00', 'LOGIN'),
(1, 3, '2023-09-29 15:30:00', 'DOWNLOAD_MATERIAL');

-- ----------------------------------------------------------------------------------
-- 2. ATUALIZAÇÃO DE DADOS (UPDATE)
-- ----------------------------------------------------------------------------------

-- Exemplo 1: Atualizar o e-mail de um aluno
UPDATE ALUNO
SET email = 'vinicius.novo@email.com'
WHERE id_aluno = 1;

-- Exemplo 2: Mudar o status de uma turma para 'CONCLUIDA' (simulando o fim do curso)
UPDATE TURMA
SET status = 'CONCLUIDA'
WHERE id_turma = 3;

-- Exemplo 3: Mudar a situação de uma matrícula para 'TRANCADA'
UPDATE MATRICULA
SET situacao = 'TRANCADA'
WHERE id_aluno = 3 AND id_turma = 2;

-- ----------------------------------------------------------------------------------
-- 3. REMOÇÃO DE DADOS (DELETE)
-- ----------------------------------------------------------------------------------

-- Exemplo 1: Remover um registro de acesso antigo
DELETE FROM ACESSO
WHERE id_acesso = 4; -- Remove o acesso de download de material

-- Exemplo 2: Remover um curso que foi cancelado (após remover as turmas e matrículas relacionadas, se houver)
-- DELETE FROM CURSO WHERE id_curso = 3; -- Comentado para manter os dados para as consultas

-- ----------------------------------------------------------------------------------
-- 4. CONSULTAS (SELECT)
-- ----------------------------------------------------------------------------------

-- Consulta 1: Listar todos os alunos e seus dados de contato
SELECT id_aluno, nome, email, cpf FROM ALUNO;

-- Consulta 2: Listar todos os cursos com carga horária superior a 40 horas
SELECT titulo, carga_horaria FROM CURSO
WHERE carga_horaria > 40;

-- Consulta 3: Listar os alunos matriculados em uma turma específica (Ex: Turma 1 - Introdução ao SQL)
SELECT 
    A.nome AS Nome_Aluno,
    M.situacao AS Situacao_Matricula
FROM ALUNO A
JOIN MATRICULA M ON A.id_aluno = M.id_aluno
WHERE M.id_turma = 1;

-- Consulta 4: Consulta com JOIN para listar Aluno, Curso e Turma (Conforme solicitado no requisito)
SELECT 
    A.nome AS Nome_Aluno, 
    C.titulo AS Titulo_Curso, 
    T.id_turma AS ID_Turma,
    M.situacao AS Situacao_Matricula
FROM ALUNO A
JOIN MATRICULA M ON A.id_aluno = M.id_aluno
JOIN TURMA T     ON M.id_turma = T.id_turma
JOIN CURSO C     ON T.id_curso = C.id_curso
ORDER BY Nome_Aluno, ID_Turma;

-- Consulta 5: Contar o número de matrículas por curso
SELECT 
    C.titulo AS Titulo_Curso,
    COUNT(M.id_matricula) AS Total_Matriculas
FROM CURSO C
JOIN TURMA T ON C.id_curso = T.id_curso
JOIN MATRICULA M ON T.id_turma = M.id_turma
GROUP BY C.titulo
ORDER BY Total_Matriculas DESC;
