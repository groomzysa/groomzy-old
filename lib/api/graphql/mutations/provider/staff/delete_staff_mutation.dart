import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_staffs_query.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/staff_controller.dart';

class DeleteStaffMutation {
  String get deleteStaff {
    return '''
      mutation DELETE_STAFF_MUTATION (
        \$staffId: Int!
      ){
        deleteStaff(
          staffId: \$staffId
        ){
          message
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> deleteStaffMutation() async {
    final StaffController staffController = Get.find();
    final GlobalsController globalsController = Get.find();

    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
        document: gql(deleteStaff),
        variables: <String, dynamic>{
          'staffId': staffController.id,
        },
        fetchPolicy: FetchPolicy.networkOnly,
        onCompleted: (dynamic results) async {
          await ProviderStaffsQuery().getProviderStaffs(
            providerId: globalsController.user['id'],
          );
        });

    staffController.isLoading = true;

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      staffController.isLoading = false;
      if (result.exception?.graphqlErrors != null) {
        throw (result.exception!.graphqlErrors[0].message);
      } else {
        throw ('Something went wrong, please close and reopen the app.');
      }
    }

    Map response = result.data?['deleteStaff'];

    if (response['message'].isNotEmpty) {
      staffController.id = 0;
      staffController.fullName = '';
      staffController.isLoading = false;
      return {'status': true, 'message': response['message']};
    }

    staffController.isLoading = false;
    return {'status': false, 'message': 'Something went wrong'};
  }
}