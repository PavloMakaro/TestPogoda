import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

// --- Design System Constants (from style.txt) ---

// Backgrounds
const Color kBgPrimary = Color(0xFF1C1C1E);
const Color kBgSecondary = Color(0xFF2C2C2E);

// Text
const Color kTextPrimary = Color(0xFFFFFFFF);
const Color kTextSecondary = Color(0xFF8E8E93);

// Accents
const Color kAccentBlue = Color(0xFF0A84FF);

// Typography (Sizes)
const double kTextBase = 14.0;
const double kTextMd = 16.0;
const double kTextXl = 28.0;

// Radius
const double kRadiusSm = 8.0;

// Spacing
const double kSpace5 = 16.0;
const double kSpace10 = 32.0;

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Иркутск Погода',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBgPrimary,
        fontFamily: '-apple-system', // Fallback to system font
        useMaterial3: false,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String _temperature = '--';
  String _description = 'Загрузка...';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
      _description = 'Обновление...';
    });

    try {
      // Irkutsk: 52.2978, 104.296
      final url = Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=52.2978&longitude=104.296&current_weather=true');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final currentWeather = data['current_weather'];
        final double temp = currentWeather['temperature'];
        final int weatherCode = currentWeather['weathercode'];

        setState(() {
          _temperature = '${temp.round()}°C';
          _description = _getWeatherDescription(weatherCode);
          _isLoading = false;
        });
      } else {
        setState(() {
          _description = 'Ошибка сети';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _description = 'Ошибка';
        _isLoading = false;
      });
    }
  }

  String _getWeatherDescription(int code) {
    // WMO Weather interpretation codes (WW)
    switch (code) {
      case 0:
        return 'Ясно';
      case 1:
      case 2:
      case 3:
        return 'Облачно';
      case 45:
      case 48:
        return 'Туман';
      case 51:
      case 53:
      case 55:
        return 'Морось';
      case 56:
      case 57:
        return 'Ледяная морось';
      case 61:
      case 63:
      case 65:
        return 'Дождь';
      case 66:
      case 67:
        return 'Ледяной дождь';
      case 71:
      case 73:
      case 75:
        return 'Снег';
      case 77:
        return 'Снежные зерна';
      case 80:
      case 81:
      case 82:
        return 'Ливень';
      case 85:
      case 86:
        return 'Снежный ливень';
      case 95:
        return 'Гроза';
      case 96:
      case 99:
        return 'Гроза с градом';
      default:
        return 'Неизвестно';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgPrimary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kSpace5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Temperature
              Text(
                _temperature,
                style: const TextStyle(
                  color: kTextPrimary,
                  fontSize: 72, // Large temperature
                  fontWeight: FontWeight.w400, // Regular weight per design
                ),
              ),
              const SizedBox(height: kSpace5),
              // Description
              Text(
                _description,
                style: const TextStyle(
                  color: kTextSecondary,
                  fontSize: kTextMd,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: kSpace10),
              // Update Button
              SizedBox(
                width: 200, // Minimalistic width
                child: GestureDetector(
                  onTap: _isLoading ? null : _fetchWeather,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: kAccentBlue,
                      borderRadius: BorderRadius.circular(kRadiusSm),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _isLoading ? 'Загрузка...' : 'Обновить',
                      style: const TextStyle(
                        color: kTextPrimary,
                        fontSize: kTextBase,
                        fontWeight: FontWeight.w500, // Medium
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
