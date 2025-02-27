// import 'package:firebase_core/firebase_core.dart';
// import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lora_business_1/src/auth/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // OpenAI.apiKey = dotenv.env['OPENAI_API_KEY']!;

  await initializeDateFormatting('es_ES', null);
  if (kIsWeb) {
    await Firebase.initializeApp(
      name: 'Lora Business',
      options: FirebaseOptions(
          apiKey: dotenv.env['FIREBASE_API_KEY']!,
          authDomain: "lora-business-flutter.firebaseapp.com",
          projectId: "lora-business-flutter",
          storageBucket: "lora-business-flutter.appspot.com",
          messagingSenderId: "808698891072",
          appId: "1:808698891072:web:84bdab878781b80ae688a5",
          measurementId: "G-850EY7L4ZD"),
    );
  }
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lora Business',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
