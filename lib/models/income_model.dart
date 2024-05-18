import 'package:hive_flutter/adapters.dart';

part 'income_model.g.dart';

@HiveType(typeId: 1)
class IncomeModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String uid;

  @HiveField(2)
  late double amount;

  @HiveField(4)
  late String description;

  @HiveField(5)
  late DateTime createdAt;

  IncomeModel({
    required this.id,
    required this.uid,
    required this.amount,
    required this.description,
    required this.createdAt,
  });
}
