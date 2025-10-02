class CalcHistoryItem {
  final DateTime timestamp;
  final String uf;
  final String estado;
  final double base;
  final double aliquota;
  final double icms;
  final double total;

  CalcHistoryItem({
    required this.timestamp,
    required this.uf,
    required this.estado,
    required this.base,
    required this.aliquota,
    required this.icms,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'uf': uf,
        'estado': estado,
        'base': base,
        'aliquota': aliquota,
        'icms': icms,
        'total': total,
      };

  factory CalcHistoryItem.fromJson(Map<String, dynamic> j) => CalcHistoryItem(
        timestamp: DateTime.parse(j['timestamp'] as String),
        uf: j['uf'],
        estado: j['estado'],
        base: (j['base'] as num).toDouble(),
        aliquota: (j['aliquota'] as num).toDouble(),
        icms: (j['icms'] as num).toDouble(),
        total: (j['total'] as num).toDouble(),
      );
}
