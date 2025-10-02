import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/lock_screen.dart';
import 'screens/home_screen.dart';
import 'services/icms_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = IcmsService();
  await service.load();
  runApp(
    ChangeNotifierProvider(
      create: (_) => service,
      child: const IcmsApp(),
    ),
  );
}

class IcmsApp extends StatefulWidget {
  const IcmsApp({super.key});
  @override
  State<IcmsApp> createState() => _IcmsAppState();
}

class _IcmsAppState extends State<IcmsApp> {
  ThemeMode mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICMS Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: mode,
      home: FutureBuilder<bool>(
        future: context.read<IcmsService>().hasPin(),
        builder: (context, snap) {
          if (!snap.hasData) return const SizedBox.shrink();
          if (snap.data == true) {
            return LockScreen(onUnlocked: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => HomeScreen(onToggleTheme: _toggleTheme),
              ));
            });
          } else {
            return HomeScreen(onToggleTheme: _toggleTheme, firstRun: true);
          }
        },
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }
}
