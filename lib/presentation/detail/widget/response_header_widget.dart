import 'package:flutter/material.dart';

class ResponseHeaderWidget extends StatelessWidget {
  final Map<String, dynamic>? headers;

  const ResponseHeaderWidget({Key? key, this.headers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (headers == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Headers :",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
          ),
          ...headers!.entries.map((e) => getListRow(e.key, e.value)),
        ],
      ),
    );
  }

  Widget getListRow(String name, var value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 2.0,
            backgroundColor: Colors.black,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          SelectableText(
            '$name: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5),
          ),
          Flexible(
            child: SelectableText(
              value.toString(),
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
