import 'dart:convert';

import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/utils/utils.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/signin_controller.dart';

class SignInClientMutation {
  String get signinClient {
    return '''
      mutation SIGNIN_CLIENT_MUTATION (
        \$email: String!
        \$password: String!
      ){
        signinClient(
          email: \$email
          password: \$password
        ){
          id
          email
          fullName
          phoneNumber
          token
          role
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> signInClientMutation() async {
    final SignInController signInController = Get.find();
    final GlobalsController globalsController = Get.find();
    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(signinClient),
      variables: <String, String>{
        'email': signInController.email,
        'password': signInController.password,
      },
    );

    final QueryResult result = await client.value.mutate(options);

    signInController.isLoading = result.isLoading;

    if (result.hasException) {
      if (result.exception?.graphqlErrors != null) {
        throw (result.exception!.graphqlErrors[0].message);
      } else {
        throw ('Something went wrong, please close and reopen the app.');
      }
    }

    Map signedIn = result.data?['signinClient'];

    if (signedIn.isNotEmpty) {
      String token = signedIn['token'];
      if (token.isNotEmpty) {
        Map user = {
          'id': signedIn['id'],
          'email': signedIn['email'],
          'fullName': signedIn['fullName'],
          'phoneNumber': signedIn['phoneNumber'],
          'role': signedIn['role'],
        };
        APIUtils().setToken(token);
        APIUtils().setUser(jsonEncode(user));
        globalsController.user = user;
        signInController.email = '';
        signInController.password = '';
        signInController.isProvider = false;

        return {'status': true};
      }
    }

    return {'status': false};
  }
}
