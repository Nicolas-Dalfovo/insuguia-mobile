import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'aviso_legal_screen.dart';
import 'lista_pacientes_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.medical_services,
                    size: 120,
                    color: Colors.blue,
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                AppConstants.appDescription,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Baseado nas Diretrizes SBD 2025',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AvisoLegalScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Novo Paciente'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListaPacientesScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.list),
                label: const Text('Pacientes Cadastrados'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  _mostrarSobre(context);
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Sobre o Aplicativo'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarSobre(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre o InsuGuia Mobile'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Versão ${AppConstants.appVersion}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aplicativo desenvolvido como projeto de extensão universitária '
                'para orientação de prescrição de insulina em pacientes hospitalizados.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Baseado nas Diretrizes da Sociedade Brasileira de Diabetes 2025.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Desenvolvido por: Curso de Sistemas de Informação - UNIDAVI',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
