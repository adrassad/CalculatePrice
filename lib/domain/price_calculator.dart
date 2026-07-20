/// Calculates total price for a target weight based on a reference price and weight.
///
/// Returns `null` when the calculation cannot be performed
/// (e.g. zero weight or zero target weight).
double? calculateTotalPrice({
  required double price,
  required double weight,
  required double targetWeight,
}) {
  if (weight == 0 || targetWeight == 0) {
    return null;
  }

  return price * targetWeight / weight;
}
