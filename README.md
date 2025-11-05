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

-   **Cadastro de Paciente:** Coleta de dados demográficos, antropométricos e laboratoriais.
-   **Cálculos Automáticos:** Cálculo de IMC e Taxa de Filtração Glomerular (TFG).
-   **Categorização Clínica:** Classificação da sensibilidade à insulina (sensível, usual, resistente) e determinação do esquema de insulinoterapia (correção isolada, basal-plus, basal-bolus).
-   **Geração de Prescrição:** Criação de uma prescrição completa e detalhada, pronta para ser copiada e utilizada.
-   **Interface Intuitiva:** Fluxo de telas guiado para facilitar o uso no ambiente hospitalar.

## Arquitetura

O aplicativo foi desenvolvido utilizando a arquitetura **Clean Architecture**, separando as responsabilidades em três camadas principais:

1.  **Presentation:** Interface do usuário, construída com Widgets do Flutter e gerenciamento de estado.
2.  **Domain:** Lógica de negócio, regras clínicas, entidades e casos de uso (use cases).
3.  **Data:** Acesso e persistência de dados (atualmente sem persistência implementada no protótipo).

## Como Executar o Projeto

### Pré-requisitos

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.5.0 ou superior)
-   Um emulador Android/iOS ou um dispositivo físico

### Passos

1.  **Clone o repositório:**

    ```bash
    git clone <https://github.com/Nicolas-Dalfovo/insuguia-mobile>
    cd insuguia_app
    ```

2.  **Instale as dependências:**

    ```bash
    flutter pub get
    ```

3.  **Execute o aplicativo:**

    ```bash
    flutter run
    ```

## Estrutura de Pastas

```
lib/
├── core/              # Constantes, temas, utilitários
├── data/              # Fontes de dados, modelos, repositórios
├── domain/            # Entidades, casos de uso, lógica de negócio
├── presentation/      # Telas, widgets, providers
└── main.dart          # Ponto de entrada da aplicação
```

## Documentação Adicional

-   [Documento de Arquitetura](docs/arquitetura_aplicativo.md)
-   [Análise de Sistemas Similares](docs/sistemas_similares.md)
-   [Resumos das Diretrizes SBD](docs/)

## Aviso Legal

Este é um projeto acadêmico e não deve ser utilizado para decisões clínicas reais sem a supervisão e responsabilidade de um profissional médico qualificado. As informações e sugestões geradas pelo aplicativo são baseadas nas diretrizes da SBD, mas a decisão final é sempre do médico prescritor.

---

*Desenvolvido pelo aluno Nicolas Marques Dalfovo - 2025*
