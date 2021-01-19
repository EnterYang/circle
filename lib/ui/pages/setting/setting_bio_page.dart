import 'package:circle/core/model/user/update_user_info_param_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/widgets/bar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingBioPage extends StatefulWidget {
  SettingBioPage({Key key, this.text}) : super(key: key);
  // 输入宽文字
  final String text;
  @override
  _SettingBioPageState createState() => _SettingBioPageState();
}

class _SettingBioPageState extends State<SettingBioPage> {
  /// 控制输入
  final TextEditingController _controller = TextEditingController(text: '');

  /// 控制键盘聚焦
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置个性签名", style: Theme.of(context).textTheme.headline1,),
        iconTheme: Theme.of(context).iconTheme,
        // leading : 最大宽度为56.0
        leading: Container(
          padding: EdgeInsets.only(left: 16.0),
          alignment: Alignment.centerLeft,
          child: BarButton(
            '取消',
            textColor: CIRAppTheme.pTextColor,
            highlightTextColor: CIRAppTheme.sTextColor,
            onTap: () {
              // 键盘掉下
              _focusNode.unfocus();
              Navigator.of(context).pop(null);
            },
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 16.0),
            alignment: Alignment.centerRight,
            child: BarButton(
              '完成',
              textColor: Colors.white,
              highlightTextColor: Colors.white.withOpacity(0.5),
              disabledTextColor: Colors.white.withOpacity(0.3),
              color: CIRAppTheme.pTintColor,
              highlightColor: CIRAppTheme.sTintColor,
              disabledColor: CIRAppTheme.sTintColor.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              enabled: true,
              onTap: _confirm,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 16.0),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: 2,
                  maxLength: 15,
                  autofocus: true,
                  // 键盘 完成按钮
                  textInputAction: TextInputAction.done,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: CIRAppTheme.pTextColor,
                  ),
                  decoration: InputDecoration(
                    // 去掉底部分割线
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(2.0),
                  ),
                  // 光标颜色
                  cursorColor: CIRAppTheme.pTintColor,
                  // 定制 counter ; 默认是 0/30 这种格式
                  buildCounter: _buildCounter,
                  // 内容改变的回调
                  onChanged: (text) {},
                  onSubmitted: (String text) {
                    // 回调数据
                    _confirm();
                  },
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: CIRAppTheme.pDividerColor, width: 0.5),
                    top: BorderSide(color: CIRAppTheme.pDividerColor, width: 0.5),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  // 自定义counter
  Widget _buildCounter(
      BuildContext context, {
        int currentLength,
        int maxLength,
        bool isFocused,
      }) {
    return Text(
      '${maxLength - currentLength}',
      style: TextStyle(
        color: CIRAppTheme.mTextColor,
        fontSize: 12.0,
      ),
    );
  }

  // 完成事件
  void _confirm() {
    // 键盘掉下
    _focusNode.unfocus();
    UpdateUserInfoParamModel updateUserInfoParam = UpdateUserInfoParamModel();
    updateUserInfoParam.bio = _controller.text;
    GetDataTool.updateUserInfo(updateUserInfoParam, (value) {
      context.read<UserViewModel>().setBio(updateUserInfoParam.bio);
      Navigator.of(context).pop();
    });
  }
}
