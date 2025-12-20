//TEMPORARY UI TEST

// ADD CHANGES SIMILAR TO OFFERINGS LIST
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TransactionList extends StatefulWidget{
  const TransactionList({super.key});

  @override
  TransactionListState createState() => TransactionListState();
}

class TransactionListState extends State<TransactionList>{
  List transactions = [];
  List filteredTransactions = [];
  bool loading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
  }

  Future<void> fetchTransactions() async {
    setState(() => loading = true);
    try {
      final data = await APIService.getTransactions();

      data.sort((a, b) => DateTime.parse(b['transaction_date'])
          .compareTo(DateTime.parse(a['transaction_date'])));
    } catch(error){
      print("Error fetching transactions: $error");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions Test")),
      body: FutureBuilder<List<dynamic>>(
        future: APIService.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No transactions yet"));
          }

          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
              return ListTile(
                title: Text("${t['transaction_type']} - ${t['category']}"),
                subtitle: Text("${t['transaction_desc']}"),
                trailing: Text("\$${t['transaction_amount']}"),
              );
            },
          );
        },
      ),
    );
  }
}