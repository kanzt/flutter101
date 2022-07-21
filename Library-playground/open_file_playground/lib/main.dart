import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file_playground/main_viewmodel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('open_file example app'),
        ),
        body: GetBuilder<MainViewModel>(
          init: MainViewModel(),
          builder: (mainViewModel) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Text(mainViewModel.openResult),
                  ElevatedButton(
                    onPressed: () {
                      mainViewModel.downloadAndOpen(
                          "http://www.africau.edu/images/default/sample.pdf",
                          // "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
                          "dummy.pdf");
                    },
                    child: const Text("Download & Open (PDF)"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      mainViewModel.downloadAndOpen(
                          "https://filesamples.com/samples/document/docx/sample1.docx",
                          "sample1.docx");
                    },
                    child: const Text("Download & Open (docx)"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
