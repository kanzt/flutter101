import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key, required this.picture});

  final XFile? picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Page')),
      body: picture != null
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                !kIsWeb
                    ? Image.file(
                        File(picture!.path),
                        fit: BoxFit.cover,
                        width: 250,
                      )
                    : Image.network(
                        picture!.path,
                        fit: BoxFit.cover,
                      ),
                const SizedBox(height: 24),
                Text(picture!.name)
              ]),
            )
          : const SizedBox(),
    );
  }
}
