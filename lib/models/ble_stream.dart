import 'dart:async';

class BleStream {
  static final StreamController<String> leftToeController =
      StreamController<String>.broadcast();
  static final StreamController<String> leftHeelController =
      StreamController<String>.broadcast();
  static final StreamController<String> rightToeController =
      StreamController<String>.broadcast();
  static final StreamController<String> rightHeelController =
      StreamController<String>.broadcast();
}
