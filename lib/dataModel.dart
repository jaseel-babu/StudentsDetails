class DataModel {
  int? id;
  String? name;
  String? age;
  String? school;
  String? standerd;

  DataModel({
    this.id,
    required this.name,
    required this.age,
    required this.school,
    required this.standerd,
  });
  factory DataModel.fromMap(Map<String, dynamic> jas) => DataModel(
        id: jas['id'],
        name: jas['name'],
        age: jas['age'],
        school: jas['school'],
        standerd: jas['standerd'],
      );
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        "school": school,
        'standerd': standerd,
      };
}
