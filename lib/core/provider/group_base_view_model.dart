import 'package:circle/core/constant/enum.dart';
import 'package:circle/core/model/feed/feed_list_param_model.dart';
import 'package:circle/core/model/feed/feed_list_result_model.dart';
import 'package:circle/core/model/group/group_list_mine_param_model.dart';
import 'package:circle/core/model/group/group_list_recommend_param_model.dart';
import 'package:circle/core/model/group/group_list_result_model.dart';
import 'package:circle/core/model/group/group_list_user_param_model.dart';
import 'package:circle/core/provider/user_view_model.dart';
import 'package:circle/core/services/get_data_tool.dart';
import 'package:flutter/material.dart';

class GroupBaseViewModel extends ChangeNotifier {
  List<Group> _groupsList = [];
  GroupListTypeEnum _listType;

  List<Group> get groupsList => List.from(_groupsList);
  int get groupsTotal => _groupsList.length;

  set listType(GroupListTypeEnum value) {
    _listType = value;
  }

  Future refreshData(){
    if (_listType == GroupListTypeEnum.groupListTypeEnumJoined) {
      return GetDataTool.getGroupMine(GroupListMineParamModel(GroupListMineTypeEnum.groupListTypeEnumJoin,offset: 0), (value) {
        GroupListResultModel result = value;
        _groupsList.clear();
        _groupsList.addAll(result.groups);
        notifyListeners();
      });
    }

    return GetDataTool.getGroupRecommend(GroupListRecommendParamModel(offset: 0), (value) {
      GroupListResultModel result = value;
      _groupsList.clear();
      _groupsList.addAll(result.groups);
      notifyListeners();
    });
  }

  Future loadMoreData(){
    if (_listType == GroupListTypeEnum.groupListTypeEnumJoined) {
      return GetDataTool.getGroupMine(GroupListMineParamModel(GroupListMineTypeEnum.groupListTypeEnumJoin,offset: groupsList.length + 20), (value) {
        GroupListResultModel result = value;
        _groupsList.addAll(result.groups);
        notifyListeners();
      });
    }

    return GetDataTool.getGroupRecommend(GroupListRecommendParamModel(offset: groupsList.length + 20), (value) {
      GroupListResultModel result = value;
      _groupsList.addAll(result.groups);
      notifyListeners();
    });
  }

  void joinGroup(Group group){
    int index = _groupsList.indexOf(group);
    if (group.joined == null || group.joined.id == null) {
      GetDataTool.joinGroup(group.id, (value) {
        group.joined = Joined();
        _groupsList[index] = group;
        notifyListeners();
      });
    }else{
      GetDataTool.exitGroup(group.id, (value) {
        group.joined = null;
        _groupsList[index] = group;
        notifyListeners();
      });
    }
  }
}