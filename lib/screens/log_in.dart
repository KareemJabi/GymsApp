import 'package:flutter/material.dart';
import 'package:gyms_in_jordan/screens/sign_up.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../provider/user_provider.dart';
import '../sql/database_helper.dart';

class LogIn extends StatefulWidget {
  // ignore: recursive_getters

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late UserProvider userProvider;
  // ignore: prefer_typing_uninitialized_variables
  late bool _passwordVisible;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  Future<void> _login(BuildContext context) async {
    final db = await DatabaseHelper.instance.database;

    final users = (await db.query(
      'users_table',
      where:
          '${DatabaseHelper.columnemail} = ? AND ${DatabaseHelper.columnpassword} = ?',
      whereArgs: [emailController.text.trim(), passwordController.text],
    ));

    if (users.isNotEmpty) {
      final data = <String, dynamic>{
        DatabaseHelper.columnisLogedIn: 1,
      };
      db.update(DatabaseHelper.table, data,
          where: '${DatabaseHelper.columnId} = ?',
          whereArgs: [users[0]['id'] as int]);
      print(users);
      bool isLoggedIn;
      if (users[0]['isLoggedIn'] == 0) {
        isLoggedIn = false;
      } else {
        isLoggedIn = true;
      }
      String password = users[0]['password'] as String;
      String email = users[0]['email'] as String;
      String username = users[0]['username'] as String;
      String age = users[0]['age'] as String;
      String ingurl = users[0]['ingurl'] as String;

      int id = users[0]['id'] as int;

      final user = UserModel(
        email: email,
        password: password,
        username: username,
        age: age,
        id: id,
        ingurl: ingurl,
        isLoggedIn: isLoggedIn,
        gymName: [],
      );

      userProvider.setUser(user);
      userProvider.updateLogging(true);

      print(
          '-----------------------------user exist in the database-----------------------------');

      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => bottomnavigation(
              index: 2,
            ),
          ));
    } else {
      print(
          '-----------------------------user not exist in the database-----------------------------');
      // ignore: use_build_context_synchronously

      await printAllData();
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Wrong Email or Password '),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Try again',
                      style: TextStyle(color: Colors.blue),
                    ))
              ],
            );
          });
    }
  }

  Future<List> getUser(users) async {
    return List<Map<String, dynamic>>.generate(
        users.length, (index) => Map<String, dynamic>.from(users[index]));
  }

  Future<void> printAllData() async {
    final db = await DatabaseHelper.instance.database;
    ();
    final results = await db.query('users_table');

    for (var row in results) {
      print(row);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Log In'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Enter your Email',
                label: const Text('Email'),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        width: 3, color: Color.fromARGB(255, 106, 187, 218))),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                hintText: 'Enter your Password',
                label: const Text('Password'),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                        width: 3, color: Color.fromARGB(255, 106, 187, 218))),
              ),
              obscureText: !_passwordVisible,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: () async {
                if (emailController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('please enter your email'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Try again',
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ],
                        );
                      });
                } else if (passwordController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('please enter your password'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Try again',
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ],
                        );
                      });
                } else {
                  await _login(context);
                }
              },
              child: const Text('LogIn')),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don`t hava an account? ',
                style: TextStyle(fontSize: 15),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const signup(),
                        ));
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 15, decoration: TextDecoration.underline),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
