import 'package:dio_request_inspector/common/copy.dart';
import 'package:dio_request_inspector/common/extensions.dart';
import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String? name;
  final String? value;
  final bool showCopyButton;
  final bool isImage;

  const CardItem(
      {Key? key,
      this.name,
      this.value,
      this.showCopyButton = false,
      this.isImage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name!, style: const TextStyle(fontWeight: FontWeight.bold)),
              Visibility(
                visible: showCopyButton,
                child: IconButton(
                  icon: const Icon(
                    Icons.copy,
                    size: 16,
                  ),
                  onPressed: () {
                    CopyToClipboard.copy(
                        text: value!.isJson ? value.prettify : value!,
                        context: context);
                  },
                ),
              ),
            ],
          ),
          if (isImage)
            Image.network(
              value!,
              width: double.infinity,
            ),
          if (!isImage)
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
