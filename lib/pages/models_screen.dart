import 'package:flutter/material.dart';
import 'package:flutter_course_project/app_data_loader.dart';
import 'package:flutter_course_project/components/model_card.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_course_project/app_data_loader.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ModelsScreen extends StatefulWidget {
  const ModelsScreen({super.key});

  @override
  _ModelsScreenState createState() => _ModelsScreenState();
}

class _ModelsScreenState extends State<ModelsScreen> {
  List<Map<String, String>> models = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadModels();
  }

  Future<void> loadModels() async {
    final appDataManager = AppDataManager();

    await appDataManager.readData();

    if (appDataManager.loadedModels.isEmpty) {
      await appDataManager.getModels();
    }

    // Получаем список загруженных моделей
    List<String> loadedModelFiles = appDataManager.loadedModels;

    // Получаем путь к локальной директории
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;

    // Формируем список моделей для отображения
    List<Map<String, String>> loadedModelsList = [];

    for (String fileName in loadedModelFiles) {
      //String filePath = '$localPath/$fileName';
      String filePath = 'assets/3dmodels/$fileName';
      //if (File(filePath).existsSync()) {
      loadedModelsList.add({
        'src': filePath,
        'description': 'Загруженная модель: $fileName',
      });
      //}
    }
    setState(() {
      models = loadedModelsList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (models.isEmpty) {
      return const Center(
        child: Text('Нет доступных моделей для отображения'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: models.length,
        itemBuilder: (context, index) {
          final model = models[index];
          return ModelCard(
            modelSrc: model['src']!,
            description: model['description']!,
            onTap: () => showModelPreviewModal(
              context,
              model['src']!,
              model['description']!,
            ),
          );
        },
      ),
    );
  }
}
