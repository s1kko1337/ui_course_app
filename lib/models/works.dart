import 'dart:convert';

class Work {
  final int id;
  final int modelerId;
  final String pathToModel;
  final Map<String, dynamic> additionalInfo;

  Work({
    required this.id,
    required this.modelerId,
    required this.pathToModel,
    required this.additionalInfo,
  });

  // Фабричный метод для создания объекта Work из Map
  factory Work.fromMap(Map<String, dynamic> map) {
    return Work(
      id: map['id'] as int,
      modelerId: map['modeler_id'] as int,
      pathToModel: map['path_to_model'] as String,
      additionalInfo: _decodeAdditionalInfo(map['additional_info']),
    );
  }

  // Метод для преобразования объекта Work в Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modeler_id': modelerId,
      'path_to_model': pathToModel,
      'additional_info': _encodeAdditionalInfo(additionalInfo),
    };
  }

  // Приватный метод для декодирования additional_info
  static Map<String, dynamic> _decodeAdditionalInfo(dynamic jsonData) {
    if (jsonData == null || jsonData is! String) {
      return {};  // Возвращаем пустую карту, если данных нет
    }
    try {
      return jsonDecode(jsonData) as Map<String, dynamic>;
    } catch (e) {
      return {};  // В случае ошибки возвращаем пустую карту
    }
  }

  // Приватный метод для кодирования additional_info
  static String _encodeAdditionalInfo(Map<String, dynamic> data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      return '{}';  // Возвращаем пустой объект, если произошла ошибка при кодировании
    }
  }
}
