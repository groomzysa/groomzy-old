import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:groomzy/api/graphql/queries/provider/provider_services_query.dart';
import 'package:groomzy/config/client.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/controller/service_controller.dart';

class DeleteServiceMutation {
  String get deleteService {
    return '''
      mutation DELETE_SERVICE_MUTATION (
        \$serviceId: Int!
        \$category: String!
      ){
        deleteService(
          serviceId: \$serviceId
          category: \$category
        ){
          message
        }
      }
    ''';
  }

  Future<Map<String, dynamic>> deleteServiceMutation() async {
    final ServiceController serviceController = Get.find();
    final GlobalsController globalsController = Get.find();

    final client = APIClient().getAPIClient();
    final MutationOptions options = MutationOptions(
        document: gql(deleteService),
        variables: <String, dynamic>{
          'serviceId': serviceController.id,
          'category': serviceController.category,
        },
        fetchPolicy: FetchPolicy.networkOnly,
        onCompleted: (dynamic results) async {
          await ProviderServicesQuery().getProviderServices(
            providerId: globalsController.user['id'],
          );
        });

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

    Map response = result.data?['deleteService'];

    if (response['message'].isNotEmpty) {
      serviceController.id = 0;
      serviceController.category = '';
      serviceController.isLoading = false;
      return {'status': true, 'message': response['message']};
    }

    serviceController.isLoading = false;
    return {'status': false, 'message': 'Something went wrong'};
  }
}