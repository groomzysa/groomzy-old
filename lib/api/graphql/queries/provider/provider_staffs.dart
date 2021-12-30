class ProviderStaffsQuery {
  String get providerStaffs {
    return '''
      query PROVIDER_STAFFS_QUERY (
        \$providerId: Int!
      ) {
        providerStaffs (
          providerId: \$providerId
        ) {
          staffs {
            id
            fullName
          }
        }
      }
    ''';
  }
}