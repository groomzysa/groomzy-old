import 'package:flutter/material.dart';

class AndroidLabels extends StatelessWidget {
  final List? categories;

  const AndroidLabels({
    this.categories,
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      margin: const EdgeInsets.only(top: 10.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: categories != null && categories!.isNotEmpty
            ? categories!
                .map(
                  (category) => Card(
                    color: Colors.white70,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 3,
                        bottom: 3,
                      ),
                      child: Text(
                        category,
                      ),
                    ),
                  ),
                )
                .toList()
            : [const Text('No categories.')].toList(),
      ),
    );
  }
}
