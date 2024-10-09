import 'package:flutter_course_project/components/custom_card.dart';
import 'package:flutter_course_project/components/default_text.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter/material.dart';

// simple example of usage
class ModelsScreen extends StatelessWidget {
  const ModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          CustomCard(
            width: 1,
            height: 50,
            child: DefaultText(text: 'Пример модального окна.'),
          ),
          SizedBox(
            height: 25,
          ),
          CustomCard(
            width: 500,
            height: 850,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ModelViewer(
                  backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                  src:
                      'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
                  alt: 'A 3D model of an astronaut',
                  ar: true,
                  autoRotate: true,
                  //iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                  disableZoom: true,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          CustomCard(
            width: 1,
            height: 125,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: DefaultText(text: 'Тут будет описание модели'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
