import 'package:flutter/material.dart';
import 'package:flutter_bank/classes/transaction.dart';
import 'package:flutter_bank/service/bank.service.dart';

class TransactionForm extends StatefulWidget {
  final Function onSubmit;
  TransactionForm({required this.onSubmit});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  double _amount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Descrição da Transação'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma descrição';
              }
              return null;
            },
            onSaved: (value) {
              _description = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Valor'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || double.tryParse(value) == null) {
                return 'Por favor, insira um valor numérico';
              }
              return null;
            },
            onSaved: (value) {
              _amount = double.parse(value!);
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(
                    Transaction(description: _description, amount: _amount));
              }
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
