import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/signup_controller.dart';

class SignUpClientMutation {
  String get signupClient {
    return '''
      mutation SIGNUP_CLIENT_MUTATION (
        \$email: String!
        \$fullName: String!
        \$password: String!
        \$phoneNumber: String!
      ){
        signupClient(
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

  Future<Map<String, dynamic>> signUpClientMutation() async {
    final SignupController signupController = Get.find();
    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(signupClient),
      variables: <String, String>{
        'fullName': signupController.fullName,
        'phoneNumber': signupController.phoneNumber,
        'email': signupController.email,
        'password': signupController.password,
      },
    );

    final QueryResult result = await client.value.mutate(options);

    signupController.isLoading = result.isLoading;

    if (result.hasException) {
      if (result.exception?.graphqlErrors != null) {
        throw (result.exception!.graphqlErrors[0].message);
      } else {
        throw ('Something went wrong, please close and reopen the app.');
      }
    }

    Map signedUp = result.data?['signupClient'];

    if (signedUp.isNotEmpty) {
      String message = signedUp['message'];
      if (message.isNotEmpty) {
        return {'status': true, 'message': message};
      }
    }

    return {'status': false};
  }
}