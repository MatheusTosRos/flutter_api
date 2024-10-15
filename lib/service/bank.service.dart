import 'package:flutter_bank/classes/services/bank.dart';
import 'package:flutter_bank/classes/transaction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionService implements ApiService<Transaction> {
  final String apiUrl =
      "https://jsonplaceholder.typicode.com/posts"; // Exemplo de URL

  @override
  Future<List<Transaction>> fetchAll() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Transaction.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  @override
  Future<Transaction> fetchById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load transaction');
    }
  }

  @override
  Future<Transaction> create(Transaction transaction) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(transaction.toJson()),
    );
    if (response.statusCode == 201) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create transaction');
    }
  }

  @override
  Future<Transaction> update(int id, Transaction transaction) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(transaction.toJson()),
    );
    if (response.statusCode == 200) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update transaction');
    }
  }

  @override
  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction');
    }
  }
}
