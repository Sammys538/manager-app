import 'dart:convert';
import 'package:http/http.dart' as http;


class APIService{
  static const String serverUrl = "http://localhost:3000";

//   static Future<List<dynamic>> getTransactions() async{
//   final response = await http.get(Uri.parse("$serverUrl/transaction"));
//   if (response.statusCode == 200){
//     return jsonDecode(response.body);
//   } else{
//     throw Exception("Failed to fetch transactions");
//   }
// }

static Future<List<dynamic>> getTransactions() async {
  final response = await http.get(Uri.parse('$serverUrl/transaction'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    return json['transactions'] as List<dynamic>; // extract the list
  } else {
    throw Exception('Failed to fetch transactions');
  }
}

static Future<bool> addTransaction(Map<String, dynamic> data) async{
  final response = await http.post(
    Uri.parse("$serverUrl/transaction"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(data),
  );

  print("Response code: ${response.statusCode}, body: ${response.body}"); // DEBUG

  return response.statusCode == 201;
}


// static Future<List<dynamic>> getOfferings() async{
//   final response = await http.get(Uri.parse("$serverUrl/offerings"));
//   if(response.statusCode == 200){
//     return jsonDecode(response.body);
//   } else {
//     throw Exception ("Failed to fetch offerings");
//   }
// }

static Future<List> getOfferings() async {
  final response = await http.get(Uri.parse("$serverUrl/offerings"));

  final body = jsonDecode(response.body);

  // Extract the list from the object
  return body["offerings"] ?? [];
}


static Future<bool> addOfferings(Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse("$serverUrl/offerings"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(data),
  );

  print("Response code: ${response.statusCode}, body: ${response.body}"); //DEBUG

  return response.statusCode == 201;
}

}

