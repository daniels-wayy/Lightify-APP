// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lightify/core/data/server/request_executor/request_executor.dart';
import 'package:lightify/core/data/server/request_executor/request_executor_impl.dart';

const OTA_UPDATE = Named('OTA_UPDATE');
const OTA_VERSION_FILENAME = Named('OTA_VERSION_FILENAME');
const OTA_FIRMWARE_FILENAME = Named('OTA_FIRMWARE_FILENAME');

@module
abstract class ServerModule {
  @LazySingleton()
  @OTA_VERSION_FILENAME
  String provideOtaVersionFilename() {
    return 'version.txt';
  }
  
  @LazySingleton()
  @OTA_FIRMWARE_FILENAME
  String provideOtaFirmwareFilename() {
    return 'firmware.bin';
  }

  @LazySingleton()
  @OTA_UPDATE
  String provideBaseOtaUrl() {
    return 'https://raw.githubusercontent.com/daniels-wayy/Lightify-ESP-OTA/main/';
  }

  @LazySingleton()
  @OTA_UPDATE
  BaseOptions provideOTABaseOptions(@OTA_UPDATE String baseUrl) {
    return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 60000),
      sendTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 60000),
    );
  }

  @LazySingleton()
  @OTA_UPDATE
  Dio provideOTARequestDio(@OTA_UPDATE BaseOptions options) {
    return Dio(options);
  }

  @LazySingleton()
  @OTA_UPDATE
  RequestExecutor provideOTARequestExecutor(@OTA_UPDATE Dio dio) {
    return RequestExecutorImpl(dio: dio);
  }
}
