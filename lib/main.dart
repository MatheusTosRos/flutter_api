import 'package:flutter/material.dart';
import 'package:flutter_bank/classes/transaction.dart';
import 'package:flutter_bank/service/bank.service.dart';

void main() => runApp(BankingApp());

class BankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação Bancária',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TransactionListScreen(),
    );
  }
}

// Tela de Listagem de Transações
class TransactionListScreen extends StatefulWidget {
  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final TransactionService service = TransactionService();

  Future<void> _refreshList() async {
    setState(() {});
  }

  void _navigateToForm([Transaction? transaction]) async {
    bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionFormScreen(transaction: transaction),
      ),
    );
    if (shouldRefresh == true) {
      _refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transações Bancárias')),
      body: FutureBuilder<List<Transaction>>(
        future: service.fetchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma transação encontrada.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index];
                return ListTile(
                  title: Text(transaction.description),
                  subtitle:
                      Text('R\$ ${transaction.amount.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _navigateToForm(transaction),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await service.delete(transaction.id!);
                          _refreshList();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToForm(),
      ),
    );
  }
}

// Tela de Formulário de Transações
class TransactionFormScreen extends StatefulWidget {
  final Transaction? transaction;
  TransactionFormScreen({this.transaction});

  @override
  _TransactionFormScreenState createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final TransactionService service = TransactionService();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _descriptionController.text = widget.transaction!.description;
      _amountController.text = widget.transaction!.amount.toString();
    }
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final description = _descriptionController.text;
      final amount = double.parse(_amountController.text);

      if (widget.transaction == null) {
        await service
            .create(Transaction(description: description, amount: amount));
      } else {
        await service.update(widget.transaction!.id!,
            Transaction(description: description, amount: amount));
      }

      Navigator.pop(context,
          true); // Retorna true para indicar que a lista precisa ser atualizada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.transaction == null
              ? 'Nova Transação'
              : 'Editar Transação')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe uma descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Informe um valor válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
