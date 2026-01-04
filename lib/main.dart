import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'signUp.dart';
import 'mainmenu.dart';
import 'profile_cookbook_screen.dart';
import 'ingredients_page.dart';
import 'meal_mode_screen.dart';
import 'emirc_shopping_cart_screen.dart';
import 'find_recipe_method_screen.dart';
import 'upload_recipe_screen.dart';
import 'my_uploads_screen.dart';
import 'saved_recipes_screen.dart';
import 'shopping_history_screen.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';

import 'utils/app_colors.dart';
import 'utils/app_text_styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    Firebase.app();
  } catch (e) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBuxBQsSwkTK2bXAZWGq6Qg-NYNgb7FcNo",
        appId: "1:87213483758:ios:e65b88a4e03ecf5570b5ff",
        messagingSenderId: "87213483758",
        projectId: "mealmate-410b7",
      ),
    );
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
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          fontFamily: 'Poppins',
        ),

        initialRoute: '/',
        routes: {
          '/': (context) => const Wrapper(),
          '/signup': (context) => const Signup(),
          '/home': (context) {
            final user = Provider.of<User?>(context);
            final name = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
            return HomeScreen(userName: name);
          },
          '/mainmenu': (context) {
            final user = Provider.of<User?>(context);
            final name = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
            return MainMenu(userName: name);
          },
          '/profile': (context) => const ProfileCookbookScreen(),
          '/ingredients': (context) => const IngredientsPage(),
          '/mealMode': (context) => const MealModeScreen(),
          '/shoppingCart': (context) => const EmirCShoppingCartScreen(),
          '/randomRecipe': (context) => const FindRecipeMethodScreen(),
          '/upload': (context) => const UploadRecipeScreen(),
          '/myUploads': (context) => const MyUploadsScreen(),
          '/savedRecipes': (context) => const SavedRecipesScreen(),
          '/shoppingHistory': (context) => const ShoppingHistoryScreen(),
        },
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
      final name = user.displayName ?? user.email!.split('@')[0];
      return HomeScreen(userName: name);
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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('last_login_email');
    if (savedEmail != null && savedEmail.isNotEmpty && mounted) {
      _emailController.text = savedEmail;
    }
  }

  Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_login_email', email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 40),

              RichText(
                text: TextSpan(
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 38),
                  children: [
                    TextSpan(
                      text: 'Meal ',
                      style: AppTextStyles.heading.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: 'Mate',
                      style: AppTextStyles.heading.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration('Email address'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Email required' : null,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscured,
                      decoration: _inputDecoration(
                        'Password',
                        suffix: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Password required' : null,
                    ),

                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _handleLogin,
                        child: Text(
                          'Log In',
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        final email = _emailController.text.trim();
        await context.read<AuthService>().signIn(
              email,
              _passwordController.text.trim(),
            );
        await _saveEmail(email);
      } on FirebaseAuthException {
        setState(() {
          _errorMessage = 'Incorrect email or password';
        });
      }
    }
  }
}