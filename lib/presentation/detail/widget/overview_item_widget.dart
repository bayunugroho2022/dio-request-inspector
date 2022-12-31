import 'package:flutter/material.dart';

class ListRowWidget extends StatelessWidget {
  String? name;
  String? value;
  double? space;

  ListRowWidget({Key? key, this.name, this.value, this.space = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (space! > 0) {
      return SizedBox(height: space);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            name!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          Flexible(
            child: SelectableText(
              value!,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 18),
          )
        ],
      ),
    );
  }
}
