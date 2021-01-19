import 'package:circle/core/constant/enum.dart';
import 'feed_base_view_model.dart';

class FeedFollowViewModel extends FeedBaseViewModel {
  FeedFollowViewModel() {
    feedType = FeedTypeEnum.feedTypeEnumFollow;
    refreshData();
  }
}