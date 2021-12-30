import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/mutations/client/book_complete.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/checkout/checkout.dart';
import 'package:groomzy/view/widgets/alert_dialog/alert_dialog.dart';

class CheckoutScreen extends StatelessWidget {
  static final String routeName =
      '/${checkoutTitle.toLowerCase().replaceAll(' ', '')}';

  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map arguments = Get.arguments;
    final String name = arguments['name'];
    final String description = arguments['description'];
    final double price = arguments['price'];
    final int bookingId = arguments['bookingId'];

    return Mutation(
      options: MutationOptions(
        document: gql(ClientBookCompleteMutation().clientBookComplete),
        update: (
          GraphQLDataProxy? cache,
          QueryResult? result,
        ) {
          if (result!.hasException) {
            String errMessage = result.exception!.graphqlErrors[0].message;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AndroidAlertDialog(
                  title: 'Error',
                  message: Text(
                    errMessage,
                    style: const TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                  popTimes: 2,
                );
              },
            );
          }
        },
        onCompleted: (dynamic clientBookCompleteResult) async {
          if (clientBookCompleteResult != null) {
            String message =
                clientBookCompleteResult['clientBookComplete']['message'];
            if (message.isNotEmpty) {
              Get.defaultDialog(
                title: 'Hooray!',
                content: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.lightGreen,
                  ),
                ),
              );
            }
          }
        },
      ),
      builder: (
        RunMutation? runClientBookCompleteMutation,
        QueryResult? clientBookCompleteResult,
      ) {
        return Checkout(
          bookingId: bookingId,
          clientBookCompleteMutation: runClientBookCompleteMutation,
          description: description,
          name: name,
          price: price,
        );
      },
    );
  }
}
