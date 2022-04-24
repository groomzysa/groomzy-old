import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/queries/client/client_bookings_query.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/controller/globals_controller.dart';

class ClientBookingRateMutation {
  String get clientBookingRate {
    return '''
      mutation CLIENT_BOOKING_RATE_MUTATION (
        \$bookingId: Int!
        \$ratingId: Int
        \$rate: Float!
        \$comment: String
      ){
        clientBookingRate(
          bookingId: \$bookingId
          ratingId: \$ratingId
          rate: \$rate
          comment: \$comment
        ){
          message
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> clientBookingRateMutation() async {
    final BookController bookController = Get.find();
    final GlobalsController globalsController = Get.find();

    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(clientBookingRate),
      variables: <String, dynamic>{
        'bookingId': bookController.id,
        'ratingId': bookController.ratingId,
        'rate': bookController.rating,
        'comment': bookController.comment,
      },
      fetchPolicy: FetchPolicy.networkOnly,
      onCompleted: (dynamic results) async {
        await ClientBookingsQuery().getClientBookings(
          clientId: globalsController.user['id'],
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

    Map editProfile = result.data?['clientBookingRate'];

    if (editProfile.isNotEmpty) {
      bookController.ratingId = 0;
      bookController.comment = '';
      bookController.rating = 0.0;
      bookController.rate = false;
      bookController.isLoading = false;
      String message = editProfile['message'];
      return {
        'status': true,
        'message': message,
      };
    }
    bookController.isLoading = false;
    return {
      'status': false,
      'message':
      'Oops! Something went wrong, please report at info@groomzy.co.za'
    };
  }
}
