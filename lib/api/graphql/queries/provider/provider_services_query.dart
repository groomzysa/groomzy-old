import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/provider_controller.dart';

class ProviderServicesQuery {
  String get providerServices {
    return '''
      query PROVIDER_SERVICES_QUERY (
        \$providerId: Int!
      ) {
        providerServices (
          providerId: \$providerId
        ) {
          serviceProviderCategories {
            service {
              id
              title
              description
              duration
              durationUnit
              price
              inHouse
            }
            category {
              id
              category
            }
          }
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> getProviderServices({
    required int providerId,
  }) async {
    final ProviderController providerController = Get.find();

    final client = APIClient().getAPIClient();
    final QueryOptions options = QueryOptions(
      document: gql(providerServices),
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

    providerController.providerServices =
        APIUtils().formatServiceProviderCategory(
      result.data?['providerServices']?['serviceProviderCategories'] ?? [],
    );

    return {'status': true};
  }
}
