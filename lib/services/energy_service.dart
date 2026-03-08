import 'dart:async';
import 'package:flutter/foundation.dart';

class EnergyService extends ChangeNotifier {
  static final EnergyService instance = EnergyService._internal();

  factory EnergyService() => instance;

  EnergyService._internal();

  int energy = 100;
  int timerSeconds = 180;
  Timer? _timer;

  void ensureStarted() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (energy < 100) {
        if (timerSeconds > 0) {
          timerSeconds--;
          notifyListeners();
        } else {
          energy += 1;
          timerSeconds = 180;
          notifyListeners();
        }
      }
    });
  }

  void addEnergy(int amount) {
    energy += amount;
    notifyListeners();
  }

  void consumeEnergy(int amount) {
    energy = (energy - amount).clamp(0, 100);
    notifyListeners();
  }

  void disposeTimer() {
    _timer?.cancel();
    _timer = null;
  }
}



