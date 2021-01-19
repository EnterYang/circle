import 'package:cached_network_image/cached_network_image.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/provider/contacts_view_model.dart';
import 'package:circle/ui/pages/contacts/widget/contact_list_item_view.dart';
import 'package:circle/ui/pages/personal/personal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:circle/core/extension/navigator_extension.dart';

class FollowingUsersListPage extends StatefulWidget {
  @override
  _FollowingUsersListPageState createState() => _FollowingUsersListPageState();
}

class _FollowingUsersListPageState extends State<FollowingUsersListPage> {
  EasyRefreshController _refreshController = EasyRefreshController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      slivers: <Widget>[
        _buildSilverList(context)
      ],
      controller: _refreshController,
      onRefresh: () async {
        _refreshController.finishLoad();
        return context.read<ContactsViewModel>().refreshFollowingsData();
      },
      onLoad: () async {
        _refreshController.finishRefresh();
        return context.read<ContactsViewModel>().loadFollowingsMoreData();
      },
      firstRefresh: true,
      firstRefreshWidget: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: SizedBox(
              height: 200.0,
              width: 300.0,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      height: 50.0,
                      child: SpinKitFadingCube(
                        color: Theme.of(context).primaryColor,
                        size: 25.0,
                      ),
                    ),
                    Container(
                      child: Text('正在加载'),
                    )
                  ],
                ),
              ),
            )),
      ),
//      header: BezierCircleHeader(),
//      footer: BezierBounceFooter(),
    );
  }

  Widget _buildSilverList(BuildContext context) {
    return Selector<ContactsViewModel, List<User>>(
      selector: (ctx, contactsVM) {
        return contactsVM.followingsList;
      },
      shouldRebuild: (prev, next) => context.read<ContactsViewModel>().shouldRefreshFollowings,
      //!ListEquality().equals(prev.feedsList, next.feedsList),
      builder: (ctx, feedList, child) {
        context.read<ContactsViewModel>().rebuildedFollowings();
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Selector<ContactsViewModel, User>(
                selector: (ctx, contactsVM) => contactsVM.followingsList[index],
                shouldRebuild: (prev, next) => true,
                builder: (ctx, user, child) {
                  return Container(
                    child: ContactListItemView(user: user,
                    onTap: (){
                      NavigatorExt.pushToPage(context,CIRPersonalPage(user: user));
                    },
                    ),
                  );
                }
            );
          },
            childCount: context.read<ContactsViewModel>().followingsTotal,
          ),
        );
      },
    );
  }
}
