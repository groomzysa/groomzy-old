import 'package:flutter/material.dart';
import 'package:groomzy/view/screens/provider/widgets/staffs/delete_staff.dart';
import 'package:groomzy/view/screens/provider/widgets/staffs/edit_staff.dart';

class Staff extends StatelessWidget {
  final String fullName;
  final int staffId;

  const Staff({
    required this.fullName,
    required this.staffId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade50,
      elevation: 0.5,
      child: Column(
        children: [
          const Divider(
            height: 0.0,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Name'),
              subtitle: Text(fullName),
              trailing: SizedBox(
                width: 120.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: EditStaff(
                                staffId: staffId,
                                fullName: fullName,
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.edit_outlined,
                        color: Colors.amber,
                      ),
                    ),
                    const VerticalDivider(),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteStaff(
                              staffId: staffId,
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
