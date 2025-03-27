import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chatbot_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request all necessary permissions
  await requestPermissions();

  // Get saved language preference
  final prefs = await SharedPreferences.getInstance();
  final String savedLanguage = prefs.getString('selectedLanguage') ?? 'English';
  final locale = _getLocaleFromLanguage(savedLanguage);

  runApp(KisaanSetuApp(initialLocale: locale));
}

// Helper function to convert language name to locale
Locale _getLocaleFromLanguage(String language) {
  Map<String, Locale> localeMap = {
    'English': Locale('en'),
    'Hindi': Locale('hi'),
    'Punjabi': Locale('pa'),
    'Bengali': Locale('bn'),
    'Tamil': Locale('ta'),
    'Telugu': Locale('te'),
    'Marathi': Locale('mr'),
    'Gujarati': Locale('gu'),
  };

  return localeMap[language] ?? Locale('en');
}

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses =
      await [
        Permission.location,
        Permission.microphone,
        Permission.camera,
        Permission.photos,
        Permission.storage,
      ].request();

  if (statuses[Permission.location]!.isDenied) {
    if (kDebugMode) {
      print("Location permission denied.");
    }
  }
  if (statuses[Permission.camera]!.isDenied) {
    if (kDebugMode) {
      print("Camera permission denied.");
    }
  }
  if (statuses[Permission.photos]!.isDenied) {
    if (kDebugMode) {
      print("Photo library access denied.");
    }
  }
  if (statuses[Permission.storage]!.isDenied) {
    if (kDebugMode) {
      print("Storage access denied.");
    }
  }
  if (statuses[Permission.microphone]!.isDenied) {
    if (kDebugMode) {
      print("Microphone access denied.");
    }
  }
}

class KisaanSetuApp extends StatefulWidget {
  final Locale initialLocale;

  const KisaanSetuApp({super.key, this.initialLocale = const Locale('en')});

  @override
  _KisaanSetuAppState createState() => _KisaanSetuAppState();

  // Static method to access state from anywhere
  static _KisaanSetuAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_KisaanSetuAppState>()!;
}

class _KisaanSetuAppState extends State<KisaanSetuApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  // Method to change the app's locale
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KisaanSetu',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Localization configuration
      locale: _locale,
      localizationsDelegates: [
        AppLocalizationsDelegate(), // New delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('pa'), // Punjabi
        Locale('bn'), // Bengali
        Locale('ta'), // Tamil
        Locale('te'), // Telugu
        Locale('mr'), // Marathi
        Locale('gu'), // Gujarati
      ],

      // Existing routes
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/chatbot': (context) => const ChatbotScreen(),
      },
    );
  }
}
