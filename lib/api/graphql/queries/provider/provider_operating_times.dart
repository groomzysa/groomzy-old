class ProviderOperatingTimesQuery {
  String get providerOperatingTimes {
    return '''
      query PROVIDER_OPERATING_TIMES_QUERY (
        \$providerId: Int!
      ) {
        providerOperatingTimes (
          providerId: \$providerId
        ) {
          dayTimes {
            id
            time {
              startTime
              endTime
            }
            day {
              day
            }
          }
        }
      }
    ''';
  }
}