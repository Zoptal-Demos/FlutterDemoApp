class ApiEndPoints {
  ApiEndPoints._();

  static String baseUrl = "http://208.68.37.50:3007/app/v1/";// Live URL
  static String imagebaseUrl = "http://208.68.37.50:3007/uploads/images/";

  // Api's Name
  static String login_api ="user/login_model_user";
  static String modelList_api ="user/get_all_models_listing";
  static String bookingList_api ="user/get_booking_by_date";
  static String addBooking_api ="user/book_model";
  static String logput_api ="user/logout_dummy";
}