import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:possiball_site/firebase_options.dart';
import 'package:possiball_site/screens/dashboard.dart';
import 'package:possiball_site/scripts/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Possiball Plus | Dashboard società',
        debugShowCheckedModeBanner: false,
        builder: (context, child) => Scaffold(
              body: Center(
                child: SizedBox(
                  width: 1000,
                  child: child,
                ),
              ),
            ),
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            primary: Color(0xff275749),
            secondary: Color(0xff275749),
            error: Colors.redAccent,
          ),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            shadowColor: Theme.of(context).primaryColor,
          ),
          timePickerTheme: const TimePickerThemeData(
            backgroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xff275749),
          textTheme: const TextTheme(
            bodySmall: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            bodyLarge: TextStyle(color: Colors.white),
          ),
          cardColor: const Color(0xffEFEFEF).withOpacity(0.5),
          iconTheme: const IconThemeData(color: Colors.white),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18)),
        ),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const DashBoard();
              } else {
                return const Home();
              }
            }));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isObscured = true;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    setState(() {
      _loading = true;
    });
    if (await Login().signInWithEmailAndPassword(email, password, context)) {
      // ignore: use_build_context_synchronously
      Navigator.popUntil(context, (route) => route.isFirst);
    }
    setState(() {
      _loading = false;
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        title: Column(
          children: [
            Image.asset(
              "assets/logo.jpeg",
              width: 80,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Dashboard Società",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 21),
            )
          ],
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 600,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  cursorColor: Theme.of(context).scaffoldBackgroundColor,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci una mail';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).cardColor,
                    filled: true,
                    hintText: 'inserisci email...',
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _passwordController,
                        cursorColor: Theme.of(context).scaffoldBackgroundColor,
                        obscureText: isObscured,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Inserisci una password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).cardColor,
                          filled: true,
                          hintText: 'inserisci password...',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isObscured = !isObscured;
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).cardColor,
                          ),
                          child: isObscured
                              ? const Icon(
                                  Icons.visibility,
                                  size: 21,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.visibility_off,
                                  size: 21,
                                  color: Colors.black,
                                )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => handleSubmit(),
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _loading
                              ? Colors.white.withOpacity(0.3)
                              : Colors.white.withOpacity(0.7)),
                      child: _loading
                          ? const Center(
                              child: SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Text(
                              "Accedi",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
