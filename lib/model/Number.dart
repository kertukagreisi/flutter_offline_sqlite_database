import 'package:uuid/uuid.dart';

class Number {
  final String id;
  final int number;

  const Number({required this.id, required this.number});

  Map<String, dynamic> toMap() {
    return {'id': id, 'number': number};
  }

  static String getUniqueId() {
    var uuid = const Uuid();

    // Generate a v1 (time-based) id
    return uuid.v1();
  }

  @override
  String toString() {
    return 'Numbers{id: $id, number: $number}';
  }
}
