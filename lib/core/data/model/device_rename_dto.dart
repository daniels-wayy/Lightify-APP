import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_rename_dto.g.dart';

@JsonSerializable()
class DeviceRenameDTO {
  final String newName;
  final String deviceTopic;

  const DeviceRenameDTO({required this.newName, required this.deviceTopic});

  factory DeviceRenameDTO.fromJson(Map<String, dynamic> json) => _$DeviceRenameDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceRenameDTOToJson(this);
}
