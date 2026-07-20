import 'package:calculateprice_app/domain/price_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calculateTotalPrice', () {
    test('calculates proportional price', () {
      expect(
        calculateTotalPrice(price: 200, weight: 100, targetWeight: 50),
        100,
      );
    });

    test('returns null when weight is zero', () {
      expect(
        calculateTotalPrice(price: 200, weight: 0, targetWeight: 50),
        isNull,
      );
    });

    test('returns null when target weight is zero', () {
      expect(
        calculateTotalPrice(price: 200, weight: 100, targetWeight: 0),
        isNull,
      );
    });

    test('handles fractional values', () {
      expect(
        calculateTotalPrice(price: 9.99, weight: 250, targetWeight: 100),
        closeTo(3.996, 0.001),
      );
    });
  });
}
