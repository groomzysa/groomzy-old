import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_bookings_query.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/controller/globals_controller.dart';

class ProviderBookingDoneMutation {
  String get providerBookingDone {
    return '''
      mutation CLIENT_BOOKING_DONE_MUTATION (
        \$bookingId: Int!
        \$done: Boolean!
      ){
        providerBookingDone(
          bookingId: \$bookingId
          done: \$done
        ){
          message
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> providerBookingDoneMutation() async {
    final BookController bookController = Get.find();
    final GlobalsController globalsController = Get.find();

    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(providerBookingDone),
      variables: <String, dynamic>{
        'bookingId': bookController.id,
        'done': bookController.done,
      },
      fetchPolicy: FetchPolicy.networkOnly,
      onCompleted: (dynamic results) async {
        await ProviderBookingsQuery().getProviderBookings(
          providerId: globalsController.user['id'],
        );
      },
    );

    bookController.isLoading = true;

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      bookController.isLoading = false;
      if (result.exception?.graphqlErrors != null) {
        throw (result.exception!.graphqlErrors[0].message);
      } else {
        throw ('Something went wrong, please close and reopen the app.');
      }
    }

    Map response = result.data?['providerBookingDone'];

    if (response['message'].isNotEmpty) {
      bookController.id = 0;
      bookController.done = false;
      bookController.isLoading = false;
      return {'status': true, 'message': response['message']};
    }

    bookController.isLoading = false;
    return {'status': false, 'message': 'Something went wrong'};
  }
}
