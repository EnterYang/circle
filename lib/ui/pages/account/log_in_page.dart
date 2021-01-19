import 'package:circle/core/model/account/login_param_model.dart';
import 'package:circle/core/model/account/login_result_model.dart';
import 'package:circle/core/services/common_data_util.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

class CIRLogInPage extends StatefulWidget {
  CIRLogInPage({Key key}) : super(key: key);

  @override
  _CIRLogInPageState createState() => _CIRLogInPageState();
}

class _CIRLogInPageState extends State<CIRLogInPage> {
  final loginFormKey = GlobalKey<FormState>();
  String userName, password;
  bool autovalidate = false;
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Builder(builder: 
        (BuildContext context) {
          return Column(
            children: <Widget>[
              // Container(
              //   padding: EdgeInsets.only(top: 80, left: 20),
              //   alignment: Alignment.topLeft,
              //   child: Text('登录', style: TextStyle( color: Colors.blue, fontSize: 33))
              // ),
              Container(
                padding: EdgeInsets.all(20),
                child: buildLogInForm(context),
              ),
            ]
          );
        }
      )
    );
*/
  bool _rememberMe = false;

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '手机号/用户名',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Colors.white,
              ),
              hintText: '请输入手机号码或用户名',
              hintStyle: kHintTextStyle,
            ),
            onSaved: (value){
              userName = value;
            },
            // validator: validateUsername,
            // autovalidate: autovalidate,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '密码',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: '请输入密码',
              hintStyle: kHintTextStyle,
            ),
            onSaved: (value){
              password = value;
            },
            // validator: validateUsername,
            // autovalidate: autovalidate,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          '忘记密码',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            '记住账号',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){
          submitLogInForm(context);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          '登录',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- 或 -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          '其他方式登录',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '还没注册过? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: '注册',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: 
        (BuildContext context){
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      // Colors.yellow,
                      // Colors.yellow,
                      // Colors.yellow,
                      // Colors.yellow,
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Form(
                    key: loginFormKey,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Circle',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        _buildEmailTF(),
                        SizedBox(height: 30.0),
                        _buildPasswordTF(),
                        _buildForgotPasswordBtn(),
                        _buildRememberMeCheckbox(),
                        _buildLoginBtn(context),
                        // _buildSignInWithText(),
                        // _buildSocialBtnRow(),
                        _buildSignupBtn(),
                      ],
                    ),
                  )
                ),
              )
            ],
          ),
        ),
      );
    }
      )
    );
  }

  void submitLogInForm (BuildContext context) {
    if (loginFormKey.currentState.validate()) { 
      loginFormKey.currentState.save();
      debugPrint(userName); 
      debugPrint(password);
      if(userName.length<1){
        return;
      }
      if(password.length<4){
        return;
      }

      GetDataTool.logIn(LoginParamModel(userName, password), (value) async {
        LogInResultModel result = value;
        debugPrint(result.accessToken);
        CommonDataUtil dataUtil = CommonDataUtil.getInstance();
        await dataUtil.setTokenWithLogInResultModel(result);

        Navigator.of(context).pop();
      });
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('正在登录...')
      // ));
    } else {
      setState(() {
        autovalidate = true;
      });
    }
  }
  String validateUsername (value){
    if (value.isEmpty) {
      return '用户名不能为空';
    }
    return null;
  }
  String validatePassword (value){
    if (value.isEmpty) {
      return '密码不能为空';
    }
    return null;
  }
}








/*



  Widget buildLogInForm (BuildContext context) {
    return Form(
        key: loginFormKey,
        child:Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Icon(Icons.account_box),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                    // decoration: InputDecoration(
                    //   isDense: true,
                    //   contentPadding: EdgeInsets.all(5.0),
                    //   hintText: '请输入手机号码或邮箱',
                    //   // helperText: '',
                    // ),
                    onSaved: (value){
                      userName = value;
                    },
                    validator: validateUsername,
                    autovalidate: autovalidate,
                  ),
                )
              ],
            ),

            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
              // decoration: InputDecoration(
              //   isDense: true,
              //   contentPadding: EdgeInsets.all(5.0),
              //   hintText: '请输入密码',
              //   helperText: ''
              // ),
              onSaved: (value){
                password = value;
              },
              validator: validatePassword,
              autovalidate: autovalidate,
            ),
            SizedBox(height: 30),
            Container(
              height: 50,
              width: double.infinity,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text('登录'),
                elevation: 0.0,
                onPressed: (){
                  submitLogInForm(context);
                  },
              )
            )
          ]
        )
      );
  }
*/