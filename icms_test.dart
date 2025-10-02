import 'package:flutter_test/flutter_test.dart';
import 'package:icms_pro_app/services/icms_service.dart';

void main() {
  test('calcularIcms should compute percentage correctly', () {
    final s = IcmsService();
    final icms = s.calcularIcms(100.0, 18.0);
    expect(icms, 18.0);
  });
}
