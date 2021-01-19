class LogInResultModel {
  String accessToken;
  String tokenType;
  int expiresIn;
  int refreshTtl;

  LogInResultModel(
      {this.accessToken, this.tokenType, this.expiresIn, this.refreshTtl});

  LogInResultModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    refreshTtl = json['refresh_ttl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    data['refresh_ttl'] = this.refreshTtl;
    return data;
  }
}