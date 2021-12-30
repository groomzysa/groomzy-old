class ServicesQuery {
  String get services {
    return '''
      query SERVICES_QUERY {
        services {
          id
          description
          duration
          durationUnit
          inHouse
          price
          title
          serviceProviderCategories {
            category {
              category
            }
          }
        }
      }
    ''';
  }
}