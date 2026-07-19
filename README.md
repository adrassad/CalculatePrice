# Best Price Calculator

Flutter utility that scales a known unit price to a target weight.

**Formula:** `total = price × target_weight ÷ weight`

Example: if 2 kg cost 10, then 5 kg cost 25.

## Features

- Unit-price scaling with validation (no divide-by-zero)
- EN / RU UI
- Local persistence of last inputs (`shared_preferences`)
- Light / dark Material 3 theme

## Architecture

```
lib/
  domain/          # Pure calculation (no Flutter UI deps)
  data/            # Translation loading
  presentation/    # Screens, widgets, BLoC
```

Business logic lives in `PriceCalculator` and is covered by unit tests.

## Requirements

- Flutter 3.27+ / Dart 3.6+

## Run

```bash
flutter pub get
flutter run
```

## Test

```bash
flutter test
flutter analyze
```

## License

MIT — see [LICENSE](LICENSE).
