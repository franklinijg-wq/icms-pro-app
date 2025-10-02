import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/icms_service.dart';
import '../models/state_rate.dart';
import '../models/calc_history_item.dart';

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  StateRate? estado;
  final TextEditingController baseCtrl = TextEditingController();
  final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void dispose() {
    baseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.watch<IcmsService>();
    final estados = service.all;

    double base = double.tryParse(baseCtrl.text.replaceAll(',', '.')) ?? 0.0;
    final aliq = estado?.aliquota ?? (estados.isNotEmpty ? estados.first.aliquota : 0.0);
    final icms = service.calcularIcms(base, aliq);
    final total = base + icms;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<StateRate>(
            value: estado ?? (estados.isNotEmpty ? estados.first : null),
            items: estados.map((e) => DropdownMenuItem(
              value: e,
              child: Text('${e.estado} (${e.uf}) - ${e.aliquota.toStringAsFixed(2)}%'),
            )).toList(),
            onChanged: (v) => setState(() => estado = v),
            decoration: const InputDecoration(
              labelText: 'Estado',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: baseCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Valor base (R$)',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ICMS: ' + formatter.format(icms), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Total com ICMS: ' + formatter.format(total), style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Salvar no histórico'),
              onPressed: base > 0 && estados.isNotEmpty ? () async {
                final e = estado ?? estados.first;
                await service.addToHistory(CalcHistoryItem(
                  timestamp: DateTime.now(),
                  uf: e.uf,
                  estado: e.estado,
                  base: base,
                  aliquota: aliq,
                  icms: icms,
                  total: total,
                ));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cálculo salvo')));
                }
              } : null,
            ),
          ),
          const Spacer(),
          const Text('Aviso: alíquotas podem variar por produto e regime. Confirme normas vigentes.'),
        ],
      ),
    );
  }
}
