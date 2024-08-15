import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_all_sensor/src/page/cameraandmic/preview_page.dart';

class CameraAndMicPage extends StatefulWidget {
  const CameraAndMicPage({super.key, required this.cameras});

  final List<CameraDescription>? cameras;

  @override
  State<CameraAndMicPage> createState() => _CameraAndMicPageState();
}

class _CameraAndMicPageState extends State<CameraAndMicPage> {
  CameraController? _cameraController;
  bool _isRearCameraSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera and Mic Page')),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: widget.cameras?.isEmpty == true
              ? const Text("Camera not found")
              : _cameraController?.value.isInitialized == true
              ? Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(_cameraController!),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24)),
                      color: Colors.black),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 30,
                          icon: Visibility(
                            visible: widget.cameras!.length > 1,
                            child: Icon(
                              _isRearCameraSelected
                                  ? CupertinoIcons.switch_camera
                                  : CupertinoIcons
                                  .switch_camera_solid,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            setState(() =>
                            _isRearCameraSelected =
                            !_isRearCameraSelected);
                            _initializeCameraController(
                              widget.cameras?[
                              _isRearCameraSelected ? 0 : 1],
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          onPressed: () {
                            _takePicture(context);
                          },
                          iconSize: 50,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.circle,
                              color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          )
              : const Center(child: CircularProgressIndicator(),),),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeCameraController(widget.cameras?[0]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _initializeCameraController(CameraDescription? description) {
    if (description != null) {
      _cameraController = CameraController(description, ResolutionPreset.max);
      _cameraController?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
            // Handle access errors here.
              break;
            default:
            // Handle other errors here.
              break;
          }
        }
      });
    }
  }

  Future _takePicture(BuildContext context) async {
    if (_cameraController?.value.isInitialized == false) {
      return null;
    }
    if (_cameraController?.value.isTakingPicture == true) {
      return null;
    }
    try {
      if (!kIsWeb) {
        await _cameraController?.setFlashMode(FlashMode.off);
      }
      XFile? picture = await _cameraController?.takePicture();
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PreviewPage(
                  picture: picture,
                ),
          ),
        );
      }
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }
}
