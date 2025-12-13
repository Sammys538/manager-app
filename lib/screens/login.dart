// // import 'package:flutter/material.dart';

// // class LoginScreen extends StatelessWidget {
// //   const LoginScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Log In'), 
// //       ),
// //       body: const Center(
// //         child: Text('Welcome to the Church Manager App!'),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   void login() async {
//     final email = emailController.text;
//     final password = passwordController.text;

//     if(email.isEmpty || password.isEmpty){
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Email and password cannot be empty"))
//       );
//       return;
//     }

//     final url = Uri.parse('http://localhost:3000/login'); // replace with your backend URL
//     final response = await http.post(url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password})
//     );

//     if(response.statusCode == 200){
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Login successful"))
//       );
//       // Navigate to home screen or dashboard here
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${response.body}"))
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: login,
//               child: Text("Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//TEMP LOGIN SCREEN USED FOR TESTING JSONWEBTOKENS
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password cannot be empty")),
      );
      return;
    }

    try {
      final url = Uri.parse('http://localhost:3000/login'); // backend login
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userEmail = data['user']['email'];

        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', token);
        await prefs.setString('email', userEmail);

        // Navigate to HomeScreen
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
