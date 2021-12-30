class EditStaffMutation {
  String get editStaff {
    return '''
      mutation EDIT_STAFF_MUTATION (
        \$staffId: Int!
        \$fullName: String
      ){
        editStaff(
          staffId: \$staffId
          fullName: \$fullName
        ){
          message
        }
      }
    ''';
  }
}