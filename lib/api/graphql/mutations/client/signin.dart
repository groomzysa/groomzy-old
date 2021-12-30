class SignInClientMutation {
  String get signinClient {
    return '''
      mutation SIGNIN_CLIENT_MUTATION (
        \$email: String!
        \$password: String!
      ){
        signinClient(
          email: \$email
          password: \$password
        ){
          id
          email
          fullName
          phoneNumber
          token
          role
        }
      }
    ''';
  }
}