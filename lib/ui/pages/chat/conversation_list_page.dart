import 'dart:math';
import 'package:circle/core/constant/constant.dart';
import 'package:circle/core/extension/navigator_extension.dart';
import 'package:circle/core/model/chat/create_im_group_param_model.dart';
import 'package:circle/core/provider/chat_view_model.dart';
import 'package:circle/core/provider/conversation_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/pages/chat/chat_page.dart';
import 'package:circle/ui/pages/chat/widgets/conversation_list_item_view.dart';
import 'package:circle/ui/pages/contacts/contacts_page.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/pages/chat/widgets/applet.dart';
import 'package:circle/ui/pages/chat/widgets/avatars.dart';
import 'package:circle/ui/pages/chat/widgets/bouncy_balls.dart';
import 'package:circle/ui/pages/chat/widgets/menus.dart';
import 'package:circle/ui/pages/chat/widgets/mh_app_bar.dart';
import 'package:circle/ui/pages/chat/widgets/mh_list_tile.dart';
import 'package:circle/ui/pages/chat/widgets/search_bar.dart';
import 'package:circle/ui/pages/chat/widgets/search_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:circle/core/extension/double_extension.dart';
import 'package:provider/provider.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

const double _kTabBarHeight = 50.0;

class CIRConversationListPage extends StatefulWidget {
  @override
  _CIRConversationListPageState createState() => _CIRConversationListPageState();
}

class _CIRConversationListPageState extends State<CIRConversationListPage> with AutomaticKeepAliveClientMixin implements EMConnectionListener, EMConversationListItemDelegate {
  String errorText;

  /// 侧滑controller
  SlidableController _slidableController;

  /// 是否展开
  bool _slideIsOpen = false;

  /// 滚动
  ScrollController _controller = ScrollController();

  // 偏移量（导航栏、三个球、小程序）
  double _offset = 0.0;

  /// 下拉临界点
  final double _topDistance = 90.0;

  // 动画时间 0 无动画
  int _duration = 0;

  /// 是否是 刷新状态
  bool _isRefreshing = false;

  /// 是否是 小程序刷新状态
  bool _isAppletRefreshing = false;

  // 是否正在动画过程中
  bool _isAnimating = false;

  // 导航栏背景色
  Color _appBarColor = Colors.grey;

  // 显示菜单
  bool _showMenu = false;

  // 焦点状态
  bool _focusState = false;
  set _focus(bool focus) {
    _focusState = focus;
  }

  // 是否展示搜索页
  bool _showSearch = false;

  ChatViewModel chatViewModel;

  @override
  void initState() {
    super.initState();
    EMClient.getInstance().addConnectionListener(this);
    _slidableController = SlidableController(
      onSlideAnimationChanged: _handleSlideAnimationChanged,
      onSlideIsOpenChanged: _handleSlideIsOpenChanged,
    );
  }

