import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_services_query.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/service_controller.dart';

class EditServiceMutation {
  String get editService {
    return '''
      mutation EDIT_SERVICE_MUTATION (
        \$serviceId: Int!
        \$category: String
        \$title: String
        \$description: String
        \$duration: Float
        \$durationUnit: String
        \$price: Float
        \$inHouse: Boolean
      ){
        editService(
          serviceId: \$serviceId
          category: \$category
          title: \$title
          description: \$description
          duration: \$duration
          durationUnit: \$durationUnit
          price: \$price
          inHouse: \$inHouse
        ){
          message
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> editServiceMutation() async {
    final ServiceController serviceController = Get.find();
    final GlobalsController globalsController = Get.find();

    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
      document: gql(editService),
      variables: <String, dynamic>{
        'serviceId': serviceController.id,
        'category': serviceController.category,
        'title': serviceController.title,
        'description': serviceController.description,
        'duration': serviceController.duration,
        'durationUnit': serviceController.durationUnit,
        'price': serviceController.price,
        'inHouse': serviceController.inHouse,
      },
      fetchPolicy: FetchPolicy.networkOnly,
      onCompleted: (dynamic results) async {
        await ProviderServicesQuery().getProviderServices(
          providerId: globalsController.user['id'],
        );
      },
    );

    serviceController.isLoading = true;

    final QueryResult result = await client.value.mutate(options);

    if (result.hasException) {
      serviceController.isLoading = false;
      if (result.exception?.graphqlErrors != null) {
        throw (result.exception!.graphqlErrors[0].message);
      } else {
        throw ('Something went wrong, please close and reopen the app.');
      }
    }

    Map response = result.data?['editService'];

    if (response['message'].isNotEmpty) {
      serviceController.id = 0;
      serviceController.category = '';
      serviceController.title = '';
      serviceController.description = '';
      serviceController.duration = 0.0;
      serviceController.durationUnit = '';
      serviceController.price = 0.0;
      serviceController.inHouse = false;
      serviceController.isLoading = false;
      return {'status': true, 'message': response['message']};
    }

    serviceController.isLoading = false;
    return {'status': false, 'message': 'Something went wrong'};
  }
}
