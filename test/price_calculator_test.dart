import 'package:calculateprice_app/domain/price_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PriceCalculator.scaleToTarget', () {
    test('scales known unit price to a target weight', () {
      final total = PriceCalculator.scaleToTarget(
        weight: 2,
        price: 10,
        targetWeight: 5,
      );
      expect(total, 25);
    });

    test('returns null when weight is zero', () {
      final total = PriceCalculator.scaleToTarget(
        weight: 0,
        price: 10,
        targetWeight: 5,
      );
      expect(total, isNull);
    });

    test('returns null for negative price', () {
      final total = PriceCalculator.scaleToTarget(
        weight: 1,
        price: -1,
        targetWeight: 1,
      );
      expect(total, isNull);
    });

    test('accepts zero target weight', () {
      final total = PriceCalculator.scaleToTarget(
        weight: 1,
        price: 10,
        targetWeight: 0,
      );
      expect(total, 0);
    });
  });

  group('PriceCalculator.parseField', () {
    test('parses comma decimals', () {
      expect(PriceCalculator.parseField('12,5'), 12.5);
    });

    test('returns null for empty input', () {
      expect(PriceCalculator.parseField('  '), isNull);
    });
  });

  group('PriceCalculator.formatTotal', () {
    test('trims trailing zeros', () {
      expect(PriceCalculator.formatTotal(25.5), '25.5');
      expect(PriceCalculator.formatTotal(25.0), '25');
    });
  });
}
