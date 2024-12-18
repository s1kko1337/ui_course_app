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
  List<Map<String, dynamic>> models = [];
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
    List<String> loadedModelInfo = appDataManager.loadedInfoAboutModels;
    List<String> loadedModelsName = appDataManager.loadedModelsNames;
    List<int> loadedModelID = appDataManager.loadedModelsId;
    log(loadedModelInfo.toString());
    List<Map<String, dynamic>> loadedModelsList = [];

    for (int index = 0; index < loadedModelFiles.length; index++) {
      String i = loadedModelFiles[index];
      String previewFilePath = i.replaceAll('.glb', '_preview.jpg');

      loadedModelsList.add({
        'src': "file://$i",
        'src_img': previewFilePath,
        'description': loadedModelsName[index],
        'description_fr': loadedModelInfo[index],
        'id': loadedModelID[index]
      });
    }

    setState(() {
      models = loadedModelsList;
      log(models.toString());
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
            id: model['id']!,
            onTap: () => showModelPreviewModal(
              context,
              model['src']!,
              model['description_fr']!,
              model['id']!,
            ),
          );
        },
      ),
    );
  }
}
