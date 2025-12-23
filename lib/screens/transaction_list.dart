//TEMPORARY UI TEST

// ADD CHANGES SIMILAR TO OFFERINGS LIST
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String? selectSort = "newest";

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() => loading = true);
    try {
      final data = await APIService.getTransactions();

      data.sort((a, b) => DateTime.parse(b['transaction_date'])
          .compareTo(DateTime.parse(a['transaction_date'])));

      setState(() {
        transactions = data;
        filteredTransactions = List.from(transactions);
      });
    } catch(error){
      print("Error fetching transactions: $error");
    }

    setState(() => loading = false);
  }

  void sortbyDate(String? value){
    setState((){
      selectSort = value;
      filteredTransactions.sort((a,b) {
        return value == "newest"
          ? DateTime.parse(b['transaction_date'])
            .compareTo(DateTime.parse(a['transaction_date']))
          : DateTime.parse(a['transaction_date'])
            .compareTo(DateTime.parse(b['transaction_date']));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction List")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        
        child: Column(
          children: [
            // TextField(
            //   controller: searchController,
            //   decoration: const InputDecoration(
            //     labelText: "Search",
            //     prefixIcon: Icon(Icons.search),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Order by: "
                ),
                DropdownButton(
                  value: selectSort,
                  items: const [
                  DropdownMenuItem(value: "newest", child: Text("Newest")),
                  DropdownMenuItem(value: "oldest", child: Text("Oldest")),
                  ],
                onChanged: (value) {
                  sortbyDate(value);
                }
                ),
              ],
            ),


            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  final item = filteredTransactions[index];
                  final date = DateTime.tryParse(item['transaction_date']) ??
                      DateTime.now();
                  final formattedDate = DateFormat('yyyy-MM-dd').format(date);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(item['transaction_type'] ?? ""),
                      subtitle: Text("${item['category']}\nDate: $formattedDate"),
                      trailing: Text("\$${item['transaction_amount'] ?? 0}"),
                    ),
                  );
                },
                ),
            ),
          ],
        )
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("Transactions Test")),
  //     body: FutureBuilder<List<dynamic>>(
  //       future: APIService.getTransactions(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text("Error: ${snapshot.error}"));
  //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //           return Center(child: Text("No transactions yet"));
  //         }

  //         final transactions = snapshot.data!;
  //         return ListView.builder(
  //           itemCount: transactions.length,
  //           itemBuilder: (context, index) {
  //             final t = transactions[index];
  //             return ListTile(
  //               title: Text("${t['transaction_type']} - ${t['category']}"),
  //               subtitle: Text("${t['transaction_desc']}"),
  //               trailing: Text("\$${t['transaction_amount']}"),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
}