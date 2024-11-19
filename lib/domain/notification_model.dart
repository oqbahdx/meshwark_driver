class NotificationModel {
  String? id;
  String? userId;
  String? title;
  String? body;
  String? date;
  String? time;

  NotificationModel(
      {this.id, this.userId, this.title, this.body, this.date, this.time});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    body = json['body'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['title'] = title;
    data['body'] = body;
    data['date'] = date;
    data['time'] = time;
    return data;
  }
}
