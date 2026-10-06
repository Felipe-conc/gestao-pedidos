# 🖥️ Sistema de Gestão de Pedidos

Aplicação desktop desenvolvida em **Delphi** para gerenciamento de pedidos, integração com API, impressão térmica e geração de relatórios.

## ✨ Funcionalidades

- 🔐 Autenticação de usuários
- 🏢 Seleção de estabelecimento
- 📦 Recebimento de pedidos via API
- 🔄 Atualização automática de pedidos
- 🖨️ Impressão em impressoras térmicas
- 📊 Relatórios de pedidos e vendas
- 🏷️ Gerenciamento de canais de venda
- 💾 Banco de dados local SQLite

## 🛠️ Tecnologias

- Delphi / Object Pascal
- VCL
- FireDAC
- SQLite
- Indy (`TIdHTTP`)
- JSON
- FastReport
- ACBr

## 🏗️ Estrutura

```text
├── classes/       # Classes e regras de negócio
├── fontes/        # Formulários e funcionalidades
├── reports/       # Relatórios
└── prjImpressaoPedidos.dproj
```

## 🔄 Fluxo

```text
Login
  ↓
Selecionar estabelecimento
  ↓
Receber pedidos da API
  ↓
Processar pedidos
  ↓
Imprimir / alterar status
  ↓
Gerar relatórios
```

## 📚 Principais conceitos

- Programação orientada a objetos
- Integração com APIs REST
- Manipulação de JSON
- Banco de dados SQLite
- SQL e FireDAC
- Processamento em threads
- Impressão térmica
- Geração de relatórios

> Este projeto utiliza uma API externa e componentes específicos para execução completa.

## 👨‍💻 Autor

**Felipe Conceição**

[GitHub](https://github.com/Felipe-conc)
