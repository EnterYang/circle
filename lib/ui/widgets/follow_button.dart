import 'package:circle/ui/shared/app_theme.dart';
import 'package:flutter/material.dart';

typedef onActionButtonPressedCallback = void Function();

class FollowButton extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color borderColor;
  final onActionButtonPressedCallback onFollowButtonPressed;

  const FollowButton({this.title = '+ 关注', this.textColor = CIRAppTheme.mainTitleTextColor, this.borderColor = CIRAppTheme.mainTitleTextColor, this.onFollowButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: FractionalOffset.centerRight,
        child: GestureDetector(
          child: Container(
            padding: new EdgeInsets.only(
                top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor),
              borderRadius: new BorderRadius.circular(12.0),
            ),
            child: Text(
              title,
              style: TextStyle(color: textColor, fontSize: 12),
            ),
          ),
          onTap: (){
            if (onFollowButtonPressed != null) {
              onFollowButtonPressed();
            }
          },
        ));
  }
}
