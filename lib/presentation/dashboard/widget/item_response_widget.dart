import 'package:dio_request_inspector/common/extensions.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/presentation/dashboard/widget/dot_animation.dart';
import 'package:flutter/material.dart';

class ItemResponseWidget extends StatelessWidget {
  final HttpActivity data;

  const ItemResponseWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      width: double.infinity,
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color:
                        data.response?.responseStatusCode?.colorByStatusCode ??
                            Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    '${data.request?.method}',
                    style: const TextStyle(color: Colors.white),
                  )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '${data.request?.path}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: data.response?.responseStatusCode
                              ?.colorByStatusCode ??
                          Colors.grey),
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
