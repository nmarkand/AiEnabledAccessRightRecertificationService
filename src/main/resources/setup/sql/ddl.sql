-- Enable the vector extension on the database level
CREATE EXTENSION IF NOT EXISTS vector;

-- ==========================================
-- SCHEMA 1: Core Relational Data (IAM)
-- ==========================================
CREATE SCHEMA iam_data;

CREATE TABLE iam_data.employees (
                                    employee_id VARCHAR(50) PRIMARY KEY,
                                    full_name VARCHAR(100),
                                    department VARCHAR(50),
                                    job_title VARCHAR(100),
                                    is_active BOOLEAN DEFAULT true
);

CREATE TABLE iam_data.roles (
                                role_code VARCHAR(50) PRIMARY KEY,
                                role_name VARCHAR(100),
                                risk_level VARCHAR(20)
);

CREATE TABLE iam_data.employee_roles (
                                         grant_id SERIAL PRIMARY KEY,
                                         employee_id VARCHAR(50) REFERENCES iam_data.employees(employee_id),
                                         role_code VARCHAR(50) REFERENCES iam_data.roles(role_code),
                                         granted_date DATE,
                                         last_login_date DATE
);

-- ==========================================
-- SCHEMA 2: AI Knowledge Base (Vector Data)
-- ==========================================
CREATE SCHEMA ai_knowledge;

-- Note: In your Spring Boot application.yml, you will need to tell Spring AI
-- to use this schema: spring.ai.vectorstore.pgvector.schema-name=ai_knowledge
CREATE TABLE ai_knowledge.vector_store (
                                           id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
                                           content text,
                                           metadata json,
                                           embedding vector(768)
);

CREATE INDEX ON ai_knowledge.vector_store USING HNSW (embedding vector_cosine_ops);