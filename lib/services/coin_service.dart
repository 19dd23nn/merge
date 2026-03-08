import 'package:flutter/foundation.dart';

class CoinService extends ChangeNotifier {
  static final CoinService instance = CoinService._internal();
  factory CoinService() => instance;
  CoinService._internal();

  int coins = 0;
  final int maxCoins = 999999;

  void add(int amount) {
    final int next = coins + amount;
    coins = next > maxCoins ? maxCoins : next;
    notifyListeners();
  }

  void spend(int amount) {
    final int next = coins - amount;
    coins = next < 0 ? 0 : next;
    notifyListeners();
  }
}



