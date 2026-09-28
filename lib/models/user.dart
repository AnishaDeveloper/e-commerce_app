class Name {
  final String firstname;
  final String lastname;

  Name({required this.firstname, required this.lastname});

  factory Name.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Name(firstname: '', lastname: '');
    return Name(
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'firstname': firstname,
    'lastname': lastname,
  };

  String get fullName => '$firstname $lastname'.trim();
}

class Address {
  final String city;
  final String street;
  final int number;
  final String zipcode;

  Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Address(city: '', street: '', number: 0, zipcode: '');
    return Address(
      city: json['city'] as String? ?? '',
      street: json['street'] as String? ?? '',
      number: (json['number'] as num?)?.toInt() ?? 0,
      zipcode: json['zipcode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'street': street,
    'number': number,
    'zipcode': zipcode,
  };

  String get fullAddress => '$number $street, $city ($zipcode)'.trim();
}

class User {
  final int id;
  final String email;
  final String username;
  final String password;
  final Name name;
  final String phone;
  final Address address;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      name: Name.fromJson(json['name'] as Map<String, dynamic>?),
      phone: json['phone'] as String? ?? '',
      address: Address.fromJson(json['address'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    'password': password,
    'name': name.toJson(),
    'phone': phone,
    'address': address.toJson(),
  };

  User copyWith({
    int? id,
    String? email,
    String? username,
    String? password,
    Name? name,
    String? phone,
    Address? address,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
