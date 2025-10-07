import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myapp_1/screens/new.dart';
import '../models/expense.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box<Expense> get box => ExpenseDbHive.box;

  void _addExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditScreen()),
    );
    if (result != null && result is Expense) await box.add(result);
  }

  void _editExpense(dynamic key, Expense expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditScreen(expense: expense)),
    );
    if (result != null && result is Expense) await box.put(key, result);
  }

  void _deleteExpense(dynamic key) async {
    await box.delete(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('متتبع المصروفات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async => await box.clear(),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Expense> box, _) {
          final expenses = box.values.toList().reversed.toList();
          if (expenses.isEmpty) {
            return const Center(child: Text('لا توجد مصروفات بعد'));
          }

          final total = expenses.fold<int>(
              0, (sum, expense) => sum + expense.amount);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'إجمالي المصروفات: $total ر.س',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final key = box.keyAt(index);
                    return ListTile(
                      title: Text(expense.category),
                      subtitle: Text(
                          '${expense.note} - ${DateFormat('yyyy-MM-dd').format(expense.date)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editExpense(key, expense),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteExpense(key),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}
