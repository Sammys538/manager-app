import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  AddTransactionFormState createState() => AddTransactionFormState();
}

  class AddTransactionFormState extends State<AddTransaction>{
    String? selectedType = "Income";
    String? selectedCategory = "Tithes";
    TextEditingController amountController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();


  Future<void> submitTransaction() async{
    Map<String, dynamic> data = {
      "transaction_type": selectedType,
      "category": selectedCategory,
      "transaction_amount" : double.tryParse(amountController.text) ?? 0,
      "transaction_desc": descriptionController.text,
      "admin_id": 1,
    };

    bool success = await APIService.addTransaction(data);

    if(success) {
      // getBack();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transaction added successfully")),
      );

      Navigator.pop(context, true);
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add transaction")),
       );
    }

  }

  void navigateTo(Widget screen){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
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
                            "Add Transaction",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 24),

                        const Text("Type:"),
                        DropdownButton<String>(
                          value: selectedType,
                          items: ["Income", "Expense"]
                              .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        const Text("Amount:"),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        const Text("Category:"),
                        DropdownButton<String>(
                          value: selectedCategory,
                          items: [
                            "Tithes",
                            "Offrend",
                            "Services",
                            "Missionary",
                            "Pro Temple",
                            "Electricity",
                            "Gas",
                            "Water",
                            "Internet",
                            "Office Supplies",
                            "Cleaning Supplies"
                          ]
                              .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        const Text("Description:"),
                        TextField(
                          controller: descriptionController,
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
                              child: ElevatedButton(
                                onPressed: submitTransaction,
                                child: const Text("Save"),
                              ),
                            ),
                          ],
                        ),
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
              child: IconButton(icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
        ),
    );
  }
  }