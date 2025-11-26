import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'data/database/hive_helper.dart';
import 'presentation/providers/paciente_provider.dart';
import 'presentation/screens/home_screen.dart';

// Ponto de entrada da aplicação
void main() async {
  // Garante que os bindings do Flutter estejam inicializados antes de usar plugins
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Hive (banco de dados local compatível com Web)
  await HiveHelper.instance.initialize();
  
  runApp(const InsuGuiaApp());
}

// Widget raiz da aplicação
class InsuGuiaApp extends StatelessWidget {
  const InsuGuiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PacienteProvider()),
      ],
      child: MaterialApp(
        title: 'InsuGuia Mobile',
        debugShowCheckedModeBanner: false, // Remove banner de debug
        theme: AppTheme.lightTheme, // Tema claro
        darkTheme: AppTheme.darkTheme, // Tema escuro
        themeMode: ThemeMode.light, // Modo de tema padrão
        home: const HomeScreen(), // Tela inicial
      ),
    );
  }
}
