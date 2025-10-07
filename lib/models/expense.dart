import 'package:hive/hive.dart';

part 'expense.g.dart';

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  int amount;

  @HiveField(2)
  String note;

  @HiveField(3)
  DateTime date;

  Expense({
    required this.category,
    required this.amount,
    required this.note,
    required this.date,
  });
}
