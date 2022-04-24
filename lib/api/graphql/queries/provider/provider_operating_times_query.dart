import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/provider_controller.dart';

class ProviderOperatingTimesQuery {
  String get providerOperatingTimes {
    return '''
      query PROVIDER_OPERATING_TIMES_QUERY (
        \$providerId: Int!
      ) {
        providerOperatingTimes (
          providerId: \$providerId
        ) {
          dayTimes {
            id
            time {
              id
              startTime
              endTime
            }
            day {
              id
              day
            }
          }
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> getProviderOperatingTimes({
    required int providerId,
  }) async {
    final ProviderController providerController = Get.find();
    final client = APIClient().getAPIClient();
    final QueryOptions options = QueryOptions(
      document: gql(providerOperatingTimes),
      variables: <String, dynamic>{
        'providerId': providerId,
      },
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      if (result.exception?.graphqlErrors != null) {
        throw (result.exception!.graphqlErrors[0].message);
      } else {
        throw ('Something went wrong, please close and reopen the app.');
      }
    }

    providerController.operatingTimes =
        APIUtils().formatProviderOperatingTimes(
          result.data?['providerOperatingTimes']['dayTimes'] ?? [],
        );

    return {'status': true};
  }
}