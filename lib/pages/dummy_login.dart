import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_circle/global/global_variables.dart';
import 'package:study_circle/http/http_client.dart';
import 'package:study_circle/pages/home_screen.dart';
import 'package:study_circle/repository/user_repository.dart';

class DummyLoginScreen extends StatefulWidget {
  const DummyLoginScreen({super.key});

  @override
  State<DummyLoginScreen> createState() => _DummyLoginScreenState();
}

class _DummyLoginScreenState extends State<DummyLoginScreen> {
  final _textEditingController = TextEditingController();

  void _initaizeApp() {
    final userNumber = _textEditingController.text;

    if (userNumber.isEmpty) {
      Fluttertoast.showToast(msg: "Username should not be empty");
    }

    UserRepository.fetchUser(userNumber)
        .then((String userId) {
          httpService = HttpService(
            headers: {"content-type": "application/json", "X-USER-ID": userId},
          );

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        })
        .onError((_, __) {
          Fluttertoast.showToast(msg: "Unable to fetch user");
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
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
            Spacer(),
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff424547)),
                borderRadius: BorderRadius.circular(24),
                color: Color(0xff2e2e2e),
              ),
              child: TextField(
                autofocus: true,
                controller: _textEditingController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                maxLines: null,
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _textEditingController.text.isEmpty
                          ? Color(0xff292929)
                          : Color(0xff0266DA),
                ),
                onPressed:
                    _textEditingController.text.isNotEmpty
                        ? _initaizeApp
                        : () {},
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color:
                          _textEditingController.text.isNotEmpty
                              ? Colors.white
                              : Color(0xff848484),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
