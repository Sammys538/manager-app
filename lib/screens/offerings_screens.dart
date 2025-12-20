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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

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

  void getBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text(
                            "Add Offering",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text("Member Name"),
                        TextField(controller: nameController),
                        const SizedBox(height: 24),
                        const Text("Amount"),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: pickDate,
                          child: Text(formatDate(selectedDate)),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: getBack,
                                child: const Text("Cancel"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: submitOfferings,
                                child: const Text("Save"),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Go back arrow, top left
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}