import 'package:dio_request_inspector/common/extensions.dart';
import 'package:dio_request_inspector/common/utils/date_time_util.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/presentation/dashboard/widget/dot_animation.dart';
import 'package:dio_request_inspector/presentation/resources/color.dart';
import 'package:flutter/material.dart';

class ItemResponseWidget extends StatelessWidget {
  final HttpActivity data;
  final _dateTimeUtils = DateTimeUtil();

  ItemResponseWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = _dateTimeUtils.milliSecondDifference(
        data.request?.createdAt, data.response?.createdAt);

    return Container(
      padding: const EdgeInsets.all(3),
      width: double.infinity,
      child: Card(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${data.request?.method}',
                          style: TextStyle(color: AppColor.primary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${data.request?.path}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: AppColor.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                          data.request?.baseUrl ?? '',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColor.primary),
                        ),
                    Divider(
                      color: Colors.grey[300],
                      endIndent: 12,
                      indent: 0,
                    ),
                    Row(
                      children: [
                        Text(
                          '${data.request?.createdAt?.toTime}',
                          textAlign: TextAlign.left,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(
                          duration,
                          textAlign: TextAlign.left,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const Spacer(),
                        Text(
                          data.response?.responseSize?.byteToKiloByte() ??
                              data.error?.errorSize?.byteToKiloByte() ??
                              '-',
                          textAlign: TextAlign.left,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              )),
              textStatusCode(
                  statusCode: data.response?.responseStatusCode ?? 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget textStatusCode({int statusCode = 0}) {
    if (statusCode >= 200 && statusCode < 300) {
      return Text(
        statusCode.toString(),
        style:
            const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      );
    } else if (statusCode >= 300 && statusCode < 400) {
      return Text(
        statusCode.toString(),
        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      );
    } else if (statusCode >= 400 && statusCode < 500) {
      return Text(
        statusCode.toString(),
        style:
            const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      );
    } else if (statusCode >= 500 && statusCode < 600) {
      return Text(
        statusCode.toString(),
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    } else {
      return const TypingIndicatorWidget(
        dotColor: Colors.grey,
        dotSize: 8.0,
        animationDuration: Duration(milliseconds: 1000),
      );
    }
  }
}
