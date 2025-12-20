// PAGE SHOULD INCLUDE BALANCE, INCOME, and EXPENSES
// CHART SHOULD ALSO HAVE THE REAL DATA
// INCLUDE ICONS + for positive, - for negative
// INCLUDE ADD TRANSACTION/OFFERING BUTTONS
// ALSO INCLUDE BOXES TO LOOK AT LISTS FOR EACH THING
import 'package:flutter/material.dart';
import 'package:manager_app/screens/offerings_list.dart';
import 'package:manager_app/screens/offerings_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manager_app/screens/login.dart';
import '../services/api_service.dart';
import '../models/summary.dart';
import 'package:manager_app/screens/add_transaction.dart';
import 'package:manager_app/screens/transaction_list.dart';
import '../widgets/line_chart_sample.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? email;
  String? token;

  Future<Summary>? summaryFuture;

  List<Map<String, dynamic>> recentTransactions = [];
  List<Map<String, dynamic>> recentOfferings = [];
  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    fetchTransactions();
    fetchOfferings();

  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    token = prefs.getString('jwt');

    if(token != null){
      summaryFuture = APIService.getSummary(token!);
    }

    setState(() {});
  }

  Future<void> fetchTransactions() async {
    try{
      final transactions = await APIService.getTransactions();
      print("Fetched transactions: $transactions");
      setState(() {
        recentTransactions = transactions
          .take(3)
          .map((tx) => tx as Map<String, dynamic>)
          .toList();


        final count = recentTransactions.length;
        chartData = recentTransactions.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> tx = entry.value;

          double amount = 0;
          if (tx['transaction_amount'] != null){
            amount = double.tryParse(tx['transaction_amount'].toString()) ?? 0;
          }

          return FlSpot((count - 1 - index).toDouble(), amount);
        }).toList();

        print("Chart Data: $chartData"); // USED FOR DEBUGGING
        
      });
    } catch (error){
      print("Error fetching transactions: $error");
    }
  }

  Future<void> fetchOfferings() async {
    try{
      final offerings = await APIService.getOfferings();
      print("Fetched offerings: $offerings");
      setState(() {
        recentOfferings = offerings
          .take(3)
          .map((tx) => tx as Map<String, dynamic>)
          .toList();
      });
    } catch (error) {
      print("Error fetching offerings: $error");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    await prefs.remove('email');

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return "${date.month}/${date.day}/${date.year}";
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: summaryFuture == null
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<Summary>(
                future: summaryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading summary"));
                  }

                  final summary = snapshot.data!;

                  return Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
 
                            // Balance Box
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 10,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Balance",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "\$${summary.balance}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            // Income Box
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 10,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Income",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "\$${summary.totalIncome}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            // Expenses Box
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 10,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Expenses",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "\$${summary.expenses}",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            // Transaction Box
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 10,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const AddTransaction()),
                                        );

                                        if(result == true) {
                                          fetchTransactions();
                                        }
                                      },
                                      child: const Text("Add Transaction"),
                                    ),
                                    const SizedBox(height: 8),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: recentTransactions.length,
                                        itemBuilder: (context, index) {
                                          final tx = recentTransactions[index]; // Map<String, dynamic>
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => const TransactionList()),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 4),
                                              child: Text(
                                                "${tx['transaction_type']}: \$${tx['transaction_amount']} (${tx['category']})",
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )




                                  ],
                                ),
                              ),
                            ),

                            
                          ],
                        ),
                      ),

                        // Bottom row: Chart + Offering Box
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                      child: chartData.isEmpty
                                      ? const Center(child: CircularProgressIndicator())
                                      : LineChartSample2(chartData: chartData),
                                  //      Text(
                                  //   "Chart",
                                  //   style: TextStyle(
                                  //       color: Colors.black, fontSize: 16),
                                  // )
                                  ),
                                ),
                              ),


                              // Offering Box
                              Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 10,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const OfferingsScreen()),
                                        );

                                        if(result == true) {
                                          fetchOfferings();
                                        }
                                      },
                                      child: const Text("Add Offering"),
                                    ),
                                    const SizedBox(height: 8),



                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: recentOfferings.length,
                                        itemBuilder: (context, index) {
                                          final tx = recentOfferings[index]; // Map<String, dynamic>
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => const OfferingsListTest()),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 6),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      // Member name
                                                      Text(
                                                        tx['member_name'],
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),

                                                      // Amount (green +)
                                                      Text(
                                                        "+\$${tx['amount']}",
                                                        style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 2),

                                                  // Date (optional but recommended)
                                                  Text(
                                                    formatDate(tx['offering_date']),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )




                                  ],
                                ),
                              ),

                                // child: Container(
                                //   margin: const EdgeInsets.all(4),
                                //   padding: const EdgeInsets.all(16),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(8),
                                //   ),
                                //   child: const Center(
                                //       child: Text(
                                //     "Offering Box",
                                //     style: TextStyle(
                                //         color: Colors.black, fontSize: 16),
                                //   )),
                                // ),
                              ),


                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      );
    }
}
