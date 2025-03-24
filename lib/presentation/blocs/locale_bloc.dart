import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'locale_event.dart';
import 'locale_state.dart';

/// Bloc для управления локализацией
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc()
      : super(LocaleState(locale: const Locale('en'), isLoading: true)) {
    on<LocaleChanged>(_onLocaleChanged);
    _loadInitialTranslations();
  }

  /// Метод для обработки изменения локали
  Future<void> _onLocaleChanged(
      LocaleChanged event, Emitter<LocaleState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final translations = await _loadTranslations(event.locale);
      emit(state.copyWith(
          locale: event.locale, translations: translations, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: 'Ошибка загрузки перевода'));
    }
  }

  /// Метод для начальной загрузки переводов
  Future<void> _loadInitialTranslations() async {
    try {
      final translations = await _loadTranslations(state.locale);
      emit(state.copyWith(translations: translations, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: 'Ошибка загрузки перевода'));
    }
  }

  /// Загрузка JSON-файла с переводами
  Future<Map<String, dynamic>> _loadTranslations(Locale locale) async {
    try {
      final String jsonString = await rootBundle
          .loadString('assets/lang/${locale.languageCode}.json');
      return json.decode(jsonString);
    } catch (e) {
      debugPrint('Ошибка загрузки перевода: $e');
      return {};
    }
  }
}
