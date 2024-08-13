class User {
  final String name;
  final int age;

  User({required this.name, required this.age});

  User copyWith({String? name, int? age}) {
    return User(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}

void main() {
  // Crear una instancia de User
  User originalUser = User(name: 'Juan', age: 27);

  // Usar copyWith para crear una nueva instancia basada en originalUser
  User updatedUser = originalUser.copyWith(name: 'Pedro', age: 30);
}
