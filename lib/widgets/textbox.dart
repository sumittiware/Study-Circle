// Type Widget
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study_circle/models/room.dart';

class TypeWidget extends StatefulWidget {
  final Room room;
  final TextEditingController textEditingController;

  final Function() refreshChat;

  const TypeWidget({
    super.key,
    required this.room,
    required this.textEditingController,
    required this.refreshChat,
  });

  @override
  State<TypeWidget> createState() => _TypeWidgetState();
}

class _TypeWidgetState extends State<TypeWidget> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),

      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff424547)),
        borderRadius: BorderRadius.circular(24),
        color: Color(0xff2e2e2e),
      ),
      child: Row(
        children:
            enabled ? _buildEnabledTextField() : _buildDisabledtextField(),
      ),
    );
  }

  List<Widget> _buildEnabledTextField() {
    return [
      Expanded(
        child: TextField(
          autofocus: true,
          controller: widget.textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          maxLines: null,
        ),
      ),
      InkWell(
        onTap: widget.refreshChat,
        child: SvgPicture.asset(
          "assest/images/send.svg",
          height: 32,
          width: 32,
        ),
      ),
    ];
  }

  List<Widget> _buildDisabledtextField() {
    return [
      GestureDetector(
        onTap: () {
          setState(() {
            enabled = true;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "Type here...",
            style: TextStyle(color: Color(0xff848484), fontSize: 16),
          ),
        ),
      ),
      Spacer(),
      InkWell(
        onTap: () {},
        child: SvgPicture.asset("assest/images/mic.svg", height: 28, width: 28),
      ),
      SizedBox(width: 8),
      InkWell(
        onTap: () {},
        child: SvgPicture.asset(
          "assest/images/camera.svg",
          height: 28,
          width: 28,
        ),
      ),
      SizedBox(width: 8),
      InkWell(
        onTap: () {},
        child: SvgPicture.asset(
          "assest/images/send.svg",
          height: 32,
          width: 32,
        ),
      ),
    ];
  }
}
