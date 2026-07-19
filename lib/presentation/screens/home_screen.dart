import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/locale_bloc.dart';
import '../blocs/locale_event.dart';
import '../blocs/locale_state.dart';
import '../widgets/calculator_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            return Text(state.t('app_title'));
          },
        ),
        actions: [
          BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, state) {
              final next =
                  state.locale.languageCode == 'en' ? 'ru' : 'en';
              return IconButton(
                tooltip: next.toUpperCase(),
                icon: const Icon(Icons.language),
                onPressed: () {
                  context.read<LocaleBloc>().add(
                        LocaleChanged(Locale(next)),
                      );
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
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: CalculatorWidget(translations: state.translations),
            ),
          );
        },
      ),
    );
  }
}
