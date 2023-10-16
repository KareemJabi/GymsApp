import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../provider/user_provider.dart';
import '../sql/database_helper.dart';
import 'log_in.dart';

class QrImage extends StatefulWidget {
  @override
  State<QrImage> createState() => _QrImageState();
}

class _QrImageState extends State<QrImage> {
  bool isLoading = true;
  final PageController _pageController = PageController(initialPage: 0);
  double currentPage = 0;
  late UserProvider userProvider;

  List<String> gyms = [];

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        isLoading = false;
      });
    });
    userProvider = Provider.of<UserProvider>(context, listen: false);

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });

    getusersAndgyms();

    super.initState();
  }

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
        int gymsId = row['gym_id'];

        userIds.add(gymsId);
        if (gymsId == 1) {
          userProvider.updateGymName('Golds Gym');
          gyms.add('Golds Gym');
        } else if (gymsId == 2) {
          userProvider.updateGymName('Glory Gym');
          gyms.add('Glory Gym');
        } else if (gymsId == 3) {
          userProvider.updateGymName('Vega Gym');
          gyms.add('Vega Gym');
        } else {
          userProvider.updateGymName('FitnessOne Gym');
          gyms.add('FitnessOne Gym');
        }
      }
    });
    print(userIds);
    print('---------------------Gyms');
    print(gyms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Check In'),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          if (userProvider.user!.isLoggedIn == false) {
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
                : exist();
          }
        },
      ),
    );
  }

  Widget exist() {
    if (gyms.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 15,
          ),
          const Center(
            child: Text(
              'Please subscribe with a gym to \n access this page',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 70,
            width: 140,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
                child: const Text(
                  'Discover Gyms',
                  style: TextStyle(fontSize: 17),
                )),
          ),
        ],
      );
    } else if (gyms.length == 1) {
      return Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              gyms[0],
              style: const TextStyle(color: Colors.blue, fontSize: 25),
            ),
          ),
          Center(
            child: QrImageView(
              data: "",
              size: 300,
              version: QrVersions.auto,
              gapless: false,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Builder(
            builder: (context) {
              if (gyms[0] == 'Golds Gym') {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total capicity now:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '25',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ],
                );
              } else if (gyms[0] == 'Vega Gym') {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total capicity now:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '15',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ],
                );
              } else if (gyms[0] == 'Glory Gym') {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total capicity now:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '11',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ],
                );
              } else {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total capicity now:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '17',
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ],
                );
              }
            },
          )
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (index) {
                currentPage = index.toDouble();
              },
              controller: _pageController,
              itemCount: gyms.length,
              itemBuilder: (context, pageIndex) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        gyms[pageIndex],
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 25),
                      ),
                    ),
                    Center(
                      child: QrImageView(
                        data: "",
                        size: 300,
                        version: QrVersions.auto,
                        gapless: false,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Builder(
                      builder: (context) {
                        if (gyms[pageIndex] == 'Golds Gym') {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total capicity now:',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '25',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.blue),
                              ),
                            ],
                          );
                        } else if (gyms[pageIndex] == 'Vega Gym') {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total capicity now:',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '15',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.blue),
                              ),
                            ],
                          );
                        } else if (gyms[pageIndex] == 'Glory Gym') {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total capicity now:',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '11',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.blue),
                              ),
                            ],
                          );
                        } else {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total capicity now:',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '17',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.blue),
                              ),
                            ],
                          );
                        }
                      },
                    )
                  ],
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: DotsIndicator(
              onTap: (index) {
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              },
              dotsCount: gyms.length,
              position: currentPage.round(),
              decorator: const DotsDecorator(
                color: Colors.grey,
                activeColor: Colors.blue,
                spacing: EdgeInsets.all(4),
                activeSize: Size(18, 9),
                size: Size(9, 9),
              ),
            ),
          ),
        ],
      );
    }
  }
}
