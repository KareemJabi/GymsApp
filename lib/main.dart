import 'package:flutter/material.dart';
import 'package:gyms_in_jordan/provider/user_provider.dart';
import 'package:gyms_in_jordan/screens/check_in.dart';
import 'package:gyms_in_jordan/screens/home_page.dart';
import 'package:gyms_in_jordan/screens/profile.dart';
import 'package:gyms_in_jordan/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => UserProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      )),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const splashScreen(),
        '/home': (context) => const Home(),
      },
    );
  }
}

// ignore: camel_case_types, must_be_immutable
class bottomnavigation extends StatefulWidget {
  int index;

  bottomnavigation({super.key, required this.index});

  @override
  State<bottomnavigation> createState() =>
      // ignore: no_logic_in_create_state
      _bottomnavigationState(t_index: index);
}

// ignore: camel_case_types
class _bottomnavigationState extends State<bottomnavigation> {
  // ignore: non_constant_identifier_names
  int t_index;
  // ignore: non_constant_identifier_names
  _bottomnavigationState({required this.t_index});

  // ignore: non_constant_identifier_names
  List Screens = [const Home(), QrImage(), const Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35.0),
          topRight: Radius.circular(35.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedIconTheme: const IconThemeData(
            color: Colors.deepOrangeAccent,
            size: 25.0,
          ),
          selectedIconTheme: const IconThemeData(
            color: Colors.greenAccent,
            size: 45,
          ),
          selectedFontSize: 16.0,
          unselectedFontSize: 12.0,
          currentIndex: t_index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.screen_search_desktop_rounded,
              ),
              label: "Discover",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.qr_code_scanner_rounded,
                ),
                label: "Check In"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile"),
          ],
          onTap: (index) {
            setState(() {
              t_index = index;
            });
          },
        ),
      ),
      body: Screens[t_index],
    );
  }
}
