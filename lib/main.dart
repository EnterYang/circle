import 'package:circle/core/provider/conversation_view_model.dart';
import 'package:circle/core/provider/groups_posts_view_model.dart';
import 'package:circle/core/provider/mine_view_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/provider/chat_view_model.dart';
import 'core/provider/contacts_view_model.dart';
import 'core/provider/feed_follow_view_model.dart';
import 'core/provider/feed_recommend_view_model.dart';
import 'core/provider/group_recommend_view_model.dart';
import 'core/router/router.dart';
import 'core/services/size_fit.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => UserViewModel()),
          ChangeNotifierProxyProvider<UserViewModel, ConversationViewModel>(
            create: (ctx) => ConversationViewModel(),
            update: (ctx, userVM, conversationVM) {
              conversationVM.updateUserInfo(userVM);
              return conversationVM;
            },
          ),
          ChangeNotifierProxyProvider<UserViewModel, ChatViewModel>(
            create: (ctx) => ChatViewModel(),
            update: (ctx, userVM, chatVM) {
              chatVM.updateUserInfo(userVM);
              return chatVM;
            },
          ),
          ChangeNotifierProxyProvider<UserViewModel, MineViewModel>(
            create: (ctx) => MineViewModel(),
            update: (ctx, userVM, mineVM) {
              mineVM.updateUserInfo(userVM);
              return mineVM;
            },
          ),
          ChangeNotifierProxyProvider<UserViewModel, ContactsViewModel>(
            create: (ctx) => ContactsViewModel(),
            update: (ctx, userVM, contactsVM) {
              contactsVM.updateUserInfo(userVM);
              return contactsVM;
            },
          ),
          ChangeNotifierProvider(create: (ctx) => FeedRecommendViewModel()),
          ChangeNotifierProvider(create: (ctx) => FeedFollowViewModel()),
          ChangeNotifierProvider(create: (ctx) => GroupRecommendViewModel()),
          ChangeNotifierProvider(create: (ctx) => GroupsPostsViewModel()),
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CIRSizeFit.initialize();
    return MaterialApp(
      title: 'Circle',
      // 主题
      theme: CIRAppTheme.norTheme,
      darkTheme: CIRAppTheme.darkTheme,
      // 路由
      initialRoute: CIRRouter.initialRoute,
      routes: CIRRouter.routes,
      onGenerateRoute: CIRRouter.generateRoute,
      onUnknownRoute: CIRRouter.unknownRoute,
    );
  }
}