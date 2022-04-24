import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_ratings_query.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/loading/loading.dart';
import 'package:groomzy/view/widgets/rating/rating.dart';

class Reviews extends StatelessWidget {

  Reviews({Key? key}) : super(key: key);

  final ProviderController providerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Query(
      options: QueryOptions(
        document: gql(ProviderRatingsQuery().providerRatings),
        variables: {'providerId': providerController.provider.id},
      ),
      builder: (
          QueryResult? providerRatingsResult, {
            Future<void> Function()? refetch,
            FetchMore? fetchMore,
          }) {
        String? errorMessage;
        if (providerRatingsResult!.hasException) {
          if (providerRatingsResult.exception!.graphqlErrors.isNotEmpty) {
            errorMessage =
                providerRatingsResult.exception!.graphqlErrors[0].message;
          }
        }

        if (providerRatingsResult.isLoading) {
          return const AndroidLoading();
        }

        Map<String, dynamic>? data = providerRatingsResult.data;
        List bookings = [];
        List ratedBookings = [];

        if (data != null && data['providerRatings'] != null) {
          bookings = data['providerRatings']['bookings'] ?? [];

          for(var booking in bookings) {
            if (booking['rating'] != null) {
              ratedBookings.add(booking);
            }
          }
        }

        return RefreshIndicator(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                if (ratedBookings.isEmpty)
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    width: 250,
                    child: const Text(
                      'There no reviews for this provider yet.',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                if (ratedBookings.isNotEmpty)
                  ...ratedBookings.map(
                        (ratedBooking) {
                      Map rating = ratedBooking['rating'];
                      Map client = ratedBooking['client'];
                      String fullName = client['fullName'];
                      String firstName = fullName.split(' ')[0];
                      String initial = firstName[0].toUpperCase();
                      Map ratingReview = Utils().ratingReview(rating['rate']);

                      return Column(
                        children: [
                          ListTile(
                            leading: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.black12,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        initial,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(firstName),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 6.0,
                                ),
                                AndroidRating(
                                  ratingCounts: rating['rate'].toDouble(),
                                  icon: Icons.star_outline,
                                  iconColor: ratingReview['color'],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  rating['comment'],
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                )
                              ],
                            ),
                            trailing: Icon(
                              ratingReview['icon'],
                              color: ratingReview['color'],
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ).toList(),
              ],
            ),
          ),
          onRefresh: refetch!,
        );
      },
    ));
  }
}
