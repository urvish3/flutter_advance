class Data {
  final int id;
  final int age;
  final String name;
  final String? image;

  Data({
    required this.id,
    required this.age,
    required this.name,
    this.image,
  });

  factory Data.fromDB(Map data) {
    return Data(
      id: data['id'],
      name: data['name'],
      age: data['age'],
      image: data['image'],
    );
  }
}
