import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/services/auth_service_provider.dart';

final appcurrencyNotifierProvider =
    NotifierProvider<AppCurrencyProvider, String?>(() {
  return AppCurrencyProvider();
});

class AppCurrencyProvider extends Notifier<String?> {
  late String symbol;
  late String currencyPosition;
  @override
  String? build() {
    init();
    return null;
  }

  void init() async {
    final response = await ref.read(authServiceProvider).getAppCurrency();
    symbol = response.data['data']['symbol'];
    currencyPosition = response.data['data']['currency_position'];
  }

  String currencyValue(double value) {
    if (currencyPosition == 'Prefix') {
      return "$symbol${value.toStringAsFixed(2)}";
    } else {
      return "${value.toStringAsFixed(2)}$symbol";
    }
  }
}
