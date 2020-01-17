import 'package:flutter/foundation.dart';
import 'global.dart';

/// Provider para o Dark Mode
class DynamicDarkMode with ChangeNotifier {
  /// Por padrão o App Começa com o modo Light Mode
  /// Você pode configurar um método de persistir o valor de
  /// [_isDarkMode] para que ele seja preservado quando o app for fechado

  /// Verifica se o App está em Dark Mode
  get isDarkMode => database.get('dark_mode', defaultValue: false);

  /// Aplica o Dark Mode
  void setDarkMode() {
    database.put('dark_mode', true);
    notifyListeners();
  }

  /// Aplica o Light Mode
  void setLightMode() {
    database.put('dark_mode', false);
    notifyListeners();
  }
}
