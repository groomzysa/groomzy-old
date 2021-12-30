class AddServiceMutation {
  String get addService {
    return '''
      mutation ADD_SERVICE_MUTATION (
        \$category: String!
        \$title: String!
        \$description: String!
        \$duration: Float!
        \$durationUnit: String!
        \$price: Float!
        \$inHouse: Boolean!
      ){
        addService(
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