import 'dart:convert';
import 'package:circle/core/database/file_url_db_provider.dart';
import 'package:circle/core/database/model/user_info_simple.dart';
import 'package:circle/core/database/user_info_db_provider.dart';
import 'package:circle/core/model/account/login_result_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/feed/get_file_param_model.dart';
import 'package:circle/core/model/feed/get_file_result_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circle/core/constant/shared_preferences_key.dart';
import 'package:sqflite/sqflite.dart';

class CommonDataUtil {
  static CommonDataUtil instance;

  static CommonDataUtil getInstance() {
    if (null == instance) instance = CommonDataUtil();
    return instance;
  }
  static init() async {

  }

  Database db;
  String _token="";
  String _tokenType="";
  DateTime _expiresIn;
  DateTime _refreshTtl;
  SharedPreferences _prefs;
  UserViewModel _currentUserData;
  Map<String, User> _userInfoMap;
  FileUrlDbProvider _fileUrlDbProvider;
  UserInfoDbProvider _userInfoDbProvider;

  Future<SharedPreferences> _getPrefs() async {
    if(_prefs != null) return _prefs;
    _prefs = await SharedPreferences.getInstance();
    await _prefs.reload();
    return _prefs;
  }

  Future<String> getToken() async {
    if (_token.length>0) return _token;
    SharedPreferences prefs = await _getPrefs();
    _token = prefs.getString(SharedPreferencesKey.ACCESS_TOKEN);

    return _token;
  }

  Future<String> getTokenType() async {
    if (_tokenType.length>0) return _tokenType;
    SharedPreferences prefs = await _getPrefs();
    _tokenType = prefs.getString(SharedPreferencesKey.TOKEN_TYPE);

    return _tokenType;
  }

  Future<DateTime> getExpiresIn() async {
    if (_expiresIn != null) return _expiresIn;
    SharedPreferences prefs = await _getPrefs();
    String timeString = prefs.getString(SharedPreferencesKey.EXPIRES_IN);
    if (timeString.length > 0) {
      _expiresIn = DateTime.parse(timeString);
    } else {
      _expiresIn = DateTime.now();
    }
    return _expiresIn;
  }

  FileUrlDbProvider _getFileUrlDbProvider(){
    if(_fileUrlDbProvider == null){
      _fileUrlDbProvider = FileUrlDbProvider();
    }
    return _fileUrlDbProvider;
  }

  UserInfoDbProvider _getUserInfoDbProvider(){
    if(_userInfoDbProvider == null){
      _userInfoDbProvider = UserInfoDbProvider();
    }
    return _userInfoDbProvider;
  }

  Future<DateTime> getRefreshTtl() async {
    if (_refreshTtl != null) return _refreshTtl;
    SharedPreferences prefs = await _getPrefs();
    String timeString = prefs.getString(SharedPreferencesKey.REFRESH_TTL);
    if (timeString.length > 0) {
      _refreshTtl = DateTime.parse(timeString);
    } else {
      _refreshTtl = DateTime.now();
    }
    return _refreshTtl;
  }

  Future<void> setTokenWithLogInResultModel(LogInResultModel model) async {
    SharedPreferences prefs = await _getPrefs();
    await prefs.setString(SharedPreferencesKey.ACCESS_TOKEN, model.accessToken);
    await prefs.setString(SharedPreferencesKey.TOKEN_TYPE, model.tokenType);
    DateTime expiresInTime = DateTime.now().add(Duration(minutes: model.expiresIn));
    DateTime refreshTtlTime = DateTime.now().add(Duration(minutes: model.refreshTtl));
    await prefs.setString(SharedPreferencesKey.EXPIRES_IN, expiresInTime.toString());
    await prefs.setString(SharedPreferencesKey.REFRESH_TTL, refreshTtlTime.toString());

    await prefs.reload();
    _token = model.accessToken;
    _tokenType = model.tokenType;
    _expiresIn = expiresInTime;
    _refreshTtl = refreshTtlTime;
  }

  Future<void> saveCurrentUserData(jsonString) async {
    SharedPreferences prefs = await _getPrefs();
    await prefs.setString(SharedPreferencesKey.CURRENT_USER_DATA, jsonString);
  }

  Future<UserViewModel> getCurrentUserData() async {
    if (_currentUserData != null) return _currentUserData;
    SharedPreferences prefs = await _getPrefs();
    String jsonString = prefs.getString(SharedPreferencesKey.CURRENT_USER_DATA);
    _currentUserData = UserViewModel.fromJson(jsonDecode(jsonString));
    return _currentUserData;
  }

  Future<void> saveUsersInfo(User user) async {
    UserInfoDbProvider userInfoDbProvider = _getUserInfoDbProvider();
    userInfoDbProvider.updateOrInsert(user);
//    Map<String, User> userInfoMap = await this.userInfoMap;
//    if(userInfoMap.containsKey(user.id)){
//      User tempUser = userInfoMap[user.id];
//      if(tempUser != user){
//        userInfoMap['${user.id}'] = user;
//      }else{
//        return;
//      }
//    }else{
//      userInfoMap['${user.id}'] = user;
//    }
//    _userInfoMap = userInfoMap;
//    SharedPreferences prefs = await _getPrefs();
//    await prefs.setString(SharedPreferencesKey.USERS_INFO_MAP, jsonEncode(userInfoMap));
  }

//  Future<Map<String, User>> get userInfoMap async{
//    if (_userInfoMap == null){
//      SharedPreferences prefs = await _getPrefs();
//      String userInfoMapJsonString = prefs.getString(SharedPreferencesKey.USERS_INFO_MAP);
//      if(userInfoMapJsonString != null){
//        _userInfoMap = jsonDecode(userInfoMapJsonString);
//      }else{
//        _userInfoMap = Map<String, User>();
//      }
//    }
//    return _userInfoMap;
//  }

  Future<UserInfoSimple> getUserInfoWithUserId(int userId) async {
    UserInfoDbProvider userInfoDbProvider = _getUserInfoDbProvider();
    UserInfoSimple userInfoSimple;
    userInfoSimple = await userInfoDbProvider.getUserInfoSimple(userId);
//    Map<String, User> userInfoMap = await this.userInfoMap;
//    if(userInfoMap.containsKey(userId)){
//      return userInfoMap['$userId'];
//    }
    if(userInfoSimple == null) {
      await GetDataTool.getUserInfo(userId, (value) {
        User user = value;
        this.saveUsersInfo(user);
        userInfoSimple = UserInfoSimple.fromJson(user.toJson());
      });
    }
    return userInfoSimple;
  }

  Future<String> getFileUrlWithFileId(int fileId) async {
    FileUrlDbProvider fileUrlDbProvider = _getFileUrlDbProvider();
    String fileUrl = await fileUrlDbProvider.getFileUrl(fileId);
    if(fileUrl == null) {
      await GetDataTool.getFile(fileId, GetFileParamModel(), (value) {
        GetFileResultModel result = value;
        fileUrl = result.url;
      });

      saveFileUrlWithFileId(fileId, fileUrl);
    }
    return fileUrl;
  }

  Future<void> saveFileUrlWithFileId(int fileId, String fileUrl) async {
    FileUrlDbProvider fileUrlDbProvider = _getFileUrlDbProvider();
    fileUrlDbProvider.updateOrInsert(fileId, fileUrl);
  }
}