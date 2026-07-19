import 'package:flutter/material.dart';

@immutable
class LocaleState {
  const LocaleState({
    required this.locale,
    this.translations = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  final Locale locale;
  final Map<String, String> translations;
  final bool isLoading;
  final String? errorMessage;

  String t(String key) => translations[key] ?? key;

  LocaleState copyWith({
    Locale? locale,
    Map<String, String>? translations,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
      translations: translations ?? this.translations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
