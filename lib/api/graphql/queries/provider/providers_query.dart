import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/model/provider.dart';

class ProvidersQuery {
  String get providersQuery {
    return '''
      query PROVIDERS_QUERY(
        \$search: String
        \$category: String
      ) {
        providers(
          search: \$search
          category: \$category
        ){
          id
          email
          fullName
          address {
            id
            streetNumber
            streetName
            suburbName
            cityName
            provinceName
            areaCode
            latitude
            longitude
          }
          dayTimes {
            id
            day {
              id
              day
            }
            time {
              id
              startTime
              endTime
            }
          }
          bookings {
            id
            bookingTime
            status
            inHouse
            createdAt
            rating {
              id
              rate
              comment
            }
            service {
              id
              description
              duration
              durationUnit
              inHouse
              price
              title
            }
            client {
              id
              fullName
              email
              phoneNumber
            }
            staff {
              id
              fullName
            }
          }
          serviceProviderCategories {
            category {
              id
              category
            }
            service {
              id
              description
              duration
              durationUnit
              inHouse
              price
              title
            }
          }
          staffs {
            id
            fullName
          }
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> getProviders({
    required String search,
    required String category,
  }) async {
    final ProviderController providerController = Get.find();
    final client = APIClient().getAPIClient();
    final QueryOptions options = QueryOptions(
      document: gql(providersQuery),
      variables: <String, dynamic>{
        'search': search,
        'category': category,
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

    List<Provider> providers = [];

    for (var p in List.from(result.data?['providers'] as List)) {
      Provider provider = APIUtils().getProviderProperties(p);
      if (provider.services != null) {
        if (provider.services!.isNotEmpty) {
          providers.add(provider);
        }
      }
    }

    providerController.providers = providers;

    return {'status': true};
  }
}
