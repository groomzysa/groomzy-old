import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_staffs.dart';
import 'package:groomzy/view/screens/provider/widgets/staffs/add_staff.dart';
import 'package:groomzy/view/screens/provider/widgets/staffs/staff.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';

class Staffs extends StatelessWidget {
  final int providerId;

  const Staffs({required this.providerId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(ProviderStaffsQuery().providerStaffs),
        variables: {'providerId': providerId},
      ),
      builder: (
        QueryResult? providerStaffsResult, {
        Future<void> Function()? refetch,
        FetchMore? fetchMore,
      }) {
        String? errorMessage;
        if (providerStaffsResult!.hasException) {
          if (providerStaffsResult.exception!.graphqlErrors.isNotEmpty) {
            errorMessage =
                providerStaffsResult.exception!.graphqlErrors[0].message;
          }
        }

        if (providerStaffsResult.isLoading) {
          return const AndroidLoading();
        }

        Map<String, dynamic>? data = providerStaffsResult.data;
        List staffs = [];

        if (data != null && data['providerStaffs'] != null) {
          staffs = data['providerStaffs']['staffs'] ?? [];
        }

        return RefreshIndicator(
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
                    title: Text('Click to add new staff'),
                  ),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                if (staffs.isEmpty)
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: const Text(
                      'You currently have no staffs.',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ...staffs.map(
                  (staff) {
                    return Column(
                      children: [
                        Staff(
                          fullName: staff['fullName'],
                          staffId: staff['id'],
                        ),
                      ],
                    );
                  },
                ).toList(),
              ],
            ),
          ),
          onRefresh: refetch!,
        );
      },
    );
  }
}
