import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_course_project/app_data_loader.dart';
import 'package:flutter_course_project/components/model_card.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

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

    List<String> loadedModelFiles = appDataManager.loadedModels;

    List<Map<String, String>> loadedModelsList = [];

    for (var i in loadedModelFiles) {
      String previewFilePath = i.replaceAll('.glb', '_preview.jpg');
      String fileName = i
          .split('/')
          .last
          .split('.')
          .first; // Получаем имя файла без расширения
      loadedModelsList.add({
        'src': "file://$i",
        'src_img': previewFilePath, 
        'description': 'Загруженная модель: $fileName',
      });
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
            imageSrc: model['src_img']!,
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
