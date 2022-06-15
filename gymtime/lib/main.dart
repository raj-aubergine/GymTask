import 'package:flutter/material.dart';
import 'package:gymtime/providers/provider.dart';
import 'package:gymtime/models/exercise.dart';
import 'package:gymtime/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        Provider<Update>(create: (_) => Update()),
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
