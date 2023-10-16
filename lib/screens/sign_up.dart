import 'package:flutter/material.dart';
import 'package:gyms_in_jordan/services/mock_services.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/user_model.dart';
import '../provider/user_provider.dart';
import '../sql/database_helper.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  late UserProvider userProvider;
  late bool _passwordVisible;

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _passwordVisible = false;
    super.initState();
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  Future<void> signup(BuildContext context) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'users_table',
      {
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'username': _usernameController.text,
        'age': _ageController.text,
        'ingurl': MockServices().user.ingurl,
        'isLoggedIn': 1,
      },
    );
    final results = await db.query(
      'users_table',
      where:
          '${DatabaseHelper.columnemail} = ? AND ${DatabaseHelper.columnpassword} = ?',
      whereArgs: [_emailController.text.trim(), _passwordController.text],
    );

    final user = UserModel(
      id: results[0]['id'] as int,
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      age: _ageController.text,
      gymName: [],
      ingurl: MockServices().user.ingurl,
      isLoggedIn: true,
    );

    userProvider.setUser(user);
    userProvider.user!.gymName.clear();

    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => bottomnavigation(
            index: 2,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  label: const Text('Enter your Email'),
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
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                obscureText: !_passwordVisible,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
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
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  hintText: 'Enter your password',
                  label: const Text('Enter your password'),
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
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  label: const Text('Enter your name'),
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
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _ageController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your age',
                  label: const Text('Enter your age'),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          width: 3, color: Color.fromARGB(255, 106, 187, 218))),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    if (_usernameController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _ageController.text.isEmpty ||
                        _emailController.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Fill all the fields '),
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
                      signup(context);
                      print(
                          '---------------added to the database----------------');
                    }
                  });
                },
                child: const Text('Sign Up'))
          ],
        ),
      ),
    );
  }
}
