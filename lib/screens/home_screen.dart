// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:manager_app/widgets/line_chart_sample.dart';


// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   HomeScreenState createState() => HomeScreenState();
// }


// class HomeScreenState extends State<HomeScreen>{

//   @override
//   Widget build(BuildContext context) {

    
//     // These are just placeholders for the values
//     double balance = 22500.00;
//     double totalIncome = 3000.00;
//     double totalExpenses = 2500.00;


//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text(
//                 "Dashboard",
//                 style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
              
              
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(child: buildBox("Balance: \$$balance")),
//                   Expanded(child: buildBox("Income: \$$totalIncome")),
//                   Expanded(child: buildBox("Expenses: \$$totalExpenses")),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Expanded(child: 
//                   LineChartSample2()
//                   ),
//                   Expanded(child: Text("Big Box 2")),
//                 ],
//               ),
//             ],
//           ),
//           ),
//           bottomNavigationBar: BottomNavigationBar(
//             items: [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

//             BottomNavigationBarItem(
//               icon: Icon(Icons.list), 
//               label:"Transactions"), 
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//            ]
        
//         ),
//       ),
//     );
//   }
  
  
//   Widget buildBox(String text, {double height = 80}){
//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//         // color: color,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white.withOpacity(.1),
//             blurRadius: 2,
//             // offset: const Offset(2, 2)
//           ),
//         ],
//       ),
      
//       alignment: Alignment.center,
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Colors.black,
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//         )
//       )
//     );
//   }
  
// }

// PAGE SHOULD INCLUDE BALANCE, INCOME, and EXPENSES
// CHART SHOULD ALSO HAVE THE REAL DATA
// INCLUDE ICONS + for positive, - for negative
// INCLUDE ADD TRANSACTION/OFFERING BUTTONS
// ALSO INCLUDE BOXES TO LOOK AT LISTS FOR EACH THING

//TEMP HOME SCREEN USED FOR TESTING JSONWEBTOKENS
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manager_app/screens/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? email;

  @override
  void initState() {
    super.initState();
    loadUserEmail();
  }

  Future<void> loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    await prefs.remove('email');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Center(
        child: Text(
          email != null ? "Welcome, $email!" : "Loading...",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
