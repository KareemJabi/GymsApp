import '../models/user_model.dart';

class MockServices {
  UserModel user = UserModel(
    id: 0,
    email: 'kareemaljabi@gmail.com',
    password: '123456789',
    age: '23',
    ingurl:
        'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg',
    username: 'Kareem AlJabi ',
    gymName: [],
    isLoggedIn: false,
  );
}
