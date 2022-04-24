import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/signup_controller.dart';

class SignUpProviderMutation {
  String get signupProvider {
    return '''
      mutation SIGNUP_PROVIDER_MUTATION (
        \$email: String!
        \$fullName: String!
        \$password: String!
        \$phoneNumber: String!
      ){
        signupProvider(
          email: \$email
          fullName: \$fullName
          password: \$password
          phoneNumber: \$phoneNumber
        ){
          message
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> signUpProviderMutation() async {
    final SignupController signupController = Get.find();
    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(signupProvider),
      variables: <String, String>{
        'fullName': signupController.fullName,
        'phoneNumber': signupController.phoneNumber,
        'email': signupController.email,
        'password': signupController.password,
      },
    );

    signupController.isLoading = true;
    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      signupController.isLoading = false;
      if (result.exception?.graphqlErrors != null) {
        throw (result.exception!.graphqlErrors[0].message);
      } else {
        throw ('Something went wrong, please close and reopen the app.');
      }
    }

    Map signedUp = result.data?['signupProvider'];

    if (signedUp.isNotEmpty) {
      String message = signedUp['message'];
      if (message.isNotEmpty) {
        signupController.fullName = '';
        signupController.email = '';
        signupController.phoneNumber = '';
        signupController.password = '';
        signupController.isProvider = false;
        signupController.showPassword = false;
        signupController.isLoading = false;

        return {
          'status': true,
          'message': message,
        };
      }
    }
    signupController.isLoading = false;
    return {
      'status': false,
      'message':
          'Oops! Something went wrong, please report at info@groomzy.co.za'
    };
  }
}
