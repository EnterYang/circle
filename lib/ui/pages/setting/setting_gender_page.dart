import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/widgets/bar_button.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class SettingGenderPage extends StatefulWidget {
  SettingGenderPage({Key key, this.text}) : super(key: key);
  // 输入宽文字
  final String text;
  @override
  _SettingGenderPageState createState() => _SettingGenderPageState();
}

class _SettingGenderPageState extends State<SettingGenderPage> {
  String _picked = "女";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置性别", style: Theme.of(context).textTheme.headline1,),
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
              Navigator.of(context).pop();
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
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RadioButtonGroup(
                  orientation: GroupedButtonsOrientation.VERTICAL,
                  margin: const EdgeInsets.only(left: 12.0),
                  onSelected: (String selected) => setState((){
                    _picked = selected;
                  }),
                  labels: <String>[
                    "男",
                    "女",
                  ],
                  picked: _picked,
                  itemBuilder: (Radio rb, Text txt, int i){
                    return Row(
                      children: <Widget>[
                        rb,
                        txt,
                      ],
                    );
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

  // 完成事件
  void _confirm() {
    Navigator.of(context).pop();
  }
}
