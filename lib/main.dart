import 'package:flutter/material.dart';
import 'package:mission_app/methods/colors.dart';
import 'package:provider/provider.dart';
import '../screens/main_screen.dart';
import '../methods/provider.dart';

void main() {
  runApp(const MissionApp());
  {}
}

class MissionApp extends StatelessWidget {
  const MissionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Services(),
      child: MaterialApp(
        home: const MainScreen(),
        theme: ThemeData(
            useMaterial3: true,
            textTheme:
                Theme.of(context).textTheme.apply(bodyColor: kWhiteColor)),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
