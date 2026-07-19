import 'dart:convert';

import 'package:flutter/services.dart';

/// Loads UI string maps from `assets/lang/{code}.json`.
class TranslationRepository {
  const TranslationRepository();

  Future<Map<String, String>> load(String languageCode) async {
    final jsonString =
        await rootBundle.loadString('assets/lang/$languageCode.json');
    final decoded = json.decode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Translation file must be a JSON object');
    }
    return decoded.map(
      (key, value) => MapEntry(key, value?.toString() ?? key),
    );
  }
}
