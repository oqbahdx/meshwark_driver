class TripModel {
  String? id;
  DateTime? date;
  String? time;
  String? startPoint;
  String? endPoint;
  double? price;
  String? userId;
  List<String>? riderIds;

  TripModel({
    this.id,
    this.date,
    this.time,
    this.startPoint,
    this.endPoint,
    this.price,
    this.userId,
    this.riderIds,
  });

  TripModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = DateTime.parse(json['date']);
    time = json['time'];
    startPoint = json['startPoint'];
    endPoint = json['endPoint'];
    price = json['price'].toDouble();
    userId = json['userId'];
    riderIds = json['riderIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date?.toIso8601String();
    data['time'] = time;
    data['startPoint'] = startPoint;
    data['endPoint'] = endPoint;
    data['price'] = price;
    data['userId'] = userId;
    data['riderIds'] = riderIds;
    return data;
  }
}
