import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/staff_controller.dart';
import 'package:groomzy/view/screens/provider/widgets/staffs/delete_staff.dart';
import 'package:groomzy/view/screens/provider/widgets/staffs/edit_staff.dart';
import 'package:groomzy/model/staff.dart' as staff_model;

class Staff extends StatelessWidget {
  final staff_model.Staff staff;

  Staff({
    required this.staff,
    Key? key
  }) : super(key: key);

  final StaffController staffController = Get.find();

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
              subtitle: Text(staff.fullName),
              trailing: SizedBox(
                width: 120.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        staffController.id = staff.id;
                        staffController.fullName = staff.fullName;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: EditStaff(),
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
                        staffController.id = staff.id;

                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteStaff();
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
