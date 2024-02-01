import 'dart:ffi';
import 'dart:math';
import 'package:chrono_pool/components/applocal.dart';
import 'package:chrono_pool/controller/settings_controller.dart';
import 'package:chrono_pool/model/score.dart';
import 'package:chrono_pool/ui/home_page.dart';
import 'package:chrono_pool/auth/photo.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:chrono_pool/ui/settings_page.dart';

// Import 'dart:js_interop_unsafe' only for web
// This is necessary because 'dart:js_interop_unsafe' is not available on mobile or desktop
// You can use conditional import based on the platform
// For now, we'll check if it's web using kIsWeb from the foundation package
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login.dart';
import 'auth/signup.dart';
import 'auth/success.dart';
import 'notes/add.dart';
import 'notes/edit.dart';

// Only import 'dart:js_interop_unsafe' when running on the web
// Note: You might need to adjust this based on your specific use case
// If you have web-specific code using 'dart:js_interop_unsafe', consider conditionalizing it as well

late SharedPreferences sharedPref ;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Score()),
        //ChangeNotifierProvider(create: (_)=>PlayerNames()),
      ],
      child: MaterialApp(
        title: "CHRONO 8 POOL",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: "CHRONO 8 POOL"),
        //title:
        //   "CHRONO 8 POOL"), //const Login(),// const
        //   MyHomePage(title: "CHRONO 8 POOL"),,
        routes: {
          "home": (context) => const MyHomePage(title: "CHRONO 8 POOL"),
          "login": (context) => const Login(),
          "signup": (context) => const SignUp(),
          "success": (context) => const Success(),
          "addnote": (context) => const AddNote(),
          "editnote": (context) => const EditNote(),
          "photo": (context) => const Photo(),

          'Settings': (context) => ChangeNotifierProvider(
              create: (BuildContext context) => SettingsController(),
              child: SettingsPage(title: "Chrono 8 Pool")),
        },
        localizationsDelegates: [
          AppLocale.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("fr", ""),
          Locale("en", ""),
        ],
        localeResolutionCallback: (currentLang, supportLang) {
          if (currentLang != null) {
            for (Locale locale in supportLang) {
              if (locale.languageCode == currentLang.languageCode) {
                return currentLang;
              }
            }
          }
          return supportLang.first;
        },
      ),
    );
  }
}
