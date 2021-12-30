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
}