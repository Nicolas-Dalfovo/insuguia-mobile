# InsuGuia Mobile

**Aplicativo para orientação de prescrição de insulina hospitalar seguindo as diretrizes da Sociedade Brasileira de Diabetes (SBD) 2025.**

---

## Visão Geral

O InsuGuia Mobile é um aplicativo desenvolvido em Flutter como um projeto de extensão universitária do curso de Sistemas de Informação. O objetivo é fornecer uma ferramenta de apoio à decisão clínica para médicos, auxiliando na prescrição de insulinoterapia para pacientes adultos, não críticos e não gestantes, internados em ambiente hospitalar.

O aplicativo categoriza o paciente, avalia sua sensibilidade à insulina e, com base nas diretrizes mais recentes da SBD, sugere um esquema de insulinoterapia completo, incluindo:

-   **Dieta**
-   **Monitorização Glicêmica**
-   **Insulina Basal** (com foco em NPH)
-   **Insulina Rápida** (com foco em Regular)
-   **Escala de Correção**
-   **Orientações para manejo de hipoglicemia**

## Funcionalidades

### Implementadas

-   **Cadastro de Paciente:** Coleta de dados demográficos, antropométricos e laboratoriais
-   **Cálculos Automáticos:** Cálculo de IMC e Taxa de Filtração Glomerular (TFG)
-   **Categorização Clínica:** Classificação da sensibilidade à insulina (sensível, usual, resistente) e determinação do esquema de insulinoterapia (correção isolada, basal-plus, basal-bolus)
-   **Geração de Prescrição:** Criação de uma prescrição completa e detalhada, pronta para ser copiada e utilizada
-   **Interface Intuitiva:** Fluxo de telas guiado para facilitar o uso no ambiente hospitalar
-   **Persistência de Dados:** Banco de dados Hive para armazenar pacientes e prescrições
-   **Listagem de Pacientes:** Visualização de todos os pacientes cadastrados com busca por nome
-   **Edição de Pacientes:** Atualização de dados de pacientes já cadastrados
-   **Exclusão de Pacientes:** Remoção de pacientes do sistema com confirmação
-   **Compatibilidade Web:** Funciona perfeitamente em navegadores web

### Em Desenvolvimento

-   Visualização de prescrições anteriores
-   Acompanhamento diário com registro de glicemias
-   Ajuste automático de doses baseado em glicemias diárias
-   Orientações para alta hospitalar
-   Exportação de prescrição em PDF

## Arquitetura

O aplicativo foi desenvolvido utilizando a arquitetura **Clean Architecture**, separando as responsabilidades em três camadas principais:

1.  **Presentation:** Interface do usuário, construída com Widgets do Flutter e gerenciamento de estado com Provider
2.  **Domain:** Lógica de negócio, regras clínicas, entidades e casos de uso (use cases)
3.  **Data:** Acesso e persistência de dados com Hive, datasources e repositórios

## Como Executar o Projeto

### Pré-requisitos

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.5.0 ou superior)
-   Um emulador Android/iOS, dispositivo físico, ou navegador web

### Passos

1.  **Clone o repositório:**

    ```bash
    git clone https://github.com/Nicolas-Dalfovo/insuguia-mobile.git
    cd insuguia-mobile
    ```

2.  **Instale as dependências:**

    ```bash
    flutter pub get
    ```

3.  **Execute o aplicativo:**

    **Para Web:**
    ```bash
    flutter run -d chrome
    ```

    **Para Android/iOS:**
    ```bash
    flutter run
    ```

    **Para Desktop:**
    ```bash
    flutter run -d windows  # ou macos, linux
    ```

## Estrutura de Pastas

```
lib/
├── core/              # Constantes, temas, utilitários
├── data/              # Fontes de dados, repositórios, banco de dados
│   ├── database/      # Helper do Hive
│   ├── datasources/   # Datasources para operações CRUD
│   └── repositories/  # Repositórios para acesso aos dados
├── domain/            # Entidades, casos de uso, lógica de negócio
│   ├── entities/      # Entidades do domínio com adaptadores Hive
│   └── usecases/      # Casos de uso (lógica clínica)
├── presentation/      # Telas, widgets, providers
│   ├── providers/     # Gerenciamento de estado com Provider
│   └── screens/       # Telas do aplicativo
└── main.dart          # Ponto de entrada da aplicação
```

## Tecnologias Utilizadas

-   **Flutter 3.35.7** - Framework multiplataforma
-   **Dart** - Linguagem de programação
-   **Hive** - Banco de dados NoSQL rápido e compatível com Web
-   **Provider** - Gerenciamento de estado
-   **Clean Architecture** - Arquitetura de software

## Banco de Dados

O aplicativo utiliza **Hive**, um banco de dados NoSQL leve e rápido que funciona em todas as plataformas suportadas pelo Flutter:

-   Android
-   iOS
-   Web
-   Windows
-   macOS
-   Linux

**Vantagens do Hive:**
-   Compatível com Flutter Web (diferente do SQLite)
-   Mais rápido que SQLite
-   Sintaxe simples e intuitiva
-   Sem necessidade de escrever SQL
-   Armazenamento local seguro

## Documentação Adicional

-   [Documento de Arquitetura](docs/arquitetura_aplicativo.md)
-   [Análise de Sistemas Similares](docs/sistemas_similares.md)
-   [Resumos das Diretrizes SBD](docs/)

## Aviso Legal

Este é um projeto acadêmico e não deve ser utilizado para decisões clínicas reais sem a supervisão e responsabilidade de um profissional médico qualificado. As informações e sugestões geradas pelo aplicativo são baseadas nas diretrizes da SBD, mas a decisão final é sempre do médico prescritor.

---

*Desenvolvido pelo Curso de Sistemas de Informação - 2025*
