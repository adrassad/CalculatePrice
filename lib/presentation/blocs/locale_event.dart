import 'package:flutter/material.dart';

@immutable
sealed class LocaleEvent {
  const LocaleEvent();
}

final class LocaleChanged extends LocaleEvent {
  const LocaleChanged(this.locale);

  final Locale locale;
}
