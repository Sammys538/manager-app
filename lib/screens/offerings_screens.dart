import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

// SAME AS TRANSACTION, MAKE THE THING REFRESH WHEN SUBMITTED
// STYLIZE FOR BETTER FRONTEND AND UI

class OfferingsScreen extends StatefulWidget {
  const OfferingsScreen({super.key});

  @override
  OfferingsScreenFormState createState() => OfferingsScreenFormState();
}

class OfferingsScreenFormState extends State<OfferingsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  DateTime? selectedDate; // New variable for user-input date

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

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> submitOfferings() async {
    final memberName = nameController.text;
    final amount = double.tryParse(amountController.text) ?? 0;

    if (memberName.isEmpty || amount <= 0 || selectedDate == null) {
      print("Invalid input or missing date");
      return;
    }

    Map<String, dynamic> data = {
      "member_name": memberName,
      "amount": amount,
      "admin_id": 1, // temp value for testing
      "offering_date": selectedDate!.toIso8601String(), // Send date in ISO format
    };

    final success = await APIService.addOfferings(data);

    if (success) {
      print("Offering added!");
      nameController.clear();
      amountController.clear();
      setState(() => selectedDate = null);
      fetchOfferings(); // refresh list
    } else {
      print("Failed to add offering");
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Select Date";
    return DateFormat('yyyy-MM-dd').format(date);
  }

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
            // Date picker button
            ElevatedButton(
              onPressed: pickDate,
              child: Text(formatDate(selectedDate)),
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
                                    "Amount: ${item["amount"]}\nDate: ${item["offering_date"] ?? 'N/A'}"),
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