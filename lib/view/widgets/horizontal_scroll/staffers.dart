import 'package:flutter/material.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/widgets/staffer/staffer.dart';

class AndroidStaffers extends StatelessWidget {
  final String selectedStaffer;
  final Function onSelectStaffer;

  const AndroidStaffers({
    required this.selectedStaffer,
    required this.onSelectStaffer,
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<Map> staffers = [
      {'imageAssetPath': barberImage, 'name': barber},
      {'imageAssetPath': hairdresserImage, 'name': hairdresser},
      {'imageAssetPath': makeupArtistImage, 'name': makeupArtist},
      {'imageAssetPath': spaImage, 'name': spa},
      {'imageAssetPath': nailTechnicianImage, 'name': nailTechnician},
    ];
    return Container(
      height: 130,
      margin: const EdgeInsets.only(top: 10.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          ...staffers
              .map(
                (category) => AndroidStaffer(
                  selectedStaffer: selectedStaffer,
                  onSelectStaffer: onSelectStaffer,
                  imageAssetPath: category['imageAssetPath'],
                  name: category['name'],
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
