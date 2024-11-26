import 'dart:convert';
import 'dart:typed_data';

class Work {
  final int id;
  final int modelerId;
  final String pathToModel;
  final String additionalInfo;
  final String modelName;
  final String binaryFile;
  final String binaryPreview;

  Work({
    required this.id,
    required this.modelerId,
    required this.pathToModel,
    required this.additionalInfo,
    required this.modelName,
    required this.binaryFile,
    required this.binaryPreview,
  });

  // Фабричный метод для создания объекта Work из Map
  factory Work.fromMap(Map<String, dynamic> map) {
    return Work(
      id: map['id'] as int,
      modelerId: map['modeler_id'] as int,
      pathToModel: map['path_to_model'] as String,
      additionalInfo: map['additional_info'] as String,
      modelName: map['model_name'] as String,
      binaryFile: map['binary_file'] as String,
      binaryPreview: map['binary_preview'] as String,
    );
  }

  // Метод для преобразования объекта Work в Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modeler_id': modelerId,
      'path_to_model': pathToModel,
      'additional_info': additionalInfo,
      'model_name' : modelName,
      'binary_file': binaryFile,
      'binary_preview': binaryPreview,
    };
  }

  @override
  String toString() {
    return 'Work{id: $id, modelerId: $modelerId, pathToModel: $pathToModel, additionalInfo: $additionalInfo}';
  }
}
