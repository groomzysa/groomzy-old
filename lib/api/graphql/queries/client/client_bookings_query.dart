import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/client_contoller.dart';

class ClientBookingsQuery {
  String get clientBookings {
    return '''
      query CLIENT_BOOKINGS_QUERY (
        \$clientId: Int!
      ) {
        clientBookings (
          clientId: \$clientId
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
            rating {
              id
              rate
              comment
            }
            provider {
              id
              fullName
            }
          }
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> getClientBookings({
    required int clientId,
  }) async {
    final ClientController clientController = Get.find();

    final client = APIClient().getAPIClient();
    final QueryOptions options = QueryOptions(
      document: gql(clientBookings),
      variables: <String, dynamic>{
        'clientId': clientId,
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

    clientController.bookings = APIUtils().formatClientBookings(
      result.data?['clientBookings']['bookings'] ?? [],
    );

    return {'status': true};
  }
}