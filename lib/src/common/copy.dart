import 'dart:io';

import 'package:dio_request_inspector/src/common/extensions.dart';
import 'package:dio_request_inspector/src/common/helpers.dart';
import 'package:dio_request_inspector/src/model/http_activity.dart';

class Copy {
  static String getCurlCommand(HttpActivity call) {
    bool compressed = false;
    final StringBuffer curlCmd = StringBuffer('curl');

    curlCmd.write(' -X ${call.method}');

    final headers = Helper.decodeRawJson(call.request?.headers ?? '{}');
    for (final MapEntry<String, dynamic> header in headers.entries) {
      final headerValue = header.value?.toString() ?? '';
      if (headerValue.isNotEmpty) {
        if (header.key.toLowerCase() == HttpHeaders.acceptEncodingHeader &&
            headerValue.toLowerCase() == 'gzip') {
          compressed = true;
        }

        curlCmd.write(' -H "${header.key}: $headerValue"');
      }
    }

    final String? requestBody = call.request?.body?.toString();
    if (requestBody != null && requestBody.isNotEmpty && requestBody != 'null') {
      curlCmd.write(" --data \$'${requestBody.replaceAll("\n", r"\n")}'");
    }

    final Map<String, dynamic>? queryParamMap = call.request?.queryParameters;
    int paramCount = queryParamMap?.keys.length ?? 0;
    final StringBuffer queryParams = StringBuffer();

    if (paramCount > 0) {
      queryParams.write('?');
      for (final MapEntry<String, dynamic> queryParam
          in queryParamMap?.entries ?? []) {
        queryParams.write('${queryParam.key}=${queryParam.value}');
        paramCount--;
        if (paramCount > 0) {
          queryParams.write('&');
        }
      }
    }

    if (call.server.contains('http://') || call.server.contains('https://')) {
      curlCmd.write(
        "${compressed ? " --compressed " : " "}"
        "${"'${call.server}${call.endpoint}$queryParams'"}",
      );
    } else {
      curlCmd.write(
        "${compressed ? " --compressed " : " "}"
        "${"'${call.secure ? 'https://' : 'http://'}${call.server}${call.endpoint}$queryParams'"}",
      );
    }

    return curlCmd.toString();
  } 

  static String getActivity(HttpActivity data) {
    var contentTypeList = data.response?.headers?["content-type"];
    final isImage = contentTypeList != null && contentTypeList.any((element) => element.contains('image'));

    final StringBuffer activityDetails = StringBuffer();

    activityDetails.writeln('--- Curl Command ---');
    activityDetails.writeln(getCurlCommand(data));

    activityDetails.writeln('\n--- HTTP Activity ---');
    activityDetails.writeln('Method: ${data.method}');
    activityDetails.writeln('Server: ${data.server}');
    activityDetails.writeln('Endpoint: ${data.endpoint}');
    activityDetails.writeln('Secure: ${data.secure}');
    activityDetails.writeln('Time: ${data.request?.time}');
    activityDetails.writeln('Started: ${data.response?.time}');
    activityDetails.writeln('Duration: ${Helper.formatTime(data.duration)}');
    activityDetails.writeln('Bytes Sent: ${Helper.formatBytes(data.request?.size ?? 0)}');
    activityDetails.writeln('Bytes Received: ${Helper.formatBytes(data.response?.size ?? 0)}');

    activityDetails.writeln('\n--- Request ---');
    activityDetails.writeln('Headers: ${Helper.encodeRawJson(data.request?.headers).isJson 
      ? Helper.encodeRawJson(data.request?.headers).prettify 
      : Helper.encodeRawJson(data.request?.headers)}');

    activityDetails.writeln('Query Parameters: ${Helper.encodeRawJson(data.request?.queryParameters).isJson
      ? Helper.encodeRawJson(data.request?.queryParameters).prettify
      : Helper.encodeRawJson(data.request?.queryParameters)}');
    
    activityDetails.writeln('Body: ${(data.request?.body ?? '').isJson 
      ? data.request?.body.prettify 
      : data.request?.body}');

    activityDetails.writeln('\n--- Response ---');
    activityDetails.writeln('Status Code: ${data.response?.status}');
    activityDetails.writeln('Headers: ${Helper.encodeRawJson(data.response?.headers)}');
    activityDetails.writeln('Body: ${(data.response?.body ?? '').isJson 
    ? data.response?.body.prettify
    : isImage ? "Image Body" : data.response?.body}');

    if (data.error?.error != null) {
      activityDetails.writeln('\n--- Error ---');
      activityDetails.writeln('Error: ${data.error?.error}');
    }

    return activityDetails.toString();
  }
}
