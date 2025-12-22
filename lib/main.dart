// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'mainmenu.dart';
import 'signUp.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBuxBQsSwkTK2bXAZWGq6Qg-NYNgb7FcNo", 
        appId: "1:87213483758:ios:e65b88a4e03ecf5570b5ff", 
        messagingSenderId: "87213483758", 
        projectId: "mealmate-410b7",
      ),
    );
    print("✅ Firebase Initialized Successfully!");
  } catch (e) {
    print("❌ Firebase Failed: $e");
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xFFFB923C),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFFFB923C),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        home: const Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    
    if (user == null) {
      return const LogIn();
    } else {
      
      String nameToShow = user.displayName ?? user.email!.split('@')[0];
      
      return MainMenu(userName: nameToShow);
    }
  }
}
class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isObscured = true;
  String? _errorMessage; // Stores the error text to display

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- LOGO ---
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(fontSize: 40),
                    children: const [
                      TextSpan(
                        text: 'Meal',
                        style: TextStyle(
                          color: Color(0xFFFB923C),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Poppins'
                        ),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: 'Mate',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Poppins'
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email address',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFFFB923C)),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Email cannot be empty";
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscured,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
                              color: Colors.grey[400]
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Color(0xFFFB923C)),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Password required';
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text("Forgot password?", style: TextStyle(color: Color(0xFFFB923C))),
                        ),
                      ),
                      
                      // --- ERROR MESSAGE AREA ---
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red, 
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      // --------------------------

                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFB923C),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 0,
                          ),
                          // --- IMPROVED LOGIC ---
                          onPressed: () async {
                            // 1. Hide Keyboard so user can see the error
                            FocusScope.of(context).unfocus();

                            // 2. Clear previous errors
                            setState(() { _errorMessage = null; });

                            if (_formKey.currentState!.validate()) {
                              try {
                                await context.read<AuthService>().signIn(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                // Wrapper handles navigation if success
                              } on FirebaseAuthException catch (e) {
                                // 3. Debug print to terminal
                                print("LOGIN ERROR: ${e.code}"); 
                                
                                // 4. Show error on screen
                                setState(() {
                                  // 'invalid-credential' is the new standard error for security
                                  if (e.code == 'invalid-credential' || 
                                      e.code == 'user-not-found' || 
                                      e.code == 'wrong-password') {
                                    _errorMessage = "Incorrect email or password.";
                                  } else if (e.code == 'invalid-email') {
                                    _errorMessage = "Invalid email format.";
                                  } else {
                                    _errorMessage = e.message ?? "Login failed.";
                                  }
                                });
                              } catch (e) {
                                setState(() {
                                  _errorMessage = "An unexpected error occurred.";
                                });
                              }
                            }
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("or", style: TextStyle(color: Colors.grey[400])),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                    GestureDetector(
                      onTap: () { 
                        setState(() { _errorMessage = null; });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Signup()));
                      },
                      child: const Text("Sign Up", style: TextStyle(color: Color(0xFFFB923C), fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}