# Sistema de Banco de Dados para Plataforma EAD (Cursos Online)

**Autor:** Vinícius da Conceição Teixeira  
**Disciplina:** Projeto Integrador de Tecnologia da Informação II  
**Instituição:** UFMS
**Período:** 2025.2

---

## 📖 Sobre o Projeto

Este projeto documenta o desenvolvimento completo de um **banco de dados relacional** para uma plataforma de Ensino a Distância (EAD), aplicando as melhores práticas de engenharia de software e modelagem de dados.

### Propósito

Demonstrar competências em:
- 🗄️ Modelagem de dados relacionais
- 📝 Implementação de esquemas SQL
- 🔄 Controle de versão com Git/GitHub
- 🔍 Operações CRUD completas
- 📊 Consultas complexas e relatórios

---

## 🎯 Objetivos

### Objetivo Geral

Desenvolver e documentar um sistema de banco de dados robusto para gerenciamento de cursos online, utilizando controle de versão para rastreabilidade e evolução do projeto.

### Objetivos Específicos

- ✅ Definir modelo de dados (entidades, atributos, relacionamentos)
- ✅ Implementar esquema completo em SQL
- ✅ Executar operações CRUD (Create, Read, Update, Delete)
- ✅ Configurar repositório Git/GitHub
- ✅ Documentar commits com mensagens descritivas
- ✅ Publicar código-fonte em repositório público

---

## 💾 Modelagem do Banco de Dados

### Visão Geral

O modelo relacional foi concebido para suportar as funcionalidades essenciais de uma plataforma EAD moderna, incluindo gestão de alunos, cursos, turmas, matrículas e monitoramento de acessos.

### Diagrama Entidade-Relacionamento

```
┌──────────┐         ┌──────────┐         ┌──────────┐
│  ALUNO   │ N     N │ MATRICULA│ N     1 │  TURMA   │
├──────────┤◄────────┤──────────┤────────►├──────────┤
│id_aluno  │         │id_aluno  │         │id_turma  │
│nome      │         │id_turma  │    ┌────┤id_curso  │
│email     │         │situacao  │    │    │status    │
│cpf       │         └──────────┘    │    └──────────┘
└──────────┘                         │           ▲
     │                               │           │
     │ 1                             │ N       1 │
     │                               │           │
     ▼ N                             ▼           │
┌──────────┐                    ┌──────────┐    │
│  ACESSO  │                    │  CURSO   │────┘
├──────────┤                    ├──────────┤
│id_acesso │                    │id_curso  │
│id_aluno  │                    │titulo    │
│id_turma  │                    │descricao │
│data_hora │                    │carga_hor.│
│tipo_acao │                    └──────────┘
└──────────┘
```

---

## 📊 Estrutura das Tabelas

### 1. Tabela: ALUNO

Armazena os dados cadastrais dos estudantes da plataforma.

```sql
CREATE TABLE ALUNO (
    id_aluno INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cpf CHAR(11) NOT NULL UNIQUE,
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE
);
```

**Atributos:**
- `id_aluno` - Identificador único (PK)
- `nome` - Nome completo do aluno
- `email` - Email único para login
- `cpf` - CPF único (sem formatação)
- `data_cadastro` - Data de registro na plataforma

**Restrições:**
- ✅ Email e CPF são UNIQUE
- ✅ Todos os campos obrigatórios (NOT NULL)

---

### 2. Tabela: CURSO

Catálogo de cursos disponíveis na plataforma.

```sql
CREATE TABLE CURSO (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    carga_horaria INT NOT NULL CHECK (carga_horaria > 0)
);
```

**Atributos:**
- `id_curso` - Identificador único (PK)
- `titulo` - Nome do curso
- `descricao` - Informações detalhadas
- `carga_horaria` - Duração em horas

**Restrições:**
- ✅ Carga horária deve ser positiva (CHECK)
- ✅ Título obrigatório

---

### 3. Tabela: TURMA

Instâncias/ofertas de cursos com datas específicas.

```sql
CREATE TABLE TURMA (
    id_turma INT PRIMARY KEY AUTO_INCREMENT,
    id_curso INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    status ENUM('aberta', 'em_andamento', 'concluída') NOT NULL DEFAULT 'aberta',
    FOREIGN KEY (id_curso) REFERENCES CURSO(id_curso),
    CHECK (data_fim > data_inicio)
);
```

