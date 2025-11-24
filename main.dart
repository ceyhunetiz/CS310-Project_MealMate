//Ceyhun Etiz


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'dart:convert'; 
import 'mainmenu.dart';
import 'signUp.dart';

void main() {
  runApp(const MainApp());
}

class Usernames {
  String? name; 
  String? email;
  String? password;
  Usernames({required this.name, required this.email, this.password});

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
  };

  factory Usernames.fromJson(Map<String, dynamic> json) {
    return Usernames(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFFB923C),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFFB923C),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const LogIn(),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  List<Usernames> users = [];

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _loadUsers(); 
  }

 
  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersString = prefs.getString('saved_users');
    
    if (usersString != null) {
      final List<dynamic> decodedList = jsonDecode(usersString);
      setState(() {
        users = decodedList.map((item) => Usernames.fromJson(item)).toList();
      });
      print("Loaded ${users.length} users from storage.");
    }
  }

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
                          onPressed: () {
                            String inputEmail = _emailController.text.trim().toLowerCase();
                            
                            String inputPass = _passwordController.text.trim();

                            try {
                              final user = users.firstWhere(
                                (u) => u.email!.toLowerCase() == inputEmail && u.password == inputPass,
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MainMenu(userName: user.name ?? "Unknown")));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Invalid Email or Password"), backgroundColor: Colors.red)
                              );
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Signup(users: users)));
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