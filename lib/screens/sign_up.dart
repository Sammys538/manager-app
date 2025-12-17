import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  void signUp() async {
    final email = emailController.text;
    final password = passwordController.text;

    if(email.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email or Password cannot be empty")),
      );
      return;
    }


    try {
      final endpoint = Uri.parse('http://localhost:3000/signup'); //Change this when testing(mainly change for emulator)
      final response = await http.post(
        endpoint,
        headers: {'Content-Type' : 'application/json'},
        body: jsonEncode({'email': email, 'password': password})
      );

      if(response.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign Up Sucessful")),
        );

        await Future.delayed(const Duration(seconds: 1));

        if(!mounted) return;
        Navigator.pop(context);
      } else if(response.statusCode == 401){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid email or password. Please try again."))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign Up failed. Please try again."))
        );
      }
    } catch (error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server Error. Please try again later."))
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
                      "Sign Up",
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPassController,
                    decoration: const InputDecoration(labelText: "Confirm Password"),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(

                    onPressed: () {
                      final password = passwordController.text;
                      final confirm = confirmPassController.text;

                      if(password != confirm){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Passwords do not match")),
                        );
                        return;
                      }
                      signUp();
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ),
            ),
        ),
        );
    }
}