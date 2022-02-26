import 'package:advance_10_13_14_12/helpers/firebase_auth_helper.dart';
import 'package:advance_10_13_14_12/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      // home: const MyApp(),
      routes: {
        '/': (context) => const MyApp(),
        'dashboard': (context) => const DashBoard(),
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailLoginController = TextEditingController();
  final TextEditingController _passwordLoginController =
      TextEditingController();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase App"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton.extended(
              heroTag: null,
              label: const Text("Login Anonymously"),
              icon: const Icon(Icons.people),
              onPressed: () async {
                User? user =
                    await FirebaseAuthHelper.authHelper.loginAnonymously();
                print("Login Successfully\nUID: ${user!.uid}");
                Navigator.of(context)
                    .pushReplacementNamed('dashboard', arguments: user);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Login Successfully\nUID: ${user.uid}"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton.extended(
                  heroTag: null,
                  label: const Text("Register"),
                  icon: const Icon(Icons.settings),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Center(
                          child: Text("Register User"),
                        ),
                        content: Form(
                          key: _registerFormKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  onSaved: (val) {
                                    setState(() {
                                      email = val!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Email"),
                                    hintText: "Enter your email",
                                  ),
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  onSaved: (val) {
                                    setState(() {
                                      password = val!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Password"),
                                    hintText: "Enter your Password",
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      child: const Text("Register"),
                                      onPressed: () async {
                                        if (_registerFormKey.currentState!
                                            .validate()) {
                                          _registerFormKey.currentState!.save();
                                          print(email);
                                          print(password);

                                          try {
                                            User? user = await FirebaseAuthHelper
                                                .authHelper
                                                .registerUserWithEmailAndPassword(
                                                    email, password);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Register Successfully\nEmail: ${user!.email}\nUID: ${user.uid}"),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            Navigator.pop(context, true);
                                          } on FirebaseAuthException catch (e) {
                                            switch (e.code) {
                                              case 'weak-password':
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Enter at least 6 char long password"),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );
                                                Navigator.pop(context, true);
                                                break;
                                              case 'email-already-in-use':
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "This email id is already in use"),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );
                                                Navigator.pop(context, true);
                                                break;
                                            }
                                          }

                                          _emailController.clear();
                                          _passwordController.clear();
                                          setState(() {
                                            email = '';
                                            password = '';
                                          });
                                        }
                                      },
                                    ),
                                    OutlinedButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                        _emailController.clear();
                                        _passwordController.clear();
                                        setState(() {
                                          email = '';
                                          password = '';
                                        });
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    // String uid =
                    //     await FirebaseAuthHelper.authHelper.loginAnonymously();
                    // print("Login Successfully\nUID: $uid");
                    // Navigator.of(context).pushReplacementNamed('dashboard');
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text("Login Successfully\nUID: $uid"),
                    //     backgroundColor: Colors.green,
                    //   ),
                    // );
                  },
                ),
                FloatingActionButton.extended(
                  heroTag: null,
                  label: const Text("Login"),
                  icon: const Icon(Icons.security),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Center(
                          child: Text("Login User"),
                        ),
                        content: Form(
                          key: _loginFormKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: _emailLoginController,
                                  onSaved: (val) {
                                    setState(() {
                                      email = val!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Email"),
                                    hintText: "Enter your email",
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _passwordLoginController,
                                  obscureText: true,
                                  onSaved: (val) {
                                    setState(() {
                                      password = val!;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    label: Text("Password"),
                                    hintText: "Enter your Password",
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      child: const Text("Login"),
                                      onPressed: () async {
                                        if (_loginFormKey.currentState!
                                            .validate()) {
                                          _loginFormKey.currentState!.save();

                                          print(email);
                                          print(password);

                                          try {
                                            User? user = await FirebaseAuthHelper
                                                .authHelper
                                                .loginUserWithEmailAndPassword(
                                                    email, password);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Login Successfully\nEmail: ${user!.email}\nUID: ${user.uid}"),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            // Navigator.of(context).pop;
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    "dashboard",
                                                    arguments: user);
                                          } on FirebaseAuthException catch (e) {
                                            switch (e.code) {
                                              case 'user-not-found':
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "User not found with this email id"),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );
                                                Navigator.of(context).pop();
                                                break;
                                              case 'wrong-password':
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Invalid Credentials..."),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );
                                                break;
                                            }
                                          }
                                          _emailLoginController.clear();
                                          _passwordLoginController.clear();
                                          setState(() {
                                            email = '';
                                            password = '';
                                          });
                                        }
                                      },
                                    ),
                                    OutlinedButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                        _emailLoginController.clear();
                                        _passwordLoginController.clear();
                                        setState(() {
                                          email = '';
                                          password = '';
                                        });
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    // String uid =
                    //     await FirebaseAuthHelper.authHelper.loginAnonymously();
                    // print("Login Successfully\nUID: $uid");
                    // Navigator.of(context).pushReplacementNamed('dashboard');
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text("Login Successfully\nUID: $uid"),
                    //     backgroundColor: Colors.green,
                    //   ),
                    // );
                  },
                ),
              ],
            ),
            FloatingActionButton.extended(
              heroTag: null,
              label: const Text("Login with Google"),
              icon: const Icon(Icons.add),
              onPressed: () async {
                User? user =
                    await FirebaseAuthHelper.authHelper.signInWithGoogle();

                print(
                    "Login Successfully\nEMAIL: ${user!.email}\nUID: ${user.uid}");

                Navigator.of(context)
                    .pushReplacementNamed('dashboard', arguments: user);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Login Successfully\nEMAIL: ${user.email}\nUID: ${user.uid}"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
