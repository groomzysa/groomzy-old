import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/explore_controller.dart';
import 'package:groomzy/utils/utils.dart';

class AndroidCategory extends StatelessWidget {
  final String imageAssetPath;
  final String category;
  final bool active;

  AndroidCategory({
    required this.imageAssetPath,
    required this.category,
    required this.active,
    Key? key,
  }) : super(key: key);

  final ExploreController exploreController = Get.find<ExploreController>();

  @override
  Widget build(BuildContext context) {
    Map<String, bool> currentDevice = Utils().currentDevice(context);

    double categoryWidth(){
      if(currentDevice['isTablet']!){
        return MediaQuery.of(context).size.width * 0.25;
      } else if(currentDevice['isDesktop']!){
        return MediaQuery.of(context).size.width * 0.15;
      }

      return MediaQuery.of(context).size.width * 0.3;
    }
    return Container(
      width: categoryWidth(),
      margin: const EdgeInsets.only(right: 5.0),
      child: Obx(() {
        return GestureDetector(
          child: GridTile(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor:
                      active && exploreController.category == category
                          ? Theme.of(context).primaryColor
                          : Colors.white10,
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundColor:
                        active && exploreController.category == category
                            ? Colors.white
                            : Colors.white10,
                    child: Image.asset(
                      imageAssetPath,
                      height: 50.0,
                      color: exploreController.category == category
                          ? Theme.of(context).primaryColor
                          : Colors.black54,
                    ),
                  ),
                ),
                AutoSizeText(
                  category,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: exploreController.category == category
                        ? FontWeight.w500
                        : FontWeight.normal,
                    color: exploreController.category == category
                        ? Theme.of(context).primaryColor
                        : null,
                  ),
                  maxLines: 1,
                )
              ],
            ),
          ),
          onTap: () {
            if (exploreController.category == category && active) {
              exploreController.category = '';
            } else if (exploreController.category != category && active) {
              exploreController.category = category;
            } else {
              Fluttertoast.showToast(
                msg: "Category '$category' coming soon, stay alert",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 20.0,
              );
            }
          },
        );
      }),
    );
  }
}
