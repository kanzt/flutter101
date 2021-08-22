import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId : 1)
class Person extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String sex;

  Person({this.name, this.age, this.sex});
}