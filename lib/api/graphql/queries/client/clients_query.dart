class ClientsQuery {
  String get clients {
    return '''
      mutation CLIENTS_QUERY {
        clients{
          id
          email
          fullName
        }
      }
    ''';
  }
}