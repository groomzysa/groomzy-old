class SignInProviderMutation {
  String get signinProvider {
    return '''
      mutation SIGNIN_PROVIDER_MUTATION (
        \$email: String!
        \$password: String!
      ){
        signinProvider(
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