# Arquitetura do Aplicativo InsuGuia Mobile

## Visão Geral

O InsuGuia Mobile é um aplicativo Flutter para orientação de prescrição de insulina em pacientes hospitalizados não críticos, desenvolvido seguindo as diretrizes da Sociedade Brasileira de Diabetes 2025.

## Tecnologias

- **Framework:** Flutter (multiplataforma - Android/iOS)
- **Linguagem:** Dart
- **Arquitetura:** Clean Architecture com Provider/Riverpod para gerenciamento de estado
- **Banco de Dados Local:** SQLite (via sqflite) para armazenamento de dados dos pacientes
- **Validações:** Dart built-in validators

## Estrutura de Camadas

### 1. Camada de Apresentação (Presentation Layer)
Responsável pela interface do usuário e interação.

**Componentes:**
- Telas (Screens/Pages)
- Widgets personalizados
- Gerenciamento de estado (Provider/Riverpod)

**Telas Principais:**
- Tela de Boas-vindas e Avisos
- Tela de Cadastro/Identificação do Paciente
- Tela de Dados Clínicos
- Tela de Categorização
- Tela de Prescrição Sugerida
- Tela de Acompanhamento Diário
- Tela de Orientações para Alta

### 2. Camada de Domínio (Domain Layer)
Contém a lógica de negócio e regras clínicas.

**Entidades:**
- Paciente
- DadosClinicos
- Prescricao
- AcompanhamentoDiario
- SensibilidadeInsulinica (enum: Sensivel, Usual, Resistente)
- EsquemaInsulina (enum: CorrecaoIsolada, BasalCorrecao, BasalBolus)
- TipoDieta (enum: Oral, Enteral, Parenteral, NPO)

**Casos de Uso (Use Cases):**
- CalcularIMC
- CalcularTFG (Taxa de Filtração Glomerular)
- ClassificarSensibilidadeInsulinica
- DeterminarEsquemaInsulina
- CalcularDoseTotalDiaria
- CalcularDoseBasal
- CalcularDoseBolus
- GerarEscalaCorrecao
- GerarPrescricaoCompleta
- AjustarDosesAcompanhamento

**Repositórios (Interfaces):**
- PacienteRepository
- PrescricaoRepository

### 3. Camada de Dados (Data Layer)
Responsável pelo acesso e persistência de dados.

**Componentes:**
- Implementações dos repositórios
- Data sources (local database)
- Modelos de dados (DTOs)

**Banco de Dados:**
```sql
-- Tabela de Pacientes
CREATE TABLE pacientes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    sexo TEXT NOT NULL,
    idade INTEGER NOT NULL,
    peso REAL NOT NULL,
    altura REAL NOT NULL,
    imc REAL,
    creatinina REAL,
    tfg REAL,
    local_internacao TEXT,
    data_cadastro TEXT,
    ativo INTEGER DEFAULT 1
);

-- Tabela de Dados Clínicos
CREATE TABLE dados_clinicos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    paciente_id INTEGER NOT NULL,
    glicemia_admissao REAL,
    hba1c REAL,
    diabetes_previo INTEGER,
    uso_insulina_previo INTEGER,
    dose_insulina_previa REAL,
    tipo_diabetes TEXT,
    tipo_dieta TEXT,
    uso_corticoide INTEGER,
    dose_corticoide REAL,
    fatores_risco TEXT,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);

-- Tabela de Prescrições
CREATE TABLE prescricoes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    paciente_id INTEGER NOT NULL,
    data_prescricao TEXT,
    sensibilidade_insulinica TEXT,
    esquema_insulina TEXT,
    dose_total_diaria REAL,
    dose_basal REAL,
    tipo_insulina_basal TEXT,
    horarios_basal TEXT,
    dose_bolus REAL,
    tipo_insulina_rapida TEXT,
    escala_correcao TEXT,
    orientacoes_dieta TEXT,
    orientacoes_monitorizacao TEXT,
    orientacoes_hipoglicemia TEXT,
    prescricao_completa TEXT,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);

-- Tabela de Acompanhamento
CREATE TABLE acompanhamentos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    paciente_id INTEGER NOT NULL,
    data_acompanhamento TEXT,
    glicemias TEXT,
    hipoglicemias INTEGER,
    hiperglicemias_severas INTEGER,
    ajuste_realizado INTEGER,
    nova_prescricao_id INTEGER,
    observacoes TEXT,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (nova_prescricao_id) REFERENCES prescricoes(id)
);
```

