import 'package:flutter/rendering.dart';

const borderRadius = BorderRadius.all(Radius.circular(8));

enum CPaddingSize { mini, small, medium, large }

extension CPaddingSizeValue on CPaddingSize {
  double get values {
    switch (this) {
      case CPaddingSize.mini:
        return 4;
      case CPaddingSize.small:
        return 8;
      case CPaddingSize.medium:
        return 16;
      case CPaddingSize.large:
        return 20;
    }
  }
}
