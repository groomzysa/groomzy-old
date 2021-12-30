class ClientBookMutation {
  String get clientBook {
    return '''
      mutation CLIENT_BOOK_MUTATION (
        \$providerId: Int!
        \$serviceId: Int!
        \$staffId: Int!
        \$bookingDate: String!
        \$bookingTime: String!
        \$inHouse: Boolean!
        \$address: String
      ){
        clientBook(
          providerId: \$providerId
          serviceId: \$serviceId
          staffId: \$staffId
          bookingDate: \$bookingDate
          bookingTime: \$bookingTime
          inHouse: \$inHouse
          address: \$address
        ){
          id
        }
      }
    ''';
  }
}