class UserModel {
  int id;
  String username;
  String age;
  String ingurl;

  List<String> gymName;
  String email;
  String password;

  bool isLoggedIn;
  UserModel({
    required this.id,
    required this.password,
    required this.email,
    required this.age,
    required this.ingurl,
    required this.username,
    // required this.gymName,
    required this.gymName,
    required this.isLoggedIn,
    // required List gymNames,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'age': age,
      'ingurl': ingurl,
      'gymName': gymName.join(','),
      'email': email,
      'password': password,
      'isLoggedIn': isLoggedIn ? 1 : 0,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      age: map['age'],
      ingurl: map['imgurl'],
      gymName: (map['gymName'] as String).split(','),
      email: map['email'],
      password: map['password'],
      isLoggedIn: map['isLoggedIn'] == 1,
    );
  }
}
