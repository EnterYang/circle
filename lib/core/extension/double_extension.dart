import 'package:circle/core/services/size_fit.dart';

extension DoubleFit on double {
  double get px {
    return CIRSizeFit.setPx(this);
  }

  double get rpx {
    return CIRSizeFit.setRpx(this);
  }
}
