# Problema de Persistência de Dados no Flutter Web

## Descrição do Problema

Ao executar o aplicativo InsuGuia Mobile em modo debug no navegador Chrome, os dados salvos no Hive (banco de dados local) não persistem entre sessões. Quando o aplicativo é fechado e reaberto, todos os pacientes e prescrições cadastrados desaparecem.

## Causa Raiz

O Flutter, em modo debug, executa o Chrome com uma **porta aleatória** a cada execução. Como o Hive utiliza o IndexedDB do navegador para armazenar dados, e o IndexedDB é isolado por origem (protocolo + domínio + porta), cada execução cria um novo armazenamento vazio.

**Exemplo:**
- Primeira execução: `http://localhost:52341`
- Segunda execução: `http://localhost:58923`

Como as portas são diferentes, o navegador trata como origens diferentes, e os dados não são compartilhados.

## Solução

Executar o aplicativo com uma **porta fixa** garante que a origem seja sempre a mesma, permitindo que o IndexedDB persista os dados entre sessões.

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

Para verificar se a solução está funcionando:

1. Execute o aplicativo com porta fixa
2. Cadastre um paciente
3. Feche o navegador completamente
4. Execute o aplicativo novamente (com a mesma porta)
5. Acesse "Pacientes Cadastrados"
6. O paciente deve estar lá!

## Observações

- Este problema **só ocorre em modo debug**
- Em **produção** (flutter build web), os dados persistem normalmente
- A porta 5555 foi escolhida arbitrariamente, você pode usar qualquer porta disponível
- Se a porta 5555 já estiver em uso, escolha outra (ex: 8080, 3000, etc.)

## Referências

- [GitHub Issue - Hive storage not persistent on Flutter web](https://github.com/hivedb/hive/issues/587)
- [Stack Overflow - Data not persisting for IndexedDB](https://stackoverflow.com/questions/70941814/data-is-not-persisting-for-indexeddb-using-flutter-and-package-hive-on-webchrom)
