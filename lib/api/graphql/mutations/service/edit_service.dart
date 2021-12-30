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
}