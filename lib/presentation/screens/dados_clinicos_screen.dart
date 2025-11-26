import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/dados_clinicos.dart';
import '../../domain/entities/paciente.dart';
import 'resultado_prescricao_screen.dart';

class DadosClinicosScreen extends StatefulWidget {
  final Paciente paciente;

  const DadosClinicosScreen({
    super.key,
    required this.paciente,
  });

  @override
  State<DadosClinicosScreen> createState() => _DadosClinicosScreenState();
}

class _DadosClinicosScreenState extends State<DadosClinicosScreen> {
  final _formKey = GlobalKey<FormState>();

  final _glicemiaAdmissaoController = TextEditingController();
  final _hba1cController = TextEditingController();
  final _doseInsulinaPreviaController = TextEditingController();
  final _doseCorticoideController = TextEditingController();

  bool _diabetesPrevio = false;
  bool _usoInsulinaPrevio = false;
  TipoDiabetes? _tipoDiabetes;
  TipoDieta _tipoDieta = TipoDieta.oral;
  bool _usoCorticoide = false;

  final List<double> _glicemiasRecentes = [];

  @override
  void dispose() {
    _glicemiaAdmissaoController.dispose();
    _hba1cController.dispose();
    _doseInsulinaPreviaController.dispose();
    _doseCorticoideController.dispose();
    super.dispose();
  }

  void _gerarPrescricao() {
    if (_formKey.currentState!.validate()) {
      final dadosClinicos = DadosClinicos(
        pacienteId: widget.paciente.id ?? 0,
        glicemiaAdmissao: double.tryParse(_glicemiaAdmissaoController.text),
        hba1c: double.tryParse(_hba1cController.text),
        diabetesPrevio: _diabetesPrevio,
        usoInsulinaPrevio: _usoInsulinaPrevio,
        doseInsulinaPrevia: double.tryParse(_doseInsulinaPreviaController.text),
        tipoDiabetes: _tipoDiabetes,
        tipoDieta: _tipoDieta,
        usoCorticoide: _usoCorticoide,
        doseCorticoide: double.tryParse(_doseCorticoideController.text),
      );

      if (_glicemiaAdmissaoController.text.isNotEmpty) {
        _glicemiasRecentes
            .add(double.parse(_glicemiaAdmissaoController.text));
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadoPrescricaoScreen(
            paciente: widget.paciente,
            dadosClinicos: dadosClinicos,
            glicemiasRecentes: _glicemiasRecentes,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados Clínicos'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paciente: ${widget.paciente.nome}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'IMC: ${widget.paciente.imc?.toStringAsFixed(1)} kg/m²',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Dados Glicêmicos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _glicemiaAdmissaoController,
              decoration: const InputDecoration(
                labelText: 'Glicemia de Admissão',
                hintText: '40 a 600 mg/dL',
                prefixIcon: Icon(Icons.water_drop),
                suffixText: 'mg/dL',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final glicemia = double.tryParse(value);
                  if (glicemia == null || glicemia < 40 || glicemia > 600) {
                    return 'Glicemia deve estar entre 40 e 600 mg/dL';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hba1cController,
              decoration: const InputDecoration(
                labelText: 'HbA1c',
                hintText: '4.0 a 15.0%',
                prefixIcon: Icon(Icons.science),
                suffixText: '%',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Histórico de Diabetes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _diabetesPrevio,
              onChanged: (value) {
                setState(() {
                  _diabetesPrevio = value;
                  if (!value) {
                    _tipoDiabetes = null;
                    _usoInsulinaPrevio = false;
                  }
                });
              },
              title: const Text('Diabetes prévio conhecido'),
              subtitle: const Text('Paciente já tinha diagnóstico de diabetes'),
            ),
            if (_diabetesPrevio) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<TipoDiabetes>(
                value: _tipoDiabetes,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Diabetes',
                  prefixIcon: Icon(Icons.medical_information),
                ),
                items: TipoDiabetes.values
                    .where((tipo) => tipo != TipoDiabetes.gestacional)
                    .map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo.descricao),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoDiabetes = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _usoInsulinaPrevio,
                onChanged: (value) {
                  setState(() {
                    _usoInsulinaPrevio = value;
                  });
                },
                title: const Text('Uso domiciliar de insulina'),
                subtitle: const Text('Paciente já usava insulina em casa'),
              ),
              if (_usoInsulinaPrevio) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _doseInsulinaPreviaController,
                  decoration: const InputDecoration(
                    labelText: 'Dose Diária de Insulina',
                    hintText: '0.1 a 3.0 UI/kg/dia',
                    prefixIcon: Icon(Icons.medication),
                    suffixText: 'UI/kg/dia',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                ),
              ],
            ],
            const SizedBox(height: 24),
            Text(
              'Dieta e Medicações',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TipoDieta>(
              value: _tipoDieta,
              decoration: const InputDecoration(
                labelText: 'Tipo de Dieta',
                prefixIcon: Icon(Icons.restaurant),
              ),
              items: TipoDieta.values.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo.descricao),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _tipoDieta = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _usoCorticoide,
              onChanged: (value) {
                setState(() {
                  _usoCorticoide = value;
                });
              },
              title: const Text('Uso de glicocorticoide'),
              subtitle: const Text('Prednisona, dexametasona, etc.'),
            ),
            if (_usoCorticoide) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _doseCorticoideController,
                decoration: const InputDecoration(
                  labelText: 'Dose de Corticoide',
                  hintText: '5 a 200 mg/dia',
                  prefixIcon: Icon(Icons.medication),
                  suffixText: 'mg/dia',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _gerarPrescricao,
              icon: const Icon(Icons.calculate),
              label: const Text('Gerar Prescrição'),
            ),
          ],
        ),
      ),
    );
  }
}
