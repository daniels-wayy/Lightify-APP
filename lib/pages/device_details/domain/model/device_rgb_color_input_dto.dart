class DeviceRGBColorInputDTO {
  final int r;
  final int g;
  final int b;

  const DeviceRGBColorInputDTO({
    required this.r,
    required this.g,
    required this.b,
  });

  const DeviceRGBColorInputDTO.empty()
      : r = 0,
        g = 0,
        b = 0;

  bool get isEmpty => r == 0 && g == 0 && b == 0;

  DeviceRGBColorInputDTO copyWith({
    final int? r,
    final int? g,
    final int? b,
  }) {
    return DeviceRGBColorInputDTO(
      r: r ?? this.r,
      g: g ?? this.g,
      b: b ?? this.b,
    );
  }
}
