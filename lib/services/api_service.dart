import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' hide Summary;
import 'package:http/http.dart' as http;
import '../models/summary.dart';

class APIService{
  static String get serverUrl {
    if(kIsWeb){
      return "http://localhost:3000";
    } else {
      return "http://10.0.2.2:3000";
    }
  }

  static Future<List<dynamic>> getTransactions() async {
    final response = await http.get(Uri.parse('$serverUrl/transaction'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return json['transactions'] as List<dynamic>;
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

    // print("Response code: ${response.statusCode}, body: ${response.body}"); // FOR DEBUGGING
    print("Response code: ${response.statusCode}");
    print("Response body: ${response.body}");

    return response.statusCode == 201 || response.statusCode == 200;
  }

  // static Future<List> getOfferings() async {
  //   final response = await http.get(Uri.parse("$serverUrl/offerings"));

  //   final body = jsonDecode(response.body);

  //   // Extract the list from the object
  //   return body["offerings"] ?? [];
  // }

  static Future<List<dynamic>> getOfferings() async {
    final response = await http.get(Uri.parse('$serverUrl/offerings'));

    print("Offerings status: ${response.statusCode}");
    print("Offerings body: ${response.body}");

    
    if(response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return json['offerings'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch offerings');
    }
  }


  static Future<bool> addOfferings(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$serverUrl/offerings"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    // print("Response code: ${response.statusCode}, body: ${response.body}"); //DEBUG FOR DEBUGGING

    return response.statusCode == 201;
  }

  static Future<Summary> getSummary(String token) async {
    final response = await http.get(
      Uri.parse("$serverUrl/summary"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      );

      if(response.statusCode == 200) {
        return Summary.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to fetch the Summary");
      }
  }

}

