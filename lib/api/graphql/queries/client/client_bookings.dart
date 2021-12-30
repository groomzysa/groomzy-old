class ClientBookingsQuery {
  String get clientBookings {
    return '''
      query CLIENT_BOOKINGS_QUERY (
        \$clientId: Int!
      ) {
        clientBookings (
          clientId: \$clientId
        ) {
          bookings {
            id
            bookingTime
            status
            inHouse
            service {
              id
              title
              description
              duration
              durationUnit
              price
              inHouse
            }
            staff {
              id
              fullName
            }
            provider {
              id
              fullName
            }
          }
        }
      }
    ''';
  }
}