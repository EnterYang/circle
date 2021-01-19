import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

typedef onPressedCallback = void Function();

class ContactListItemView extends StatelessWidget {
  final User user;
  final onPressedCallback onTap;

  const ContactListItemView({@required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Theme.of(context).backgroundColor)),
      ),
      height: 55.px,
      child: InkWell(
        onTap: (){
          onTap();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 38.px,
              height: 38.px,
              margin: EdgeInsets.only(left: Constant.mainMargin),
              child: user.avatar == null ? CircleAvatar(child: Icon(Icons.account_circle)) : ClipOval(child: CachedNetworkImage(imageUrl:user.avatar.url)),
            ),
            SizedBox(width: 8.px,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(user.name, style: Theme.of(context).textTheme.bodyText1,),
                  if(user.bio != null) ...[SizedBox(height: 3.px), Text(user.bio, style: Theme.of(context).textTheme.bodyText2.copyWith(color: CIRAppTheme.lightGreyTextColor), overflow: TextOverflow.ellipsis,)],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
