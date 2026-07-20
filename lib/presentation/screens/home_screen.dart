import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/locale_bloc.dart';
import '../blocs/locale_event.dart';
import '../blocs/locale_state.dart';
import '../widgets/calculator_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const CircularProgressIndicator();
            }
            return Text(state.translations?['app_title'] ?? 'Calculate Price');
          },
        ),
        actions: [
          BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.language),
                tooltip: state.locale.languageCode == 'en' ? 'Русский' : 'English',
                onPressed: () {
                  final nextLocale = state.locale.languageCode == 'en'
                      ? const Locale('ru')
                      : const Locale('en');
                  context.read<LocaleBloc>().add(LocaleChanged(nextLocale));
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }

          return Center(
            child: CalculatorWidget(translations: state.translations),
          );
        },
      ),
    );
  }
}
