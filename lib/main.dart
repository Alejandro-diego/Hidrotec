import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hidrotec/screen/login.dart';

import 'package:hidrotec/screen/logo.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'authbloc/authbloc.dart';
import 'models/providerrtdb.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    Provider(
      create: (context) => AuthBloc(),
    ),
    ChangeNotifierProvider(
      create: (_) => ProviderRTDB(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Hidrotec',
      home: AnimatedSplashScreen(
        backgroundColor: Colors.black,
        duration: 3000,
        splash: LogoHidrotec(
          fontSize1: 38,
          fontSize2: 12,
        ),
        nextScreen: const LoginPage1(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  
}


