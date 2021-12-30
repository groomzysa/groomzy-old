class ClientBookCompleteMutation {
  String get clientBookComplete {
    return '''
      mutation CLIENT_BOOK_COMPLETE_MUTATION (
        \$bookingId: Int!
        \$complete: Boolean!
      ){
        clientBookComplete(
          bookingId: \$bookingId
          complete: \$complete
        ){
          message
        }
      }
    ''';
  }
}