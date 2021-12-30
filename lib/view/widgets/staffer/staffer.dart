import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AndroidStaffer extends StatelessWidget {
  final String imageAssetPath;
  final String name;
  final String selectedStaffer;
  final Function onSelectStaffer;

  const AndroidStaffer({
    required this.selectedStaffer,
    required this.imageAssetPath,
    required this.name,
    required this.onSelectStaffer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 5.0),
      child: GestureDetector(
        child: GridTile(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35.0,
                backgroundColor: name == selectedStaffer
                    ? Theme.of(context).primaryColor
                    : Colors.white10,
                child: CircleAvatar(
                  radius: 32.0,
                  backgroundColor:
                      name == selectedStaffer ? Colors.white : Colors.black12,
                  child: Image.asset(
                    imageAssetPath,
                    height: 40.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              AutoSizeText(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0),
                maxLines: 1,
              )
            ],
          ),
        ),
        onTap: () {
          onSelectStaffer(name);
        },
      ),
    );
  }
}
