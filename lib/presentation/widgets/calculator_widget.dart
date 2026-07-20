import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/price_calculator.dart';

class CalculatorWidget extends StatefulWidget {
  final Map<String, dynamic>? translations;

  const CalculatorWidget({super.key, this.translations});

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  final _controllerWeight = TextEditingController();
  final _controllerPrice = TextEditingController();
  final _controllerWeightTarget = TextEditingController();
  final _controllerPriceTotal = TextEditingController();

  final _focusNodeWeight = FocusNode();
  final _focusNodePrice = FocusNode();
  final _focusNodeWeightTarget = FocusNode();

  static const _keyWeight = 'saved_weight';
  static const _keyPrice = 'saved_price';
  static const _keyWeightTarget = 'saved_weight_target';
  static const _keyPriceTotal = 'saved_price_total';

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  @override
  void dispose() {
    _controllerWeight.dispose();
    _controllerPrice.dispose();
    _controllerWeightTarget.dispose();
    _controllerPriceTotal.dispose();
    _focusNodeWeight.dispose();
    _focusNodePrice.dispose();
    _focusNodeWeightTarget.dispose();
    super.dispose();
  }

  void _recalculate() {
    final price = double.tryParse(_controllerPrice.text) ?? 0;
    final weight = double.tryParse(_controllerWeight.text) ?? 0;
    final targetWeight = double.tryParse(_controllerWeightTarget.text) ?? 0;

    final total = calculateTotalPrice(
      price: price,
      weight: weight,
      targetWeight: targetWeight,
    );

    _controllerPriceTotal.text = total?.toString() ?? '';
    _saveValues();
  }

  Future<void> _loadSavedValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _controllerWeight.text = prefs.getString(_keyWeight) ?? '';
      _controllerPrice.text = prefs.getString(_keyPrice) ?? '';
      _controllerWeightTarget.text = prefs.getString(_keyWeightTarget) ?? '';
      _controllerPriceTotal.text = prefs.getString(_keyPriceTotal) ?? '';
    });
  }

  Future<void> _saveValues() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWeight, _controllerWeight.text);
    await prefs.setString(_keyPrice, _controllerPrice.text);
    await prefs.setString(_keyWeightTarget, _controllerWeightTarget.text);
    await prefs.setString(_keyPriceTotal, _controllerPriceTotal.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildTextField(
                context: context,
                controller: _controllerWeight,
                labelKey: 'weight',
                focusNode: _focusNodeWeight,
                nextFocusNode: _focusNodePrice,
              ),
              _buildTextField(
                context: context,
                controller: _controllerPrice,
                labelKey: 'price',
                focusNode: _focusNodePrice,
                nextFocusNode: _focusNodeWeightTarget,
              ),
            ],
          ),
          Row(
            children: [
              _buildTextField(
                context: context,
                controller: _controllerWeightTarget,
                labelKey: 'target_weight',
                focusNode: _focusNodeWeightTarget,
                nextFocusNode: _focusNodeWeight,
              ),
              _buildTextField(
                context: context,
                controller: _controllerPriceTotal,
                labelKey: 'total_price',
                readOnly: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String labelKey,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    bool readOnly = false,
  }) {
    final label = widget.translations?[labelKey] ?? labelKey;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,7}')),
          ],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => _recalculate(),
          onSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
        ),
      ),
    );
  }
}
