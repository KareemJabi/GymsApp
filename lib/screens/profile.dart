import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

import '../provider/user_provider.dart';
import '../sql/database_helper.dart';
import 'log_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserProvider userProvider;

  bool isLoading = true;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        isLoading = false;
      });
    });
    userProvider = Provider.of<UserProvider>(context, listen: false);

    getusersAndgyms();
    super.initState();
  }

  List<String> gyms = [];
  Future<void> getusersAndgyms() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT ${DatabaseHelper.table}.*, users_gyms.gym_id
    FROM ${DatabaseHelper.table}
    LEFT JOIN users_gyms ON ${DatabaseHelper.table}.${DatabaseHelper.columnId} = users_gyms.user_id
    WHERE ${DatabaseHelper.table}.${DatabaseHelper.columnId} =?;
  ''', [userProvider.user!.id]);
    List<int> userIds = [];
    setState(() {
      for (Map<String, dynamic> row in result) {
        int gymsID = row['gym_id'];

        userIds.add(gymsID);
        if (gymsID == 1) {
          gyms.add('Golds Gym');
        } else if (gymsID == 2) {
          gyms.add('Glory Gym');
        } else if (gymsID == 3) {
          gyms.add('Vega Gym');
        } else {
          gyms.add('FitnessOne Gym');
        }
      }
    });
    print(userIds);
  }

  Future<void> logOut(int userId, int value) async {
    final db = await DatabaseHelper.instance.database;
    final data = <String, dynamic>{
      DatabaseHelper.columnisLogedIn: value,
    };
    final whereClause = '${DatabaseHelper.columnId} = ?';
    final whereArgs = [userId];
    await db.update(DatabaseHelper.table, data,
        where: whereClause, whereArgs: whereArgs);
  }

  Future<void> updateUserName(int userId, String newvalue) async {
    final db = await DatabaseHelper.instance.database;
    final data = <String, dynamic>{
      DatabaseHelper.columnName: newvalue,
    };
    final whereClause = '${DatabaseHelper.columnId} = ?';
    final whereArgs = [userId];
    await db.update(DatabaseHelper.table, data,
        where: whereClause, whereArgs: whereArgs);
  }

  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print('-------------------im here');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: userProvider.user!.isLoggedIn
            ? Text(userProvider.user!.username)
            : const Text('Welcome '),
        centerTitle: true,
      ),
      body: LogedIn(),
    );
  }

  // ignore: non_constant_identifier_names
  Widget LogedIn() {
    if (userProvider.user!.isLoggedIn == false) {
      print('--------------------test');
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Center(
            child: Text(
              'Please LogIn to access this Page',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 70,
            width: 140,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogIn(),
                      ));
                },
                child: const Text(
                  'LogIn',
                  style: TextStyle(fontSize: 17),
                )),
          ),
        ],
      );
    } else {
      return isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.blueGrey,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: const BorderRadius.all(Radius.zero)),
                      child: Image(
                        image: NetworkImage(
                          userProvider.user!.ingurl,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Full Name: ",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(userProvider.user!.username,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Gym: ",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Builder(
                            builder: (context) {
                              if (gyms.isEmpty) {
                                return const Text(
                                  'No Gym subscribed  yet',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                );
                              } else if (gyms.length == 1) {
                                return Text(
                                  gyms[0],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                return Text(
                                  '$gyms',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Age: ",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(userProvider.user!.age,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 120,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content:
                                      const Text('Log out of your account? '),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          userProvider.updateLogging(false);
                                          logOut(userProvider.user!.id, 0);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    bottomnavigation(index: 2),
                                              ));
                                        },
                                        child: const Text(
                                          'Log Out',
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: const Text('Cancel'))
                                  ],
                                );
                              });
                        },
                        child: const Text('Log Out')),
                  ),
                ],
              ),
            );
    }
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Enter your new name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  updateUserName(userProvider.user!.id, nameController.text);
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
