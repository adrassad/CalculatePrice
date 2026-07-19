/// Pure unit-price scaling: given a known (weight, price) pair,
/// compute the price for a different target weight.
///
/// Formula: `total = price * targetWeight / weight`
class PriceCalculator {
  const PriceCalculator._();

  /// Returns the scaled total price, or `null` when inputs are invalid
  /// (non-finite, non-positive weight, or negative price/target).
  static double? scaleToTarget({
    required double weight,
    required double price,
    required double targetWeight,
  }) {
    if (!_isUsable(weight) || weight <= 0) return null;
    if (!_isUsable(price) || price < 0) return null;
    if (!_isUsable(targetWeight) || targetWeight < 0) return null;

    return price * targetWeight / weight;
  }

  /// Parses a UI decimal field. Empty / invalid → `null`.
  static double? parseField(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed.replaceAll(',', '.'));
  }

  /// Formats a total for display (trim trailing zeros).
  static String formatTotal(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    var text = value.toStringAsFixed(6);
    text = text.replaceFirst(RegExp(r'0+$'), '');
    text = text.replaceFirst(RegExp(r'\.$'), '');
    return text;
  }

  static bool _isUsable(double value) => value.isFinite;
}
