import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorWidget extends StatefulWidget {
  final Map<String, dynamic>? translations;
  const CalculatorWidget(this.translations, {super.key});
  @override
  CalculatorWidgetState createState() => CalculatorWidgetState();
}

class CalculatorWidgetState extends State<CalculatorWidget> {
  final _controllerWeight = TextEditingController();
  final _controllerPrice = TextEditingController();
  final _controllerWeightTarget = TextEditingController();
  final _controllerPriceTotal = TextEditingController();

  final _focusNodeWeight = FocusNode();
  final _focusNodePrice = FocusNode();
  final _focusNodeWeightTarget = FocusNode();

  static const String _keyWeight = 'saved_weight';
  static const String _keyPrice = 'saved_price';
  static const String _keyWeightTarget = 'saved_weight_target';
  static const String _keyPriceTotal = 'saved_price_total';

  @override
  void initState() {
    super.initState();
    _loadText();
  }

  void total() {
    final price = double.tryParse(_controllerPrice.text) ?? 0;
    final weight = double.tryParse(_controllerWeight.text) ?? 0;
    final weightTarget = double.tryParse(_controllerWeightTarget.text) ?? 0;

    if (weightTarget != 0) {
      _controllerPriceTotal.text = (price * weightTarget / weight).toString();
    } else {
      _controllerPriceTotal.text = '';
    }
    _saveText();
  }

  Future<void> _loadText() async {
    final prefs = await SharedPreferences.getInstance();
    _controllerWeight.text = prefs.getString(_keyWeight) ?? '';
    _controllerPrice.text = prefs.getString(_keyPrice) ?? '';
    _controllerWeightTarget.text = prefs.getString(_keyWeightTarget) ?? '';
    _controllerPriceTotal.text = prefs.getString(_keyPriceTotal) ?? '';
  }

  Future<void> _saveText() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWeight, _controllerWeight.text);
    await prefs.setString(_keyPrice, _controllerPrice.text);
    await prefs.setString(_keyWeightTarget, _controllerWeightTarget.text);
    await prefs.setString(_keyPriceTotal, _controllerPriceTotal.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                _customTextField(
                    context: context,
                    controller: _controllerWeight,
                    labelKey: "weight",
                    focusNode: _focusNodeWeight,
                    focusNodeNext: _focusNodePrice),
                _customTextField(
                    context: context,
                    controller: _controllerPrice,
                    labelKey: "price",
                    focusNode: _focusNodePrice,
                    focusNodeNext: _focusNodeWeightTarget),
              ],
            ),
            Row(
              children: [
                _customTextField(
                    context: context,
                    controller: _controllerWeightTarget,
                    labelKey: "target_weight",
                    focusNode: _focusNodeWeightTarget,
                    focusNodeNext: _focusNodeWeight),
                _customTextField(
                    context: context,
                    controller: _controllerPriceTotal,
                    labelKey: "total_price",
                    readyOnly: true)
              ],
            ),
          ],
        ));
  }

  Widget _customTextField(
      {context,
      required TextEditingController controller,
      required String labelKey,
      focusNode,
      focusNodeNext,
      readyOnly = false}) {
    final label = widget.translations?[labelKey] ?? labelKey;
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
          }),
    );
  }
}
