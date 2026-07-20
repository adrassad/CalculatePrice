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
    add(LocaleChanged(const Locale('en')));
  }

  Future<void> _onLocaleChanged(
    LocaleChanged event,
    Emitter<LocaleState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final translations = await _loadTranslations(event.locale);
      emit(
        state.copyWith(
          locale: event.locale,
          translations: translations,
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load translations',
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _loadTranslations(Locale locale) async {
    final jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    return json.decode(jsonString) as Map<String, dynamic>;
  }
}
