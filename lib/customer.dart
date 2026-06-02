class Customer {
  const Customer({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  final int? id;
  final String name;
  final String email;
  final String phone;

  Customer copyWith({int? id, String? name, String? email, String? phone}) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'email': email, 'phone': phone};
  }

  factory Customer.fromMap(Map<String, Object?> map) {
    return Customer(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
    );
  }
}
