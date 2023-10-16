class GymModel {
  final int id;
  final String gymName;
  final String imgUrl;
  final String bio;
  final String mobileNumber;

  GymModel({
    required this.id,
    required this.gymName,
    required this.imgUrl,
    required this.bio,
    required this.mobileNumber,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gymName': gymName,
      'imgUrl': imgUrl,
      'bio': bio,
      'mobileNumber': mobileNumber,
    };
  }

  factory GymModel.fromMap(Map<String, dynamic> map) {
    return GymModel(
      id: map['id'],
      gymName: map['gymName'],
      bio: map['bio'],
      imgUrl: map['imgUrl'],
      mobileNumber: map['mobileNumber'],
    );
  }
}