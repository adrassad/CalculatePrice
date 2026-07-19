import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/translation_repository.dart';
import 'locale_event.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc({
    TranslationRepository? translationRepository,
    Locale initialLocale = const Locale('en'),
  })  : _translations = translationRepository ?? const TranslationRepository(),
        super(LocaleState(locale: initialLocale, isLoading: true)) {
    on<LocaleChanged>(_onLocaleChanged);
    add(LocaleChanged(initialLocale));
  }

  final TranslationRepository _translations;

  Future<void> _onLocaleChanged(
    LocaleChanged event,
    Emitter<LocaleState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final map = await _translations.load(event.locale.languageCode);
      emit(
        state.copyWith(
          locale: event.locale,
          translations: map,
          isLoading: false,
          clearError: true,
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
}
