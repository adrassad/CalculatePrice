import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'presentation/blocs/locale_bloc.dart';
import 'presentation/blocs/locale_state.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Инициализация перед runApp()
  runApp(const MyApp());
}

/// Виджет приложения
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleBloc(),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            darkTheme: ThemeData.dark(),
            color: Colors.black,
            title: 'Localized App',
            locale: state.locale,
            supportedLocales: const [Locale('en', ''), Locale('ru', '')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}
