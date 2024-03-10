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
        return 4.0;
      case HomeWidgetVariant.bigger:
        return 5.5;
    }
  }

  double get iconSize {
    switch (this) {
      case HomeWidgetVariant.smallest:
        return 19.0;
      case HomeWidgetVariant.bigger:
        return 27.0;
    }
  }
}
