import 'package:circle/core/constant/enum.dart';
import 'group_base_view_model.dart';

class GroupRecommendViewModel extends GroupBaseViewModel {
  GroupRecommendViewModel() {
    listType = GroupListTypeEnum.groupListTypeEnumRecommend;
    refreshData();
  }
}