class ClientBookDeleteMutation {
  String get clientBookDelete {
    return '''
      mutation CLIENT_BOOK_DELETE_MUTATION (
        \$bookingId: Int!
        \$delete: Boolean!
      ){
        clientBookDelete(
          bookingId: \$bookingId
          delete: \$delete
        ){
          message
        }
      }
    ''';
  }
}