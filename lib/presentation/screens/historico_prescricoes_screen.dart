import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/paciente.dart';
import '../../domain/entities/prescricao.dart';
import '../providers/prescricao_provider.dart';
import 'visualizar_prescricao_screen.dart';

// Tela de histórico de prescrições de um paciente
class HistoricoPrescricoesScreen extends StatefulWidget {
  final Paciente paciente;

  const HistoricoPrescricoesScreen({
    super.key,
    required this.paciente,
  });

  @override
  State<HistoricoPrescricoesScreen> createState() =>
      _HistoricoPrescricoesScreenState();
}

class _HistoricoPrescricoesScreenState
    extends State<HistoricoPrescricoesScreen> {
  List<Prescricao> _prescricoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarPrescricoes();
  }

  Future<void> _carregarPrescricoes() async {
    setState(() => _isLoading = true);

    final provider = Provider.of<PrescricaoProvider>(context, listen: false);
    final prescricoes =
        await provider.carregarPrescricoesPorPaciente(widget.paciente.id!);

    setState(() {
      _prescricoes = prescricoes;
      _isLoading = false;
    });
  }

  void _visualizarPrescricao(Prescricao prescricao) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisualizarPrescricaoScreen(
          paciente: widget.paciente,
          prescricao: prescricao,
        ),
      ),
    );
  }

  Future<void> _confirmarExclusao(Prescricao prescricao) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Prescrição'),
        content: const Text(
          'Tem certeza que deseja excluir esta prescrição?\n\n'
          'Esta ação não pode ser desfeita.',
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

    if (confirmar == true && mounted) {
      final provider = Provider.of<PrescricaoProvider>(context, listen: false);
      await provider.deletarPrescricao(prescricao.key as int);
      await _carregarPrescricoes();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prescrição excluída com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Prescrições'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _prescricoes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma prescrição encontrada',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'As prescrições geradas para\n${widget.paciente.nome}\naparecerão aqui',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _prescricoes.length,
                  itemBuilder: (context, index) {
                    final prescricao = _prescricoes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          dateFormat.format(prescricao.dataPrescricao),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Esquema: ${prescricao.esquemaInsulina.descricao}',
                            ),
                            Text(
                              'DTD: ${prescricao.doseTotalDiaria.toStringAsFixed(0)} UI',
                            ),
                            Text(
                              'Sensibilidade: ${prescricao.sensibilidadeInsulinica.descricao}',
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'visualizar',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility),
                                  SizedBox(width: 8),
                                  Text('Visualizar'),
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
                            if (value == 'visualizar') {
                              _visualizarPrescricao(prescricao);
                            } else if (value == 'excluir') {
                              _confirmarExclusao(prescricao);
                            }
                          },
                        ),
                        onTap: () => _visualizarPrescricao(prescricao),
                      ),
                    );
                  },
                ),
    );
  }
}
