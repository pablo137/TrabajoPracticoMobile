import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trabajo_practico/pages/login/preferences_page.dart';
import 'package:trabajo_practico/pages/popular_movies/popular_movies_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreferencesPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _signInWithEmailAndPassword();
                  },
                  child: Text('Login'),
                ),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      // Perform login
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Simulated authentication, replace this with your actual authentication logic
      if (email == 'prueba@gmail.com' && password == '123') {
        // Save authentication state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // Check if fingerprint authentication is enabled
        final useFingerprint = prefs.getBool('useFingerprint') ?? false;
        if (useFingerprint) {
          _authenticateWithFingerprint();
        } else {
          // Navigate to home screen or perform desired action
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PopularMoviesPage()),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
      }
    }
  }

  Future<void> _authenticateWithFingerprint() async {
    final localAuth = LocalAuthentication();
    try {
      final isFingerprintAvailable = await localAuth.canCheckBiometrics;
      if (isFingerprintAvailable) {
        final isAuthenticated = await localAuth.authenticate(
          localizedReason: 'Authenticate with fingerprint',
          options: AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          )
        );
        if (isAuthenticated) {
          // Navigate to home screen or perform desired action
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PopularMoviesPage()),
          );
        }
      }
    } catch (e) {
      print('Error authenticating with fingerprint: $e');
    }
  }
}
