import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_sample/dataModel.dart';

class DataModel {
  int? id;
  String? name;
  String? age;
  String? school;
  String? standerd;
  DataModel(
      {this.id,
      required this.name,
      required this.age,
      required this.school,
      required this.standerd});
  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        school: json['school'],
        standerd: json['standerd'],
      );
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        "school": school,
        'standerd': standerd,
      };
}
