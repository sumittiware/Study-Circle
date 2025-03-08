import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study_circle/models/room.dart';
import 'package:study_circle/pages/rooms_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,

        body: Padding(
          padding: EdgeInsets.only(top: mediaQuery.padding.top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Study Groups",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Tabs
              TabBar(
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: EdgeInsets.symmetric(horizontal: 8),
                dividerColor: Color(0xff2e2e2e),
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "Plus Jakarta Sans",
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  color: Color(0xff2e2e2e),
                  fontSize: 14,
                  fontFamily: "Plus Jakarta Sans",
                ),
                tabs: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("My Groups"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Other Rooms"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("My Peers"),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    GroupsListView(),
                    GroupsListView(),
                    GroupsListView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupsListView extends StatelessWidget {
  const GroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(rooms.length, (i) => GroupWidget(room: rooms[i])),
    );
  }
}

class GroupWidget extends StatelessWidget {
  final Room room;
  const GroupWidget({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return RoomScreen(room: room);
              },
            ),
          );
        },
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            SvgPicture.asset(
              "assest/images/card_${room.id}.svg",
              width: double.infinity,
              height: 160,
            ),
            Positioned(
              right: 24,
              height: 120,
              child: Image.asset("assest/images/group_${room.id}.png"),
            ),
          ],
        ),
      ),
    );
  }
}
