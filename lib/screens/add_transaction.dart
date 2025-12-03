import 'package:flutter/material.dart';

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
    Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 450,
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 16, right:16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Add Transaction",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  ),

                Text("Type:"),
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
                  }),
                
                Text("Amount:"),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                ),
                
                Text("Category:"),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: ["Tithes", "Offrend", "Services", "Missionary", "Pro Temple", "Electricity", "Gas", "Water", "Internet", "Office Supplies", "Cleaning Supplies"]
                        .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                        .toList(),
                  onChanged: (String? value){
                    setState(() {
                      selectedCategory = value;
                    });
                  }),
                
                Text("Description:"),
                TextField(
                  controller: descriptionController,
                ),

                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        getBack();
                      },
                      child: Text("Cancel"),
                  ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        getBack();
                      }, 
                      child: Text("Save")
                      ),
                      ),
                ])

              ],
            ),
          ),
        )
      ),
    );
    }
  }