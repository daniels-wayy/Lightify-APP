class FirmwareVersion {
  static const unknownVersion = -1.0;

  final double version;
  const FirmwareVersion(this.version);
  const FirmwareVersion.unknown() : version = unknownVersion;
  FirmwareVersion.fromString(String ver) : version = double.tryParse(ver) ?? unknownVersion;

  bool get isVersion => version >= 0.0;

  bool operator >(FirmwareVersion other) {
    return version > other.version;
  }

  @override
  String toString() {
    return 'v$version';
  }
}
