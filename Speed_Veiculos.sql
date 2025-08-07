-- Criar base de dados para concessionária
CREATE DATABASE CONCESSIONARIA;
GO
USE CONCESSIONARIA;

-- Criando tabela de departamento
CREATE TABLE DEPARTAMENTO(
    ID_DEPARTAMENTO INT IDENTITY(1,1) PRIMARY KEY,
    NOME_DEPARTAMENTO VARCHAR(25) NOT NULL
);

-- Criando tabela de cliente
CREATE TABLE CLIENTE(
    ID_CLIENTE INT IDENTITY(1,1) PRIMARY KEY,
    NOME_CLIENTE VARCHAR(30) NOT NULL,
    ENDERECO VARCHAR(200) NOT NULL,
    TELEFONE BIGINT NOT NULL
);

-- Criando tabela de fornecedor
CREATE TABLE FORNECEDOR(
    ID_FORNECEDOR INT IDENTITY(1,1) PRIMARY KEY,
    NOME_FORNECEDOR VARCHAR(30) NOT NULL,
    CNPJ VARCHAR(14) NOT NULL,
    TELEFONE BIGINT NOT NULL,
    ENDERECO VARCHAR(200) NOT NULL
);

-- Criando tabela de funcionário
CREATE TABLE FUNCIONARIO(
    ID_FUNCIONARIO INT IDENTITY(1,1) PRIMARY KEY,
    ID_DEPARTAMENTO INT,
    NOME_FUNCIONARIO VARCHAR(30) NOT NULL,
    SALARIO DECIMAL(10,2),
    DATA_ADMISSAO DATE,
    DATA_DEMISSAO DATE NULL,
    MOTIVO_DEMISSAO VARCHAR(70) NULL,
    ESPECIALIDADE VARCHAR(50) NULL,
    COMISSAO_PORC DECIMAL(5,2) NULL,
    FOREIGN KEY(ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO)
);

-- 3. Tabelas que dependem das tabelas acima
CREATE TABLE VEICULO(
    ID_VEICULO INT IDENTITY(1,1) PRIMARY KEY,
    ID_CLIENTE INT,
    PLACA VARCHAR(7),
    MODELO VARCHAR(10),
    CHASSIS VARCHAR(17),
    MARCA VARCHAR(10),
    FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE)
);

CREATE TABLE PRODUTO(
    ID_PRODUTO BIGINT IDENTITY(1,1) PRIMARY KEY,
    ID_FORNECEDOR INT,
    NOME_PRODUTO VARCHAR(25) NOT NULL,
    DESCRICAO VARCHAR(200),
    CATEGORIA VARCHAR(25) NOT NULL,
    QUANTIDADE BIGINT NOT NULL,
    QUANTIDADE_MINIMA INT,
    PRECO DECIMAL(10, 2) NOT NULL,
    VALIDADE DATE NULL,
    FOREIGN KEY(ID_FORNECEDOR) REFERENCES FORNECEDOR(ID_FORNECEDOR)
);

-- 4. Tabelas que dependem das tabelas acima
CREATE TABLE ORDEM_SERVICO(
    ID_OS INT IDENTITY(200, 1) PRIMARY KEY,
    ID_VEICULO INT,
    ID_CLIENTE INT,
    DATA_INICIO DATE,
    DATA_CONCLUSAO DATE,
    DATA_PREVISTA DATE,
    AGENDAMENTO DATE,
    DURACAO_SERVICO AS DATEDIFF(DAY, DATA_INICIO, DATA_CONCLUSAO) PERSISTED,
    VALOR_TOTAL DECIMAL(10,2),
    REPARO VARCHAR(100),
    FOREIGN KEY(ID_VEICULO) REFERENCES VEICULO(ID_VEICULO),
    FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE)
);

CREATE TABLE VENDAS(
    ID_VENDA INT IDENTITY(1,1) PRIMARY KEY,
    ID_VEICULO INT,
    ID_CLIENTE INT,
    ID_FUNCIONARIO INT,
    DATA_VENDA DATE DEFAULT GETDATE(),
    TIPO_VENDA VARCHAR(10),
    VALOR_VENDA DECIMAL(10,2),
    FORMA_PAGAMENTO VARCHAR(20),
    STATUS_VENDA VARCHAR(20),
    FOREIGN KEY(ID_VEICULO) REFERENCES VEICULO(ID_VEICULO),
    FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    FOREIGN KEY(ID_FUNCIONARIO) REFERENCES FUNCIONARIO(ID_FUNCIONARIO)
);

-- 5. Tabelas que dependem das tabelas acima
CREATE TABLE PAGAMENTO(
    ID_PAGAMENTO INT IDENTITY(1,1) PRIMARY KEY,
    ID_CLIENTE INT,
    ID_OS INT NULL,
    ID_PRODUTO BIGINT NULL,
    METODO_PAGAMENTO VARCHAR(30),
    PARCELAS INT,
    DATA_PAGAMENTO DATE,
    VALOR_PAGAMENTO DECIMAL(10,2),
    STATUS_PAGAMENTO VARCHAR(20),
    FOREIGN KEY(ID_OS) REFERENCES ORDEM_SERVICO(ID_OS),
    FOREIGN KEY(ID_PRODUTO) REFERENCES PRODUTO(ID_PRODUTO),
    FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE)
);

CREATE TABLE FEEDBACK(
    ID_FEEDBACK INT IDENTITY(1,1) PRIMARY KEY,
    ID_CLIENTE INT,
    AVALIACAO INT,
    DESCRICAO VARCHAR(200),
    FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE)
);

CREATE TABLE FINANCIMENTO(
    ID_FINANCIAMENTO INT IDENTITY(100,1) PRIMARY KEY,
    ID_VENDA INT,
    VALOR_FINANCIADO DECIMAL(10,2),
    TAXA_JUROS_ANUAL DECIMAL(5,2),
    NUM_PARCELAS INT,
    DATA_PRIMEIRA_PARCELA DATE,
    FOREIGN KEY(ID_VENDA) REFERENCES VENDAS(ID_VENDA)
);

CREATE TABLE SEGURO_GARANTIA(
    ID_SEGURO INT IDENTITY(1,1) PRIMARY KEY,
    ID_VENDA INT,
    TIPO_SEGURO VARCHAR(25),
    VALOR_SEGURO DECIMAL(10,2),
    GARANTIA_EXT_MES INT,
    FOREIGN KEY(ID_VENDA) REFERENCES VENDAS(ID_VENDA)
);

CREATE TABLE CONTA_RECEBER(
    ID_CONTA_R INT IDENTITY(1,1) PRIMARY KEY,
    ID_CLIENTE INT,
    ID_VENDA INT,
    VALOR_R DECIMAL(10,2),
    DATA_EMISSAO_R DATE,
    DATA_VENCIMENTO_R DATE,
    STATUS_R VARCHAR(20),
    FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    FOREIGN KEY(ID_VENDA) REFERENCES VENDAS(ID_VENDA)
);

CREATE TABLE CONTA_PAGAR(
    ID_CONTA_P INT IDENTITY(1,1) PRIMARY KEY,
    ID_FORNECEDOR INT,
    ID_PRODUTO INT,
    VALOR_P DECIMAL(10,2),
    DATA_EMISSAO_P DATE,
    DATA_VENCIMENTO_P DATE,
    STATUS_P VARCHAR(20),
    FOREIGN KEY(ID_FORNECEDOR) REFERENCES FORNECEDOR(ID_FORNECEDOR)
);

