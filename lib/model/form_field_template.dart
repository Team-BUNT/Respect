enum FormFieldType {
  short,
  long,
  multiple,
  checkBox,
}

extension FormFieldTypeExtension on FormFieldType {
  String get convertToString {
    switch (this) {
      case FormFieldType.short:
        return '단답형';
      case FormFieldType.long:
        return '장문형';
      case FormFieldType.multiple:
        return '객관식';
      case FormFieldType.checkBox:
        return '체크박스';
      default:
        return "";
    }
  }
}

class FormFieldTemplate {
  FormFieldTemplate({
    this.type = FormFieldType.short,
    this.title = '',
    this.shortText = '',
    this.longText = '',
    this.options = const ['옵션 1'],
    this.selectedOption = '',
    this.checkBoxes = const ['옵션 1'],
    this.selectedBoxes = const [],
  });

  FormFieldType type;
  String title;
  String shortText;
  String longText;
  List<String> options;
  String selectedOption;
  List<String> checkBoxes;
  List<String> selectedBoxes;
}
