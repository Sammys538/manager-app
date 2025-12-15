import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';


// TEMP FILE FOR TESTING SORTING FEATURES
// LIST PAGE SHOULD INCLUDE BUTTONS FOR SEARCH AND SORTING
// HAVE EITHER A BACK BUTTON OR X BUTTON

class OfferingsListTest extends StatefulWidget {
  const OfferingsListTest({super.key});

  @override
  State<OfferingsListTest> createState() => _OfferingsListTestState();
}

class _OfferingsListTestState extends State<OfferingsListTest> {
  List offerings = [];
  List filteredOfferings = [];
  bool loading = false;
  TextEditingController searchController = TextEditingController();
  bool sortByNameAsc = true;

  @override
  void initState() {
    super.initState();
    fetchOfferings();
  }

  Future<void> fetchOfferings() async {
    setState(() => loading = true);
    try {
      final data = await APIService.getOfferings(); // should return List<dynamic>

      // Default sort by date descending
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Offerings Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search by Name",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterByName,
            ),
            const SizedBox(height: 10),
            // Sorting buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // default: sort by date descending
                    setState(() {
                      filteredOfferings.sort((a, b) => DateTime.parse(b['offering_date'])
                          .compareTo(DateTime.parse(a['offering_date'])));
                    });
                  },
                  icon: const Icon(Icons.date_range),
                  label: const Text("Sort by Date"),
                ),
                ElevatedButton.icon(
                  onPressed: sortByName,
                  icon: const Icon(Icons.sort_by_alpha),
                  label: const Text("Sort by Name"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Offerings list
            loading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: filteredOfferings.isEmpty
                        ? const Center(child: Text("No offerings found"))
                        : ListView.builder(
                            itemCount: filteredOfferings.length,
                            itemBuilder: (context, index) {
                              final item = filteredOfferings[index];
                              final date = DateTime.tryParse(item['offering_date']) ??
                                  DateTime.now();
                              final formattedDate =
                                  DateFormat('yyyy-MM-dd').format(date);
                              return ListTile(
                                title: Text(item['member_name'] ?? ""),
                                subtitle: Text(
                                    "Amount: ${item['amount']}\nDate: $formattedDate"),
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
