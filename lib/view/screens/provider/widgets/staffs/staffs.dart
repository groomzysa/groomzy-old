import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_staffs_query.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/staff_controller.dart';
import 'package:groomzy/view/screens/provider/widgets/staffs/add_staff.dart';
import 'package:groomzy/view/screens/provider/widgets/staffs/staff.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class Staffs extends StatelessWidget {
  Staffs({Key? key}) : super(key: key);

  final GlobalsController globalsController = Get.find();
  final ProviderController providerController = Get.find();
  final StaffController staffController = Get.put(StaffController());

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: ProviderStaffsQuery().getProviderStaffs(
        providerId: globalsController.user['id'],
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Obx(() => RefreshIndicator(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: AddStaff(),
                          );
                        },
                      );
                    },
                    child: const ListTile(
                      leading: Icon(Icons.add_outlined, color: Colors.green),
                      title: Text('Add new staff'),
                    ),
                  ),
                  if (providerController.staffs.isEmpty)
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      width: 250,
                      child: const Text(
                        'You currently have no staffs under your profile.',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ...providerController.staffs.map(
                        (staff) {
                      return Column(
                        children: [
                          Staff(
                            staff: staff,
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
            onRefresh: () async {
              ProviderStaffsQuery().getProviderStaffs(
                providerId: globalsController.user['id'],
              );
            },
          ));
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: Text(
              snapshot.error.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.redAccent,
              ),
            ),
          );
        }
        return const AndroidLoading();
      },
    );
  }
}
