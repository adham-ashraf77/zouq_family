import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function onClick;

  const AppButton({this.text, this.onClick});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: GestureDetector(
        onTap: () {
          // pushPage(context, ResetPasswordPage());
          this.onClick();
        },
        child: Container(
          color: Color.fromRGBO(29, 174, 240, 100),
          width: MediaQuery.of(context).size.width * 0.73,
          height: 45,
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
