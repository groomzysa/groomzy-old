class StaffsQuery {
  String get staffs {
    return '''
      query STAFFS_QUERY {
        staffs {
          id
          fullName
        }
      }
    ''';
  }
}