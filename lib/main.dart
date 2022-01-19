import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? path;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final picked = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowMultiple: false,
            );

            final fls = picked?.files;
            if (fls != null && fls.isNotEmpty) {
              path = fls.first.path;
              setState(
                () {},
              );
            }
          },
          child: const Text('pick'),
        ),
        if (path != null) ...[
          Image.file(
            File(path!),
            fit: BoxFit.cover,
          ),
          FutureBuilder(
            future: GoogleMlKit.vision
                .textDetector()
                .processImage(InputImage.fromFilePath(path!)),
            builder: (context, snp) {
              if (!snp.hasData) {
                return const SizedBox();
              }

              final rec = snp.data as RecognisedText;

              return Text(rec.text);
            },
          ),
        ],
      ],
    );
  }
}
