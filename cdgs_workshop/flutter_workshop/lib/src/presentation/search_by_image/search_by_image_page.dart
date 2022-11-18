import 'package:flutter/material.dart';
import 'package:flutter_workshop/src/core/config/theme/theme.dart';
import 'package:flutter_workshop/src/core/widgets/appbar_icon_button.dart';
import 'package:flutter_workshop/src/core/widgets/title_text.dart';
import 'package:flutter_workshop/src/presentation/search_by_image/search_by_image_page_controller.dart';
import 'package:get/get.dart';

class SearchByImagePage extends StatelessWidget {
  SearchByImagePage({Key? key}) : super(key: key);

  final _searchByImagePageController = Get.put(SearchByImagePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              _appBar(),
              GetBuilder<SearchByImagePageController>(
                builder: (SearchByImagePageController controller) {
                  return GestureDetector(
                    onTap: () {
                      _showOptions(context);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                      ),
                      margin: const EdgeInsets.all(16),
                      width: 500,
                      height: 500,
                      child: controller.image != null
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(13)),
                              child: Image.file(
                                controller.image!,
                                fit: BoxFit.cover,
                              ))
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  TitleText(
                                    color: Colors.white,
                                    text: "No Image selected",
                                  ),
                                  TitleText(
                                    color: Colors.white,
                                    text: "Tap to start",
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Icon(
                                    Icons.touch_app_outlined,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AppbarIconButton(
                Icons.arrow_back_ios,
                iconColor: Colors.black54,
                onPressed: () {
                  Get.back();
                  // Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: TitleText(text: "Image search"),
            ),
          ),
        ],
      ),
    );
  }

  Future _showOptions(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _searchByImagePageController.getImageFromGallery();
                  Navigator.pop(Get.overlayContext!);
                },
                leading: const Icon(Icons.image_outlined),
                title: const TitleText(
                  text: "Gallery",
                  fontWeight: FontWeight.w400,
                ),
              ),
              ListTile(
                onTap: () {
                  _searchByImagePageController.getImageFromCamera();
                  Navigator.pop(Get.overlayContext!);
                },
                leading: const Icon(Icons.photo_camera_outlined),
                title: const TitleText(
                  text: "Camera",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        });
  }
}
