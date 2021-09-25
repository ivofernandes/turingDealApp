import 'dart:collection';

/// Class that represents the account in a broker
class TradingAccount{
  static const double INITIAL_BALANCE = 10000;

  double balance = INITIAL_BALANCE;
  LinkedHashMap<DateTime, double> balanceHistory = LinkedHashMap();
}