**Atributos:**
- `id_turma` - Identificador único (PK)
- `id_curso` - Curso associado (FK)
- `data_inicio` - Data de início da turma
- `data_fim` - Data de encerramento
- `status` - Situação atual da turma

**Restrições:**
- ✅ Data fim posterior à data início
- ✅ Status controlado por ENUM
- ✅ Integridade referencial com CURSO

---

### 4. Tabela: MATRICULA

Relacionamento N:N entre ALUNO e TURMA (tabela associativa).

```sql
CREATE TABLE MATRICULA (
    id_matricula INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT NOT NULL,
    id_turma INT NOT NULL,
    data_matricula DATE NOT NULL DEFAULT CURRENT_DATE,
    situacao ENUM('ativa', 'trancada', 'concluída', 'cancelada') NOT NULL DEFAULT 'ativa',
    FOREIGN KEY (id_aluno) REFERENCES ALUNO(id_aluno),
    FOREIGN KEY (id_turma) REFERENCES TURMA(id_turma),
    UNIQUE (id_aluno, id_turma)
);
```

**Atributos:**
- `id_matricula` - Identificador único (PK)
- `id_aluno` - Aluno matriculado (FK)
- `id_turma` - Turma escolhida (FK)
- `data_matricula` - Data da matrícula
- `situacao` - Status da matrícula

**Restrições:**
- ✅ Chave composta UNIQUE (aluno + turma)
- ✅ Situação controlada por ENUM
- ✅ Dupla integridade referencial

---

### 5. Tabela: ACESSO

Log de acessos dos alunos às turmas (auditoria).

```sql
CREATE TABLE ACESSO (
    id_acesso INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT NOT NULL,
    id_turma INT NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_acao VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES ALUNO(id_aluno),
    FOREIGN KEY (id_turma) REFERENCES TURMA(id_turma)
);
```

**Atributos:**
- `id_acesso` - Identificador único (PK)
- `id_aluno` - Aluno que acessou (FK)
- `id_turma` - Turma acessada (FK)
- `data_hora` - Timestamp do acesso
- `tipo_acao` - Tipo de ação (login, visualização, etc.)

**Restrições:**
- ✅ Todos os campos obrigatórios
- ✅ Registro automático de timestamp

---

## 🔗 Relacionamentos

### Mapeamento Completo

| Relacionamento | Cardinalidade | Implementação |
|----------------|---------------|---------------|
| CURSO → TURMA | 1:N | FK `id_curso` em TURMA |
| ALUNO ↔ TURMA | N:N | Tabela associativa MATRICULA |
| ALUNO → MATRICULA | 1:N | FK `id_aluno` em MATRICULA |
| TURMA → MATRICULA | 1:N | FK `id_turma` em MATRICULA |
| ALUNO → ACESSO | 1:N | FK `id_aluno` em ACESSO |
| TURMA → ACESSO | 1:N | FK `id_turma` em ACESSO |

### Integridade Referencial

```sql
-- Exemplos de constraints
FOREIGN KEY (id_curso) REFERENCES CURSO(id_curso)
    ON DELETE RESTRICT 
    ON UPDATE CASCADE

FOREIGN KEY (id_aluno) REFERENCES ALUNO(id_aluno)
    ON DELETE CASCADE 
    ON UPDATE CASCADE
```

---

## 📦 Estrutura do Repositório

```
cursos-online-ead-bd/
├── sql/
│   ├── schema.sql          # DDL - Definição das tabelas
│   ├── dml.sql             # DML - Operações CRUD
├── README.md               # Esta documentação
└── .gitignore              # Arquivos ignorados
```

---

## 🔧 Implementação SQL

### DDL (Data Definition Language)

Arquivo: `sql/schema.sql`

**Conteúdo:**
- ✅ CREATE TABLE para todas as entidades
- ✅ Definição de chaves primárias (PK)
- ✅ Definição de chaves estrangeiras (FK)
- ✅ Restrições CHECK e UNIQUE
- ✅ Valores DEFAULT apropriados

### DML (Data Manipulation Language)

Arquivo: `sql/dml.sql`

**Operações implementadas:**

#### 1. Inserção (INSERT)

