import 'package:flutter_bank/classes/services/bank.dart';
import 'package:flutter_bank/classes/transaction.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionService {
  final String apiUrl =
      "http://localhost:3000/transactions"; // URL do json-server

  Future<List<Transaction>> fetchAll() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Transaction.fromJson(data)).toList();
    } else {
      throw Exception('Erro ao carregar transações');
    }
  }

  Future<Transaction> create(Transaction transaction) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(transaction.toJson()),
    );
    if (response.statusCode == 201) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao criar transação');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar transação');
    }
  }

  Future<Transaction> update(int id, Transaction transaction) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(transaction.toJson()),
    );
    if (response.statusCode == 200) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao atualizar transação');
    }
  }
}
