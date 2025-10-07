import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp_1/models/expense.dart';

class ExpenseDbHive {
  static const String boxName = 'expensesBox';
  static late Box<Expense> _box;

  static Future<void> initDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseAdapter());
    _box = await Hive.openBox<Expense>(boxName);
  }

  static Box<Expense> get box => _box;

  static Future<void> addExpense(Expense model) async {
    await _box.add(model);
  }

  static Future<void> updateExpense(int key, Expense model) async {
    await _box.put(key, model);
  }

  static Future<void> deleteExpense(int key) async {
    await _box.delete(key);
  }

  static Future<void> clearAllExpenses() async {
    await _box.clear();
  }

  static List<Expense> getAllExpenses() {
    final expenses = _box.values.toList();
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses;
  }
}
