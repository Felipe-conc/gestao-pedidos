# 🖥️ Sistema de Gestão de Pedidos

Aplicação desktop desenvolvida em **Delphi / Object Pascal** para gerenciamento e impressão de pedidos, integração com API REST, controle de vendas e geração de relatórios.

## ✨ Funcionalidades

* 🔐 Autenticação de usuários
* 🏢 Seleção de estabelecimento
* 📦 Recebimento de pedidos através de API REST
* 🔄 Atualização automática de pedidos
* 🧾 Processamento e armazenamento local dos pedidos
* 🖨️ Impressão em impressoras térmicas
* ⚙️ Configuração de impressoras
* 🏷️ Gerenciamento de canais de venda
* 📊 Relatórios de pedidos e vendas
* 💾 Banco de dados local SQLite
* 🔄 Processamento de comunicação com a API em thread

## 🛠️ Tecnologias

* **Delphi / Object Pascal**
* **VCL**
* **FireDAC**
* **SQLite**
* **Indy (`TIdHTTP`)**
* **JSON**
* **FastReport**
* **ACBrPosPrinter**

## 🏗️ Estrutura do Projeto

```text
├── classes/       # Classes e regras de negócio
├── fontes/        # Formulários, telas e funcionalidades
├── reports/       # Relatórios FastReport
└── prjImpressaoPedidos.dproj
```

## 🔄 Fluxo da Aplicação

```text
Login
  ↓
Selecionar estabelecimento
  ↓
Autenticar na API
  ↓
Receber pedidos
  ↓
Processar e armazenar pedidos
  ↓
Imprimir pedidos
  ↓
Alterar status
  ↓
Gerar relatórios
```

## 🌐 Integração com API

A aplicação realiza comunicação com uma **API REST externa** utilizando requisições HTTP e dados em JSON.

Entre as operações realizadas estão:

* Autenticação de usuário
* Validação de token
* Consulta de pedidos/cupons
* Consulta incremental de novos pedidos
* Comunicação para atualização dos dados

> A execução completa do projeto depende da API externa e das configurações do ambiente.

## 🖨️ Impressão Térmica

A impressão dos pedidos é realizada utilizando o **ACBrPosPrinter**, permitindo configurar características como:

* Modelo da impressora
* Porta de comunicação
* Código de página
* Corte de papel
* Espaçamento entre linhas
* Quantidade de colunas

## 📊 Relatórios

O projeto utiliza **FastReport** para geração de relatórios, incluindo:

* Relatório de pedidos
* Relatório sintético de pedidos
* Relatório de produtos vendidos
* Comparativo de vendas

## 💾 Banco de Dados

Utiliza **SQLite** como banco de dados local, acessado através do **FireDAC**.

Os dados dos pedidos são armazenados localmente, incluindo informações como:

* ID do pedido
* JSON recebido da API
* Status
* Data
* Código/descrição
* Estabelecimento

## 🧵 Processamento em Threads

A comunicação para atualização dos pedidos utiliza processamento em **thread (`TThread`)**, permitindo realizar operações de comunicação com a API sem bloquear diretamente a interface da aplicação.

## 📚 Principais Conceitos Aplicados

* Programação Orientada a Objetos
* Desenvolvimento desktop com VCL
* Integração com APIs REST
* Manipulação de JSON
* SQL e FireDAC
* Banco de dados SQLite
* Processamento assíncrono com threads
* Impressão térmica
* Geração de relatórios
* Organização de código em classes e formulários

## 👨‍💻 Autor

**Felipe Conceição**

[GitHub](https://github.com/Felipe-conc)
