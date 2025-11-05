import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/paciente.dart';
import '../../domain/usecases/calcular_imc.dart';
import '../../domain/usecases/calcular_tfg.dart';
import 'dados_clinicos_screen.dart';

class CadastroPacienteScreen extends StatefulWidget {
  const CadastroPacienteScreen({super.key});

  @override
  State<CadastroPacienteScreen> createState() => _CadastroPacienteScreenState();
}

class _CadastroPacienteScreenState extends State<CadastroPacienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _calcularIMC = CalcularIMC();
  final _calcularTFG = CalcularTFG();

  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();
  final _creatininaController = TextEditingController();
  final _localInternacaoController = TextEditingController();

  String _sexo = 'Masculino';
  bool _negroOuPardo = false;

  double? _imc;
  String? _classificacaoIMC;
  double? _tfg;
  String? _classificacaoTFG;

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

  void _proximaEtapa() {
    if (_formKey.currentState!.validate()) {
      final paciente = Paciente(
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

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DadosClinicosScreen(paciente: paciente),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro do Paciente'),
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
                hintText: 'Nome completo',
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
                hintText: 'Em anos',
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
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _negroOuPardo,
              onChanged: (value) {
                setState(() {
                  _negroOuPardo = value ?? false;
                  _calcularIndicadores();
                });
              },
              title: const Text('Raça negra ou parda'),
              subtitle: const Text('Para cálculo da TFG'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
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
                hintText: 'Em quilogramas',
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
                hintText: 'Em centímetros',
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
                hintText: 'Valor sérico',
                prefixIcon: Icon(Icons.science),
                suffixText: 'mg/dL',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: (_) => _calcularIndicadores(),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final creatinina = double.tryParse(value);
                  if (creatinina == null ||
                      creatinina < 0.3 ||
                      creatinina > 15) {
                    return 'Creatinina deve estar entre 0.3 e 15.0 mg/dL';
                  }
                }
                return null;
              },
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
                      if (_tfg! < 60) ...[
                        const SizedBox(height: 8),
                        Text(
                          _calcularTFG.orientacaoAjuste(_tfg!),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.orange[900]),
                        ),
                      ],
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
                hintText: 'Enfermaria, leito, etc.',
                prefixIcon: Icon(Icons.local_hospital),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _proximaEtapa,
              child: const Text('Próxima Etapa: Dados Clínicos'),
            ),
          ],
        ),
      ),
    );
  }
}
