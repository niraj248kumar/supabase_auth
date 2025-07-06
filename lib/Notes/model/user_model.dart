class UserModel {
  final int? id;
  final String? name;
  final String? description;
  final int? price;

  UserModel({this.id, this.name, this.description, this.price});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
    );
  }
}