  @override
  void dispose() {
    super.dispose();
    EMClient.getInstance().removeConnectionListener(this);
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    chatViewModel = Provider.of<ChatViewModel>(context);
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('消息', style: Theme.of(context).textTheme.headline1,),
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          InkWell(
            child: Row(
              children: <Widget>[
                Icon(Icons.view_headline, size: 22, color: CIRAppTheme.mainTitleTextColor,),
                Text('联系人', style: TextStyle(fontSize: 16, color: CIRAppTheme.mainTitleTextColor,),),
                SizedBox(width: 8.px,)
              ],
            ),
            onTap: (){
              NavigatorExt.pushToPage(context,ContactsPage());
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          buildConversationListView(context),
        ],
      ),
    );
//    return Scaffold(
//      body: _buildChildWidget(context),
//    );
  }

  // 处理偏移逻辑
  void _handlerOffset(double offset) {
    // 计算
    if (offset <= 0.0) {
      _offset = offset * -1;
    } else if (_offset != 0.0) {
      _offset = 0.0;
    }
    // 这里需要
    if (_isRefreshing && !_isAnimating) {
      // 刷新且非动画状态
      // 正在动画
      _isAnimating = true;
      // 动画时间
      _duration = 300;
      // 最终停留的位置
      _offset = ScreenUtil.screenHeight -
          kToolbarHeight -
          ScreenUtil.statusBarHeight;
      // 隐藏掉底部的TabBar
//      Provider.of<TabBarProvider>(context, listen: false).setHidden(true);
      setState(() {});
      return;
    }

    _duration = 0;
    // 非刷新且非动画状态
    if (!_isAnimating) {
      setState(() {});
    }
  }

  /// 构建子部件
  Widget _buildChildWidget(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: Theme.of(context).backgroundColor,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          // 导航栏
          AnimatedPositioned(
            key: Key('bar'),
            top: _showSearch
                ? (-kToolbarHeight - ScreenUtil.statusBarHeight)
                : _offset,
            left: 0,
            right: 0,
            child: MHAppBar(
              title: Text('消息', style: Theme.of(context).textTheme.headline1,),
              iconTheme: Theme.of(context).iconTheme,
              centerTitle: true,
              backgroundColor: Colors.white,
              actions: <Widget>[
                InkWell(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.view_headline, size: 22, color: CIRAppTheme.mainTitleTextColor,),
                      Text('联系人', style: TextStyle(fontSize: 16, color: CIRAppTheme.mainTitleTextColor,),),
                      SizedBox(width: 8.px,)
                    ],
                  ),
                  onTap: (){
//                    NavigatorExt.pushToPage(context,CIRLogInPage(), fullscreenDialog: true);
                  },
                ),
                /*
                IconButton(
                  icon: Icon(Icons.add),
//                SvgPicture.asset(
//                  Constant.assetsImagesMainframe + 'icons_outlined_add2.svg',
//                  color: Color(0xFF181818),
//                ),
                  onPressed: () {
                    // 关闭上一个侧滑
                    _closeSlidable();
                    _showMenu = !_showMenu;
                    setState(() {});
                  },
                ),
                */
              ],
            ),
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: _duration),
          ),

          // 内容页
          AnimatedPositioned(
            key: Key('list'),
            top: _isRefreshing ? _offset : (_showSearch ? -kToolbarHeight : 0),
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: kToolbarHeight + ScreenUtil.statusBarHeight),
              height: ScreenUtil.screenHeight - _kTabBarHeight,
              child: _buildContentWidget(context),
            ),
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: _duration),
            onEnd: () {
              // 300ms 的动画结束
              _isAnimating = false;
              print('🔥动画结束 < 0--------- $_isAnimating  $_duration');
              if (_duration > 0.0) {
                if (_isAppletRefreshing) {
                  // 上拉
                  _isAppletRefreshing = false;
                  _isRefreshing = false;

                  _appBarColor = Theme.of(context).backgroundColor;

                  // 显示底部的TabBar
//                Provider.of<TabBarProvider>(context, listen: false)
//                    .setHidden(false);
                } else {
                  // 下拉
                  _appBarColor = Colors.white;
                  _isAppletRefreshing = false;
                }
                print('🔥动画结束> 0--------- $_isAnimating');
                setState(() {});
              }
            },
          ),

          // 菜单
          Positioned(
            left: 0,
            right: 0,
            height: ScreenUtil.screenHeight - ScreenUtil.statusBarHeight - kToolbarHeight - _kTabBarHeight,
            top: ScreenUtil.statusBarHeight + kToolbarHeight,
            child: Menus(
              show: _showMenu,
              onCallback: (index) {
                print('index is 👉 $index');
                _showMenu = false;
                if(index == 0){
                  _createGroupChat();
                }
                setState(() {});
              },
            ),
          ),

          // 搜索内容页
          Positioned(
            top: ScreenUtil.statusBarHeight + 56,
            left: 0,
            right: 0,
            height: ScreenUtil.screenHeight - ScreenUtil.statusBarHeight - 56,
            child: Offstage(
              offstage: !_showSearch,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: _duration),
                child: SearchContent(),
                curve: Curves.easeInOut,
                opacity: _showSearch ? 1.0 : .0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建内容部件
  Widget _buildContentWidget(BuildContext context) {
    return Scrollbar(
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            // 正在刷新 do nothing...
            if (_isRefreshing || _isAnimating) {
              return false;
            }
            // offset
            final offset = notification.metrics.pixels;

            if (notification is ScrollStartNotification) {
              if (notification.dragDetails != null) {
                _focus = true;
              }
            } else if (notification is ScrollUpdateNotification) {
              // 能否进入刷新状态
              final bool canRefresh = offset <= 0.0
                  ? (-1 * offset >= _topDistance ? true : false)
                  : false;

              if (_focusState && notification.dragDetails == null) {
                _focus = false;
                // 下拉

                // 手指释放的瞬间
                _isRefreshing = canRefresh;
              }
            } else if (notification is ScrollEndNotification) {
              if (_focusState) {
                _focus = false;
              }
            }
            // 处理
            _handlerOffset(offset);
            return false;
          },
          child: CustomScrollView(
            controller: _controller,
            // Fixed Bug: 让安卓和iOS 都是下拉回弹效果  否则 安卓无法 展示小程序 逻辑
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SearchBar(
                  onEdit: () {
                    print('edit action ....');
                    // 隐藏底部的TabBar
//                  Provider.of<TabBarProvider>(context, listen: false)
//                      .setHidden(true);
                    setState(() {
                      _showSearch = true;
                      _duration = 300;
                    });
                  },
                  onCancel: () {
                    print('cancel action ....');
                    // 显示底部的TabBar
//                  Provider.of<TabBarProvider>(context, listen: false)
//                      .setHidden(false);
                    setState(() {
                      _showSearch = false;
                      _duration = 300;
                    });
                  },
                ),
              ),
              buildConversationListView(context),
            ],
          ),
        ));
  }

  Widget buildConversationListView(BuildContext context){
    return Selector<ConversationViewModel, ConversationViewModel>(
        selector: (ctx, conversationVM) {
          return conversationVM;
        },
        shouldRebuild: (prev, next) {
          return true;
        },
        builder: (ctx, conversationVM, child) {
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Selector<ConversationViewModel ,EMConversation>(
                      selector: (ctx, conversationVM) {
                        return conversationVM.conversationList[index];
                      },
                      shouldRebuild: (prev, next) => true,
                      builder: (ctx, conversation, child) {
                        return _buildListItemWidget(ctx, conversation);
                      }
                  );
                },
                childCount: conversationVM.conversationsTotal
            ),
          );
        });
  }

  /// 构建列表项
  Widget _buildListItemWidget(BuildContext cxt, EMConversation conversation) {
    if(conversation.conversationId == Constant.CONVERSATION_NOTIFICATION_ITEM){
      return EMConversationListItem(conversation, this);
    }
    return Slidable(
      key: Key(conversation.conversationId),
      controller: _slidableController,
      child: EMConversationListItem(conversation, this),
      // 抽屉式
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      secondaryActions: _slidableDrawerActionButtons(conversation, cxt),
      dismissal: SlidableDismissal(
        closeOnCanceled: false,
        dragDismissible: true,
        child: SlidableDrawerDismissal(),
        onWillDismiss: (actionType) {
          return false;
        },
        onDismissed: (_) {},
      ),
    );
  }

  List<Widget> _slidableDrawerActionButtons(EMConversation conversation, BuildContext context){
    final List<Widget> buttons = [];

    Widget deleteBtn = GestureDetector(
      child: Container(
        color: Colors.red,
        child: Text(
          '删除',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(42.0),
            fontWeight: FontWeight.w400,
          ),
        ),
        alignment: Alignment.center,
      ),
      onTap: () {
        context.read<ConversationViewModel>().deleteConversation(conversation);
      },
    );

    final Widget notRead = GestureDetector(
      child: Container(
        color: Color(0xFFC7C7CB),
        width: 150,
        child: Text(
          '标为未读',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(42.0),
            fontWeight: FontWeight.w400,
          ),
        ),
        alignment: Alignment.center,
      ),
      onTap: () {
        context.read<ConversationViewModel>().clearConversationUnread(conversation);
      },
    );
    buttons.addAll([notRead, deleteBtn]);
    return buttons;
  }

  /// 侧滑监听
  void _handleSlideAnimationChanged(Animation<double> slideAnimation) {}
  void _handleSlideIsOpenChanged(bool isOpen) { _slideIsOpen = isOpen; }

  /// 关闭slidable
  void _closeSlidable() {
    // 容错处理
    if (!_slideIsOpen) return;
    // 方案三：
    _slidableController.activeState?.close();
  }


  void _createGroupChat(){
    CreateIMGroupParamModel param = CreateIMGroupParamModel(groupName: '周杰伦', desc: '周杰伦粉丝群');
    GetDataTool.createIMGroup(param, (value) {

    });
  }

  /// 连接监听
  void onConnected(){
    print('onConnected');
  }

  void onDisconnected(int errorCode){
    print('onDisconnected');
  }

  /// 点击事件
  @override
  void onTapConversation(EMConversation conversation){
    if(conversation.conversationId == Constant.CONVERSATION_NOTIFICATION_ITEM){
//      NavigatorExt.pushToPage(context, CIRChatPage(conversation: conversation,));
      return;
    }
    context.read<ChatViewModel>().currentConversation = conversation;
    NavigatorExt.pushToPage(context, CIRChatPage(conversation: conversation,));
  }

  @override
  void onLongPressConversation(EMConversation conversation, Offset tapPos) {
  }

  @override
  bool get wantKeepAlive => true;
}
