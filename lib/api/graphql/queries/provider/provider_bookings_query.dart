import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/provider_controller.dart';

class ProviderBookingsQuery {
  String get providerBookings {
    return '''
      query PROVIDER_BOOKINGS_QUERY (
        \$providerId: Int!
      ) {
        providerBookings (
          providerId: \$providerId
        ) {
          bookings {
            id
            bookingTime
            createdAt
            status
            inHouse
            service {
              id
              title
              description
              duration
              durationUnit
              price
              inHouse
            }
            staff {
              id
              fullName
            }
            client {
              id
              fullName
              email
              phoneNumber
            }
          }
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> getProviderBookings({
    required int providerId,
  }) async {
    final ProviderController providerController = Get.find();

    final client = APIClient().getAPIClient();
    final QueryOptions options = QueryOptions(
      document: gql(providerBookings),
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

    providerController.bookings = APIUtils().formatProviderBookings(
      result.data?['providerBookings']['bookings'] ?? [],
    );

    return {'status': true};
  }
}