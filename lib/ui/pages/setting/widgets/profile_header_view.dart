import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileHeaderView extends StatelessWidget {
  final VoidCallback onTapContent;

  ProfileHeaderView({this.onTapContent});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapContent,
      child: Container(
        color: Colors.white,
        height: 100.px,
        child: Row(
          children: <Widget>[
            Selector<UserViewModel, Avatar>(
                selector: (context, userVM) => userVM.avatar,
                shouldRebuild: (prev, next) {
                  return prev != next;
                },
                builder: (context, avatar, child) {
                  return Container(
                      width: 60.px,
                      height: 60.px,
                      margin: EdgeInsets.only(left: 10.px),
                      child:ClipOval(child: avatar == null ? Icon(Icons.account_circle) : CachedNetworkImage(imageUrl:avatar.url)),
                    );
                }),
            SizedBox(width: 7.px,),
            Selector<UserViewModel, String>(
                selector: (context, userVM) => userVM.name,
                shouldRebuild: (prev, next) {
                  return prev != next;
                },
                builder: (context, name, child) {
                  return Text(
                    name,
                    style: Theme.of(context).textTheme.bodyText2,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
