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
      id: map['id'],
      modelerId: map['modeler_id'],
      pathToModel: map['path_to_model'],
      additionalInfo: jsonDecode(map['additional_info']),
    );
  }

  // Метод для преобразования объекта Work в Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modeler_id': modelerId,
      'path_to_model': pathToModel,
      'additional_info': jsonEncode(additionalInfo),
    };
  }
}