CREATE TABLE MOVIMENTO_ESTOQUE(
    ID_MOVIMENTO INT IDENTITY(100,1) PRIMARY KEY,
    ID_PRODUTO BIGINT,
    ID_OS INT,
    ID_FORNECEDOR INT,
    QUANTIDADE INT,
    TIPO_MOVIMENTO VARCHAR(10),
    DATA_MOVIMENTO DATE,
    FOREIGN KEY(ID_PRODUTO) REFERENCES PRODUTO(ID_PRODUTO),
    FOREIGN KEY(ID_OS) REFERENCES ORDEM_SERVICO(ID_OS),
    FOREIGN KEY(ID_FORNECEDOR) REFERENCES FORNECEDOR(ID_FORNECEDOR)
);

CREATE TABLE ATENDIMENTO(
    ID_ATENDIMENTO INT IDENTITY(200,1) PRIMARY KEY,
    ID_CLIENTE INT,
    ID_RESPONSAVEL INT,
    ASSUNTO VARCHAR(70),
    DESCRICAO TEXT,
    DATA_ABERTURA DATETIME,
    STATUS_ATENDIMENTO VARCHAR(20),
    FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    FOREIGN KEY(ID_RESPONSAVEL) REFERENCES FUNCIONARIO(ID_FUNCIONARIO)
);

CREATE TABLE OS_TECNICO(
    ID_OS_TECNICO INT IDENTITY(20,1) PRIMARY KEY,
    ID_OS INT,
    ID_FUNCIONARIO INT,
    DATA_INICIO DATE,
    DATA_FIM DATE,
    FOREIGN KEY(ID_OS) REFERENCES ORDEM_SERVICO(ID_OS),
    FOREIGN KEY(ID_FUNCIONARIO) REFERENCES FUNCIONARIO(ID_FUNCIONARIO)
);

CREATE TABLE GARANTIA_OS(
    ID_GARANTIA INT IDENTITY(3000,1) PRIMARY KEY,
    ID_OS INT,
    DATA_INICIO DATE,
    PERIODO_MESES INT,
    STATUS_GARANTIA VARCHAR(30),
    FOREIGN KEY(ID_OS) REFERENCES ORDEM_SERVICO(ID_OS)
);

CREATE TABLE RECLAMACAO(
    ID_RECLAMACAO INT IDENTITY(4000,1) PRIMARY KEY,
    ID_CLIENTE INT,
    ID_GARANTIA INT,
    DATA_RECLAMACAO DATETIME,
    DESCRICAO TEXT,
    STATUS_RECLAMACAO VARCHAR(20),
    FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    FOREIGN KEY(ID_GARANTIA) REFERENCES GARANTIA_OS(ID_GARANTIA)
);

CREATE TABLE CONTRATO(
    ID_CONTRATO INT IDENTITY(1,1) PRIMARY KEY,
    ID_CLIENTE INT,
    ID_FUNCIONARIO INT,
    TIPO_CONTRATO VARCHAR(40),
    DATA_INICIO_CONTRATO DATE,
    DATA_FIM_CONTRATO DATE,
    TEXTO_CONTRATO TEXT,
    FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    FOREIGN KEY(ID_FUNCIONARIO) REFERENCES FUNCIONARIO(ID_FUNCIONARIO)
);

