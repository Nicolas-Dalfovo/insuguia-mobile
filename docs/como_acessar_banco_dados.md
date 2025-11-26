# Como Acessar o Banco de Dados Hive

## Visão Geral

O InsuGuia Mobile usa **Hive** como banco de dados local. No Flutter Web, o Hive armazena os dados no **IndexedDB** do navegador.

## Métodos de Acesso

### 1. Via DevTools do Navegador (Recomendado)

#### Passo a Passo:

1. **Abra o aplicativo no Chrome**
   ```bash
   flutter run -d chrome
   ```

2. **Abra o DevTools**
   - Pressione `F12` ou
   - Clique com botão direito → "Inspecionar"

3. **Acesse a aba "Application"** (ou "Aplicativo" em português)

4. **Navegue até IndexedDB**
   - No menu lateral esquerdo, expanda "Storage" → "IndexedDB"
   - Você verá o banco do Hive

5. **Visualize os dados**
   - Expanda o banco de dados
   - Você verá as "object stores" (boxes):
     - `insuguia_pacientes`
     - `insuguia_prescricoes`
   - Clique em cada uma para ver os dados armazenados

#### Estrutura dos Dados:

**Box: insuguia_pacientes**
```
Key: 0, 1, 2... (IDs auto-incrementais)
Value: {
  "nome": "João Silva",
  "idade": 45,
  "peso": 70.0,
  "altura": 170.0,
  "sexo": "M",
  "creatinina": 1.0,
  "imc": 24.2,
  "tfg": 85.5,
  ...
}
```

**Box: insuguia_prescricoes**
```
Key: 0, 1, 2... (IDs auto-incrementais)
Value: {
  "pacienteId": 1,
  "dataPrescricao": "2025-11-26T...",
  "sensibilidadeInsulinica": 1,
  "esquemaInsulina": 2,
  "doseTotalDiaria": 35.0,
  "doseBasal": 17.5,
  ...
}
```

### 2. Via Código (Programaticamente)

Você pode acessar os dados diretamente no código:

```dart
import 'package:hive_flutter/hive_flutter.dart';

// Abrir box de pacientes
final boxPacientes = await Hive.openBox<Paciente>('insuguia_pacientes');

// Listar todos os pacientes
print('Total de pacientes: ${boxPacientes.length}');
for (var paciente in boxPacientes.values) {
  print('Paciente: ${paciente.nome}, ID: ${paciente.key}');
}

// Buscar paciente por key
final paciente = boxPacientes.get(0);
print('Primeiro paciente: ${paciente?.nome}');

// Abrir box de prescrições
final boxPrescricoes = await Hive.openBox<Prescricao>('insuguia_prescricoes');

// Listar prescrições de um paciente
final prescricoesPaciente = boxPrescricoes.values
    .where((p) => p.pacienteId == 1)
    .toList();
print('Prescrições do paciente 1: ${prescricoesPaciente.length}');
```

### 3. Via Tela de Visualização (Incluída no App)

O InsuGuia Mobile tem uma tela de debug para visualizar o banco:

1. Execute o app
2. Na tela inicial, clique em **"Teste do Hive (Debug)"** (botão laranja)
3. Clique em **"Executar Teste"**
4. Os logs mostrarão informações do banco

Ou use a tela de **"Teste Fluxo Completo"** (botão verde) que mostra:
- Total de pacientes no banco
- Total de prescrições no banco
- IDs e dados salvos

## Operações Comuns

### Limpar o Banco de Dados

**Opção 1 - Via DevTools:**
1. Abra DevTools (F12)
2. Vá em "Application" → "IndexedDB"
3. Clique com botão direito no banco
4. Selecione "Delete database"

**Opção 2 - Via Código:**
```dart
await Hive.deleteBoxFromDisk('insuguia_pacientes');
await Hive.deleteBoxFromDisk('insuguia_prescricoes');
```

**Opção 3 - Limpar cache do navegador:**
1. Pressione `Ctrl + Shift + Del`
2. Selecione "Todos os períodos"
3. Marque "Dados de sites"
4. Clique em "Limpar dados"

### Exportar Dados do Banco

**Via DevTools:**
1. Abra "Application" → "IndexedDB"
2. Clique na box desejada
3. Clique com botão direito nos dados
4. Selecione "Copy" ou "Copy object"
5. Cole em um arquivo JSON