## Fluxo de Dados

```
Usuário → UI (Tela) → Controller/Provider → Use Case → Repository → Data Source → Database
                                                                                      ↓
                                                                                   SQLite
```

## Módulos Principais

### 1. Módulo de Cadastro
- Coleta de dados demográficos
- Coleta de dados clínicos e laboratoriais
- Validações de entrada
- Cálculos automáticos (IMC, TFG)

### 2. Módulo de Categorização
- Classificação de sensibilidade insulínica
- Determinação do esquema de insulina apropriado
- Identificação de fatores de risco

### 3. Módulo de Cálculo de Doses
- Cálculo da DTD (Dose Total Diária)
- Cálculo da dose basal
- Cálculo da dose bolus (quando aplicável)
- Geração de escala de correção personalizada
- Arredondamento de doses

### 4. Módulo de Prescrição
- Geração de prescrição formatada
- Orientações sobre dieta
- Orientações sobre monitorização
- Orientações sobre manejo de hipoglicemia
- Exportação/compartilhamento da prescrição

### 5. Módulo de Acompanhamento
- Registro de glicemias diárias
- Detecção de padrões (hipoglicemias, hiperglicemias)
- Sugestão de ajustes de doses
- Histórico de evolução

## Padrões de Design

### 1. Repository Pattern
Abstração da camada de dados, facilitando testes e manutenção.

### 2. Use Case Pattern
Cada ação do usuário corresponde a um caso de uso específico, encapsulando a lógica de negócio.

### 3. Provider Pattern
Gerenciamento de estado reativo e eficiente.

### 4. Factory Pattern
Criação de objetos complexos (prescrições, escalas de correção).

## Validações e Segurança

### Validações de Entrada
- Peso: 30-300 kg
- Altura: 100-250 cm
- Idade: 18-120 anos
- Glicemia: 40-600 mg/dL
- Creatinina: 0.3-15 mg/dL

### Alertas Clínicos
- Glicemia < 70 mg/dL: Alerta de hipoglicemia
- Glicemia > 400 mg/dL: Alerta de hiperglicemia severa
- TFG < 30: Alerta de insuficiência renal
- IMC < 18.5 ou > 40: Alertas nutricionais

### Avisos Legais
- Tela inicial com aviso de que se trata de ferramenta orientadora
- Decisões terapêuticas são de responsabilidade do médico
- Baseado nas diretrizes da SBD 2025
- Projeto acadêmico (para versão protótipo)

## Requisitos Não Funcionais

### Performance
- Tempo de resposta < 1 segundo para cálculos
- Interface fluida (60 fps)
- Tamanho do aplicativo < 50 MB

### Usabilidade
- Interface intuitiva e limpa
- Fluxo linear e guiado
- Feedback visual claro
- Suporte a modo claro e escuro

### Confiabilidade
- Validação rigorosa de dados
- Tratamento de erros
- Backup automático de dados
- Recuperação de sessão

### Manutenibilidade
- Código bem documentado
- Arquitetura modular
- Testes unitários e de integração
- Versionamento adequado

## Estrutura de Pastas

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── themes/
│   ├── utils/
│   └── validators/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

## Próximos Passos

1. Configuração do projeto Flutter
2. Implementação das entidades do domínio
3. Criação do banco de dados local
4. Implementação dos casos de uso clínicos
5. Desenvolvimento das telas principais
6. Integração e testes
7. Documentação final
