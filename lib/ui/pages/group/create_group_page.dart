import 'dart:io';
import 'package:circle/core/model/group/create_group_param_model.dart';
import 'package:circle/core/services/Image_util.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:circle/ui/shared/app_theme.dart';
import 'package:circle/ui/widgets/bar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:circle/core/extension/int_extension.dart';
import 'package:circle/core/extension/double_extension.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  PickedFile _selectedImageFile;
  final TextEditingController _titleTextFieldController = TextEditingController(text: '');
  final FocusNode _titleTextFieldFocusNode = FocusNode();
  final TextEditingController _summaryTextFieldController = TextEditingController(text: '');
  final FocusNode _summaryTextFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建圈子', style: Theme.of(context).textTheme.headline1,),
        iconTheme: Theme.of(context).iconTheme,
        leading: Container(
          padding: EdgeInsets.only(left: 16.0),
          alignment: Alignment.centerLeft,
          child: BarButton(
            '取消',
            textColor: CIRAppTheme.pTextColor,
            highlightTextColor: CIRAppTheme.sTextColor,
            onTap: () {
              // 键盘掉下
              _summaryTextFieldFocusNode.unfocus();
              _titleTextFieldFocusNode.unfocus();
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
        padding: EdgeInsets.only(top: 20.px),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildIconSelector(),
              SizedBox(height: 16.px,),
              _buildTitleTextField(),
              SizedBox(height: 16.px,),
              _buildSummaryTextField(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildIconSelector() {
    return InkWell(
        child: ClipOval(
          child: Container(
              color: Colors.white,
              height: 100.px,
              width: 100.px,
              child: _selectedImageFile == null ?
              Center(child: Text('上传Icon')) :
              Image.file(File(_selectedImageFile.path), fit: BoxFit.cover)
          ),
        ),
        onTap: (){
          ImageUtil.getGalleryImage().then((PickedFile imageFile) {
            if (imageFile != null) {
              _selectedImageFile = imageFile;
              this.setState(() { });
            } else {
              print('No image selected.');
            }
          });
        },
      );
  }

  Widget _buildTitleTextField(){
    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextField(
        controller: _titleTextFieldController,
        focusNode: _titleTextFieldFocusNode,
        maxLines: 1,
        maxLength: 10,
        autofocus: true,
        // 键盘 完成按钮
        textInputAction: TextInputAction.next,
        style: TextStyle(
          fontSize: 14.0,
          color: CIRAppTheme.pTextColor,
        ),
        decoration: InputDecoration(
          hintText: '圈子名称',
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
    );
  }

  Widget _buildSummaryTextField(){
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextField(
        controller: _summaryTextFieldController,
        focusNode: _summaryTextFieldFocusNode,
        maxLines: 5,
        maxLength: 60,
        autofocus: false,
        // 键盘 完成按钮
        textInputAction: TextInputAction.done,
        style: TextStyle(
          fontSize: 14.0,
          color: CIRAppTheme.pTextColor,
        ),
        decoration: InputDecoration(
          hintText: '圈子简介',
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
    );
  }

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
    _titleTextFieldFocusNode.unfocus();
    _summaryTextFieldFocusNode.unfocus();
    CreateGroupParamModel param = CreateGroupParamModel(
        name: _titleTextFieldController.text,
        summary: _summaryTextFieldController.text,
     );
    GetDataTool.createGroup(param, File(_selectedImageFile.path), (value) {
      if(value) {
        Navigator.of(context).pop();
      }
    });
  }
}
