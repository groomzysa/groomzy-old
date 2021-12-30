class DeleteOperatingTimeMutation {
  String get deleteOperatingTime {
    return '''
      mutation DELETE_OPERATING_TIME_MUTATION (
        \$dayTimeId: Int!
      ){
        deleteOperatingTime(
          dayTimeId: \$dayTimeId
        ){
          message
        }
      }
    ''';
  }
}