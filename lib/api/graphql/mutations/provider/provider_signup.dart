class SignUpProviderMutation {
  String get signupProvider {
    return '''
      mutation SIGNUP_PROVIDER_MUTATION (
        \$email: String!
        \$fullName: String!
        \$password: String!
        \$phoneNumber: String!
      ){
        signupProvider(
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