import 'package:flutter/material.dart';

void main() {
  runApp(const ICMSProApp());
}

class ICMSProApp extends StatelessWidget {
  const ICMSProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remove a faixa de debug
      title: 'ICMS Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ICMS Pro"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Bem-vindo ao aplicativo ICMS Pro!",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
