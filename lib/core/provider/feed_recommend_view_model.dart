import 'package:circle/core/constant/enum.dart';
import 'feed_base_view_model.dart';

class FeedRecommendViewModel extends FeedBaseViewModel {
  FeedRecommendViewModel() {
    feedType = FeedTypeEnum.feedTypeEnumNew;
    refreshData();
  }
}