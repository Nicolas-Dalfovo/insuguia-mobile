import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'presentation/screens/home_screen.dart';

// Ponto de entrada da aplicação
void main() {
  runApp(const InsuGuiaApp());
}

// Widget raiz da aplicação
class InsuGuiaApp extends StatelessWidget {
  const InsuGuiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsuGuia Mobile',
      debugShowCheckedModeBanner: false, // Remove banner de debug
      theme: AppTheme.lightTheme, // Tema claro
      darkTheme: AppTheme.darkTheme, // Tema escuro
      themeMode: ThemeMode.light, // Modo de tema padrão
      home: const HomeScreen(), // Tela inicial
    );
  }
}
