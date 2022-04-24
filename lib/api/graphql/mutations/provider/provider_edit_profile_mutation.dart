import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/EditProfileController.dart';
import 'package:groomzy/controller/globals_controller.dart';

class EditProfileProviderMutation {
  String get editProfileProvider {
    return '''
      mutation EDIT_PROFILE_PROVIDER_MUTATION (
        \$fullName: String
        \$streetNumber: String
        \$streetName: String
        \$suburbName: String
        \$cityName: String
        \$provinceName: String
        \$areaCode: String
        \$latitude: Float
        \$longitude: Float
      ){
        editProfileProvider(
          fullName: \$fullName
          streetNumber: \$streetNumber
          streetName: \$streetName
          suburbName: \$suburbName
          cityName: \$cityName
          provinceName: \$provinceName
          areaCode: \$areaCode
          latitude: \$latitude
          longitude: \$longitude
        ){
          message
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> editProfileProviderMutation() async {
    final EditProfileController editProfileController = Get.find();
    final GlobalsController globalsController = Get.find();
    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(editProfileProvider),
      variables: <String, dynamic>{
        'fullName': editProfileController.fullName,
        'streetNumber': editProfileController.streetNumber,
        'streetName': editProfileController.streetName,
        'suburbName': editProfileController.suburbName,
        'cityName': editProfileController.cityName,
        'provinceName': editProfileController.provinceName,
        'areaCode': editProfileController.areaCode,
        'latitude': editProfileController.latitude,
        'longitude': editProfileController.longitude,
      },
    );

    editProfileController.isLoading = true;
    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      editProfileController.isLoading = false;
      if (result.exception?.graphqlErrors != null) {
        throw (result.exception!.graphqlErrors[0].message);
      } else {
        throw ('Something went wrong, please close and reopen the app.');
      }
    }

    Map editProfile = result.data?['editProfileProvider'];

    if (editProfile.isNotEmpty) {
      String message = editProfile['message'];
      if (message.isNotEmpty) {
        editProfileController.isProvider = false;
        editProfileController.showPassword = false;
        editProfileController.isLoading = false;

        return {
          'status': true,
          'message': message,
        };
      }
    }
    editProfileController.isLoading = false;
    return {
      'status': false,
      'message':
          'Oops! Something went wrong, please report at info@groomzy.co.za'
    };
  }
}
