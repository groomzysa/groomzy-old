class ProviderServicesQuery {
  String get providerServices {
    return '''
      query PROVIDER_SERVICES_QUERY (
        \$providerId: Int!
      ) {
        providerServices (
          providerId: \$providerId
        ) {
          serviceProviderCategories {
            service {
              id
              title
              description
              duration
              durationUnit
              price
              inHouse
            }
            category {
              category
            }
          }
        }
      }
    ''';
  }
}