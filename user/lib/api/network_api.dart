import 'package:doctro/model/AddAddress.dart';
import 'package:doctro/model/Appointments.dart';
import 'package:doctro/model/Banner.dart';
import 'package:doctro/model/BookMedicine.dart';
import 'package:doctro/model/CancelAppointment.dart';
import 'package:doctro/model/DeleteAddress.dart';
import 'package:doctro/model/DetailSetting.dart';
import 'package:doctro/model/DisplayOffer.dart';
import 'package:doctro/model/Docterdetail.dart';
import 'package:doctro/model/FavoriteDoctor.dart';
import 'package:doctro/model/ForgotPassword.dart';
import 'package:doctro/model/HealthIssue.dart';
import 'package:doctro/model/HealthTip.dart';
import 'package:doctro/model/HealthTipDetail.dart';
import 'package:doctro/model/MedicineOrderDetail.dart';
import 'package:doctro/model/MedicineOrderModel.dart';
import 'package:doctro/model/Medicinedetails.dart';
import 'package:doctro/model/Notification.dart';
import 'package:doctro/model/PharamaciesDetails.dart';
import 'package:doctro/model/ResendOtp.dart';
import 'package:doctro/model/Review.dart';
import 'package:doctro/model/ShowAddress.dart';
import 'package:doctro/model/ShowFavoriteDoctor.dart';
import 'package:doctro/model/Timeslot.dart';
import 'package:doctro/model/TreatmentWishDoctor.dart';
import 'package:doctro/model/Treatments.dart';
import 'package:doctro/model/UpdateProfile.dart';
import 'package:doctro/model/UpdateUserImage.dart';
import 'package:doctro/model/UserDetail.dart';
import 'package:doctro/model/apply_offer.dart';
import 'package:doctro/model/changepassword.dart';
import 'package:doctro/model/pharamacies.dart';
import 'package:doctro/model/prescription.dart';
import 'package:doctro/model/register.dart';
import 'package:doctro/model/submitOTP.dart';
import 'package:doctro/model/verifyphone.dart';
import 'package:doctro/models/Plans.dart';
import 'package:doctro/models/Plans.dart';
import 'package:doctro/view/appointment/family/models/M_addmmember.dart';
import 'package:doctro/view/appointment/family/models/m_familymember.dart';
import 'package:retrofit/retrofit.dart';
import 'package:doctro/model/login.dart';
import 'package:dio/dio.dart';
import 'package:doctro/model/doctors.dart';
import 'package:doctro/model/bookappointments.dart';
import 'package:doctro/model/Checkotp.dart';
import 'package:retrofit/http.dart';

import 'apis.dart';

part 'network_api.g.dart';

@RestApi(baseUrl: Apis.baseUrl)
//Please don't remove "/api/".

abstract class RestClient {
  factory RestClient(Dio dio,{String? baseUrl}) = _RestClient;

  @POST(Apis.login)
  Future<log_in> loginRequest(@Body() body);

  @GET(Apis.verify)
  Future<verifyphone> verifyRequest(@Body() body,String int);
  @POST(Apis.verify)
  Future<Submitotp> SubmitOTpRequest(@Body() body,String Phn);
//updateProfile
 // @POST(Apis.update_profile)
 // Future<Submitotp> SubmitOTpRequest(@Body() body,String Phn);
  @POST(Apis.register)
  Future<register> registerRequest(@Body() body);

  @POST(Apis.doctors_list)
  Future<Doctors> doctorlist(@Body() body);

  @GET(Apis.doctor_detail)
  Future<Doctordetails> doctoedetailRequest(@Path() int? id);

  @GET(Apis.healthTip)
  Future<HealthTip> healthtipRequest();

  @GET(Apis.healthTip_detail)
  Future<HealthTipDetails> healthtipdetailRequest(@Path() int? id);

  @GET(Apis.treatment_list)
  Future<Treatments> treatmentsRequest();
  @GET(Apis.healthissues_list)
  Future<HealthIssue> HealthIssueRequest();
  @GET(Apis.book_appointment_list)
  Future<Appointments> appointmentsRequest();

  @GET(Apis.medicine_detail)
    Future<Medicinedetails> medicinedetails(@Path() int? id);

  @POST(Apis.user_book_appointment)
  Future<Bookappointments> bookappointment(@Body() body);

  @POST(Apis.check_otp)
  Future<Checkotp> checkotp(@Body() body);

  @POST(Apis.timeSlot)
  Future<Timeslot> timeslot(@Body() body);

  @POST(Apis.add_address)
  Future<AddAddress> addaddressRequest(@Body() body);

  @GET(Apis.show_address)
  Future<ShowAddress> showaddressRequest(int ?id);
  @GET(Apis.Plans)
  Future<Plans> showPlans();

  @GET(Apis.delete_address)
  Future<DeleteAddress> deleteaddressRequest(@Path() int? id);

  @GET(Apis.user_detail)
  Future<UserDetail> userdetailRequest(String p);

  @GET(Apis.setting)
  Future<DetailSetting> detailsettingRequest();

  @GET(Apis.all_pharamacy)
  Future<pharamacy> pharamaciesRequest();

  @GET(Apis.pharamacy_detail)
  Future<PharamaciesDetails> pharmaciesdetailRequest(@Path() int? id);

  @POST(Apis.book_medicine)
  Future<BookMedicine> bookMedicineRequest(@Body() body);

  @POST(Apis.add_review)
  Future<ReviewAppointment> addReviewRequest(@Body() body);

  @POST(Apis.cancel_appointment)
  Future<CancelAppointment> cancelAppointmentRequest(@Body() body);

  @GET(Apis.medicine_order_list)
  Future<MedicineOrderModel> medicineOrderRequest();

  @POST(Apis.update_profile)
  Future<UpdateProfile> updateProfileRequest(@Body() body);

  @POST(Apis.addmembers)
  Future<M_addmmember> addmembersRequest(@Body() body);
  @POST(Apis.addmembers)
  Future<M_addmmember> UpdatemembersRequest(@Body() body);
  @GET(Apis.medicine_order_detail)
  Future<MedicineOrderDetails>  medicineOrderDetailRequest(@Path() int? id);

  @GET(Apis.offer)
  Future<DisplayOffer> displayOfferRequest();

  @POST(Apis.treatmentWise_doctor)
  Future<TreatmentWishDoctor> treatmentWishDoctorRequest(@Path() int? id,@Body() body);

  @POST(Apis.familymember)
  Future<M_familymember> familymemberRequest(@Path() int? id,@Body() body);

  @POST(Apis.update_image)
  Future<UpdateUserImage> updateUserImageRequest(@Body() body);

  @GET(Apis.user_notification)
  Future<UserNotification> notificationRequest();

  @GET(Apis.banner)
    Future<Banners> bannerRequest();

  @GET(Apis.add_favorite_doctor)
  Future<FavoriteDoctor> favoriteDoctorRequest(@Path() int? id);

  @GET(Apis.show_favorite_doctor)
  Future<ShowFavoriteDoctor> showFavoriteDoctorRequest();

  @POST(Apis.forgot_password)
  Future<ForgotPassword> forgotPasswordRequest(@Body() body);

  @POST(Apis.apply_offer)
  Future<ApplyOffer> applyOfferRequest(@Body() body);

  @POST(Apis.change_password)
  Future<ChangePasswords> changePasswordRequest(@Body() body);

  @GET(Apis.resend_otp)
  Future<ResendOtp> resendOtpRequest(@Path() int? id);

  @GET(Apis.prescription)
  Future<prescription> prescriptionRequest(@Path() int? id);
}



