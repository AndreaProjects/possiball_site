import 'package:flutter/material.dart';
import 'package:possiball_site/screens/dashboard.dart';
import 'package:possiball_site/utils/custompagetransitions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Center(
        child: SizedBox(
          width: 700,
          child: child,
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        cardColor: Colors.grey,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            cursorColor: Theme.of(context).scaffoldBackgroundColor,
            decoration: InputDecoration(
              fillColor: Theme.of(context).cardColor,
              filled: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            cursorColor: Theme.of(context).scaffoldBackgroundColor,
            decoration: InputDecoration(
              fillColor: Theme.of(context).cardColor,
              filled: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () =>
                Navigator.push(context, RightPageRoute(child: DashBoard())),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.green),
              child: Text("Invia"),
            ),
          ),
        ],
      ),
    );
  }
}
