import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_operating_times_query.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/operating_time_controller.dart';

class DeleteOperatingTimeMutation {
  String get deleteOperatingTime {
    return '''
      mutation DELETE_OPERATING_TIME_MUTATION (
        \$dayTimeId: Int!
      ){
        deleteOperatingTime(
          dayTimeId: \$dayTimeId
        ){
          message
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> deleteOperatingTimeMutation() async {
    final OperatingTimeController operatingTimeController = Get.find();
    final GlobalsController globalsController = Get.find();

    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
        document: gql(deleteOperatingTime),
        variables: <String, dynamic>{
          'dayTimeId': operatingTimeController.id,
        },
        fetchPolicy: FetchPolicy.networkOnly,
        onCompleted: (dynamic results) async {
          await ProviderOperatingTimesQuery().getProviderOperatingTimes(
            providerId: globalsController.user['id'],
          );
        });

    operatingTimeController.isLoading = true;

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      operatingTimeController.isLoading = false;
      if (result.exception?.graphqlErrors != null) {
        throw (result.exception!.graphqlErrors[0].message);
      } else {
        throw ('Something went wrong, please close and reopen the app.');
      }
    }

    Map response = result.data?['deleteOperatingTime'];

    if (response['message'].isNotEmpty) {
      operatingTimeController.id = 0;
      operatingTimeController.isLoading = false;
      return {'status': true, 'message': response['message']};
    }

    operatingTimeController.isLoading = false;
    return {'status': false, 'message': 'Something went wrong'};
  }
}