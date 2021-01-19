class FeedReportParamModel {
  String reason;

  FeedReportParamModel (this.reason);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    return data;
  }
}