### Verificar Tamanho do Banco

**Via DevTools:**
1. Abra "Application" → "Storage"
2. Veja "IndexedDB" no resumo
3. O tamanho em MB será exibido

## Localização dos Dados

### No Navegador (Web):

Os dados ficam em:
```
IndexedDB → [origem] → insuguia_db → object stores
```

Onde `[origem]` é algo como:
- `http://localhost:5555` (se usar porta fixa)
- `http://localhost:[porta_aleatória]` (se não usar porta fixa)

### Em Dispositivos Móveis:

**Android:**
```
/data/data/com.example.insuguia_app/app_flutter/insuguia_db/
```

**iOS:**
```
Library/Application Support/insuguia_db/
```

## Ferramentas Úteis

### 1. Hive Viewer (Extensão do Chrome)

Não existe uma extensão oficial, mas você pode usar:
- **IndexedDB Explorer** (extensão do Chrome)
- **Storage Area Explorer** (extensão do Chrome)

### 2. Flutter DevTools

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

Acesse: http://localhost:9100

### 3. Logs de Debug

O InsuGuia tem logs detalhados. Para vê-los:

1. Abra o console do navegador (F12 → Console)
2. Filtre por "DEBUG" para ver operações do banco
3. Exemplos de logs:
   ```
   DEBUG: Box pacientes já está aberta
   DEBUG: Total de pacientes no banco: 3
   DEBUG: Paciente salvo com key: 2, id: 2
   DEBUG: Sincronizado paciente João - key: 2, id: 2
   ```

## Estrutura das Boxes

### Box: insuguia_pacientes

**Campos principais:**
- `id`: int (sincronizado com key)
- `nome`: String
- `idade`: int
- `peso`: double
- `altura`: double
- `sexo`: String
- `creatinina`: double
- `imc`: double (calculado)
- `tfg`: double (calculado)
- `localInternacao`: String?

### Box: insuguia_prescricoes

**Campos principais:**
- `id`: int (sincronizado com key)
- `pacienteId`: int (chave estrangeira)
- `dataPrescricao`: DateTime
- `sensibilidadeInsulinica`: enum (0=sensível, 1=usual, 2=resistente)
- `esquemaInsulina`: enum (0=correção, 1=basal-correção, 2=basal-bolus)
- `doseTotalDiaria`: double
- `doseBasal`: double
- `doseBolus`: double?
- `tipoInsulinaBasal`: enum (0=NPH, 1=glargina, 2=detemir, 3=degludeca)
- `tipoInsulinaRapida`: enum (0=regular, 1=lispro, 2=aspart, 3=glulisina)
- `horariosBasal`: List<HorarioInsulina>
- `escalaCorrecao`: List<EscalaCorrecao>
- `orientacoesDieta`: String
- `orientacoesMonitorizacao`: String
- `orientacoesHipoglicemia`: String
- `prescricaoCompleta`: String

## Troubleshooting

### Problema: Dados não aparecem

**Solução:**
1. Verifique se está usando a mesma porta
2. Verifique se o Hive foi inicializado
3. Veja os logs no console

### Problema: Banco vazio após reabrir

**Solução:**
1. Use porta fixa: `flutter run -d chrome --web-port 5555`
2. Ou use a configuração do VS Code (já incluída no projeto)

### Problema: Erro ao abrir box

**Solução:**
1. Limpe o banco: `Hive.deleteBoxFromDisk('nome_da_box')`
2. Execute `flutter clean`
3. Reconstrua o app

## Dicas de Desenvolvimento

1. **Use logs:** Os datasources já têm logs detalhados
2. **Use o teste automatizado:** Valide operações rapidamente
3. **Use DevTools:** Visualize dados em tempo real
4. **Limpe o banco:** Ao fazer mudanças na estrutura de dados

## Segurança

⚠️ **Importante:**

- O Hive no navegador NÃO é criptografado por padrão
- Dados ficam visíveis no IndexedDB
- Para produção, considere criptografar dados sensíveis
- Não armazene senhas ou tokens no Hive sem criptografia

## Referências

- [Documentação oficial do Hive](https://docs.hivedb.dev/)
- [Hive Flutter](https://pub.dev/packages/hive_flutter)
- [IndexedDB MDN](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)