CREATE TABLE AGENCIAMENTO_VEICULO(
    ID_AGENCIAMENTO INT IDENTITY(1,1) PRIMARY KEY,
    ID_CLIENTE INT,
    ID_VEICULO INT,
    DATA_AGENCIAMENTO DATE,
    VALOR_AGENCIAMENTO DECIMAL(10,2),
    PRAZO_DIAS INT,
    COMISSAO_PORC DECIMAL(5,2),
    STATUS_AGENCIAMENTO VARCHAR(20),
    FOREIGN KEY(ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    FOREIGN KEY(ID_VEICULO) REFERENCES VEICULO(ID_VEICULO)
);

-- Inserindo departamentos
INSERT INTO DEPARTAMENTO (NOME_DEPARTAMENTO) VALUES
('Mecânica'),
('Elétrica'),
('Pintura'),
('Administração'),
('Vendas'),
('Compras'),
('Financeiro'),
('RH'),
('TI'),
('Logística'),
('Atendimento'),
('Estoque'),
('Garantia'),
('Seguros'),
('Agenciamento');

-- Inserindo dados de funcionários
INSERT INTO FUNCIONARIO (ID_DEPARTAMENTO, NOME_FUNCIONARIO, SALARIO, DATA_ADMISSAO, DATA_DEMISSAO, MOTIVO_DEMISSAO, ESPECIALIDADE, COMISSAO_PORC) VALUES
(7, 'Carlos Silva', 3500.00, '2022-01-10', NULL, NULL, 'Mecânico', NULL),
(3, 'João Souza', 3400.00, '2021-03-15', '2023-12-01', 'Pedido de demissão', 'Mecânico', NULL),
(12, 'Ana Lima', 3600.00, '2020-06-20', NULL, NULL, 'Eletricista', NULL),
(9, 'Paulo Mendes', 3550.00, '2019-08-12', NULL, NULL, 'Eletricista', 5.00),
(11, 'Marina Costa', 3300.00, '2022-02-01', NULL, NULL, 'Atendimento', NULL),
(13, 'Lucas Rocha', 3200.00, '2021-11-11', NULL, NULL, 'Pintor', NULL),
(2, 'Fernanda Alves', 4000.00, '2020-04-05', NULL, NULL, 'Administradora', NULL),
(8, 'Ricardo Dias', 4100.00, '2018-09-09', '2022-10-10', 'Aposentadoria', 'Administrador', NULL),
(11, 'Patrícia Ramos', 3000.00, '2022-05-20', NULL, NULL, 'Vendedora', NULL),
(1, 'Bruno Martins', 3100.00, '2021-07-13', NULL, NULL, 'Vendedor', 6.00),
(14, 'Juliana Teixeira', 3200.00, '2020-10-01', NULL, NULL, 'Compradora', NULL),
(4, 'Gabriel Nunes', 3150.00, '2019-12-22', NULL, NULL, 'Comprador', NULL),
(6, 'Sofia Ferreira', 4200.00, '2022-03-03', NULL, NULL, 'Financeiro', NULL),
(10, 'Eduardo Pinto', 4250.00, '2021-08-18', NULL, NULL, 'Financeiro', NULL),
(15, 'Isabela Barros', 3800.00, '2020-01-30', NULL, NULL, 'RH', NULL),
(2, 'Felipe Gomes', 3850.00, '2019-05-25', NULL, NULL, 'RH', NULL),
(8, 'Camila Borges', 5000.00, '2021-09-14', NULL, NULL, 'TI', NULL),
(5, 'Thiago Carvalho', 5100.00, '2020-12-17', NULL, NULL, 'TI', 4.00),
(11, 'Larissa Duarte', 3400.00, '2022-06-06', NULL, NULL, 'Logística', NULL),
(3, 'Vinícius Lopes', 3450.00, '2021-03-27', NULL, NULL, 'Logística', NULL),
(13, 'Amanda Farias', 3000.00, '2020-08-08', NULL, NULL, 'Atendimento', NULL),
(7, 'Rafael Castro', 3050.00, '2019-11-19', '2023-05-15', 'Justa causa', 'Atendimento', NULL),
(1, 'Beatriz Souza', 3200.00, '2022-04-04', NULL, NULL, 'Estoque', NULL),
(6, 'Pedro Henrique', 3250.00, '2021-10-10', NULL, NULL, 'Estoque', NULL),
(12, 'Luana Pires', 3500.00, '2020-07-07', NULL, NULL, 'Garantia', NULL),
(4, 'André Almeida', 3550.00, '2019-02-02', '2022-08-01', 'Redução de quadro', 'Garantia', NULL),
(9, 'Tatiane Melo', 3700.00, '2022-09-09', NULL, NULL, 'Seguros', NULL),
(10, 'Marcelo Vieira', 3750.00, '2021-01-01', NULL, NULL, 'Seguros', NULL),
(14, 'Renata Freitas', 3600.00, '2020-03-03', NULL, NULL, 'Agenciamento', NULL),
(8, 'Gustavo Tavares', 3650.00, '2019-06-06', NULL, NULL, 'Agenciamento', NULL),
(11, 'Jéssica Moura', 3450.00, '2022-07-07', NULL, NULL, 'Mecânica', NULL),
(15, 'Otávio Brito', 3500.00, '2021-08-08', NULL, NULL, 'Elôtrica', NULL),
(2, 'Débora Sales', 3250.00, '2020-09-09', NULL, NULL, 'Pintura', NULL),
(6, 'Murilo Braga', 4150.00, '2019-10-10', NULL, NULL, 'Administração', NULL),
(4, 'Helena Cardoso', 3150.00, '2022-11-11', NULL, NULL, 'Vendas', 5.00),
(7, 'Danilo Rezende', 3300.00, '2021-12-12', NULL, NULL, 'Compras', NULL),
(13, 'Priscila Cunha', 4300.00, '2020-02-02', NULL, NULL, 'Financeiro', NULL),
(1, 'Caio Santana', 3900.00, '2019-03-03', '2023-01-20', 'Pedido de demissão', 'RH', NULL),
(12, 'Melissa Prado', 5200.00, '2021-04-04', NULL, NULL, 'TI', NULL),
(5, 'Rodrigo Peixoto', 3500.00, '2020-05-05', NULL, NULL, 'Logística', NULL);

-- Inserindo dados de clientes
INSERT INTO CLIENTE (NOME_CLIENTE, ENDERECO, TELEFONE) VALUES
('Maria Silva', 'Rua das Laranjeiras, 123, Laranjeiras, Rio de Janeiro', 21987654321),
('João Souza', 'Av. Atlântica, 456, Copacabana, Rio de Janeiro', 21987654322),
('Ana Oliveira', 'Rua Voluntários da Pátria, 789, Botafogo, Rio de Janeiro', 21987654323),
('Carlos Pereira', 'Rua Barata Ribeiro, 321, Copacabana, Rio de Janeiro', 21987654324),
('Fernanda Lima', 'Av. Presidente Vargas, 654, Centro, Rio de Janeiro', 21987654325),
('Paulo Mendes', 'Rua Dias da Cruz, 987, Méier, Rio de Janeiro', 21987654326),
('Marina Costa', 'Rua Conde de Bonfim, 654, Tijuca, Rio de Janeiro', 21987654327),
('Lucas Rocha', 'Av. das Américas, 852, Barra da Tijuca, Rio de Janeiro', 21987654328),
('Patrícia Ramos', 'Rua São Clemente, 741, Botafogo, Rio de Janeiro', 21987654329),
('Bruno Martins', 'Av. Nossa Senhora de Copacabana, 963, Copacabana, Rio de Janeiro', 21987654330),
('Juliana Teixeira', 'Rua Uruguai, 159, Tijuca, Rio de Janeiro', 21987654331),
('Gabriel Nunes', 'Av. Rio Branco, 357, Centro, Rio de Janeiro', 21987654332),
('Sofia Ferreira', 'Rua Visconde de Pirajá, 258, Ipanema, Rio de Janeiro', 21987654333),
('Eduardo Pinto', 'Rua Haddock Lobo, 654, Tijuca, Rio de Janeiro', 21987654334),
('Isabela Barros', 'Rua Santa Clara, 369, Copacabana, Rio de Janeiro', 21987654335),
('Felipe Gomes', 'Av. Vieira Souto, 147, Ipanema, Rio de Janeiro', 21987654336),
('Camila Borges', 'Rua do Catete, 951, Catete, Rio de Janeiro', 21987654337),
('Thiago Carvalho', 'Av. das Nações Unidas, 753, Barra da Tijuca, Rio de Janeiro', 21987654338),
('Larissa Duarte', 'Rua Marquês de Abrantes, 852, Flamengo, Rio de Janeiro', 21987654339),
('Vinícius Lopes', 'Av. Pasteur, 456, Urca, Rio de Janeiro', 21987654340);

-- Inserindo dados de veículos
INSERT INTO VEICULO (ID_CLIENTE, PLACA, MODELO, CHASSIS, MARCA) VALUES
(1, 'ABC1234', 'Civic', '1HGCM82633A123456', 'Honda'),
(2, 'XYZ5678', 'Corolla', '2T1BURHE5JC123456', 'Toyota'),
(3, 'DEF2345', 'Onix', '9BGKS19Z04B123456', 'Chevrolet'),
(4, 'GHI3456', 'HB20', '9BHBZ41B0JP123456', 'Hyundai'),
(5, 'JKL4567', 'Gol', '9BWZZZ377VT123456', 'Volkswagen'),
(6, 'MNO5678', 'Ka', '9BFZH55A0J1234567', 'Ford'),
(7, 'PQR6789', 'Argo', '9BD31218JH1234567', 'Fiat'),
(8, 'STU7890', 'Sandero', '93YBBRAB5KJ123456', 'Renault'),
(9, 'VWX8901', 'Fit', 'JHMGD38407S123456', 'Honda'),
(10, 'YZA9012', 'March', '3N1CK3CP7KL123456', 'Nissan'),
(11, 'BCD0123', 'Cruze', '1G1BE5SM6J7123456', 'Chevrolet'),
(12, 'EFG1234', 'Focus', '3FAHP0HA6AR123456', 'Ford'),
(13, 'HIJ2345', 'C3', 'VF7SC8HP0DT123456', 'Citroen'),
(14, 'KLM3456', '208', 'VF3CC8HP0DT123456', 'Peugeot'),
(15, 'NOP4567', 'Versa', '3N1CN7APXGL123456', 'Nissan'),
(16, 'QRS5678', 'Kwid', '93YBBRAB5KJ654321', 'Renault'),
(17, 'TUV6789', 'HB20S', '9BHBZ41B0JP654321', 'Hyundai'),
(18, 'WXY7890', 'Spin', '9BGKS19Z04B654321', 'Chevrolet'),
(19, 'ZAB8901', 'Uno', '9BD31218JH6543210', 'Fiat'),
(20, 'CDE9012', 'EcoSport', '9BFZH55A0J6543210', 'Ford'),
(1, 'AAA1111', 'Fit', 'JHMGD38407S654321', 'Honda'),
(5, 'BBB2222', 'Polo', '9BWZZZ377VT654321', 'Volkswagen'),
(10, 'CCC3333', 'Kicks', '3N1CK3CP7KL654321', 'Nissan'),
(15, 'DDD4444', 'Sentra', '3N1CN7APXGL654321', 'Nissan');

-- Inserindo dados de vendas
INSERT INTO VENDAS (ID_VEICULO, ID_CLIENTE, ID_FUNCIONARIO, DATA_VENDA, TIPO_VENDA, VALOR_VENDA, FORMA_PAGAMENTO, STATUS_VENDA) VALUES
(5, 5, 10, '2023-11-15', 'Novo', 42000.00, 'A vista', 'Concluído'),
(12, 8, 3, '2023-12-01', 'Usado', 28000.00, 'Financiado', 'Financiado'),
(3, 2, 7, '2023-10-20', 'Novo', 35000.00, 'A vista', 'Concluído'),
(18, 13, 15, '2023-12-10', 'Usado', 21000.00, 'Financiado', 'Financiado'),
(9, 6, 2, '2023-11-25', 'Novo', 39000.00, 'A vista', 'Concluído'),
(21, 1, 8, '2023-12-15', 'Usado', 25000.00, 'Financiado', 'Financiado'),
(7, 4, 12, '2023-10-30', 'Novo', 32000.00, 'A vista', 'Concluído'),
(15, 11, 5, '2023-11-05', 'Usado', 18000.00, 'Financiado', 'Financiado'),
(2, 10, 9, '2023-12-20', 'Novo', 41000.00, 'A vista', 'Concluído'),
(23, 17, 6, '2023-11-10', 'Usado', 23000.00, 'Financiado', 'Financiado'),
(14, 7, 13, '2023-10-25', 'Novo', 37000.00, 'A vista', 'Concluído'),
(1, 3, 11, '2023-12-05', 'Usado', 19500.00, 'Financiado', 'Financiado'),
(20, 15, 4, '2023-11-18', 'Novo', 36000.00, 'A vista', 'Concluído'),
(8, 9, 14, '2023-12-12', 'Usado', 22500.00, 'Financiado', 'Financiado'),
(11, 12, 1, '2023-10-28', 'Novo', 40000.00, 'A vista', 'Concluído');

-- Inserindo dados de fornecedores
INSERT INTO FORNECEDOR (NOME_FORNECEDOR, CNPJ, TELEFONE, ENDERECO) VALUES
('Auto Peças Rio', '12345678000101', 2123456789, 'Av. Brasil, 1000, Bonsucesso, Rio de Janeiro'),
('Lubrificantes BR', '12345678000102', 2123456790, 'Rua do Catete, 200, Catete, Rio de Janeiro'),
('Pneus Total', '12345678000103', 2123456791, 'Av. das Américas, 3500, Barra da Tijuca, Rio de Janeiro'),
('Vidros e Cia', '12345678000104', 2123456792, 'Rua Voluntários da Pátria, 400, Botafogo, Rio de Janeiro'),
('Baterias Plus', '12345678000105', 2123456793, 'Rua Conde de Bonfim, 500, Tijuca, Rio de Janeiro'),
('Filtros Max', '12345678000106', 2123456794, 'Rua Dias da Cruz, 600, Méier, Rio de Janeiro'),
('Freios Seguros', '12345678000107', 2123456795, 'Av. Nossa Senhora de Copacabana, 700, Copacabana, Rio de Janeiro'),
('Suspensão Forte', '12345678000108', 2123456796, 'Rua Haddock Lobo, 800, Tijuca, Rio de Janeiro'),
('Escapamentos BR', '12345678000109', 2123456797, 'Rua São Francisco Xavier, 900, Maracanã, Rio de Janeiro'),
('Lâmpadas Auto', '12345678000110', 2123456798, 'Av. Rio Branco, 1000, Centro, Rio de Janeiro'),
('Rodas e Rodas', '12345678000111', 2123456799, 'Rua Uruguai, 1100, Tijuca, Rio de Janeiro'),
('Acessórios Vip', '12345678000112', 2123456800, 'Rua Barata Ribeiro, 1200, Copacabana, Rio de Janeiro'),
('Auto Som', '12345678000113', 2123456801, 'Rua do Ouvidor, 1300, Centro, Rio de Janeiro'),
('Tintas Car', '12345678000114', 2123456802, 'Rua Visconde de Pirajá, 1400, Ipanema, Rio de Janeiro'),
('Parachoques Ltda', '12345678000115', 2123456803, 'Av. Presidente Vargas, 1500, Centro, Rio de Janeiro'),
('Retrovisores BR', '12345678000116', 2123456804, 'Rua São Clemente, 1600, Botafogo, Rio de Janeiro'),
('Estofados Auto', '12345678000117', 2123456805, 'Rua Marquês de Abrantes, 1700, Flamengo, Rio de Janeiro'),
('Volantes Pro', '12345678000118', 2123456806, 'Rua Santa Clara, 1800, Copacabana, Rio de Janeiro'),
('Painéis Auto', '12345678000119', 2123456807, 'Rua Senador Vergueiro, 1900, Flamengo, Rio de Janeiro'),
('Motores BR', '12345678000120', 2123456808, 'Rua do Carmo, 2000, Centro, Rio de Janeiro');

-- Inserir dados de produtos
INSERT INTO PRODUTO (ID_FORNECEDOR, NOME_PRODUTO, DESCRICAO, CATEGORIA, QUANTIDADE, QUANTIDADE_MINIMA, PRECO, VALIDADE) VALUES
(3, 'Pneu Aro 15', 'Pneu para carros de passeio', 'Pneus', 8, 10, 350.00, '2025-12-31'),
(2, 'Óleo 5W30', 'Óleo sintético para motor', 'Lubrificantes', 25, 20, 60.00, '2025-06-30'),
(6, 'Filtro de Óleo', 'Filtro para óleo de motor', 'Filtros', 5, 15, 30.00, '2026-01-01'),
(5, 'Bateria 60Ah', 'Bateria automotiva', 'Baterias', 12, 10, 400.00, '2027-07-15'),
(10, 'Lâmpada Farol', 'Lâmpada para farol', 'Iluminação', 20, 10, 25.00, '2026-12-31'),
(7, 'Pastilha de Freio', 'Pastilha dianteira', 'Freios', 18, 15, 80.00, '2026-10-10'),
(8, 'Amortecedor', 'Amortecedor traseiro', 'Suspensão', 9, 12, 150.00, '2027-05-05'),
(9, 'Escapamento', 'Escapamento esportivo', 'Escapamento', 7, 10, 250.00, '2028-03-03'),
(11, 'Roda Liga Leve', 'Roda aro 16', 'Rodas', 6, 8, 500.00, NULL),
(16, 'Retrovisor', 'Retrovisor elétrico', 'Acessórios', 15, 10, 120.00, NULL),
(13, 'Som Automotivo', 'Rádio com bluetooth', 'Acessórios', 11, 10, 300.00, NULL),
(14, 'Tintas Spray', 'Tinta para retoque', 'Tintas', 14, 10, 35.00, '2027-11-11'),
(15, 'Parachoque Dianteiro', 'Parachoque para sedan', 'Parachoques', 3, 5, 600.00, NULL),
(17, 'Estofado Couro', 'Estofado de couro', 'Estofados', 2, 5, 900.00, NULL),
(18, 'Volante Esportivo', 'Volante revestido', 'Acessórios', 4, 8, 250.00, NULL),
(19, 'Painel Digital', 'Painel para hatch', 'Painéis', 10, 10, 700.00, NULL),
(20, 'Motor 1.0', 'Motor completo 1.0', 'Motores', 1, 2, 4000.00, NULL),
(6, 'Filtro de Ar', 'Filtro para ar condicionado', 'Filtros', 20, 15, 40.00, '2027-04-04'),
(12, 'Capa de Banco', 'Capa impermeável', 'Acessórios', 22, 10, 60.00, NULL),
(12, 'Sensor de Ré', 'Sensor ultrassônico', 'Acessórios', 13, 10, 150.00, NULL),
(12, 'Câmera de Ré', 'Câmera para estacionamento', 'Acessórios', 7, 10, 180.00, NULL),
(11, 'Calota', 'Calota aro 14', 'Rodas', 16, 10, 40.00, NULL),
(12, 'Chave Canivete', 'Chave reserva', 'Acessórios', 5, 10, 80.00, NULL),
(12, 'Macaco Hidráulico', 'Macaco para elevação', 'Ferramentas', 12, 10, 120.00, NULL),
(12, 'Kit Multimídia', 'Central multimídia', 'Acessórios', 9, 10, 950.00, NULL);

-- Inserir dados da ordem de serviço
INSERT INTO ORDEM_SERVICO (ID_VEICULO, ID_CLIENTE, DATA_INICIO, DATA_CONCLUSAO, DATA_PREVISTA, AGENDAMENTO, VALOR_TOTAL, REPARO) VALUES
(1, 1, '2023-10-01', '2023-10-05', '2023-10-06', '2023-09-30', 500.00, 'Troca de óleo'),
(1, 1, '2023-11-01', '2023-11-03', '2023-11-04', '2023-10-30', 300.00, 'Alinhamento'),
(21, 1, '2023-12-01', '2023-12-05', '2023-12-06', '2023-11-30', 700.00, 'Troca de pneus'),
(2, 2, '2023-10-02', '2023-10-07', '2023-10-08', '2023-09-29', 800.00, 'Troca de pneus'),
(3, 3, '2023-10-03', '2023-10-08', '2023-10-09', '2023-09-28', 600.00, 'Alinhamento'),
(4, 4, '2023-10-04', '2023-10-09', '2023-10-10', '2023-09-27', 900.00, 'Balanceamento'),
(5, 5, '2023-10-05', '2023-10-10', '2023-10-11', '2023-09-26', 700.00, 'Troca de bateria'),
(22, 5, '2023-11-10', '2023-11-15', '2023-11-16', '2023-11-09', 950.00, 'Troca de roda'),
(6, 6, '2023-10-06', '2023-10-11', '2023-10-12', '2023-09-25', 750.00, 'Reparo de suspensão'),
(7, 7, '2023-10-07', '2023-10-12', '2023-10-13', '2023-09-24', 650.00, 'Troca de pastilha'),
(9, 9, '2023-10-09', '2023-10-14', '2023-10-15', '2023-09-22', 950.00, 'Troca de escapamento'),
(10, 10, '2023-10-10', '2023-10-15', '2023-10-16', '2023-09-21', 1050.00, 'Troca de roda'),
(23, 10, '2023-11-20', '2023-11-25', '2023-11-26', '2023-11-19', 1200.00, 'Instalação de som'),
(11, 11, '2023-10-11', '2023-10-16', '2023-10-17', '2023-09-20', 1150.00, 'Troca de retrovisor'),
(13, 13, '2023-10-13', '2023-10-18', '2023-10-19', '2023-09-18', 1350.00, 'Pintura'),
(14, 14, '2023-10-14', '2023-10-19', '2023-10-20', '2023-09-17', 1450.00, 'Troca de parachoque'),
(15, 15, '2023-10-15', '2023-10-20', '2023-10-21', '2023-09-16', 1550.00, 'Troca de estofado'),
(24, 15, '2023-12-10', '2023-12-15', '2023-12-16', '2023-12-09', 1600.00, 'Troca de filtro');

--Inserir dados de pagamentos
INSERT INTO PAGAMENTO (ID_CLIENTE, ID_OS, ID_PRODUTO, METODO_PAGAMENTO, PARCELAS, DATA_PAGAMENTO, VALOR_PAGAMENTO, STATUS_PAGAMENTO) VALUES
(1, 200, NULL, 'CARTÃO DE DÉBITO', 1, '2023-10-05', 500.00, 'Pago'), 
(2, NULL, 2, 'CARTÃO DE CRÉDITO', 3, '2023-10-07', 60.00, 'Pago'), 
(3, 204, NULL, 'DINHEIRO', 1, '2023-10-08', 600.00, 'Pago'), 
(4, NULL, 4, 'PIX', 1, '2023-10-09', 400.00, 'Pago'), 
(5, 206, NULL, 'CARTÃO DE DÉBITO', 2, '2023-10-10', 700.00, 'Pago'), 
(6, NULL, 6, 'CARTÃO DE CRÉDITO', 4, '2023-10-11', 80.00, 'Pago'), 
(7, 208, NULL, 'DINHEIRO', 1, '2023-10-12', 650.00, 'Pago'), 
(8, NULL, 8, 'PIX', 1, '2023-10-13', 250.00, 'Pago'),     
(9, 210, NULL, 'CARTÃO DE DÉBITO', 1, '2023-10-14', 950.00, 'Pago'), 
(10, NULL, 10, 'CARTÃO DE CRÉDITO', 5, '2023-10-15', 120.00, 'Pago'), 
(11, 211, NULL, 'DINHEIRO', 1, '2023-10-16', 1050.00, 'Pago'), 
(12, NULL, 12, 'PIX', 1, '2023-10-17', 150.00, 'Pago'), 
(13, 203, NULL, 'CARTÃO DE DÉBITO', 1, '2023-10-18', 800.00, 'Pago'),
(14, NULL, 14, 'CARTÃO DE CRÉDITO', 2, '2023-10-19', 35.00, 'Pago'), 
(15, 205, NULL, 'DINHEIRO', 1, '2023-10-20', 900.00, 'Pago'), 
(16, NULL, 16, 'PIX', 1, '2023-10-21', 120.00, 'Pago'), 
(17, 207, NULL, 'CARTÃO DE DÉBITO', 1, '2023-10-22', 750.00, 'Pago'), 
(18, NULL, 18, 'CARTÃO DE CRÉDITO', 3, '2023-10-23', 250.00, 'Pago'),    
(19, 209, NULL, 'DINHEIRO', 1, '2023-10-24', 850.00, 'Pago'), 
(20, NULL, 20, 'PIX', 1, '2023-10-25', 950.00, 'Pago');

-- Inserir dados de feedbacks
INSERT INTO FEEDBACK (ID_CLIENTE, AVALIACAO, DESCRICAO) VALUES
(1, 10, 'Ótimo atendimento e serviço rápido.'),
(2, 6, 'Serviço bom, mas poderia ser mais rápido.'),
(3, 9, 'Equipe muito atenciosa.'),
(4, 4, 'Demorou um pouco além do previsto.'),
(5, 10, 'Recomendo a todos.'),
(6, 7, 'Bom custo-benefício.'),
(7, 9, 'Funcionários educados.'),
(8, 8, 'Serviço de qualidade.'),
(9, 5, 'Preço um pouco alto.'),
(10, 10, 'Voltarei mais vezes.'),
(11, 8, 'Tudo certo com o serviço.'),
(12, 10, 'Atendimento excelente.'),
(13, 7, 'Gostei do resultado.'),
(14, 9, 'Muito bom!'),
(15, 3, 'Poderia melhorar a comunicação.'),
(16, 10, 'Serviço perfeito.'),
(17, 8, 'Equipe eficiente.'),
(18, 10, 'Muito satisfeito.'),
(19, 7, 'Serviço dentro do esperado.'),
(20, 10, 'Nota máxima!');

-- Inserir dados de financiamentos
INSERT INTO FINANCIMENTO (ID_VENDA, VALOR_FINANCIADO, TAXA_JUROS_ANUAL, NUM_PARCELAS, DATA_PRIMEIRA_PARCELA) VALUES
(1, 15000.00, 7.5, 24, '2023-11-01'),
(2, 22000.00, 6.9, 36, '2023-12-01'),
(3, 18000.00, 8.2, 18, '2023-10-15'),
(4, 25000.00, 7.0, 48, '2023-09-20'),
(5, 12000.00, 8.0, 12, '2023-08-10'),
(6, 17000.00, 7.8, 24, '2023-07-05'),
(7, 21000.00, 7.2, 36, '2023-06-15'),
(8, 19500.00, 7.9, 30, '2023-05-01'),
(9, 16000.00, 8.1, 20, '2023-04-10'),
(10, 23000.00, 7.3, 36, '2023-03-20');

-- Inserir dados de seguros
INSERT INTO SEGURO_GARANTIA (ID_VENDA, TIPO_SEGURO, VALOR_SEGURO, GARANTIA_EXT_MES) VALUES
(1, 'Total', 1200.00, 12),
(2, 'Roubo e Incêndio', 800.00, 6),
(3, 'Total', 1300.00, 12),
(4, 'Roubo e Incêndio', 900.00, 6),
(5, 'Total', 1100.00, 12),
(6, 'Roubo e Incêndio', 850.00, 6),
(7, 'Total', 1250.00, 12),
(8, 'Roubo e Incêndio', 950.00, 6),
(9, 'Total', 1400.00, 12),
(10, 'Roubo e Incêndio', 1000.00, 6);

-- Inserindo dados de contas a receber
INSERT INTO CONTA_RECEBER (ID_CLIENTE, ID_VENDA, VALOR_R, DATA_EMISSAO_R, DATA_VENCIMENTO_R, STATUS_R) VALUES
(1, 1, 500.00, '2025-01-01', '2025-01-10', 'Pago'),
(2, 2, 800.00, '2025-02-02', '2025-02-12', 'Pendente'),
(3, 3, 600.00, '2025-03-03', '2025-03-13', 'Pago'),
(4, 4, 900.00, '2025-04-04', '2025-04-14', 'Pago'),
(5, 5, 700.00, '2025-05-05', '2025-05-15', 'Pendente'),
(6, 6, 750.00, '2025-06-06', '2025-06-16', 'Pago'),
(7, 7, 650.00, '2025-07-07', '2025-07-17', 'Pago'),
(8, 8, 850.00, '2025-08-08', '2025-08-18', 'Pendente'),
(9, 9, 950.00, '2025-09-09', '2025-09-19', 'Pago'),
(10, 10, 1050.00, '2025-10-10', '2025-10-20', 'Pago');

-- Inserindo dados de contas a pagar
INSERT INTO CONTA_PAGAR (ID_FORNECEDOR, ID_PRODUTO, VALOR_P, DATA_EMISSAO_P, DATA_VENCIMENTO_P, STATUS_P) VALUES
(1, 1, 1200.00, '2025-01-01', '2025-01-10', 'Pago'),
(2, 2, 900.00, '2025-02-02', '2025-02-12', 'Pendente'),
(3, 3, 1100.00, '2025-03-03', '2025-03-13', 'Pago'),
(4, 4, 950.00, '2025-04-04', '2025-04-14', 'Pago'),
(5, 5, 1300.00, '2025-05-05', '2025-05-15', 'Pendente'),
(6, 6, 1000.00, '2025-06-06', '2025-06-16', 'Pago'),
(7, 7, 1150.00, '2025-07-07', '2025-07-17', 'Pago'),
(8, 8, 1050.00, '2025-08-08', '2025-08-18', 'Pendente'),
(9, 9, 1250.00, '2025-09-09', '2025-09-19', 'Pago'),
(10, 10, 1400.00, '2025-10-10', '2025-10-20', 'Pago');

-- Inseririndo dados de atendimento
INSERT INTO ATENDIMENTO (ID_CLIENTE, ID_RESPONSAVEL, ASSUNTO, DESCRICAO, DATA_ABERTURA, STATUS_ATENDIMENTO) VALUES
(1, 7, 'Dúvida sobre orçamento', 'Cliente solicitou explicação sobre valores.', '2025-01-10T09:00:00', 'Concluído'),
(2, 7, 'Reclamação de atraso', 'Cliente reclamou de atraso na entrega.', '2025-02-15T10:00:00', 'Em andamento'),
(3, 13, 'Solicitação de serviço', 'Cliente pediu revisão completa.', '2025-03-20T11:00:00', 'Concluído'),
(4, 11, 'Dúvida sobre garantia', 'Cliente questionou prazo de garantia.', '2025-04-01T12:00:00', 'Concluído'),
(5, 13, 'Reclamação de peça', 'Cliente reclamou de peça trocada.', '2025-05-05T13:00:00', 'Em andamento'),
(6, 7, 'Solicitação de orçamento', 'Cliente pediu orçamento detalhado.', '2024-12-01T14:00:00', 'Concluído'),
(7, 11, 'Dúvida sobre pagamento', 'Cliente questionou valor da parcela.', '2024-12-10T15:00:00', 'Concluído'),
(8, 11, 'Reclamação de atendimento', 'Cliente não gostou do atendimento.', '2025-01-01T16:00:00', 'Em andamento'),
(9, 7, 'Solicitação de serviço', 'Cliente pediu troca de óleo.', '2025-02-01T17:00:00', 'Concluído'),
(10, 13, 'Dúvida sobre prazo', 'Cliente perguntou sobre prazo de entrega.', '2025-03-01T18:00:00', 'Concluído');

-- Inserindo dados da tabela OS_TECNICO
INSERT INTO OS_TECNICO (ID_OS, ID_FUNCIONARIO, DATA_INICIO, DATA_FIM) VALUES
(200, 1, '2024-12-15', '2024-12-15'),
(201, 2, '2025-01-05', '2025-01-05'),
(202, 3, '2025-02-10', '2025-02-10'),
(203, 4, '2025-03-01', '2025-03-01'),
(204, 5, '2025-04-10', '2025-04-10'),
(205, 6, '2025-05-01', '2025-05-01'),
(206, 7, '2024-12-01', '2024-12-01'),
(207, 8, '2025-01-15', '2025-01-15'),
(208, 9, '2025-02-01', '2025-02-01'),
(209, 10, '2025-03-10', '2025-03-10');

-- Inserir dados de garantia
INSERT INTO GARANTIA_OS (ID_OS, DATA_INICIO, PERIODO_MESES, STATUS_GARANTIA) VALUES
(200, '2024-12-20', 12, 'Ativa'),
(201, '2025-01-10', 6, 'Expirada'),
(202, '2025-02-01', 12, 'Expirada'),
(203, '2025-03-15', 6, 'Ativa'),
(204, '2025-04-01', 12, 'Expirada'),
(205, '2025-05-01', 9, 'Ativa'),
(206, '2024-12-01', 6, 'Expirada'),
(207, '2025-01-10', 12, 'Ativa'),
(208, '2025-02-15', 6, 'Expirada');

-- Inserir dados de reclamação
INSERT INTO RECLAMACAO (ID_CLIENTE, ID_GARANTIA, DATA_RECLAMACAO, DESCRICAO, STATUS_RECLAMACAO) VALUES
(1, 3000, '2024-12-01T10:00:00', 'Problema após serviço de funilaria.', 'Aberta'),
(2, 3001, '2025-01-02T11:00:00', 'Pintura descascando.', 'Em análise'),
(3, 3002, '2025-02-03T12:00:00', 'Peça trocada apresentou defeito.', 'Resolvida'),
(4, 3003, '2025-03-04T13:00:00', 'Alinhamento não ficou bom.', 'Aberta'),
(5, 3004, '2025-04-05T14:00:00', 'Vidro com vazamento.', 'Em análise');

-- Inserir 5 contratos
INSERT INTO CONTRATO (ID_CLIENTE, ID_FUNCIONARIO, TIPO_CONTRATO, DATA_INICIO_CONTRATO, DATA_FIM_CONTRATO, TEXTO_CONTRATO) VALUES
(1, 1, 'Manutenção', '2024-12-01', '2025-12-01', 'Contrato anual de manutenção.'),
(2, 2, 'Reparo', '2025-01-02', '2026-01-02', 'Contrato de reparo completo.'),
(3, 3, 'Garantia Estendida', '2025-02-03', '2027-02-03', 'Garantia estendida de 2 anos.'),
(4, 4, 'Seguro', '2025-03-04', '2026-03-04', 'Seguro total do veículo.'),
(5, 5, 'Agenciamento', '2025-04-05', '2026-04-05', 'Contrato de agenciamento de venda.');

-- Inserir 5 agenciamentos de veículo (IDs de veículos de 1 a 24)
INSERT INTO AGENCIAMENTO_VEICULO (ID_CLIENTE, ID_VEICULO, DATA_AGENCIAMENTO, VALOR_AGENCIAMENTO, PRAZO_DIAS, COMISSAO_PORC, STATUS_AGENCIAMENTO) VALUES
(1, 1, '2025-01-20', 25000.00, 30, 5.00, 'Concluído'),
(2, 4, '2025-02-21', 30000.00, 45, 6.00, 'Em andamento'),
(3, 7, '2025-03-22', 18000.00, 60, 4.50, 'Concluído'),
(4, 9, '2025-04-23', 22000.00, 40, 5.50, 'Cancelado'),
(5, 11, '2025-05-24', 21000.00, 35, 5.00, 'Concluído'),
(6, 14, '2024-12-25', 17000.00, 30, 4.00, 'Em andamento'),
(7, 16, '2025-01-26', 16000.00, 25, 3.50, 'Concluído'),
(8, 18, '2025-02-27', 15000.00, 20, 3.00, 'Concluído'),
(9, 20, '2025-03-28', 14000.00, 15, 2.50, 'Cancelado'),
(10, 21, '2025-04-29', 13000.00, 10, 2.00, 'Concluído');

-- Iniciando as consultas

-- Cosultando dados de clientes e seus veículos
SELECT CLIENTE.NOME_CLIENTE, CLIENTE.TELEFONE, VEICULO.MARCA, VEICULO.MODELO, VEICULO.PLACA
FROM CLIENTE
INNER JOIN VEICULO ON VEICULO.ID_CLIENTE = CLIENTE.ID_CLIENTE;

-- Mostrando clientes que possuem APENAS UM veículo
SELECT CLIENTE.NOME_CLIENTE, CLIENTE.TELEFONE, CLIENTE.ENDERECO, COUNT(VEICULO.ID_VEICULO) AS QTDE_VEICULO
FROM CLIENTE
INNER JOIN VEICULO ON CLIENTE.ID_CLIENTE = VEICULO.ID_CLIENTE
GROUP BY CLIENTE.NOME_CLIENTE, CLIENTE.TELEFONE, CLIENTE.ENDERECO
HAVING COUNT(VEICULO.ID_VEICULO) = 1;

-- Mostrando clientes que possuem MAIS DE UM veículo
SELECT CLIENTE.NOME_CLIENTE, CLIENTE.TELEFONE, CLIENTE.ENDERECO, COUNT(VEICULO.ID_VEICULO) AS QTDE_VEICULO
FROM CLIENTE
INNER JOIN VEICULO ON CLIENTE.ID_CLIENTE = VEICULO.ID_CLIENTE
GROUP BY CLIENTE.NOME_CLIENTE, CLIENTE.TELEFONE, CLIENTE.ENDERECO
HAVING COUNT(VEICULO.ID_VEICULO) > 1;

-- Criar uma PROCEDURE que vai verificar se um produto está acima ou abaixo do estoque mínimo permitido
CREATE PROCEDURE CHECAGEM_ESTOQUE @PRODUTO_ID INT AS
BEGIN
	IF EXISTS (SELECT 1 FROM PRODUTO WHERE ID_PRODUTO = @PRODUTO_ID)
	BEGIN
		DECLARE @QTDE INT, @QTDE_MIN INT
		SELECT @QTDE = QUANTIDADE, @QTDE_MIN = QUANTIDADE_MINIMA FROM PRODUTO WHERE ID_PRODUTO = @PRODUTO_ID;
		IF (@QTDE < @QTDE_MIN)
		BEGIN
			SELECT 'O ITEM SELECIONADO ESTÁ COM A QUANTIDADE ABAIXO DO ESTOQUE DO ESTOQUE MÍNIMO PERMITIDO!' AS MENSAGEM
			SELECT * FROM PRODUTO WHERE ID_PRODUTO = @PRODUTO_ID;
		END
		ELSE
		BEGIN
			SELECT 'O ITEM SELECIONADO ESTÁ COM A QUANTIDADE ACIMA DO ESTOQUE MÍNIMO PERMITIDO' AS MENSAGEM
		END
	END
	ELSE
	BEGIN
		SELECT 'O ITEM SELECIONADO NÃO FOI ENCONTRADO NO ESTOQUE, VERIFIQUE SE DIGITOU O NÚMERO DE IDENTIFICAÇÃO CORRETO!' AS MENSAGEM
	END
END;

EXEC CHECAGEM_ESTOQUE @PRODUTO_ID = 99;

-- Esta PROCEDURE vai consultar a Ordem de Serivço de um veículo com base na identificação do cliente
CREATE PROCEDURE CONSULTA_OS @CLIENTE_OS INT AS
BEGIN
	IF EXISTS (SELECT 1 FROM CLIENTE WHERE CLIENTE.ID_CLIENTE = @CLIENTE_OS)
	BEGIN
		SELECT * FROM ORDEM_SERVICO 
		INNER JOIN CLIENTE ON ORDEM_SERVICO.ID_CLIENTE = CLIENTE.ID_CLIENTE
		WHERE CLIENTE.ID_CLIENTE = @CLIENTE_OS;
	END
	ELSE
	BEGIN
		SELECT 'O CLIENTE NÃO FOI ENCONTRADO NO BANCO DE DADOS, VERIFIQUE SE DIGITOU O ID CORRETO!' AS MENSAGEM
	END
END;

EXEC CONSULTA_OS @CLIENTE_OS = 2;

-- Esta consulta mostra o nome do produto, a categoria a qual ele pertence e de qual fornecedor foi comprado
SELECT PRODUTO.NOME_PRODUTO, PRODUTO.CATEGORIA, FORNECEDOR.NOME_FORNECEDOR
FROM PRODUTO
INNER JOIN FORNECEDOR ON PRODUTO.ID_FORNECEDOR = FORNECEDOR.ID_FORNECEDOR;

-- Esta PROCEDURE vai consultar todos os funcionários que fazem parte de um departamento específico
CREATE PROCEDURE CONSULTA_DEPARTAEMENTO @DEPARTAMENTOID INT AS
BEGIN
	IF EXISTS (SELECT 1 FROM DEPARTAMENTO WHERE ID_DEPARTAMENTO = @DEPARTAMENTOID)
	BEGIN
		SELECT FUNCIONARIO.NOME_FUNCIONARIO, FUNCIONARIO.DATA_ADMISSAO, FUNCIONARIO.SALARIO, DEPARTAMENTO.NOME_DEPARTAMENTO
		FROM FUNCIONARIO
		INNER JOIN DEPARTAMENTO ON FUNCIONARIO.ID_DEPARTAMENTO = DEPARTAMENTO.ID_DEPARTAMENTO
		WHERE DEPARTAMENTO.ID_DEPARTAMENTO = @DEPARTAMENTOID;
	END
	ELSE
	BEGIN
		SELECT 'O DEPARTAMENTO SELECIONADO NÃO EXISTE, VERIFIQUE SE DIGITOU O NÚMERO DE IDENTIFICAÇÃO CORRETO!' AS MENSAGEM;
	END
END;

EXEC CONSULTA_DEPARTAEMENTO @DEPARTAMENTOID = 999;

-- Esta consulta vai verificar quais veículos não possuem uma ordem de serviço
CREATE VIEW VEICULO_S_OS AS
SELECT VEICULO.ID_VEICULO, VEICULO.MODELO, VEICULO.MARCA, VEICULO.PLACA 
FROM VEICULO
FULL JOIN ORDEM_SERVICO ON VEICULO.ID_VEICULO = ORDEM_SERVICO.ID_VEICULO WHERE ORDEM_SERVICO.ID_OS IS NULL;

SELECT * FROM VEICULO_S_OS;

-- Esta PROCEDURE vai verificar se algum cliente fez alguma reclamação a algum serviço da concessionária
CREATE PROCEDURE CONSULTA_RECLAMACAO @RECLAMACAO_CLIENTE INT AS
BEGIN
	IF EXISTS (SELECT 1 FROM RECLAMACAO WHERE ID_CLIENTE = @RECLAMACAO_CLIENTE)
	BEGIN
		SELECT RECLAMACAO.DATA_RECLAMACAO, CLIENTE.NOME_CLIENTE, RECLAMACAO.DESCRICAO, RECLAMACAO.STATUS_RECLAMACAO
		FROM RECLAMACAO
		INNER JOIN CLIENTE ON RECLAMACAO.ID_CLIENTE = CLIENTE.ID_CLIENTE WHERE RECLAMACAO.ID_CLIENTE = @RECLAMACAO_CLIENTE;
	END
	ELSE
	BEGIN
		SELECT 'PELO VISTO NÃO HÁ NENHUMA RECLAMAÇÃO DO CLIENTE SELECIONADO!' AS MENSAGEM;
	END
END;

EXEC CONSULTA_RECLAMACAO @RECLAMACAO_CLIENTE = 6;

-- Esta PROCEDURE irá consultar se algum cliente buscou fazer algum agenciamento de veículo
CREATE PROCEDURE CONSULTA_AGENCIAMENTO @IDAGENCIAMENTO INT AS
BEGIN
	IF EXISTS (SELECT 1 FROM AGENCIAMENTO_VEICULO WHERE ID_AGENCIAMENTO = @IDAGENCIAMENTO)
	BEGIN
		SELECT CLIENTE.NOME_CLIENTE, VEICULO.MARCA, VEICULO.MODELO, AGENCIAMENTO_VEICULO.DATA_AGENCIAMENTO, AGENCIAMENTO_VEICULO.VALOR_AGENCIAMENTO, AGENCIAMENTO_VEICULO.DATA_AGENCIAMENTO, AGENCIAMENTO_VEICULO.STATUS_AGENCIAMENTO
		FROM CLIENTE
		INNER JOIN AGENCIAMENTO_VEICULO ON CLIENTE.ID_CLIENTE = AGENCIAMENTO_VEICULO.ID_CLIENTE 
		INNER JOIN VEICULO ON CLIENTE.ID_CLIENTE = VEICULO.ID_CLIENTE
		WHERE AGENCIAMENTO_VEICULO.ID_AGENCIAMENTO = @IDAGENCIAMENTO;
	END
	ELSE
	BEGIN
		SELECT 'O CLIENTE SELECIONADO NÃO BUSCOU NENHUM AGENCIAMENTO COM NOSSA CONCESSIONÁRIA' AS MENSAGEM;
	END
END;



-- Essa consulta vai retornar quais funcionários fizeram parte de uma ordem de serviço técnica
SELECT ORDEM_SERVICO.REPARO, VEICULO.MARCA, VEICULO.MODELO, FUNCIONARIO.NOME_FUNCIONARIO, OS_TECNICO.DATA_INICIO, OS_TECNICO.DATA_FIM
FROM OS_TECNICO
INNER JOIN ORDEM_SERVICO ON OS_TECNICO.ID_OS = ORDEM_SERVICO.ID_OS
INNER JOIN FUNCIONARIO ON OS_TECNICO.ID_FUNCIONARIO = FUNCIONARIO.ID_FUNCIONARIO
INNER JOIN VEICULO ON ORDEM_SERVICO.ID_VEICULO = VEICULO.ID_VEICULO;

-- Média de tempo pra realizar uma ordem de serviço
SELECT AVG(ORDEM_SERVICO.DURACAO_SERVICO) AS MEDIA_TEMPO FROM ORDEM_SERVICO;

-- Garantias ainda ativas
SELECT GARANTIA_OS.DATA_INICIO, GARANTIA_OS.STATUS_GARANTIA, GARANTIA_OS.PERIODO_MESES FROM GARANTIA_OS WHERE STATUS_GARANTIA = 'Ativa';

-- Consultando o valor total de contas a receber
SELECT SUM(CONTA_RECEBER.VALOR_R) AS VALOR_TOTAL FROM CONTA_RECEBER WHERE STATUS_R = 'Pendente';

-- Consultando o valor total de contas a pagar
SELECT FORNECEDOR.NOME_FORNECEDOR, CONTA_PAGAR.DATA_EMISSAO_P, CONTA_PAGAR.DATA_VENCIMENTO_P, SUM(CONTA_PAGAR.VALOR_P) AS VALOR_TOTAL 
FROM CONTA_PAGAR
INNER JOIN FORNECEDOR ON CONTA_PAGAR.ID_FORNECEDOR = FORNECEDOR.ID_FORNECEDOR
WHERE CONTA_PAGAR.STATUS_P = 'Pendente'
GROUP BY FORNECEDOR.NOME_FORNECEDOR, CONTA_PAGAR.DATA_EMISSAO_P, CONTA_PAGAR.DATA_VENCIMENTO_P;

-- Consultando clientes que pagaram pela ordem de serviço
SELECT CLIENTE.NOME_CLIENTE, ORDEM_SERVICO.REPARO, PAGAMENTO.VALOR_PAGAMENTO, PAGAMENTO.DATA_PAGAMENTO, PAGAMENTO.METODO_PAGAMENTO, PAGAMENTO.STATUS_PAGAMENTO, PAGAMENTO.PARCELAS
FROM CLIENTE
JOIN ORDEM_SERVICO ON CLIENTE.ID_CLIENTE = ORDEM_SERVICO.ID_CLIENTE
JOIN PAGAMENTO ON ORDEM_SERVICO.ID_OS = PAGAMENTO.ID_OS
WHERE PAGAMENTO.STATUS_PAGAMENTO = 'Pago';

-- Consultando clientes que pagaram por produtos
SELECT CLIENTE.NOME_CLIENTE, PRODUTO.NOME_PRODUTO, PAGAMENTO.VALOR_PAGAMENTO, PAGAMENTO.DATA_PAGAMENTO, PAGAMENTO.METODO_PAGAMENTO, PAGAMENTO.STATUS_PAGAMENTO, PAGAMENTO.PARCELAS
FROM CLIENTE
JOIN PAGAMENTO ON CLIENTE.ID_CLIENTE = PAGAMENTO.ID_CLIENTE
JOIN PRODUTO ON PAGAMENTO.ID_PRODUTO = PRODUTO.ID_PRODUTO
WHERE PAGAMENTO.STATUS_PAGAMENTO = 'Pago';

-- Consulta para verificar as contas a receber
SELECT CLIENTE.NOME_CLIENTE, CONTA_RECEBER.VALOR_R, DATA_EMISSAO_R, DATA_VENCIMENTO_R, STATUS_R
FROM CLIENTE
JOIN CONTA_RECEBER ON CLIENTE.ID_CLIENTE = CONTA_RECEBER.ID_CLIENTE
WHERE STATUS_R = 'Pendente';

-- Consulta para verificar as contas a receber que foram pagas
SELECT CLIENTE.NOME_CLIENTE, CONTA_RECEBER.VALOR_R, DATA_EMISSAO_R, DATA_VENCIMENTO_R, STATUS_R
FROM CLIENTE
JOIN CONTA_RECEBER ON CLIENTE.ID_CLIENTE = CONTA_RECEBER.ID_CLIENTE
WHERE STATUS_R = 'Pago';