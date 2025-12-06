import 'dart:convert';
import 'package:http/http.dart' as http;


class APIService{
  static const String serverUrl = "http://localhost:3000";

  static Future<List<dynamic>> getTransaction() async{
  final response = await http.get(Uri.parse("$serverUrl/transactions"));
  if (response.statusCode == 200){
    return jsonDecode(response.body);
  } else{
    throw Exception("Failed to fetch transactions");
  }
}

static Future<bool> addTransaction(Map<String, dynamic> data) async{
  final response = await http.post(
    Uri.parse("$serverUrl/transactions"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(data),
  );

  print("Response code: ${response.statusCode}, body: ${response.body}"); // DEBUG

  return response.statusCode == 201;
}
}

