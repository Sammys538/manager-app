import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OfferingsScreen extends StatefulWidget {
  const OfferingsScreen({super.key});

  @override
  OfferingsScreenFormState createState() => OfferingsScreenFormState();
}

class OfferingsScreenFormState extends State<OfferingsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  List offerings = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchOfferings();
  }

  Future<void> fetchOfferings() async {
    setState(() => loading = true);
    try {
      final data = await APIService.getOfferings();
      setState(() => offerings = data);
    } catch (e) {
      print("Error fetching offerings: $e");
    }
    setState(() => loading = false);
  }

   Future<void> submitOfferings() async {
    final memberName = nameController.text;
    final amount = double.tryParse(amountController.text) ?? 0;

    if (memberName.isEmpty || amount <= 0) {
      print("Invalid input");
      return;
    }

    Map<String, dynamic> data = {
      "member_name": memberName,
      "amount": amount,
      "admin_id": 1, // temp value for testing
    };

    final success = await APIService.addOfferings(data);

    if (success) {
      print("Offering added!");
      nameController.clear();
      amountController.clear();
      fetchOfferings(); // refresh list
    } else {
      print("Failed to add offering");
    }
  }



// Future<void> submitOfferings() async {
//   Map<String, dynamic> data = {
//     "member_name": nameController.text,
//     "amount": double.tryParse(amountController.text) ?? 0,
//     "admin_id": 1,
//   };

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offerings Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Member Name"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: submitOfferings,
              child: const Text("Submit Offering"),
            ),
            const SizedBox(height: 20),
            // Offerings list
            loading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: offerings.isEmpty
                        ? const Center(child: Text("No offerings found"))
                        : ListView.builder(
                            itemCount: offerings.length,
                            itemBuilder: (context, index) {
                              final item = offerings[index];
                              return ListTile(
                                title: Text(item["member_name"] ?? ""),
                                subtitle: Text(
                                    "Amount: ${item["amount"]}\nDate: ${item["offerings_date"]}"),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }


}


//   @override
//   Widget build(BuildContext context){
//     return SingleChildScrollView(

//     );
//   }
// }