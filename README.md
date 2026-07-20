# Calculate Price

Cross-platform Flutter app that helps compare product prices by weight. Enter the price and weight of one package, specify a target weight, and the app instantly calculates the proportional cost.

[Русская версия](#русская-версия)

## Features

- **Price calculator** — proportional cost for any target weight
- **Localization** — English and Russian UI
- **Persistent input** — values are saved between sessions via `SharedPreferences`
- **Multi-platform** — Android, iOS, macOS, Web, Windows, Linux

## Screenshots

| English | Russian |
|---------|---------|
| *Add screenshots after first release* | *Добавьте скриншоты после первого релиза* |

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, SDK ^3.6)
- Platform tooling for your target (Xcode for iOS/macOS, Android Studio for Android, Chrome for Web)

### Installation

```bash
git clone https://github.com/adrassad/calculateprice_app.git
cd calculateprice_app
flutter pub get
```

### Run

```bash
# List available devices
flutter devices

# Web (Chrome)
flutter run -d chrome

# macOS
flutter config --enable-macos-desktop
flutter run -d macos

# Android / iOS
flutter run
```

### Test & Analyze

```bash
flutter analyze
flutter test
```

## How It Works

The app uses a simple proportional formula:

```
total_price = price × target_weight / weight
```

**Example:** A 100 g package costs 200. What is the price for 50 g?

```
200 × 50 / 100 = 100
```

## Project Structure

```
lib/
├── domain/              # Pure business logic
│   └── price_calculator.dart
├── presentation/
│   ├── blocs/           # Locale state management (BLoC)
│   ├── screens/         # App screens
│   └── widgets/         # Reusable UI components
└── main.dart
assets/
└── lang/                # Localization files (en.json, ru.json)
```

## Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter | UI framework |
| flutter_bloc | State management |
| shared_preferences | Local data persistence |
| flutter_localizations | i18n support |

## License

This project is licensed under the [MIT License](LICENSE).

---

## Русская версия

**Calculate Price** — кроссплатформенное Flutter-приложение для сравнения цен товаров по весу. Введите цену и вес одной упаковки, укажите целевой вес — приложение мгновенно рассчитает пропорциональную стоимость.

### Возможности

- Калькулятор цены по весу
- Локализация: русский и английский
- Сохранение введённых значений между сессиями
- Поддержка Android, iOS, macOS, Web, Windows, Linux

### Быстрый старт

```bash
git clone https://github.com/adrassad/calculateprice_app.git
cd calculateprice_app
flutter pub get
flutter run -d chrome
```

### Формула

```
итоговая_цена = цена × целевой_вес / вес
```

**Пример:** Упаковка 100 г стоит 200. Сколько стоят 50 г?

```
200 × 50 / 100 = 100
```

### Лицензия

[MIT License](LICENSE)
