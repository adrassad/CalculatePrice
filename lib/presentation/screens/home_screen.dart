import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/locale_bloc.dart';
import '../blocs/locale_event.dart';
import '../blocs/locale_state.dart';
import '../widgets/calculator_widget.dart';

/// Главная страница
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const CircularProgressIndicator();
              }
              return Text(state.translations?["app_title"] ?? "App");
            },
          ),
          actions: [
            BlocBuilder<LocaleBloc, LocaleState>(builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.language, color: Colors.white),
                onPressed: () {
                  context.read<LocaleBloc>().add(
                        LocaleChanged(
                          Locale(
                              state.locale.languageCode == 'en' ? 'ru' : 'en'),
                        ),
                      );
                },
              );
            })
          ]),
      body: Center(
        child: BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const CircularProgressIndicator();
            }
            if (state.errorMessage != null) {
              return Text('Ошибка: ${state.errorMessage}');
            }
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CalculatorWidget(state.translations),
              ],
            ));
          },
        ),
      ),
    );
  }
}
