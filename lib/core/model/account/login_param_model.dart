class LoginParamModel {
  String login;
  String password;
  LoginParamModel (this.login, this.password);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['password'] = this.password;
    return data;
  }
}