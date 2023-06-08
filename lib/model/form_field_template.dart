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

extension FormFieldTypeStringExtension on String {
  FormFieldType get convertToFormFieldType {
    switch (this) {
      case '단답형':
        return FormFieldType.short;
      case '장문형':
        return FormFieldType.long;
      case '객관식':
        return FormFieldType.multiple;
      case '체크박스':
        return FormFieldType.checkBox;
      default:
        return FormFieldType.short;
    }
  }
}

class FormFieldTemplate {
  FormFieldTemplate({
    this.index = 0,
    this.type = FormFieldType.short,
    this.title = '',
    this.shortText = '',
    this.longText = '',
    this.options = const ['옵션 1'],
    this.selectedOption = '',
    this.checkBoxes = const ['옵션 1'],
    this.selectedBoxes = const [],
  });

  int index;
  FormFieldType type;
  String title;
  String shortText;
  String longText;
  List<String> options;
  String selectedOption;
  List<String> checkBoxes;
  List<String> selectedBoxes;

  FormFieldTemplate.fromFirestore(Map<String, Object?> json)
      : this(
          index: json['index'] as int,
          type: (json['type'] as String).convertToFormFieldType,
          title: json['title'] as String,
          shortText: json['shortText'] as String,
          longText: json['longText'] as String,
          options: json['options'] as List<String>,
          selectedOption: json['selectedOption'] as String,
          checkBoxes: json['checkBoxes'] as List<String>,
          selectedBoxes: json['selectedBoxes'] as List<String>,
        );

  Map<String, Object?> toFirestore() {
    return {
      'index': index,
      'type': type.convertToString,
      'title': title,
      'shortText': shortText,
      'longText': longText,
      'options': options,
      'selectedOption': selectedOption,
      'checkBoxes': checkBoxes,
      'selectedBoxes': selectedBoxes,
    };
  }
}
