import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/explore_controller.dart';
import 'package:groomzy/view/widgets/text_field/text_field.dart';

class AndroidSearch extends StatelessWidget {
   AndroidSearch({
    Key? key,
  }) : super(key: key);

  final ExploreController exploreController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx( () {
      return AndroidTextField(
        value: exploreController.search,
        label: 'Search',
        suffixIcon: Icons.search_outlined,
        borderRadius: 50,
        onInputChange: (String input) {
          EasyDebounce.debounce(
            'search-deBouncer', // <-- An ID for this particular deBouncer
            const Duration(seconds: 1), // <-- The debounce duration
                () {
              exploreController.search = input;
            }, // <-- The target method
          );
        },
      );
    });
  }
}
