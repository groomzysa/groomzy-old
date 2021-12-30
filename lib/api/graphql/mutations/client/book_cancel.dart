class ClientBookCancelMutation {
  String get clientBookCancel {
    return '''
      mutation CLIENT_BOOK_CANCEL_MUTATION (
        \$bookingId: Int!
        \$cancel: Boolean!
      ){
        clientBookCancel(
          bookingId: \$bookingId
          cancel: \$cancel
        ){
          message
        }
      }
    ''';
  }
}