import 'package:flutter/material.dart';

class LocaleState {
  final Locale locale;
  final Map<String, dynamic>? translations;
  final bool isLoading;
  final String? errorMessage;

  LocaleState({
    required this.locale,
    this.translations,
    this.isLoading = false,
    this.errorMessage,
  });

  LocaleState copyWith({
    Locale? locale,
    Map<String, dynamic>? translations,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
      translations: translations ?? this.translations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
