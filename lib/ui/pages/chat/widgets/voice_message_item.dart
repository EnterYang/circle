import 'package:circle/core/services/size_fit.dart';
import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

class VoiceMessageItem extends StatelessWidget {
  final Direction direction;
  final EMVoiceMessageBody messageBody;

  const VoiceMessageItem({Key key, this.direction, this.messageBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CIRSizeFit.screenWidth * 0.8 * (messageBody.getVoiceDuration()/60),
      padding: EdgeInsets.all(5.px),
      constraints: BoxConstraints(
        minWidth: 55.px
      ),
      child: Row(
        mainAxisAlignment: direction == Direction.SEND ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Text('${messageBody.getVoiceDuration()}″'),
        ],
      ),
    );
  }
}
