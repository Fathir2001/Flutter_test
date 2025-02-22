class UserModel {
  final String fullName;
  final String city;
  final String email;
  final String phone;
  final String profileImage;

  UserModel({
    required this.fullName,
    required this.city,
    required this.email,
    required this.phone,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: "${json['name']['first']} ${json['name']['last']}",
      city: json['location']['city'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['picture']['large'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'city': city,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
    };
  }
}
