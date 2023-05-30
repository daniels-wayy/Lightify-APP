import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

abstract class DebugPrintService {
  Function(String?, {int? wrapWidth}) get debugPrint;
}

@Injectable(as: DebugPrintService)
class DevDebugPrintService implements DebugPrintService {
  @override
  Function(String? p1, {int? wrapWidth}) get debugPrint => (String? message, {int? wrapWidth}) {
        final pattern = RegExp('.{1,1000}'); // 1000 is the size of each chunk
        int i = 0;
        pattern.allMatches(message ?? '').forEach((match) {
          if (0 == i) {
            debugPrintSynchronously("[${DateFormat('HH:mm:ss.SSS').format(DateTime.now())}]: ${match.group(0)}",
                wrapWidth: wrapWidth);
          } else {
            debugPrintSynchronously(match.group(0), wrapWidth: wrapWidth);
          }
          i++;
        });
      };
}

void debugPrintWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}
