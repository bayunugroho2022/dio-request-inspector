class FormDataFieldModel {
  final String name;
  final String value;

  FormDataFieldModel(this.name, this.value);
}


class FormDataFileModel {
  final String? fileName;
  final String contentType;
  final int length;

  FormDataFileModel(this.fileName, this.contentType, this.length);
}
