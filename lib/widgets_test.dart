// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:home_widget/home_widget.dart';
// import 'package:lightify/core/domain/repo/mqtt_repo.dart';
// import 'package:lightify/core/domain/repo/network_repo.dart';
// import 'package:lightify/core/ui/constants/app_constants.dart';
// import 'package:lightify/core/ui/utils/function_util.dart';
// import 'package:lightify/core/ui/utils/mqtt_util.dart';
// import 'package:lightify/di/di.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';

// const countKey = "count";
// const addIntentUrl = "add";

// const appGroupId = 'group.lightify_ds_app_group';
// const iOSName = 'lightifyDevicesWidget';

// @pragma('vm:entry-point')
// Future<void> interactiveCallback(Uri? uri) async {
//   debugPrint('interactiveCallback: $uri');
  // if (uri?.host == addIntentUrl) {
  //   // configureDependencies();

  //   // final networkRepo = getIt<NetworkRepo>();
  //   // final mqttRepo = getIt<MQTTRepo>();

  //   // await networkRepo.initializeConnection(
  //   //   onConnected: () {
  //   //     mqttRepo.send('DSLY_Bedroom_Monitor', MQTT_UTIL.power_cmd(0));
  //   //   },
  //   // );

  //   late MqttServerClient client;

  //   final connMessage = MqttConnectMessage().withWillQos(MqttQos.atMostOnce).withClientIdentifier(
  //         FunctionUtil.generateRandomString(12),
  //       );
  //   client = MqttServerClient(AppConstants.api.MQTT_BROKER_HOST, '',
  //       maxConnectionAttempts: AppConstants.api.MQTT_CONNECTION_ATTEMPTS);
  //   client.port = AppConstants.api.MQTT_PORT;

  //   client.setProtocolV311();
  //   client.keepAlivePeriod = AppConstants.api.MQTT_KEEP_ALIVE_FREQ_SEC;
  //   client.connectTimeoutPeriod = 3000; // milliseconds
  //   client.connectionMessage = connMessage;
  //   client.onConnected = () {
  //     final value = '${AppConstants.api.MQTT_PACKETS_HEADER}${MQTT_UTIL.power_cmd(0)}';
  //     final mqttPayloadBuilder = MqttClientPayloadBuilder().addString(value);
  //     if (mqttPayloadBuilder.payload != null) {
  //       client.publishMessage('DSLY_Bedroom_Monitor', MqttQos.exactlyOnce, mqttPayloadBuilder.payload!);
  //       // client.disconnect();
  //     }
  //   };

  //   try {
  //     await client.connect();
  //     await Future<void>.delayed(const Duration(milliseconds: 50));
  //   } on NoConnectionException catch (e) {
  //     debugPrint('MQTT Connection NoConnectionException! $e');
  //     client.disconnect();
  //   } on SocketException catch (e) {
  //     debugPrint('MQTT Connection SocketException! $e');
  //     client.disconnect();
  //   } catch (e) {
  //     debugPrint('MQTT Connection error! $e');
  //     client.disconnect();
  //   }

  //   if (client.connectionStatus?.state == MqttConnectionState.connected) {
  //     client.subscribe(AppConstants.api.MQTT_TOPIC, MqttQos.atMostOnce);
  //   }

//     final oldValue = await _value;
//     final newValue = oldValue + 1;
//     await _sendAndUpdate(newValue);
//   }
// }

// Future<int> get _value async {
//   final value = await HomeWidget.getWidgetData<int>(countKey, defaultValue: 0);
//   return value!;
// }

// Future<void> _sendAndUpdate([int? value]) async {
//   await HomeWidget.saveWidgetData(countKey, value);
//   await HomeWidget.updateWidget(
//     iOSName: iOSName,
//   );
// }

// class WidgetsTest extends StatelessWidget {
//   const WidgetsTest({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       restorationScopeId: 'lightify_app',
//       home: Scaffold(
//         body: Container(),
//       ),
//     );
//   }
// }
