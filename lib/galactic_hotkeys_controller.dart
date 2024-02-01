import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

@protected
class GalacticHotkeysController {
  final _pressedKeysController =
      StreamController<List<LogicalKeyboardKey>>.broadcast();

  Stream<List<LogicalKeyboardKey>> get stream => _pressedKeysController.stream;

  void add(List<LogicalKeyboardKey> keys) {
    _pressedKeysController.add(keys);
  }

  void dispose() {
    _pressedKeysController.close();
  }
}
