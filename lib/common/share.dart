import 'package:dio_request_inspector/common/utils/date_time_util.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio_request_inspector/common/extensions.dart';

class ShareActivity {
  final _dateTimeUtils = DateTimeUtil();

  void data(HttpActivity data) async {
    Share.share(
      await getShareData(data),
      subject: 'Dio Request Inspector : ${data.request?.path}',
    );
  }

  Future<String> getShareData(HttpActivity data) async {
    try {
      return _buildShareData(data);
    } catch (exception) {
      return "Failed to generate call log";
    }
  }

  String _buildShareData(HttpActivity data) {
    final duration = _dateTimeUtils.milliSecondDifference(
        data.request?.createdAt, data.response?.createdAt);

    final StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write("===========================================\n");
    stringBuffer.write("=========== Dio Request Inspector ===========\n");
    stringBuffer.write("===========================================\n");
    stringBuffer.write("\n\n");
    stringBuffer.write("-------------------------------------------\n");
    stringBuffer.write("Overview\n");
    stringBuffer.write("-------------------------------------------\n");
    stringBuffer.write(
        "Host: ${data.request!.secure! ? "https://${data.request!.server!}" : "http://${data.request!.server!}"} \n");
    stringBuffer.write("Method: ${data.request?.method} \n");
    stringBuffer.write("Endpoint: ${data.request?.path} \n");
    stringBuffer.write("Duration $duration \n");
    stringBuffer.write("Client: ${data.request?.client} \n");
    stringBuffer.write("Secure: ${data.request?.secure} \n");
    stringBuffer.write("\n\n");

    stringBuffer.write("-------------------------------------------\n");
    stringBuffer.write("Request\n");
    stringBuffer.write("-------------------------------------------\n");
    stringBuffer.write("Started: ${data.request?.createdAt?.toDateTime} \n");
    stringBuffer
        .write("Bytes sent: ${data.request?.requestSize?.byteToKiloByte()} \n");
    if (data.request?.requestHeader != null) {
      stringBuffer.write("Headers: \n");
      stringBuffer.write(
          "${data.request!.requestHeader!.isJson ? data.request!.requestHeader!.prettify : data.request!.requestHeader} \n");
    }

    if (data.request?.params != null) {
      stringBuffer.write("Query Parameter: \n");
      stringBuffer.write(
          "${data.request!.params!.isJson ? data.request!.params!.prettify : data.request!.params} \n");
    }

    if (data.request?.requestBody != null &&
        data.request?.requestBody != "null") {
      stringBuffer.write("Body: \n");
      stringBuffer.write(
          "${data.request!.requestBody!.isJson ? data.request!.requestBody!.prettify : data.request!.requestBody} \n");
    }
    stringBuffer.write("\n\n");
    stringBuffer.write("-------------------------------------------\n");
    stringBuffer.write("Response\n");
    stringBuffer.write("-------------------------------------------\n");
    stringBuffer.write("Received: ${data.response?.createdAt?.toDateTime} \n");
    stringBuffer.write("Status Code: ${data.response?.responseStatusCode} \n");
    stringBuffer.write(
        "Bytes received: ${data.response?.responseSize?.byteToKiloByte()} \n");
    if (data.response?.responseHeader != null ||
        data.response!.responseHeader!.isNotEmpty) {
      stringBuffer.write("Headers: \n");
      data.response?.responseHeader
          ?.map((key, value) => MapEntry(key, value))
          .forEach((key, value) {
        stringBuffer.write("- $key: $value \n");
      });
      stringBuffer.write("\n");
    }

    if (data.response?.responseBody != null) {
      stringBuffer.write("Body: \n");
      stringBuffer.write(
          "${data.response!.responseBody!.isJson ? data.response!.responseBody!.prettify : data.response!.responseBody} \n");
    }
    stringBuffer.write("\n\n");
    if (data.error?.errorMessage != null) {
      stringBuffer.write("-------------------------------------------\n");
      stringBuffer.write("Error\n");
      stringBuffer.write("-------------------------------------------\n");
      stringBuffer.write("Error: ${data.error?.errorMessage} \n");
    }

    stringBuffer.write("===========================================\n");

    return stringBuffer.toString();
  }
}
