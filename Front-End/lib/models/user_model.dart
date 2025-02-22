class User {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String city;
  final String profileImage;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.city,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final results = json['results'][0];
    final name = results['name'];
    return User(
      id: results['login']['uuid'],
      fullName: '${name['first']} ${name['last']}',
      email: results['email'],
      phone: results['phone'],
      city: results['location']['city'],
      profileImage: results['picture']['large'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'city': city,
      'profileImage': profileImage,
    };
  }
}