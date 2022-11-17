import 'package:appointment_manager/constants.dart';
import 'package:appointment_manager/models/appointment.dart';
import 'package:appointment_manager/screens/home.dart';
import 'package:appointment_manager/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await Hive.initFlutter();
  Hive.registerAdapter(AppointmentAdapter());
  Hive.registerAdapter(AppointmentTypeAdapter());
  await Hive.openBox('systemPreferences');
  await Hive.openBox<Appointment>('appointments');
  await NotificationService().init();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('systemPreferences').listenable(),
      builder: (context, prefsBox, _) {
        bool isDarkMode = prefsBox.get('darkMode', defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kOffWhite,
            errorColor: kLightErrorColor,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: kPrimaryColor,
            ),
            appBarTheme: const AppBarTheme(
              color: kOffWhite,
              elevation: 0,
              foregroundColor: kDarkColor,
            ),
          ),
          darkTheme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Colors.grey,
            cardColor: kDarkColor,
            dialogBackgroundColor: kDarkColor,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: kDarkColor,
            errorColor: kDarkErrorColor,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: kPrimaryColor,
              foregroundColor: kDarkColor,
            ),
            appBarTheme: const AppBarTheme(
              color: kDarkColor,
              elevation: 0,
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: Home(isDarkMode: isDarkMode),
        );
      },
    );
  }
}
