import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/state_rate.dart';
import '../models/calc_history_item.dart';

class IcmsService extends ChangeNotifier {
  List<StateRate> _all = [];
  List<StateRate> get all => List.unmodifiable(_all);

  static const _pinKey = 'app_pin_v1';
  static const _historyKey = 'calc_history_v1';

  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/data/icms.json');
    final data = json.decode(raw) as List;
    _all = data.map((e) => StateRate.fromJson(e)).toList();
    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
  }

  List<StateRate> search(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return all;
    return _all.where((e) =>
      e.estado.toLowerCase().contains(query) || e.uf.toLowerCase().contains(query)
    ).toList();
  }

  double calcularIcms(double base, double aliquota) => base * (aliquota / 100.0);

  // --- PIN ---
  Future<bool> hasPin() async {
    final sp = await SharedPreferences.getInstance();
    return sp.containsKey(_pinKey);
    }

  Future<void> setPin(String pin) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_pinKey, pin);
  }

  Future<bool> validatePin(String pin) async {
    final sp = await SharedPreferences.getInstance();
    final saved = sp.getString(_pinKey);
    return saved == pin;
  }

  Future<void> resetPin() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_pinKey);
  }

  // --- Histórico ---
  Future<List<CalcHistoryItem>> loadHistory() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_historyKey);
    if (raw == null) return [];
    final list = (json.decode(raw) as List)
        .map((e) => CalcHistoryItem.fromJson(e))
        .toList();
    return list;
  }

  Future<void> addToHistory(CalcHistoryItem item) async {
    final sp = await SharedPreferences.getInstance();
    final list = await loadHistory();
    list.insert(0, item);
    final raw = json.encode(list.map((e) => e.toJson()).toList());
    await sp.setString(_historyKey, raw);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_historyKey);
    notifyListeners();
  }
}
