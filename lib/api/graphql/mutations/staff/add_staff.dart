class AddStaffMutation {
  String get addStaff {
    return '''
      mutation ADD_STAFF_MUTATION (
        \$fullName: String!
      ){
        addStaff(
          fullName: \$fullName
        ){
          message
        }
      }
    ''';
  }
}