import 'package:flutter/material.dart';
import 'package:flutter_course_project/components/custom_card.dart';
import 'package:flutter_course_project/components/model_card.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelsScreen extends StatelessWidget {
  const ModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> models = [
      {
        'src': 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
        'description':
            'Модель астронавта, разработанная пользователем тест тест тест тест тест тест тест тест'
      },
    ];

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
