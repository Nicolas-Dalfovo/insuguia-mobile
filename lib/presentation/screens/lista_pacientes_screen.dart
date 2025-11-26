import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/paciente.dart';
import '../providers/paciente_provider.dart';
import 'cadastro_paciente_screen.dart';
import 'dados_clinicos_screen.dart';
import 'editar_paciente_screen.dart';
import 'historico_prescricoes_screen.dart';

// Tela para listar todos os pacientes cadastrados
class ListaPacientesScreen extends StatefulWidget {
  const ListaPacientesScreen({super.key});

  @override
  State<ListaPacientesScreen> createState() => _ListaPacientesScreenState();
}

class _ListaPacientesScreenState extends State<ListaPacientesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializa e carrega os pacientes ao iniciar a tela
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await context.read<PacienteProvider>().initialize();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao inicializar: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _buscarPacientes(String termo) {
    context.read<PacienteProvider>().buscarPorNome(termo);
  }

  void _novoPaciente() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroPacienteScreen(),
      ),
    ).then((_) {
      // Recarrega a lista ao voltar
      context.read<PacienteProvider>().carregarPacientes();
    });
  }

  void _selecionarPaciente(Paciente paciente) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DadosClinicosScreen(paciente: paciente),
      ),
    );
  }

  void _verHistorico(Paciente paciente) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoricoPrescricoesScreen(paciente: paciente),
      ),
    );
  }

  void _editarPaciente(Paciente paciente) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarPacienteScreen(paciente: paciente),
      ),
    ).then((_) {
      // Recarrega a lista após editar
      context.read<PacienteProvider>().carregarPacientes();
    });
  }

  void _excluirPaciente(Paciente paciente) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text(
          'Deseja realmente excluir o paciente ${paciente.nome}?\n\nEsta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar == true && paciente.id != null) {
      try {
        await context.read<PacienteProvider>().excluirPaciente(paciente.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Paciente excluído com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir paciente: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes Cadastrados'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nome...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _buscarPacientes('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _buscarPacientes,
            ),
          ),
        ),
      ),
      body: Consumer<PacienteProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.erro != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.erro!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.carregarPacientes(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (provider.pacientes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_off_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchController.text.isEmpty
                        ? 'Nenhum paciente cadastrado'
                        : 'Nenhum paciente encontrado',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cadastre um novo paciente para começar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.pacientes.length,
            itemBuilder: (context, index) {
              final paciente = provider.pacientes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      paciente.nome[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    paciente.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('${paciente.idade} anos • ${paciente.sexo}'),
                      Text(
                        'IMC: ${paciente.imc?.toStringAsFixed(1) ?? 'N/A'} kg/m²',
                      ),
                      if (paciente.localInternacao != null)
                        Text('Local: ${paciente.localInternacao}'),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'prescrever',
                        child: Row(
                          children: [
                            Icon(Icons.medical_services),
                            SizedBox(width: 8),
                            Text('Nova Prescrição'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'historico',
                        child: Row(
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 8),
                            Text('Histórico'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'editar',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'excluir',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Excluir',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'prescrever') {
                        _selecionarPaciente(paciente);
                      } else if (value == 'historico') {
                        _verHistorico(paciente);
                      } else if (value == 'editar') {
                        _editarPaciente(paciente);
                      } else if (value == 'excluir') {
                        _excluirPaciente(paciente);
                      }
                    },
                  ),
                  onTap: () => _selecionarPaciente(paciente),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _novoPaciente,
        icon: const Icon(Icons.add),
        label: const Text('Novo Paciente'),
      ),
    );
  }
}
