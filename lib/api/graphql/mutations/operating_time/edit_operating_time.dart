class EditOperatingTimeMutation {
  String get editOperatingTime {
    return '''
      mutation EDIT_OPERATING_TIME_MUTATION (
        \$dayTimeId: Int!
        \$day: String!
        \$startTime: String
        \$endTime: String
      ){
        editOperatingTime(
          dayTimeId: \$dayTimeId
          day: \$day
          startTime: \$startTime
          endTime: \$endTime
        ){
          message
        }
      }
    ''';
  }
}