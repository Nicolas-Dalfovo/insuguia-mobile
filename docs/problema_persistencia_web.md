# Persistência de Dados no Flutter Web

## Problema Original (RESOLVIDO)

Ao executar o aplicativo InsuGuia Mobile em modo debug no navegador Chrome, os dados salvos no Hive (banco de dados local) não persistem entre sessões. Quando o aplicativo é fechado e reaberto, todos os pacientes e prescrições cadastrados desaparecem.

## Causa Raiz

O Flutter, em modo debug, executa o Chrome com uma **porta aleatória** a cada execução. Como o Hive utiliza o IndexedDB do navegador para armazenar dados, e o IndexedDB é isolado por origem (protocolo + domínio + porta), cada execução cria um novo armazenamento vazio.

**Exemplo:**
- Primeira execução: `http://localhost:52341`
- Segunda execução: `http://localhost:58923`

Como as portas são diferentes, o navegador trata como origens diferentes, e os dados não são compartilhados.

## Solução Implementada

O problema foi resolvido configurando o Hive para usar um **subdiretório fixo** ao invés de depender da porta. Agora o aplicativo persiste dados automaticamente, independente da porta usada.

### Como funciona

O método `Hive.initFlutter()` aceita um parâmetro opcional que define o nome do subdiretório onde os dados serão armazenados:

```dart
await Hive.initFlutter('insuguia_db');
```

Além disso, os nomes das boxes são prefixados com `insuguia_` para garantir isolamento:

```dart
final fullBoxName = 'insuguia_$boxName';
```

Com isso, o IndexedDB armazena os dados em um local fixo, independente da porta:
- `insuguia_db/insuguia_pacientes`
- `insuguia_db/insuguia_prescricoes`

### Solução Alternativa (Porta Fixa)

Caso ainda queira usar porta fixa por outros motivos, o projeto também está configurado para isso:

### Opção 1: Configuração Automática (VS Code)

O projeto já está configurado com arquivos `.vscode/launch.json` e `.vscode/settings.json` que definem a porta 5555 automaticamente.

**Como usar:**
1. Abra o projeto no VS Code
2. Pressione F5 ou vá em "Run > Start Debugging"
3. O aplicativo será executado em `http://localhost:5555`
4. Os dados persistirão entre sessões

### Opção 2: Linha de Comando

Execute o aplicativo com o parâmetro `--web-port`:

```bash
flutter run -d chrome --web-port 5555
```

### Opção 3: Android Studio / IntelliJ

1. Vá em "Run > Edit Configurations"
2. Selecione a configuração do seu projeto
3. Em "Additional run args", adicione: `--web-port 5555`
4. Clique em "Apply" e "OK"

## Verificação

Para verificar se a persistência está funcionando:

1. Execute o aplicativo (com qualquer porta ou sem especificar)
   ```bash
   flutter run -d chrome
   ```
2. Cadastre um paciente
3. Feche o navegador completamente
4. Execute o aplicativo novamente (pode ser com porta diferente)
5. Acesse "Pacientes Cadastrados"
6. O paciente deve estar lá!

### Teste com portas diferentes

```bash
# Primeira execução
flutter run -d chrome --web-port 5555
# Cadastre um paciente

# Segunda execução (porta diferente)
flutter run -d chrome --web-port 8080
# O paciente ainda estará lá!
```

## Observações

- A solução com subdiretório fixo funciona em **qualquer modo** (debug, profile, release)
- Os dados persistem independente da porta usada
- O nome `insuguia_db` garante isolamento de outros apps Flutter
- Em **produção** (flutter build web), os dados persistem normalmente sem nenhuma configuração adicional

## Referências

- [GitHub Issue - Hive storage not persistent on Flutter web](https://github.com/hivedb/hive/issues/587)
- [Stack Overflow - Data not persisting for IndexedDB](https://stackoverflow.com/questions/70941814/data-is-not-persisting-for-indexeddb-using-flutter-and-package-hive-on-webchrom)
