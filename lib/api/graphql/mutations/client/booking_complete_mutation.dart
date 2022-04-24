import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/book_controller.dart';

class ClientBookingCompleteMutation {
  String get clientBookingComplete {
    return '''
      mutation CLIENT_BOOKING_COMPLETE_MUTATION (
        \$bookingId: Int!
        \$complete: Boolean!
      ){
        clientBookingComplete(
          bookingId: \$bookingId
          complete: \$complete
        ){
          message
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> clientBookingCompleteMutation() async {
    final BookController bookController = Get.find();

    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(clientBookingComplete),
      variables: <String, dynamic>{
        'bookingId': bookController.id,
        'complete': bookController.complete,
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

    Map editProfile = result.data?['clientBookingComplete'];

    if (editProfile.isNotEmpty) {
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
