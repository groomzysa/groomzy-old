import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/provider_controller.dart';

class ProviderStaffsQuery {
  String get providerStaffs {
    return '''
      query PROVIDER_STAFFS_QUERY (
        \$providerId: Int!
      ) {
        providerStaffs (
          providerId: \$providerId
        ) {
          staffs {
            id
            fullName
          }
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> getProviderStaffs({
    required int providerId,
  }) async {
    final ProviderController providerController = Get.find();

    final client = APIClient().getAPIClient();
    final QueryOptions options = QueryOptions(
      document: gql(providerStaffs),
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

    providerController.staffs = APIUtils().formatProviderStaffs(
      result.data?['providerStaffs']['staffs'] ?? [],
    );

    return {'status': true};
  }
}
