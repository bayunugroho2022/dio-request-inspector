import 'package:dio_request_inspector/common/extensions.dart';
import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  String? name;
  String? value;

  CardItem({Key? key, this.name, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
                  value!.isJson ? value.prettify : value!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
