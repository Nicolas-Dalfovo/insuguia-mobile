import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'core/database/database_helper.dart';
import 'data/datasources/paciente_local_datasource.dart';
import 'data/datasources/prescricao_local_datasource.dart';
import 'data/repositories/paciente_repository.dart';
import 'data/repositories/prescricao_repository.dart';
import 'presentation/providers/paciente_provider.dart';
import 'presentation/providers/prescricao_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InsuGuiaApp());
}

class InsuGuiaApp extends StatelessWidget {
  const InsuGuiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper.instance;
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PacienteProvider(
            repository: PacienteRepository(
              localDataSource: PacienteLocalDataSource(dbHelper),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PrescricaoProvider(
            PrescricaoRepository(
              dataSource: PrescricaoLocalDataSource(dbHelper),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'InsuGuia Mobile',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const HomeScreen(),
      ),
    );
  }
}
