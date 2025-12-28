import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';


class OfferingsList extends StatefulWidget {
  const OfferingsList({super.key});

  @override
  OfferingsListState createState() => OfferingsListState();
}

class OfferingsListState extends State<OfferingsList> {
  List offerings = [];
  List filteredOfferings = [];
  bool loading = false;
  TextEditingController searchController = TextEditingController();
  bool sortByNameAsc = true;
  String? selectSort = "newest";

  @override
  void initState() {
    super.initState();
    fetchOfferings();
  }

  Future<void> fetchOfferings() async {
    setState(() => loading = true);
    try {
      final data = await APIService.getOfferings();

      data.sort((a, b) => DateTime.parse(b['offering_date'])
          .compareTo(DateTime.parse(a['offering_date'])));

      setState(() {
        offerings = data;
        filteredOfferings = List.from(offerings);
      });
    } catch (e) {
      print("Error fetching offerings: $e");
    }
    setState(() => loading = false);
  }

  void filterByName(String name) {
    if (name.isEmpty) {
      setState(() => filteredOfferings = List.from(offerings));
    } else {
      setState(() {
        filteredOfferings = offerings
            .where((o) =>
                o['member_name'].toString().toLowerCase().contains(name.toLowerCase()))
            .toList();
      });
    }
  }

  void sortByName() {
    setState(() {
      filteredOfferings.sort((a, b) {
        final aName = a['member_name'] ?? "";
        final bName = b['member_name'] ?? "";
        return sortByNameAsc
            ? aName.toLowerCase().compareTo(bName.toLowerCase())
            : bName.toLowerCase().compareTo(aName.toLowerCase());
      });
      sortByNameAsc = !sortByNameAsc; // toggle for next press
    });
  }

  void sortbyDate(String? value){
    setState((){
      selectSort = value;
      filteredOfferings.sort((a,b) {
        return value == "newest"
          ? DateTime.parse(b['offering_date'])
            .compareTo(DateTime.parse(a['offering_date']))
          : DateTime.parse(a['offering_date'])
            .compareTo(DateTime.parse(b['offering_date']));
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offering List")),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: 
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: "Search by Name",
                        prefixIcon: Icon(Icons.search),
                        isDense: true,
                      ),
                      onChanged: filterByName,
                    ),
                ), 


                Text("Order by: "),
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
                itemCount: filteredOfferings.length,
                itemBuilder: (context, index) {
                  final item = filteredOfferings[index];
                  final date = DateTime.tryParse(item['offering_date']) ?? DateTime.now();
                  final formattedDate = DateFormat('yyyy-MM-dd').format(date);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(item['member_name'] ?? ""),
                      subtitle: Text("Date: $formattedDate"),
                      trailing: Text("\$${item['amount'] ?? 0}"),
                    )
                  );
                }
              )
            ),
          ]
        )
      )
    );
  }
}
