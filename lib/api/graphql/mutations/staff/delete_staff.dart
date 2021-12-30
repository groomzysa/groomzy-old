class DeleteStaffMutation {
  String get deleteStaff {
    return '''
      mutation DELETE_STAFF_MUTATION (
        \$staffId: Int!
      ){
        deleteStaff(
          staffId: \$staffId
        ){
          message
        }
      }
    ''';
  }
}