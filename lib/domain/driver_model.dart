class DriverModel {
  int? status;
  String? message;
  Data? data;

  DriverModel({this.status, this.message, this.data});

  DriverModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? number;
  String? numberPlate;
  String? gender;
  String? carModel;
  String? carColor;
  String? carYear;
  int? seatsAvailable;
  int? seatsReserved;
  int? isOnline;
  String? service;
  String? personalImage;
  String? idImage;
  String? licenseImage;
  String? plateImage;
  String? nextDestination;
  String? tripPrice;
  int? profileCompleted;
  int? driverApproved;
  double? latitude;
  double? longitude;

  Data(
      {this.id,
      this.firstName,
      this.middleName,
      this.lastName,
      this.number,
      this.numberPlate,
      this.gender,
      this.carModel,
      this.carColor,
      this.carYear,
      this.seatsAvailable,
      this.seatsReserved,
      this.isOnline,
      this.service,
      this.personalImage,
      this.idImage,
      this.licenseImage,
      this.plateImage,
      this.nextDestination,
      this.tripPrice,
      this.profileCompleted,
      this.driverApproved,
      this.latitude,
      this.longitude});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    number = json['number'];
    numberPlate = json['number_plate'];
    gender = json['gender'];
    carModel = json['car_model'];
    carColor = json['car_color'];
    carYear = json['car_year'];
    seatsAvailable = json['seats_available'];
    seatsReserved = json['seats_reserved'];
    isOnline = json['is_online'];
    service = json['service'];
    personalImage = json['personal_image'];
    idImage = json['id_image'];
    licenseImage = json['license_image'];
    plateImage = json['plate_image'];
    nextDestination = json['next_destination'];
    tripPrice = json['trip_price'];
    profileCompleted = json['profile_completed'];
    driverApproved = json['driver_approved'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['number'] = number;
    data['number_plate'] = numberPlate;
    data['gender'] = gender;
    data['car_model'] = carModel;
    data['car_color'] = carColor;
    data['car_year'] = carYear;
    data['seats_available'] = seatsAvailable;
    data['seats_reserved'] = seatsReserved;
    data['is_online'] = isOnline;
    data['service'] = service;
    data['personal_image'] = personalImage;
    data['id_image'] = idImage;
    data['license_image'] = licenseImage;
    data['plate_image'] = plateImage;
    data['next_destination'] = nextDestination;
    data['trip_price'] = tripPrice;
    data['profile_completed'] = profileCompleted;
    data['driver_approved'] = driverApproved;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