```sql
-- Exemplo de inserção de aluno
INSERT INTO ALUNO (nome, email, cpf) 
VALUES ('João Silva', 'joao@email.com', '12345678901');

-- Exemplo de inserção de curso
INSERT INTO CURSO (titulo, descricao, carga_horaria)
VALUES ('Python para Iniciantes', 'Curso básico de Python', 40);
```

#### 2. Atualização (UPDATE)

```sql
-- Atualizar email de aluno
UPDATE ALUNO 
SET email = 'novoemail@email.com' 
WHERE id_aluno = 1;

-- Atualizar status de turma
UPDATE TURMA 
SET status = 'em_andamento' 
WHERE id_turma = 1;
```

#### 3. Remoção (DELETE)

```sql
-- Remover acesso específico
DELETE FROM ACESSO 
WHERE id_acesso = 5;

-- Remover matrículas canceladas antigas
DELETE FROM MATRICULA 
WHERE situacao = 'cancelada' 
AND data_matricula < '2024-01-01';
```

#### 4. Consultas (SELECT)

```sql
-- Listar todos os alunos
SELECT * FROM ALUNO ORDER BY nome;

-- Cursos com carga horária superior a 30h
SELECT titulo, carga_horaria 
FROM CURSO 
WHERE carga_horaria > 30;

-- Consulta complexa com JOIN (requisito obrigatório)
SELECT 
    a.nome AS aluno,
    c.titulo AS curso,
    t.data_inicio,
    t.data_fim,
    m.situacao
FROM ALUNO a
INNER JOIN MATRICULA m ON a.id_aluno = m.id_aluno
INNER JOIN TURMA t ON m.id_turma = t.id_turma
INNER JOIN CURSO c ON t.id_curso = c.id_curso
WHERE m.situacao = 'ativa'
ORDER BY a.nome, c.titulo;

-- Contagem de matrículas por curso (GROUP BY)
SELECT 
    c.titulo,
    COUNT(m.id_matricula) AS total_matriculas
FROM CURSO c
LEFT JOIN TURMA t ON c.id_curso = t.id_curso
LEFT JOIN MATRICULA m ON t.id_turma = m.id_turma
GROUP BY c.id_curso, c.titulo
ORDER BY total_matriculas DESC;
```

---

## 🔍 Consultas Avançadas

### Relatório de Alunos por Turma

```sql
SELECT 
    t.id_turma,
    c.titulo AS curso,
    t.status,
    COUNT(m.id_aluno) AS total_alunos
FROM TURMA t
INNER JOIN CURSO c ON t.id_curso = c.id_curso
LEFT JOIN MATRICULA m ON t.id_turma = m.id_turma
GROUP BY t.id_turma, c.titulo, t.status
HAVING COUNT(m.id_aluno) > 0;
```

### Alunos Mais Ativos

```sql
SELECT 
    a.nome,
    a.email,
    COUNT(ac.id_acesso) AS total_acessos
FROM ALUNO a
INNER JOIN ACESSO ac ON a.id_aluno = ac.id_aluno
GROUP BY a.id_aluno, a.nome, a.email
ORDER BY total_acessos DESC
LIMIT 10;
```

### Turmas Disponíveis para Matrícula

```sql
SELECT 
    t.id_turma,
    c.titulo,
    t.data_inicio,
    t.data_fim,
    COUNT(m.id_matricula) AS vagas_ocupadas
FROM TURMA t
INNER JOIN CURSO c ON t.id_curso = c.id_curso
LEFT JOIN MATRICULA m ON t.id_turma = m.id_turma
WHERE t.status = 'aberta'
AND t.data_inicio > CURRENT_DATE
GROUP BY t.id_turma, c.titulo, t.data_inicio, t.data_fim;
```

---

## 🔄 Controle de Versão (Git/GitHub)

### Histórico de Commits

O desenvolvimento seguiu uma abordagem incremental e organizada:

| # | Commit | Mensagem | Alterações |
|---|--------|----------|-----------|
| 1️⃣ | `feat` | Inicialização do projeto e estrutura de diretórios | Criação de pastas sql/, docs/ |
| 2️⃣ | `feat` | Implementação do esquema do banco de dados (DDL) | schema.sql completo |
| 3️⃣ | `feat` | Implementação das operações de manipulação (DML) | dml.sql com CRUD |
| 4️⃣ | `docs` | Adiciona README.md com documentação completa | Este arquivo |

