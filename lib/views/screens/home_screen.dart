import 'package:flutter/material.dart';

import '../../constants.dart';
import '../widgets/add_video_icon.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

}


class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        backgroundColor: black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: green,
        unselectedItemColor: gray,
        currentIndex: pageIdx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30,),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30,),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: AddVideoIcon(),
            label: "Upload",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 30,),
            label: "Inbox",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30,),
            label: "Profile",
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }

}