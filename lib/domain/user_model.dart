class UserModel {
  String? id;
  String? phoneNumber;
  String? email;
  String? password;
  String? role;
  String? firstName;
  String? lastName;
  bool? hasProfile;
  String? gender;
  bool? isOnline;
  int? availableSeats;
  int? reservedSeats;
  String? nextDestination;
  double? longitude;
  double? latitude;
  String? carColor;
  int? carYear;
  String? carModel;
  String? typeOfTrip;
  String? plateImage;
  String? insuranceImage;
  String? numberPlate;
  String? licenseImage;
  String? personalImage;
  dynamic rating;
  int? completedTrips;
  int? canceledTrips;
  bool? isApproved;

  UserModel(
      {this.id,
      this.phoneNumber,
      this.email,
      this.password,
      this.role,
      this.firstName,
      this.lastName,
      this.hasProfile,
      this.gender,
      this.isOnline,
      this.availableSeats,
      this.reservedSeats,
      this.nextDestination,
      this.longitude,
      this.latitude,
      this.carColor,
      this.carYear,
      this.carModel,
      this.typeOfTrip,
      this.plateImage,
      this.insuranceImage,
      this.numberPlate,
      this.licenseImage,
      this.personalImage,
      this.rating,
      this.completedTrips,
      this.canceledTrips,
      this.isApproved});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    hasProfile = json['hasProfile'];
    gender = json['gender'];
    isOnline = json['isOnline'];
    availableSeats = json['availableSeats'];
    reservedSeats = json['reservedSeats'];
    nextDestination = json['nextDestination'];
    longitude = json['longitude'] != null ? (json['longitude'] as num).toDouble() : null;
    latitude = json['latitude'] != null ? (json['latitude'] as num).toDouble() : null;
    carColor = json['carColor'];
    carYear = json['carYear'];
    carModel = json['carModel'];
    typeOfTrip = json['typeOfTrip'];
    plateImage = json['plateImage'];
    insuranceImage = json['insuranceImage'];
    numberPlate = json['numberPlate'];
    licenseImage = json['licenseImage'];
    personalImage = json['personalImagePath'];
    rating = json['rating'];
    completedTrips = json['completedTrips'];
    canceledTrips = json['canceledTrips'];
    isApproved = json['isApproved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['hasProfile'] = hasProfile;
    data['gender'] = gender;
    data['isOnline'] = isOnline;
    data['availableSeats'] = availableSeats;
    data['reservedSeats'] = reservedSeats;
    data['nextDestination'] = nextDestination;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['carColor'] = carColor;
    data['carYear'] = carYear;
    data['carModel'] = carModel;
    data['typeOfTrip'] = typeOfTrip;
    data['plateImage'] = plateImage;
    data['insuranceImage'] = insuranceImage;
    data['numberPlate'] = numberPlate;
    data['licenseImage'] = licenseImage;
    data['personalImagePath'] = personalImage;
    data['rating'] = rating;
    data['completedTrips'] = completedTrips;
    data['canceledTrips'] = canceledTrips;
    data['isApproved'] = isApproved;
    return data;
  }
}
