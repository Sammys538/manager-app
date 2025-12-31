import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_app/screens/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;
    String serverUrl = kIsWeb ? "http://localhost:3000" : "http://10.0.2.2:3000";
    // print("Login pressed: email=$email, password=$password"); FOR DEBUGGING

    if(email.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email or password cannot be empty")),
      );
      return;
    }

    try{
      final endpoint = Uri.parse('$serverUrl/login'); // Change this when testing (changes if using emulator)
      final response = await http.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      // .timeout(const Duration(seconds: 10)); FOR DEBUGGING

      // print("Response code: ${response.statusCode}, body: ${response.body}"); FOR DEBUGGING

      if(response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userEmail = data['user']['email'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', token);
        await prefs.setString('email', userEmail);
        
        if(!mounted){
          return;
        }
          
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if(response.statusCode == 401){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid email or password. Please try again.")),
        );
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed. Please try again.")),
        );
      }  
      } catch(error){
        // print("Login error: $error"); FOR DEBUGGING
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error. Please try again later.")),
        );
      }
    }

    @override
    Widget build(BuildContext context){
      return Scaffold(
        body: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.black, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: login,
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()),
                              );
                            }
                        )
                      ]
                    )
                  )
                ],
              ),
            ),
            ),
        ),
        );
    }
}
