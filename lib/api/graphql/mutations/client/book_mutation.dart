import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/provider_trading_controller.dart';
import 'package:intl/intl.dart';
import 'package:groomzy/model/service.dart' as service_model;

class ClientBookMutation {
  String get clientBook {
    return '''
      mutation CLIENT_BOOK_MUTATION (
        \$providerId: Int!
        \$serviceId: Int!
        \$staffId: Int!
        \$bookingDate: String!
        \$bookingTime: String!
        \$inHouse: Boolean!
        \$address: String
      ){
        clientBook(
          providerId: \$providerId
          serviceId: \$serviceId
          staffId: \$staffId
          bookingDate: \$bookingDate
          bookingTime: \$bookingTime
          inHouse: \$inHouse
          address: \$address
        ){
          id
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> clientBookMutation() async {
    final BookController bookController = Get.find();
    final ProviderController providerController = Get.find();
    final ProviderTradingController providerTradingController = Get.find();

    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(clientBook),
      variables: <String, dynamic>{
        'providerId': providerController.provider.id,
        'serviceId': providerTradingController.selectedService.id,
        'staffId': bookController.selectedStafferId,
        'bookingDate':
        DateFormat('yyyy-MM-dd').format(bookController.selectedDay),
        'bookingTime': bookController.selectedTime,
        'inHouse': bookController.inHouse,
        'address': bookController.serviceCallAddress,
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

    Map editProfile = result.data?['clientBook'];

    if (editProfile.isNotEmpty) {
      int? bookingId = editProfile['id'];
      if (bookingId != null) {
        bookController.selectedStafferId = 0;
        bookController.selectedDay = DateTime.now();
        bookController.selectedTime = 'none';
        bookController.inHouse = false;
        bookController.serviceCallAddress = 'none';
        bookController.isLoading = false;

        return {
          'status': true,
          'bookingId': bookingId,
        };
      }
    }
    bookController.isLoading = false;
    return {
      'status': false,
      'message':
      'Oops! Something went wrong, please report at info@groomzy.co.za'
    };
  }
}