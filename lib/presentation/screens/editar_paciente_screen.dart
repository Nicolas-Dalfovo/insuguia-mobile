import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/paciente.dart';
import '../../domain/usecases/calcular_imc.dart';
import '../../domain/usecases/calcular_tfg.dart';
import '../providers/paciente_provider.dart';

// Tela para editar dados de um paciente existente
class EditarPacienteScreen extends StatefulWidget {
  final Paciente paciente;

  const EditarPacienteScreen({
    super.key,
    required this.paciente,
  });

  @override
  State<EditarPacienteScreen> createState() => _EditarPacienteScreenState();
}

class _EditarPacienteScreenState extends State<EditarPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _calcularIMC = CalcularIMC();
  final _calcularTFG = CalcularTFG();

  late TextEditingController _nomeController;
  late TextEditingController _idadeController;
  late TextEditingController _pesoController;
  late TextEditingController _alturaController;
  late TextEditingController _creatininaController;
  late TextEditingController _localInternacaoController;

  late String _sexo;
  late bool _negroOuPardo;

  double? _imc;
  String? _classificacaoIMC;
  double? _tfg;
  String? _classificacaoTFG;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.paciente.nome);
    _idadeController =
        TextEditingController(text: widget.paciente.idade.toString());
    _pesoController =
        TextEditingController(text: widget.paciente.peso.toString());
    _alturaController =
        TextEditingController(text: widget.paciente.altura.toString());
    _creatininaController = TextEditingController(
        text: widget.paciente.creatinina?.toString() ?? '');
    _localInternacaoController =
        TextEditingController(text: widget.paciente.localInternacao ?? '');

    _sexo = widget.paciente.sexo;
    _negroOuPardo = false;

    _imc = widget.paciente.imc;
    _tfg = widget.paciente.tfg;

    if (_imc != null) {
      _classificacaoIMC = _calcularIMC.classificarIMC(_imc!);
    }
    if (_tfg != null) {
      _classificacaoTFG = _calcularTFG.classificarTFG(_tfg!);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    _creatininaController.dispose();
    _localInternacaoController.dispose();
    super.dispose();
  }

  void _calcularIndicadores() {
    if (_pesoController.text.isNotEmpty && _alturaController.text.isNotEmpty) {
      final peso = double.tryParse(_pesoController.text);
      final altura = double.tryParse(_alturaController.text);

      if (peso != null && altura != null) {
        setState(() {
          _imc = _calcularIMC.execute(peso, altura);
          _classificacaoIMC = _calcularIMC.classificarIMC(_imc!);
        });
      }
    }

    if (_creatininaController.text.isNotEmpty &&
        _idadeController.text.isNotEmpty) {
      final creatinina = double.tryParse(_creatininaController.text);
      final idade = int.tryParse(_idadeController.text);

      if (creatinina != null && idade != null) {
        setState(() {
          _tfg = _calcularTFG.execute(
            creatinina: creatinina,
            idade: idade,
            sexo: _sexo,
            negro: _negroOuPardo,
          );
          _classificacaoTFG = _calcularTFG.classificarTFG(_tfg!);
        });
      }
    }
  }

  void _salvarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      final pacienteAtualizado = widget.paciente.copyWith(
        nome: _nomeController.text,
        sexo: _sexo,
        idade: int.parse(_idadeController.text),
        peso: double.parse(_pesoController.text),
        altura: double.parse(_alturaController.text),
        imc: _imc,
        creatinina: double.tryParse(_creatininaController.text),
        tfg: _tfg,
        localInternacao: _localInternacaoController.text.isEmpty
            ? null
            : _localInternacaoController.text,
      );

      try {
        await context.read<PacienteProvider>().atualizarPaciente(pacienteAtualizado);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Paciente atualizado com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar paciente: $e'),
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
        title: const Text('Editar Paciente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvarAlteracoes,
            tooltip: 'Salvar alterações',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              'Dados Demográficos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Paciente',
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _sexo,
              decoration: const InputDecoration(
                labelText: 'Sexo',
                prefixIcon: Icon(Icons.person_outline),
              ),
              items: ['Masculino', 'Feminino'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _sexo = value!;
                  _calcularIndicadores();
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _idadeController,
              decoration: const InputDecoration(
                labelText: 'Idade',
                hintText: '18 a 120 anos',
                prefixIcon: Icon(Icons.cake),
                suffixText: 'anos',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => _calcularIndicadores(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                final idade = int.tryParse(value);
                if (idade == null || idade < 18 || idade > 120) {
                  return 'Idade deve estar entre 18 e 120 anos';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Dados Antropométricos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pesoController,
              decoration: const InputDecoration(
                labelText: 'Peso',
                hintText: '30 a 300 kg',
                prefixIcon: Icon(Icons.monitor_weight),
                suffixText: 'kg',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: (_) => _calcularIndicadores(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                final peso = double.tryParse(value);
                if (peso == null || peso < 30 || peso > 300) {
                  return 'Peso deve estar entre 30 e 300 kg';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alturaController,
              decoration: const InputDecoration(
                labelText: 'Altura',
                hintText: '100 a 250 cm',
                prefixIcon: Icon(Icons.height),
                suffixText: 'cm',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: (_) => _calcularIndicadores(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo obrigatório';
                }
                final altura = double.tryParse(value);
                if (altura == null || altura < 100 || altura > 250) {
                  return 'Altura deve estar entre 100 e 250 cm';
                }
                return null;
              },
            ),
            if (_imc != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IMC: ${_imc!.toStringAsFixed(1)} kg/m²',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Classificação: $_classificacaoIMC',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Dados Laboratoriais',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _creatininaController,
              decoration: const InputDecoration(
                labelText: 'Creatinina',
                prefixIcon: Icon(Icons.science),
                suffixText: 'mg/dL',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: (_) => _calcularIndicadores(),
            ),
            if (_tfg != null) ...[
              const SizedBox(height: 16),
              Card(
                color: _tfg! < 60 ? Colors.orange[50] : Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TFG: ${_tfg!.toStringAsFixed(1)} mL/min/1.73m²',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Classificação: $_classificacaoTFG',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Informações Adicionais',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _localInternacaoController,
              decoration: const InputDecoration(
                labelText: 'Local de Internação',
                prefixIcon: Icon(Icons.local_hospital),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _salvarAlteracoes,
              icon: const Icon(Icons.save),
              label: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
