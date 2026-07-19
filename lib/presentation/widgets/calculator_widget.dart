import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/price_calculator.dart';

class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({
    super.key,
    required this.translations,
  });

  final Map<String, String> translations;

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  static const _keyWeight = 'saved_weight';
  static const _keyPrice = 'saved_price';
  static const _keyWeightTarget = 'saved_weight_target';

  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _totalController = TextEditingController();

  final _weightFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _targetWeightFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    unawaited(_restoreFields());
  }

  @override
  void dispose() {
    _weightController.dispose();
    _priceController.dispose();
    _targetWeightController.dispose();
    _totalController.dispose();
    _weightFocus.dispose();
    _priceFocus.dispose();
    _targetWeightFocus.dispose();
    super.dispose();
  }

  Future<void> _restoreFields() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    _weightController.text = prefs.getString(_keyWeight) ?? '';
    _priceController.text = prefs.getString(_keyPrice) ?? '';
    _targetWeightController.text = prefs.getString(_keyWeightTarget) ?? '';
    _recalculate();
  }

  Future<void> _persistFields() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWeight, _weightController.text);
    await prefs.setString(_keyPrice, _priceController.text);
    await prefs.setString(_keyWeightTarget, _targetWeightController.text);
  }

  void _recalculate() {
    final weight = PriceCalculator.parseField(_weightController.text);
    final price = PriceCalculator.parseField(_priceController.text);
    final target = PriceCalculator.parseField(_targetWeightController.text);

    if (weight == null || price == null || target == null) {
      _totalController.text = '';
      return;
    }

    final total = PriceCalculator.scaleToTarget(
      weight: weight,
      price: price,
      targetWeight: target,
    );

    _totalController.text =
        total == null ? '' : PriceCalculator.formatTotal(total);
    unawaited(_persistFields());
  }

  String _label(String key) => widget.translations[key] ?? key;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _field(
                controller: _weightController,
                label: _label('weight'),
                focusNode: _weightFocus,
                nextFocus: _priceFocus,
              ),
              const SizedBox(width: 8),
              _field(
                controller: _priceController,
                label: _label('price'),
                focusNode: _priceFocus,
                nextFocus: _targetWeightFocus,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _field(
                controller: _targetWeightController,
                label: _label('target_weight'),
                focusNode: _targetWeightFocus,
              ),
              const SizedBox(width: 8),
              _field(
                controller: _totalController,
                label: _label('total_price'),
                readOnly: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
    FocusNode? nextFocus,
    bool readOnly = false,
  }) {
    return Expanded(
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,7}')),
        ],
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: readOnly ? null : (_) => _recalculate(),
        onSubmitted: (_) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
      ),
    );
  }
}
