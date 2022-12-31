import 'dart:convert';

import 'package:dio_request_inspector/common/extensions.dart';
import 'package:flutter/material.dart';

class ResponseJson extends StatelessWidget {
  final String? name;
  final String? value;
  static const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  const ResponseJson({Key? key, this.name, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name!, style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 0,
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(
                 value!.isJson ? value! : value!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

