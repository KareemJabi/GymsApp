import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../models/gym_model.dart';
import '../provider/user_provider.dart';
import '../sql/database_helper.dart';
import 'log_in.dart';

// ignore: camel_case_types
class gymDetails extends StatefulWidget {
  final GymModel gym;
  const gymDetails({
    super.key,
    required this.gym,
  });

  @override
  State<gymDetails> createState() => _gymDetailsState();
}

class _gymDetailsState extends State<gymDetails> {
  late UserProvider userProvider;

  Future<void> un_subscribe(userId, gymId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('users_gyms',
        where: 'user_id = ? AND gym_id = ?', whereArgs: [userId, gymId]);
  }

  Future<void> subscribe(int userId, int gymId) async {
    final db = await DatabaseHelper.instance.database;
    db.insert('users_gyms', {
      'user_id': userId,
      'gym_id': gymId,
    });
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);

    userProvider.getLogingStatus().then((value) {
      setState(() {});
    });

    getusersAndgyms();

    super.initState();
  }

  List<String> gyms = [];
  Future<void> getusersAndgyms() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT ${DatabaseHelper.table}.*, users_gyms.gym_id
    FROM ${DatabaseHelper.table}
    LEFT JOIN users_gyms ON ${DatabaseHelper.table}.id = users_gyms.user_id
    WHERE ${DatabaseHelper.table}.${DatabaseHelper.columnId} =?; 
  ''', [userProvider.user!.id]);
    List<int> userIds = [];

    setState(() {
      for (Map<String, dynamic> row in result) {
        int userId = row['gym_id'];

        userIds.add(userId);
        if (userId == 1) {
          userProvider.updateGymName('Golds Gym');
          gyms.add('Golds Gym');
        } else if (userId == 2) {
          userProvider.updateGymName('Glory Gym');
          gyms.add('Glory Gym');
        } else if (userId == 3) {
          userProvider.updateGymName('Vega Gym');
          gyms.add('Vega Gym');
        } else {
          userProvider.updateGymName('FitnessOne Gym');
          gyms.add('FitnessOne Gym');
        }
      }
    });
  }

  List<String> newValues = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gym.gymName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(50)),
                child: Image(image: NetworkImage(widget.gym.imgUrl)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                widget.gym.bio,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 1.0,
              color: Colors.blue,
              height: 30.0,
              indent: 15,
              endIndent: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.call,
                  color: Colors.blue,
                  size: 36,
                ),
                Text(
                  widget.gym.mobileNumber,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final Uri url = Uri(
                        scheme: 'tel',
                        path: widget.gym.mobileNumber,
                      );
                      launchUrl(url);
                    },
                    child: const Text('Call'))
              ],
            ),
            const Divider(
              thickness: 1.0,
              color: Colors.blue,
              height: 30.0,
              indent: 15,
              endIndent: 15,
            ),
            const SizedBox(
              height: 8,
            ),
            Builder(
              builder: (context) {
                if (userProvider.user!.isLoggedIn == false) {
                  return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogIn(),
                            ));
                      },
                      child: const Text('LogIn'));
                } else {
                  return Builder(
                    builder: (context) {
                      if (gyms.contains(widget.gym.gymName)) {
                        return ElevatedButton(
                            onPressed: () {
                              userProvider.updateGymName(widget.gym.gymName);

                              un_subscribe(
                                  userProvider.user!.id, widget.gym.id);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        bottomnavigation(index: 2),
                                  ));
                            },
                            child: const Text('Un-Sunscribe'));
                      } else if (gyms.isEmpty ||
                          !userProvider.user!.gymName
                              .contains(widget.gym.gymName)) {
                        return ElevatedButton(
                            onPressed: () async {
                              userProvider.updateGymName(widget.gym.gymName);

                              subscribe(userProvider.user!.id, widget.gym.id);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        bottomnavigation(index: 1),
                                  ));
                            },
                            child: const Text('Subscribe'));
                      }
                      return Container();
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
