import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorWidget extends StatelessWidget {
  final _controllerWeight = TextEditingController();
  final _controllerPrice = TextEditingController();
  final _controllerWeightTarget = TextEditingController();
  final _controllerPriceTotal = TextEditingController();

  final _focusNodeWeight = FocusNode();
  final _focusNodePrice = FocusNode();
  final _focusNodeWeightTarget = FocusNode();

  final Map<String, dynamic>? translations;

  CalculatorWidget(this.translations);

  void total() {
    final price = double.tryParse(_controllerPrice.text) ?? 0;
    final weight = double.tryParse(_controllerWeight.text) ?? 0;
    final weightTarget = double.tryParse(_controllerWeightTarget.text) ?? 0;

    if (weightTarget != 0) {
      _controllerPriceTotal.text = (price * weightTarget / weight).toString();
    } else {
      _controllerPriceTotal.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                _custumTextField(
                    context: context,
                    controller: _controllerWeight,
                    label: translations?["weight"],
                    focusNode: _focusNodeWeight,
                    focusNodeNext: _focusNodePrice),
                _custumTextField(
                    context: context,
                    controller: _controllerPrice,
                    label: translations?["price"],
                    focusNode: _focusNodePrice,
                    focusNodeNext: _focusNodeWeightTarget),
              ],
            ),
            Row(
              children: [
                _custumTextField(
                    context: context,
                    controller: _controllerWeightTarget,
                    label: translations?["target_weight"],
                    focusNode: _focusNodeWeightTarget,
                    focusNodeNext: _focusNodeWeight),
                _custumTextField(
                    context: context,
                    controller: _controllerPriceTotal,
                    label: translations?["total_price"],
                    readyOnly: true)
              ],
            ),
          ],
        ));
  }

  Widget _custumTextField(
      {context,
      required TextEditingController controller,
      required String label,
      focusNode,
      focusNodeNext,
      readyOnly = false}) {
    return Expanded(
      child: TextField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,7}')),
          ],
          focusNode: focusNode,
          controller: controller,
          decoration: InputDecoration(labelText: label),
          keyboardType: TextInputType.number,
          readOnly: readyOnly,
          onChanged: (_) => total(),
          onSubmitted: (value) {
            if (focusNodeNext != null) {
              FocusScope.of(context).requestFocus(focusNodeNext);
            }
            ;
          }),
    );
  }
}
