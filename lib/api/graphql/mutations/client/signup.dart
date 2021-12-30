class SignUpClientMutation {
  String get signupClient {
    return '''
      mutation SIGNUP_CLIENT_MUTATION (
        \$email: String!
        \$fullName: String!
        \$password: String!
        \$phoneNumber: String!
      ){
        signupClient(
          email: \$email
          fullName: \$fullName
          password: \$password
          phoneNumber: \$phoneNumber
        ){
          message
        }
      }
    ''';
  }
}