import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gymtime/providers/provider.dart';
import 'package:gymtime/models/exercise.dart';
import 'package:gymtime/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Flag>(create: (_) => Flag()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.black,
            secondary: Colors.grey,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
