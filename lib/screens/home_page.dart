import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../models/gym_model.dart';
import '../sql/database_helper.dart';
import 'gym_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<GymModel> dataList = [];
  Future<void> deleteDb() async {
    final db = DatabaseHelper();
    db.deleteGymsDB();
  }

  Future<void> getGyms() async {
    final db = await DatabaseHelper.instance.database;

    await db.insert('gym', {
      DatabaseHelper.columnGymId: 1,
      DatabaseHelper.columngymName: 'Golds Gym',
      DatabaseHelper.columngymImgurl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9cylJEKZM1Lv-qIk_4LZRdWTEa89oWm0YYg&usqp=CAU',
      DatabaseHelper.columngymBio: 'Most famous gym in the word',
      DatabaseHelper.columnmobileNumber: '064001222'
    });
    await db.insert('gym', {
      DatabaseHelper.columnGymId: 2,
      DatabaseHelper.columngymName: 'Glory Gym',
      DatabaseHelper.columngymImgurl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-TXJI-S_k4XP5LubBuNILepBDHpyakPDxjQ&usqp=CAU",
      DatabaseHelper.columngymBio:
          'Amazing gym to get in shape \n located in amman tabarbour',
      DatabaseHelper.columnmobileNumber: '00962792929333'
    });
    await db.insert('gym', {
      DatabaseHelper.columnGymId: 3,
      DatabaseHelper.columngymName: 'Vega Gym',
      DatabaseHelper.columngymImgurl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwGxaSe3b_9s6n039TSSGGW9DEiwd2RHfkdw&usqp=CAU",
      DatabaseHelper.columngymBio: 'open 24/7',
      DatabaseHelper.columnmobileNumber: '00962791811395'
    });
    await db.insert('gym', {
      DatabaseHelper.columnGymId: 4,
      DatabaseHelper.columngymName: 'FitnessOne Gym',
      DatabaseHelper.columngymImgurl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9AvGD0bd9y3clSNSyaLQY3-aoQRrv_YwdVA&usqp=CAU",
      DatabaseHelper.columngymBio: 'We got the best group classes in town',
      DatabaseHelper.columnmobileNumber: '00962791097028'
    });

    final results = await db.query('gym');

    setState(() {
      for (var i = 0; i < results.length; i++) {
        int id = results[i]['id'] as int;
        String gymName = results[i][DatabaseHelper.columngymName] as String;
        String bio = results[i][DatabaseHelper.columngymBio] as String;
        String mobileNumber =
            results[i][DatabaseHelper.columnmobileNumber] as String;
        String imgurl = results[i][DatabaseHelper.columngymImgurl] as String;
        final gym = GymModel(
            id: id,
            gymName: gymName,
            imgUrl: imgurl,
            bio: bio,
            mobileNumber: mobileNumber);
        dataList.add(gym);
      }
    });
  }

  double _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
    deleteDb();

    getGyms();

    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Gyms in Jordan"),
      ),
      body: SafeArea(
        // ignore: sized_box_for_whitespace
        child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final gym = dataList.elementAt(index);

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => gymDetails(
                                      gym: gym,
                                    )));
                      },
                      child: SizedBox(
                        height: 100,
                        width: 250,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(50)),
                              height: 250,
                              width: 250,
                              child: Image(image: NetworkImage(gym.imgUrl)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              gym.gymName,
                              style: const TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: dataList.length,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 70),
                child: DotsIndicator(
                  onTap: (index) {
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  },
                  dotsCount: 4,
                  position: _currentPage.round(),
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
          ),
        ),
      ),
    );
  }
}
