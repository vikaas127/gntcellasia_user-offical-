// Class for api tags
class Apis {
  static const String  baseUrl                = "http://brtechgeeks.pythonanywhere.com/";
  //Please don't remove "/public/api/".
  static const String  baseUrlImages                = "http://brtechgeeks.pythonanywhere.com/";
  static const String  login                  = "login";
  static const String  verify                 = "verify/";
  static const String  updateProfile              = "profile-update";
  static const String  register               = "register";
  static const String  doctors_list           = "doctors";
  static const String  doctor_detail          = "doctor_details/{id}";
  static const String  healthTip              = "blogs";
  static const String  healthTip_detail       = "blog_details/{id}";
  static const String  treatment_list         = "api/get-specialty";
  static const String  healthissues_list   = "api/get-health-issues";
 // api/get-health-issues
 // get-specialty
  static const String  book_appointment_list  = "appointments";
  static const String  medicine_detail        = "medicine_details/{id}";
  static const String  user_book_appointment  = "book_appointment";
  static const String  check_otp              = "check_otp";
  static const String  timeSlot               = "timeslot";
  static const String  add_address            = "api/post-address";
  static const String  show_address           = "api/get-address";
  static const String  delete_address         = "delete_address/{id}";
  static const String  user_detail            = "api/profile-details/";
  static const String  setting                = "setting";
  static const String  all_pharamacy          = "pharamacies";
  static const String  pharamacy_detail       = "pharmacy_details/{id}";
  static const String  book_medicine          = "book_medicine";
  static const String  add_review             = "add_review";
  static const String  cancel_appointment     = "cancel_appointment";
  static const String  medicine_order_list    = "medicines";
  static const String  update_profile         = "api/profile-update";
  static const String  medicine_order_detail  = "single_medicine/{id}";
  static const String  offer                  = "offers";
  static const String  treatmentWise_doctor   = "treatment_wise_doctor/{id}";
  static const String  update_image           = "api/profile-photo-update";
  static const String  user_notification      = "user_notification";
  static const String  banner                 = "banner";
  static const String  add_favorite_doctor    = "add_bookmark/{id}";
  static const String  show_favorite_doctor   = "faviroute_doctor";
  static const String  forgot_password        = "forgot_password";
  static const String  apply_offer            = "check_offer";
  static const String  change_password        = "doctor_change_password";
  static const String  resend_otp             = "resendOtp/{id}";
  static const String  prescription           = "prescription/{id}";
}