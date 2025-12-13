// import 'package:flutter/material.dart';
import 'package:manager_app/screens/login.dart';
// import 'package:manager_app/screens/offerings_list.dart';
// import 'package:manager_app/screens/offerings_screens.dart';
// import 'package:manager_app/screens/sign_up.dart';
// import 'package:manager_app/screens/transaction_list.dart';
import 'screens/home_screen.dart';
// import 'screens/add_transaction.dart';
// import 'screens/sign_up.dart';

// void main() {
//   runApp(const ManagerApp());
// }

// class ManagerApp extends StatelessWidget{
//   const ManagerApp({super.key});
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Church Manager',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
//         useMaterial3: true,
//       ),
//       // home: HomeScreen(),
//       home: Scaffold( 
//         appBar: AppBar(
//           // title: Text("Add Transaction"),
//           ),
//         body: SignUpScreen(),
//       ),
//       );
//   }
// }


//TEMP MAIN FILE USED FOR TESTING
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');
    if (token != null && token.isNotEmpty) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Church Manager App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
