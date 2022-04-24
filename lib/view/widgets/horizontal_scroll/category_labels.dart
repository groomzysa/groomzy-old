import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/widgets/category/category.dart';

class AndroidCategoryLabels extends StatelessWidget {
  const AndroidCategoryLabels({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<Map> categories = [
      {'imageAssetPath': barberImage, 'category': barber, 'active': true},
      {
        'imageAssetPath': hairdresserImage,
        'category': hairdresser,
        'active': true
      },
      {
        'imageAssetPath': makeupArtistImage,
        'category': makeupArtist,
        'active': true
      },
      {'imageAssetPath': spaImage, 'category': spa, 'active': true},
      {
        'imageAssetPath': nailTechnicianImage,
        'category': nailTechnician,
        'active': true
      },
    ];
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 5.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          ...categories
              .map(
                (category) => AndroidCategory(
                  imageAssetPath: category['imageAssetPath'],
                  category: category['category'],
                  active: category['active'],
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
