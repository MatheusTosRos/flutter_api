class Transaction {
  final int? id;
  final String description;
  final double amount;

  Transaction({this.id, required this.description, required this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
    };
  }
}
