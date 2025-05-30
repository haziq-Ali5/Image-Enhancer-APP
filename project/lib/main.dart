import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/job_provider.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/result_screen.dart';
import 'package:project/screens/welcome_screen.dart';
import 'package:project/screens/splash_wraper.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/services/api_service.dart';
import 'package:project/services/storage_service.dart';
import 'package:project/models/job.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:project/screens/login_screen.dart';
import 'package:project/screens/register_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add error handling for Firebase initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
    // Handle error appropriately (e.g., show error UI)
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            AuthService(),
            StorageService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => JobProvider(
            ApiService(StorageService()),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Image Enhancer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashWrapper(), 
      routes: {
        '/welcome': (_) => WelcomeScreen(),
        '/home': (_) => HomeScreen(),
        '/register': (_) => RegisterScreen(),
      '/login': (_) => LoginScreen(),
        '/result': (context) => ResultScreen(
          job: ModalRoute.of(context)!.settings.arguments as ProcessingJob,
        ),
      },
    );
  }
}