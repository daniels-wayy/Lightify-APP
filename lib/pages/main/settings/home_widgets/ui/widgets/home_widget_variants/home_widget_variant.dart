enum HomeWidgetVariant {
  smallest,
  bigger,
}

extension HomeWidgetVariantX on HomeWidgetVariant {
  double get widgetSize {
    switch (this) {
      case HomeWidgetVariant.smallest:
        return 126;
      case HomeWidgetVariant.bigger:
        return 174;
    }
  }
  
  double get progressValueStroke {
    switch (this) {
      case HomeWidgetVariant.smallest:
        return 5.0;
      case HomeWidgetVariant.bigger:
        return 6.5;
    }
  }
  
  double get iconSize {
    switch (this) {
      case HomeWidgetVariant.smallest:
        return 20.0;
      case HomeWidgetVariant.bigger:
        return 29.0;
    }
  }
}