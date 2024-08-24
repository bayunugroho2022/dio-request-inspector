class FormDataField {
  const FormDataField(
    this.name,
    this.value,
  );

  final String name;
  final String value;
}

class FormDataFile {
  const FormDataFile(
    this.fileName,
    this.contentType,
    this.length,
  );

  final String? fileName;
  final String contentType;
  final int length;
}
