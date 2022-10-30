import 'package:flutter_test/flutter_test.dart';

import 'package:cyclic_button_group/cyclic_button_group.dart';

void main() {
  test('adds one to input values', () {
    final calculator = CyclicButtonGroup(buttonNumber: 5, pressedIndex: const {1}, onPressed:(index, selected) {},);
    // expect(calculator.addOne(2), 3);
    // expect(calculator.addOne(-7), -6);
    // expect(calculator.addOne(0), 1);
  });
}
