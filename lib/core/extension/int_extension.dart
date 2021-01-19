import 'package:circle/core/services/size_fit.dart';

extension IntFit on int {
  double get px {
    return CIRSizeFit.setPx(this.toDouble());
  }

  double get rpx {
    return CIRSizeFit.setRpx(this.toDouble());
  }
}