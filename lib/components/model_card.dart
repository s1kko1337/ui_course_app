import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';
import 'package:flutter_course_project/components/custom_card.dart';
import 'package:flutter_course_project/components/card_text.dart';
import 'package:flutter_course_project/components/gray_text.dart';
import 'package:flutter_course_project/components/orange_button_style.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelCard extends StatelessWidget {
  final String modelSrc;
  final String imageSrc;
  final String description;
  final VoidCallback onTap;

  const ModelCard({
    super.key,
    required this.modelSrc,
    required this.imageSrc,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.9;
    final cardHeight = screenHeight * 0.175;

    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        width: cardWidth,
        height: cardHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: cardHeight * 0.7,
                child: _buildImageWidget(imageSrc),
              ),
              const SizedBox(height: 8),
              CardText(
                text: description,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (Uri.tryParse(imagePath)?.isAbsolute ?? false) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
      );
    }
  }
}

void showModelPreviewModal(
    BuildContext context, String modelSrc, String description) {
  final colors = RootColors();

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final dialogWidth = screenWidth * 0.9;
  final dialogHeight = screenHeight * 0.8;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CardText(
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
                  width: dialogWidth * 0.8,
                  child: CardText(
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
