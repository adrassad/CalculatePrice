import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'locale_event.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc()
      : super(LocaleState(locale: const Locale('en'), isLoading: true)) {
    on<LocaleChanged>(_onLocaleChanged);

    // Вместо прямого вызова _loadInitialTranslations, вызываем событие
    add(LocaleChanged(const Locale('en')));
  }

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
