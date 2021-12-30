class AddOperatingTimeMutation {
  String get addOperatingTime {
    return '''
      mutation ADD_OPERATING_TIME_MUTATION (
        \$day: String!
        \$startTime: String!
        \$endTime: String!
      ){
        addOperatingTime(
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