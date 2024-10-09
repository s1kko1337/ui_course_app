import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';
import 'package:flutter_course_project/components/custom_card.dart';
import 'package:flutter_course_project/components/default_text.dart';
import 'package:flutter_course_project/components/gray_text.dart';
import 'package:flutter_course_project/components/orange_button_style.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelCard extends StatelessWidget {
  final String modelSrc;
  final String description;
  final VoidCallback onTap;

  const ModelCard({
    super.key,
    required this.modelSrc,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Вызывает открытие модального окна
      child: CustomCard(
        width: 140,
        height: 140,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: ModelViewer(
                  backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                  src: modelSrc,
                  autoRotate: true,
                  disableZoom: true,
                  alt: '3D model preview',
                ),
              ),
              const SizedBox(height: 8),
              DefaultText(
                text: description,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showModelPreviewModal(
    BuildContext context, String modelSrc, String description) {
  final colors = RootColors();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: SizedBox(
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const DefaultText(
                  text: 'Интерактивное окно предпросмотра 3D модели',
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ModelViewer(
                    backgroundColor:
                        const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                    src: modelSrc,
                    alt: 'Full 3D model preview',
                    autoRotate: true,
                    ar: true,
                    disableZoom: false,
                  ),
                ),
                const SizedBox(height: 16),
                CustomCard(
                  height: 50,
                  width: 50,
                  child: DefaultText(
                    text: description,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyles.elevatedButtonStyle(colors),
                  onPressed: () => Navigator.pop(context),
                  child: const GrayText(text: 'Закрыть'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
