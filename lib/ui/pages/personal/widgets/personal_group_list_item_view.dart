import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/ui/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

typedef onPressedCallback = void Function();

class PersonalGroupListItemView extends StatelessWidget {
  final Group group;
  final onPressedCallback onTap;

  const PersonalGroupListItemView({@required this.group, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.px,
      color: Colors.white,
      child: InkWell(
        onTap: (){
          onTap();
        },
        child: Row(
          children: <Widget>[
            Container(
              width: 36.px,
              height: 36.px,
              margin: EdgeInsets.only(left: Constant.mainMargin),
              child: group.avatar == null ? CircleAvatar(child: Icon(Icons.account_circle)) : ClipOval(child: CachedNetworkImage(imageUrl:group.avatar.url)),
            ),
            SizedBox(width: 8.px,),
            Text(group.name, style: Theme.of(context).textTheme.bodyText2,),
          ],
        ),
      ),
    );
  }
}
