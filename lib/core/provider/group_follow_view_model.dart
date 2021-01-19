import 'package:circle/core/constant/enum.dart';
import 'group_base_view_model.dart';

class GroupFollowViewModel extends GroupBaseViewModel {
  GroupFollowViewModel() {
    listType = GroupListTypeEnum.groupListTypeEnumJoined;
    refreshData();
  }
}