import 'dart:convert';

class Work {
  final int id;
  final int modelerId;
  final String pathToModel;
  final String additionalInfo;

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
      additionalInfo: map['additional_info'] as String,
    );
  }

  // Метод для преобразования объекта Work в Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modeler_id': modelerId,
      'path_to_model': pathToModel,
      'additional_info': additionalInfo,
    };
  }

  @override
  String toString() {
    return 'Work{id: $id, modelerId: $modelerId, pathToModel: $pathToModel, additionalInfo: $additionalInfo}';
  }
}
