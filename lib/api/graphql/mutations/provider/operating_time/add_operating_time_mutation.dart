import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_operating_times_query.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/operating_time_controller.dart';

class AddOperatingTimeMutation {
  String get addOperatingTime {
    return '''
      mutation ADD_OPERATING_TIME_MUTATION (
        \$day: String!
        \$startTime: String!
        \$endTime: String!
      ){
        addOperatingTime(
          day: \$day
          startTime: \$startTime
          endTime: \$endTime
        ){
          message
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> addOperatingTimeMutation() async {
    final OperatingTimeController operatingTimeController = Get.find();
    final GlobalsController globalsController = Get.find();

    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(addOperatingTime),
      variables: <String, dynamic>{
        'day': operatingTimeController.day,
        'startTime': operatingTimeController.startTime,
        'endTime': operatingTimeController.endTime,
      },
      fetchPolicy: FetchPolicy.networkOnly,
      onCompleted: (dynamic results) async {
        await ProviderOperatingTimesQuery().getProviderOperatingTimes(
          providerId: globalsController.user['id'],
        );
      },
    );

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

    Map response = result.data?['addOperatingTime'];

    if (response['message'].isNotEmpty) {
      operatingTimeController.day = '';
      operatingTimeController.startTime = '';
      operatingTimeController.endTime = '';
      operatingTimeController.isLoading = false;
      return {'status': true, 'message': response['message']};
    }

    operatingTimeController.isLoading = false;
    return {'status': false, 'message': 'Something went wrong'};
  }
}