### Padrão de Mensagens (Conventional Commits)

```
<tipo>(<escopo>): <descrição>

[corpo opcional]
[rodapé opcional]
```

**Tipos utilizados:**
- `feat` - Nova funcionalidade
- `fix` - Correção de bug
- `docs` - Documentação
- `refactor` - Refatoração de código
- `test` - Adição de testes

### Branches Utilizadas

```
main (produção)
├── develop (desenvolvimento)
│   ├── feature/schema
│   ├── feature/dml
│   └── feature/docs
```

---

## 🚀 Como Utilizar

### Pré-requisitos

```bash
# Ferramentas necessárias
MySQL 8.0+ ou MariaDB 10.6+
Git 2.40+
Cliente SQL (MySQL Workbench, DBeaver, etc.)
```

### Instalação Passo a Passo

#### 1. Clonar o Repositório

```bash
git clone https://github.com/viniciusvdct/cursos-online-ead-bd.git
cd cursos-online-ead-bd
```

#### 2. Conectar ao MySQL

```bash
mysql -u root -p
```

#### 3. Criar o Banco de Dados

```sql
CREATE DATABASE cursos_online CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cursos_online;
```

#### 4. Executar os Scripts

**Opção A - Linha de comando:**
```bash
mysql -u root -p cursos_online < sql/schema.sql
mysql -u root -p cursos_online < sql/dml.sql
```

**Opção B - Interface gráfica:**
1. Abra o MySQL Workbench
2. Execute `schema.sql` primeiro
3. Execute `dml.sql` em seguida

#### 5. Verificar a Instalação

```sql
-- Listar tabelas criadas
SHOW TABLES;

-- Verificar estrutura
DESCRIBE ALUNO;
DESCRIBE CURSO;
DESCRIBE TURMA;
DESCRIBE MATRICULA;
DESCRIBE ACESSO;

-- Verificar dados inseridos
SELECT COUNT(*) FROM ALUNO;
SELECT COUNT(*) FROM CURSO;
```

---

## 🧪 Testes e Validação

### Testes de Integridade

```sql
-- Teste 1: Tentar inserir aluno com CPF duplicado (deve falhar)
INSERT INTO ALUNO (nome, email, cpf) 
VALUES ('Teste', 'teste@email.com', '12345678901');
-- Erro esperado: Duplicate entry

-- Teste 2: Tentar criar turma com data_fim anterior a data_inicio (deve falhar)
INSERT INTO TURMA (id_curso, data_inicio, data_fim) 
VALUES (1, '2025-12-31', '2025-01-01');
-- Erro esperado: Check constraint violation

-- Teste 3: Tentar matricular aluno em turma inexistente (deve falhar)
INSERT INTO MATRICULA (id_aluno, id_turma) 
VALUES (1, 9999);
-- Erro esperado: Foreign key constraint fails
```

### Testes de Performance

```sql
-- Criar índice para otimização
CREATE INDEX idx_aluno_email ON ALUNO(email);
CREATE INDEX idx_matricula_aluno ON MATRICULA(id_aluno);
CREATE INDEX idx_acesso_data ON ACESSO(data_hora);

-- Testar performance
EXPLAIN SELECT * FROM ALUNO WHERE email = 'joao@email.com';
```

---

## 📈 Estatísticas do Projeto

| Métrica | Valor |
|---------|-------|
| **Tabelas criadas** | 5 |
| **Relacionamentos** | 6 |
| **Constraints (CHECK, UNIQUE, FK)** | 12+ |
| **Commits realizados** | 4+ |
| **Queries implementadas** | 10+ |
| **Linhas de SQL** | 300+ |

---

## 🔮 Melhorias Futuras

### Fase 2 - Expansão Funcional

- 📚 **Módulos e Aulas**: Dividir cursos em módulos e aulas
- 📝 **Avaliações**: Sistema de provas e exercícios
- 🎓 **Certificados**: Emissão automática de certificados
- 💬 **Fóruns**: Discussões entre alunos

### Fase 3 - Otimização

- 🚀 **Índices avançados**: Otimizar consultas frequentes
- 📊 **Views materializadas**: Relatórios pré-calculados
- 🔒 **Stored Procedures**: Lógica de negócio no banco
- ⚡ **Triggers**: Automação de processos

### Fase 4 - Integração

