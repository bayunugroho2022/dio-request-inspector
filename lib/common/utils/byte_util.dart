import 'dart:convert';

import 'dart:typed_data';

class ByteUtil {
  String totalTransferSize(
    int? requestSize,
    int? responseSize,
    bool isRaw,
  ) {
    var reqSize = requestSize ?? 0;
    var resSize = responseSize ?? 0;
    var rawTotalSize = reqSize + resSize;
    var totalSize =
        (!isRaw) ? (rawTotalSize / 1024).toStringAsFixed(2) : rawTotalSize;
    return '$totalSize kb';
  }

  int stringToBytes(String data) {
    final bytes = utf8.encode(data);
    final size = Uint8List.fromList(bytes);
    return size.lengthInBytes;
  }
}
