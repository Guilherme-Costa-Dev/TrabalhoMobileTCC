CREATE DATABASE IF NOT EXISTS banco_bico;
USE banco_bico;

-- TABELA DE USUÁRIOS

CREATE TABLE IF NOT EXISTS Usuario (
    id_usuario INT AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE, 
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(25),
    cidade VARCHAR(100),
    bairro VARCHAR(100),
    estado VARCHAR(50),
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cep VARCHAR(10),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    CONSTRAINT PK_Usuario PRIMARY KEY (id_usuario)
);

-- TABELA DE PERFIL DE PRESTADOR 

CREATE TABLE IF NOT EXISTS PerfilPrestador (
    id_perfil INT AUTO_INCREMENT,
    id_usuario INT NOT NULL UNIQUE,
    descricao TEXT,
    foto_perfil VARCHAR(255),
    raio_atendimento INT,
    CONSTRAINT PK_PerfilPrestador PRIMARY KEY (id_perfil),
    CONSTRAINT FK_PerfilPrestador_Usuario FOREIGN KEY (id_usuario) 
        REFERENCES Usuario (id_usuario) ON DELETE CASCADE
);

-- TABELAS DE ESPECIALIDADES E PORTFÓLIO

CREATE TABLE IF NOT EXISTS Especialidade (
    id_especialidade INT AUTO_INCREMENT,
    nome_servico VARCHAR(100) NOT NULL UNIQUE,
    CONSTRAINT PK_Especialidade PRIMARY KEY (id_especialidade)
);

CREATE TABLE IF NOT EXISTS PrestadorEspecialidade (
    id_perfil INT NOT NULL,
    id_especialidade INT NOT NULL,
    CONSTRAINT PK_PrestadorEspecialidade PRIMARY KEY (id_perfil, id_especialidade),
    CONSTRAINT FK_PrestadorEsp_Perfil FOREIGN KEY (id_perfil) 
        REFERENCES PerfilPrestador (id_perfil) ON DELETE CASCADE,
    CONSTRAINT FK_PrestadorEsp_Especialidade FOREIGN KEY (id_especialidade) 
        REFERENCES Especialidade (id_especialidade) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Portfolio (
    id_midia INT AUTO_INCREMENT,
    id_perfil INT NOT NULL,
    arquivo VARCHAR(255) NOT NULL,
    tipo VARCHAR(50),
    descricao VARCHAR(255),
    CONSTRAINT PK_Portfolio PRIMARY KEY (id_midia),
    CONSTRAINT FK_Portfolio_Perfil FOREIGN KEY (id_perfil) 
        REFERENCES PerfilPrestador (id_perfil) ON DELETE CASCADE
);

-- TABELAS DE COMUNICAÇÃO

CREATE TABLE IF NOT EXISTS Chat (
    id_chat INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_prestador INT NOT NULL,
    data_inicio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Chat PRIMARY KEY (id_chat),
    CONSTRAINT FK_Chat_Cliente FOREIGN KEY (id_cliente) 
        REFERENCES Usuario (id_usuario) ON DELETE CASCADE,
    CONSTRAINT FK_Chat_Prestador FOREIGN KEY (id_prestador) 
        REFERENCES PerfilPrestador (id_perfil) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Mensagem (
    id_mensagem INT AUTO_INCREMENT,
    id_chat INT NOT NULL,
    id_remetente INT NOT NULL,
    conteudo TEXT NOT NULL,
    data_envio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Mensagem PRIMARY KEY (id_mensagem),
    CONSTRAINT FK_Mensagem_Chat FOREIGN KEY (id_chat) 
        REFERENCES Chat (id_chat) ON DELETE CASCADE,
    CONSTRAINT FK_Mensagem_Remetente FOREIGN KEY (id_remetente) 
        REFERENCES Usuario (id_usuario) ON DELETE CASCADE
);

-- TABELAS DE OPERAÇÃO E AVALIAÇÃO

CREATE TABLE IF NOT EXISTS Servico (
    id_servico INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_prestador INT NOT NULL,
    descricao_servico VARCHAR(255),
    data_hora DATETIME NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Pendente', 
    valor DECIMAL(10,2),
    prazo DATE,
    parcelas_disponiveis INT,
    CONSTRAINT PK_Servico PRIMARY KEY (id_servico),
    CONSTRAINT FK_Servico_Cliente FOREIGN KEY (id_cliente) 
        REFERENCES Usuario (id_usuario) ON DELETE CASCADE,
    CONSTRAINT FK_Servico_Prestador FOREIGN KEY (id_prestador) 
        REFERENCES PerfilPrestador (id_perfil) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Avaliacao (
    id_avaliacao INT AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_prestador INT NOT NULL,
    nota DECIMAL(3,1) NOT NULL, 
    comentario TEXT,
    data_avaliacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_Avaliacao PRIMARY KEY (id_avaliacao),
    CONSTRAINT FK_Avaliacao_Cliente FOREIGN KEY (id_cliente) 
        REFERENCES Usuario (id_usuario) ON DELETE CASCADE,
    CONSTRAINT FK_Avaliacao_Prestador FOREIGN KEY (id_prestador) 
        REFERENCES PerfilPrestador (id_perfil) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Favorito (
    id_cliente INT NOT NULL,
    id_prestador INT NOT NULL,
    CONSTRAINT PK_Favorito PRIMARY KEY (id_cliente, id_prestador),
    CONSTRAINT FK_Favorito_Cliente FOREIGN KEY (id_cliente) 
        REFERENCES Usuario (id_usuario) ON DELETE CASCADE,
    CONSTRAINT FK_Favorito_Prestador FOREIGN KEY (id_prestador) 
        REFERENCES PerfilPrestador (id_perfil) ON DELETE CASCADE
);

-- TABELA DE SEGURANÇA E SUPORTE

CREATE TABLE IF NOT EXISTS Denuncia_Suporte (
    id_denuncia INT AUTO_INCREMENT,
    id_remetente INT NOT NULL, 
    tipo VARCHAR(50),          
    categoria VARCHAR(100),
    descricao VARCHAR(1000), 
    anexo_url VARCHAR(255),
    status VARCHAR(50) DEFAULT 'Aberto',
    id_denunciado INT NULL,    
    id_mensagem INT NULL,      
    CONSTRAINT PK_Denuncia PRIMARY KEY (id_denuncia),
    CONSTRAINT FK_Denuncia_Remetente FOREIGN KEY (id_remetente) 
        REFERENCES Usuario (id_usuario) ON DELETE CASCADE,
    CONSTRAINT FK_Denuncia_Denunciado FOREIGN KEY (id_denunciado) 
        REFERENCES Usuario (id_usuario) ON DELETE SET NULL,
    CONSTRAINT FK_Denuncia_Mensagem FOREIGN KEY (id_mensagem) 
        REFERENCES Mensagem (id_mensagem) ON DELETE SET NULL 
);