- 🌐 **API REST**: Backend em Node.js/Python
- 📱 **App Mobile**: React Native / Flutter
- 📧 **Notificações**: Email e push notifications
- ☁️ **Cloud Deploy**: AWS RDS / Google Cloud SQL

---

## 🛠️ Tecnologias e Ferramentas

| Ferramenta | Versão | Finalidade |
|------------|--------|-----------|
| **MySQL** | 8.0+ | Sistema Gerenciador de Banco de Dados |
| **Git** | 2.40+ | Controle de versão |
| **GitHub** | - | Hospedagem do repositório |
| **MySQL Workbench** | 8.0+ | Modelagem e administração |
| **DBeaver** | 23.0+ | Cliente SQL alternativo |

---

## 🔗 Link do Repositório

📦 **Repositório GitHub (Código Completo):**  
🔗 https://github.com/viniciusvdct/cursos-online-ead-bd

**Conteúdo disponível:**
- ✅ Scripts SQL completos (DDL + DML)
- ✅ Diagrama Entidade-Relacionamento
- ✅ Documentação detalhada
- ✅ Histórico de commits
- ✅ Exemplos de consultas

---

## 📚 Referências Técnicas

### Documentação Oficial

- [MySQL 8.0 Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)
- [SQL Standards - ISO/IEC 9075](https://www.iso.org/standard/63555.html)
- [Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)

### Tutoriais Recomendados

- [W3Schools - SQL Tutorial](https://www.w3schools.com/sql/)
- [SQLBolt - Interactive Lessons](https://sqlbolt.com/)
- [MySQL Tutorial](https://www.mysqltutorial.org/)

### Livros de Referência

- **"Database System Concepts"** - Silberschatz, Korth, Sudarshan
- **"SQL in 10 Minutes"** - Ben Forta
- **"High Performance MySQL"** - Baron Schwartz

---

## 🎓 Conceitos Aplicados

### Normalização

O modelo atende às **três primeiras formas normais (1FN, 2FN, 3FN)**:

- ✅ **1FN** - Todos os atributos são atômicos
- ✅ **2FN** - Não há dependências parciais
- ✅ **3FN** - Não há dependências transitivas

### Integridade de Dados

**Integridade de Entidade:**
- Todas as tabelas possuem chave primária

**Integridade Referencial:**
- Chaves estrangeiras com ON DELETE e ON UPDATE

**Integridade de Domínio:**
- Constraints CHECK para validação
- ENUM para valores pré-definidos

**Integridade Definida pelo Usuário:**
- UNIQUE para evitar duplicatas
- DEFAULT para valores padrão

---

## 📊 Dicionário de Dados

### Tipos de Dados Utilizados

| Tipo SQL | Uso | Exemplo |
|----------|-----|---------|
| INT | Identificadores | id_aluno, id_curso |
| VARCHAR(n) | Textos variáveis | nome, email, titulo |
| TEXT | Textos longos | descricao |
| CHAR(n) | Textos fixos | cpf (11 dígitos) |
| DATE | Datas | data_inicio, data_fim |
| DATETIME | Data + hora | data_hora (acessos) |
| ENUM | Valores fixos | status, situacao |

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Para contribuir:

1. **Fork** o repositório
2. Crie uma **branch** para sua feature:
   ```bash
   git checkout -b feature/MinhaNovaFeature
   ```
3. **Commit** suas mudanças:
   ```bash
   git commit -m 'feat: Adiciona nova funcionalidade X'
   ```
4. **Push** para a branch:
   ```bash
   git push origin feature/MinhaNovaFeature
   ```
5. Abra um **Pull Request**

### Diretrizes

- Use mensagens de commit descritivas
- Documente alterações significativas
- Teste antes de submeter PR
- Siga o padrão SQL do projeto

---

## 📄 Licença

Este projeto está licenciado sob a **MIT License**.

```
MIT License

Copyright (c) 2025 Vinícius da Conceição Teixeira

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 👨‍💻 Sobre o Autor

**Vinícius da Conceição Teixeira**  
Estudante de Tecnologia da Informação  
UFMS Digital - Universidade Federal de Mato Grosso do Sul

**📅 Data de Conclusão:** Novembro de 2025  
**🔖 Versão:** 1.0.0  
**⭐ Status:** ✅ Concluído  
**🎯 Propósito:** Relatório Final - Projeto Integrador  
