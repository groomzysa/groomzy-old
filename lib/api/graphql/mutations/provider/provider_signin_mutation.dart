import 'dart:convert';

import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/provider_controller.dart';
import 'package:groomzy/controller/signin_controller.dart';

class SignInProviderMutation {
  String get signinProvider {
    return '''
      mutation SIGNIN_PROVIDER_MUTATION (
        \$email: String!
        \$password: String!
      ){
        signinProvider(
          email: \$email
          password: \$password
        ){
          id
          email
          fullName
          phoneNumber
          token
          role
          address{
            id
            streetNumber
            streetName
            suburbName
            cityName
            provinceName
            areaCode
          }
        }
      }
    ''';
  }

  Future<Map<String, bool>> signInProviderMutation() async {
    final SignInController signInController = Get.find();
    final GlobalsController globalsController = Get.find();
    final ProviderController providerController = Get.find();
    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(signinProvider),
      variables: <String, String>{
        'email': signInController.email,
        'password': signInController.password,
      },
      fetchPolicy: FetchPolicy.networkOnly,
    );

    signInController.isLoading = true;

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      signInController.isLoading = false;
      if (result.exception?.graphqlErrors != null) {
        throw (result.exception!.graphqlErrors[0].message);
      } else {
        throw ('Something went wrong, please close and reopen the app.');
      }
    }

    Map signedIn = result.data?['signinProvider'];

    if (signedIn.isNotEmpty) {
      String token = signedIn['token'];
      if (token.isNotEmpty) {
        Map address = signedIn['address'];
        Map user = {
          'id': signedIn['id'],
          'email': signedIn['email'],
          'fullName': signedIn['fullName'],
          'phoneNumber': signedIn['phoneNumber'],
          'role': signedIn['role'],
          'address': {
            'id': address['id'] ?? 0,
            'streetNumber': address['streetNumber'] ?? '',
            'streetName': address['streetName'] ?? '',
            'suburbName': address['suburbName'] ?? '',
            'cityName': address['cityName'] ?? '',
            'provinceName': address['provinceName'] ?? '',
            'areaCode': address['areaCode'] ?? '',
            'latitude': address['latitude'] ?? 0.0,
            'longitude': address['longitude'] ?? 0.0,
          }
        };
        APIUtils().setToken(token);
        APIUtils().setUser(jsonEncode(user));
        globalsController.user = user;
        providerController.providerId = signedIn['id'];
        signInController.email = '';
        signInController.password = '';
        signInController.showPassword = false;
        signInController.isProvider = false;
        signInController.isLoading = false;

        return {'status': true};
      }
    }

    signInController.isLoading = false;
    return {'status': false};
  }
}
