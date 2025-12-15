// import 'package:flutter/material.dart';

// class TransactionList extends StatelessWidget {
//   const TransactionList({super.key});

//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(

//     );
//   }
// }


//TEMPORARY UI TEST

// ADD CHANGES SIMILAR TO OFFERINGS LIST
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TransactionListTest extends StatelessWidget {
  const TransactionListTest({super.key});

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