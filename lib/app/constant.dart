class Constants {
  // static const String baseUrl = "http://meshwark-001-site1.jtempurl.com/api";
  // static const String hubUrl = "http://meshwark-001-site1.jtempurl.com/";
  static const String baseUrl = "https://192.168.1.126:5001/api/";
  static const String hubUrl = "https://192.168.1.126:5001/";
  // static const String baseUrl = "https://10.0.2.2:5001/api/";
  // static const String hubUrl = "https://10.0.2.2:5001/";
  static const String registerEndPoint = "/users/register";
  static const String loginEndPoint = "/users/login";
  static const String notificationsEndPoint = "/notifications";
  static const String addNotificationsEndPoint = "/notifications";
  static const String tripsEndPoint = "/trip";
  static const String getUserEndPoint = "/users";
  static const String updateUserEndPoint = "/users/update";
  static const String updateTripStatusEndPoint = "/users/updateDriverTrip";
  static const String sendDriverResponseEndPoint =
      "/RideRequest/send-driver-response";
  static const String cancelTripEndPoint = "/RideRequest/cancelTrip";
  static const String notifyRiderEndPoint = "RideRequest/sendDriverArrivalNotification";

  static const String empty = "";
  static int isBoarding = 0;
  static String id = "";
  static int carSeats = 0;
  static String firstName = "";
  static String middleName = "";
  static String lastName = "";
  static String token = "";
  static const int zero = 0;
  static const double doubleZero = 0.0;
  static const int apiTimeOut = 60000;
  static const String publicKeyApi = "pk_sbox_kphzjesonz5ofslucb2pxvmzayl";
  static const String secretKeyApi = "sk_sbox_bagh7iuewbqbe4yccyav3rnkmie";
}
