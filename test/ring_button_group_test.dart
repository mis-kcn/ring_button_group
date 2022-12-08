import 'package:flutter_test/flutter_test.dart';

import 'package:ring_button_group/ring_button_group.dart';

void main() {
  test('initialization', () {
    final calculator = RingButtonGroup(
      buttonNumber: 5,
      pressedIndex: const {1},
      onPressed: (index, selected) async => true,
    );
    expect(calculator.buttonSize, 40);
  });
}
