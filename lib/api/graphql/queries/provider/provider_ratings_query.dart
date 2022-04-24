class ProviderRatingsQuery {
  String get providerRatings {
    return '''
      query PROVIDER_RATINGS_QUERY (
        \$providerId: Int!
      ) {
        providerRatings (
          providerId: \$providerId
        ) {
          bookings {
            rating {
              rate
              comment
            }
            client {
              fullName
            }
          }
        }
      }
    ''';
  }
}