/*
 ---------------------------------------
 Project: Khelo Yar Mobile Application
 Date: March 30, 2026
 Author: Ameer Salman
 ---------------------------------------
 Description: Auth Logic.
*/
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../GetServices/CheckConnectionService.dart';
import '../data/auth_repo/auth_repo.dart';

class AuthController extends GetxController {
  AuthRepo authRepo;
  SharedPreferences sharedPreferences;
  AuthController({
    required this.authRepo,
    required this.sharedPreferences,
  });
  CheckConnectionService connectionService = CheckConnectionService();

//   bool isGuest = true;
//   RxBool isPasswordVisible = false.obs;
//   RxBool isConfirmPasswordVisible = false.obs;
//   // List of topics and selected topics for user interest
//   RxList<String> topics = <String>[].obs;
//   RxList<String> selectedTopics = <String>[].obs;
//   RxBool isGuestUser = true.obs;
//   TextEditingController fullNameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//   RxBool obscurePassword = true.obs;
//   RxBool obscureConfirmPassword = true.obs;
//   String userId = "0";
//
//   // login controller's
//   TextEditingController loginEmailController = TextEditingController();
//   TextEditingController loginPasswordController = TextEditingController();
//
//   // forget password controller and stored email
//   TextEditingController forgetPasswordEmailController = TextEditingController();
//   String? storedEmail; // Store the email
//
//   //verify forget password OTP controller
//   TextEditingController verifyEmailOtpController = TextEditingController();
//
//   // enter new password controller's
//   TextEditingController newPasswordController = TextEditingController();
//   TextEditingController confirmNewPasswordController = TextEditingController();
//
//   // Toggle visibility for the password field
//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }
//
//   // Toggle visibility for the confirm password field
//   void toggleConfirmPasswordVisibility() {
//     isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
//   }
//
//   // some form key's for validation
//   final formKey = GlobalKey<FormState>(); // signup screen
//   final formKey111 = GlobalKey<FormState>(); // login with email screen
//   final formKey2 = GlobalKey<FormState>(); // forgot Password
//   final formKey3 = GlobalKey<FormState>();
//
//   // clear login text field
//   clearLoginFields() {
//     loginEmailController.clear();
//     loginPasswordController.clear();
//   }
//
//   // clear sign up text field
//   clearSignupFields() {
//     fullNameController.clear();
//     emailController.clear();
//     passwordController.clear();
//     confirmPasswordController.clear();
//   }
//
//   // clear forget password
//   clearForgotPasswordFields() {
//     forgetPasswordEmailController.clear();
//   }
//
//   // new password controller's
//   clearUpdatePasswordField() {
//     newPasswordController.clear();
//     confirmNewPasswordController.clear();
//   }
//
//   // clear verify phone no.
//   clearVerifyPhoneNoOtp() {
//     noController.clear();
//   }
//
//   // Clear clear Selected Topics
//   void clearSelectedTopics() {
//     selectedTopics.clear();
//   }
//
//   // onClose method
//   @override
//   void onClose() {
//     clearLoginFields();
//     clearSignupFields();
//     clearForgotPasswordFields();
//     clearUpdatePasswordField();
//     clearVerifyPhoneNoOtp();
//     super.onClose();
//   }
//
//   // onInit func
//   @override
//   void onInit() {
//     super.onInit();
//     fetchTopics();
//     onClose();
//     isGuestUser;
//     _locationService.getCurrentLocation();
//   }
//
//   // fetch topic's for user interest screen
//   void fetchTopics() {
//     topics.addAll(["Vehicles", "Real estate", "Services", "Events", "Jobs", "Electronics", "Furniture", "Fashion", "Kids", "Sports & Hobby",]);
//   }
//
//   // toggle func for user interest screen
//   void toggleSelection(String topic) {
//     if (selectedTopics.contains(topic)) {
//       selectedTopics.remove(topic);
//     } else {
//       selectedTopics.add(topic);
//     }
//   }
//
//   initializeFireBase() {
//     notificationServices.requestNotificationPermission();
//     notificationServices.forgroundMessage();
//     notificationServices.firebaseInit();
//     notificationServices.setupInteractMessage();
//     notificationServices.isTokenRefresh();
//     notificationServices.subscribeToTopic();
//     notificationServices.getDeviceToken();
//   }
//
//   addInterests(List<String> tags) async {
//     Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//     final accessToken = sharedPreferences.getString(Constants.accessToken);
//     if (accessToken == null) {
//       CustomToast.failToast(msg: "Session expired or not saved correctly. Please log in again.");
//       Get.offAll(() => const LoginScreen());
//       return;
//     }
//     connectionService.checkConnection().then((value) async {
//       if (!value) {
//         Get.back();
//         CustomToast.noInternetToast();
//       } else {
//         authRepo.addInterests(
//           tags: tags,
//           accessToken: accessToken,
//         ).then((response) async {
//           Get.back();
//           if (response.statusCode == 200) {
//             if (response.body["status"] == 400) {
//               CustomToast.failToast(msg: response.body["error"]);
//             } else if (response.body["status"] != 400) {
//               final ApiResponse<InterestModel> model = ApiResponse.fromJson(response.body, InterestModel.fromJson);
//               if (response.body["status"] == 201) {
//                 CustomToast.successToast(msg: model.message.toString());
//                 Get.offAll(() => const HomePages());
//               } else {
//                 CustomToast.failToast(msg: "Some Error has occurred, Try Again Later");
//               }
//             } else {
//               CustomToast.failToast(msg: "Some Error has occurred,",
//               );
//             }
//           } else {
//             CustomToast.serverErrorToast();
//           }
//         });
//       }
//     });
//   }
//
//   checkSession1() async {
//     try {
//       final isConnected = await connectionService.checkConnection();
//       if (!isConnected) {
//         CustomToast.noInternetToast();
//         return;
//       }
//       final refreshToken = sharedPreferences.getString(Constants.refreshToken);
//       if (refreshToken == null) {
//         CustomToast.failToast(msg: "Session expired or not saved correctly. Please log in again.");
//         Get.offAll(() => const LoginScreen());
//         return;
//       }
//       final response = await authRepo.checkSession(refreshToken: refreshToken);
//       if (response.statusCode == 200) {
//         final responseBody = response.body;
//         if (responseBody["status"] == 400) {
//           CustomToast.failToast(msg: "${responseBody["message"]}\n${responseBody["error"]}",);
//           Get.offAll(() => const LoginScreen());
//         } else if (responseBody["status"] != 400) {
//           final ApiResponse<LoginModel> model = ApiResponse.fromJson(responseBody, LoginModel.fromJson);
//           if (model.status == 200) {
//             isGuestUser.value = false;
//             initializeFireBase();
//             Get.offAll(() => const HomePages());
//           } else {
//             CustomToast.failToast(msg: "Some Error has occurred, Try Again Later");
//           }
//         }
//       } else if (response.statusCode == 401) {
//         Get.offAll(() => const LoginScreen());
//       } else {
//         CustomToast.serverErrorToast();
//       }
//     } catch (e) {
//       // Handle unexpected errors
//       CustomToast.failToast(msg: "An error occurred: $e");
//     }
//   }
//
//   deviceToken() async {
//     connectionService.checkConnection().then((value) {
//       if (!value) {
//         Get.back();
//         CustomToast.noInternetToast();
//       } else {
//         authRepo.deviceTokenRepo(
//           accessToken: sharedPreferences.getString(Constants.accessToken).toString(),
//           plateForm: 'android',
//           token: sharedPreferences.getString(Constants.deviceToken).toString(),
//           email: sharedPreferences.getString(Constants.userEmail) ?? 'dummy@gmail.com',
//         ).then((response) async {
//           Get.back();
//           if (response.statusCode == 200) {
//             if (response.body["status"] == 400) {
//               CustomToast.failToast(msg: response.body["error"]);
//             } else if (response.body["status"] != 400) {
//               final ApiResponse<OtpVerificationModel> model = ApiResponse.fromJson(response.body, OtpVerificationModel.fromJson);
//               if (response.body["status"] == 201) {
//                 debugPrint("Stored Refresh Token: ${sharedPreferences.getString(Constants.refreshToken)}");
//                 debugPrint("Stored Access Token: ${sharedPreferences.getString(Constants.accessToken)}");
//                 debugPrint("Stored email: ${sharedPreferences.getString(Constants.userEmail)}");
//                 debugPrint("Stored device token: ${sharedPreferences.getString(Constants.deviceToken)}");
//                 debugPrint("Print Success toast: ${model.message.toString()}");
//               } else {
//                 CustomToast.failToast(msg: "Some Error has occurred, Try Again Later");
//               }
//             } else {
//               CustomToast.failToast(msg: "Some Error has occurred,",);
//             }
//           } else {
//             CustomToast.serverErrorToast();
//           }
//         });
//       }
//     });
//   }
//
//   signUp() async {
//     Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//     connectionService.checkConnection().then((value) {
//       if (!value) {
//         Get.back();
//         CustomToast.noInternetToast();
//       } else {
//         authRepo.registerRepo(
//           name: fullNameController.text,
//           email: emailController.text,
//           password: passwordController.text,
//         ).then((response) async {
//           Get.back();
//           if (response.statusCode == 200) {
//             if (response.body["status"] == 400) {
//               CustomToast.failToast(msg: response.body["error"]);
//             } else if (response.body["status"] != 400) {
//               final ApiResponse<RegisterModel> model = ApiResponse.fromJson(response.body, RegisterModel.fromJson);
//               if (response.body["status"] == 201) {
//                 initializeFireBase();
//                 await sharedPreferences.setString(Constants.accessToken, model.data!.token.access);
//                 await sharedPreferences.setString(Constants.refreshToken, model.data!.token.refresh);
//                 await sharedPreferences.setString(Constants.userEmail, model.data!.email);
//                 await sharedPreferences.setBool(Constants.businessStatus, model.data!.businessStatus ?? false);
//                 await sharedPreferences.setString(Constants.userName, model.data?.name ?? "Guest");
//                 debugPrint("Stored Refresh Token: ${sharedPreferences.getString(Constants.refreshToken)}");
//                 debugPrint("Stored Access Token: ${sharedPreferences.getString(Constants.accessToken)}");
//                 debugPrint("Stored email: ${sharedPreferences.getString(Constants.userEmail)}");
//                 debugPrint("Stored userName: ${sharedPreferences.getString(Constants.userName)}");
//                 debugPrint("Print Success toast: ${model.message.toString()}");
//                 //CustomToast.successToast(msg: model.message.toString());
//                 clearSignupFields(); // add this to clear text fields controller's
//                 isGuestUser.value = false; // User is logged in, set guest to false
//                 deviceToken();
//                 Get.offAll(() => InterestsScreen()); // Ensure it's offAll to clear previous screens
//               } else {
//                 CustomToast.failToast(msg: "Some Error has occurred, Try Again Later");
//               }
//             } else {
//               CustomToast.failToast(msg: "Some Error has occurred,",);
//             }
//           } else {
//             CustomToast.serverErrorToast();
//           }
//         });
//       }
//     });
//   }
//
//   RxBool businessStatusAuth = false.obs;
//   login() async {
//     Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//     connectionService.checkConnection().then((value) async {
//       if (!value) {
//         Get.back();
//         CustomToast.noInternetToast();
//       } else {
//         authRepo.loginRepo(
//           email: loginEmailController.text.trim(),
//           password: loginPasswordController.text.trim(),
//         ).then((response) async {
//           Get.back();
//           if (response.statusCode == 200) {
//             if (response.body["status"] == 400) {
//               CustomToast.failToast(msg: response.body["error"]);
//             } else if (response.body["status"] != 400) {
//               final ApiResponse<LoginModel> model = ApiResponse.fromJson(response.body, LoginModel.fromJson);
//               businessStatusAuth.value = model.data!.businessStatus ?? false;
//               if (model.status == 200) {
//                 initializeFireBase();
//                 await sharedPreferences.setString(Constants.accessToken, model.data!.token?.access ?? 'PLEASE CHECK YOUR ACCESS TOKEN');
//                 await sharedPreferences.setString(Constants.refreshToken, model.data!.token?.refresh ?? 'PLEASE CHECK YOUR REFRESH TOKEN');
//                 await sharedPreferences.setString(Constants.userEmail, model.data!.email ?? 'PLEASE CHECK YOUR YOUR EMAIL');
//                 await sharedPreferences.setBool(Constants.businessStatus, model.data!.businessStatus ?? false);
//                 await sharedPreferences.setString(Constants.userName, model.data?.name ?? "Guest");
//                 await sharedPreferences.setString(Constants.businessName, model.data?.businessName?? '');
//                 await sharedPreferences.setString(Constants.userStatus, model.data?.businessStatus.toString()?? 'false');
//                 debugPrint("Stored userName: ${sharedPreferences.getString(Constants.userName)}");
//                 debugPrint("Stored business name: ${sharedPreferences.getString(Constants.businessName)}");
//                 debugPrint("Stored Refresh Token: ${sharedPreferences.getString(Constants.refreshToken)}");
//                 debugPrint("Stored Access Token: ${sharedPreferences.getString(Constants.accessToken)}");
//                 debugPrint("Stored email: ${sharedPreferences.getString(Constants.userEmail)}");
//                 debugPrint("Stored user status: ${sharedPreferences.getString(Constants.userStatus)}");
//                 //CustomToast.successToast(msg: model.message.toString());
//                 clearLoginFields();
//                 isGuestUser.value = false;
//                 deviceToken();
//                 Get.offAll(() => const HomePages());
//               } else {
//                 CustomToast.failToast(msg: "Some Error has occurred, Try Again Later");
//               }
//             } else {
//               CustomToast.failToast(msg: "Some Error has occurred,");
//             }
//           } else {
//             CustomToast.serverErrorToast();
//           }
//         });
//       }
//     });
//   }
//
//   Future<void> sendOtpToEmail() async {
//     final email = forgetPasswordEmailController.text.trim();
//     if (email.isEmpty) {
//       Get.snackbar('Error', 'Please enter a valid email',);
//       return;
//     }
//     Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//     connectionService.checkConnection().then((value) async {
//       if (!value) {
//         Get.back();
//         CustomToast.noInternetToast();
//       } else {
//         await authRepo.forgetPasswordRepo(email: email).then((response) async {
//           Get.back();
//           if (response.statusCode == 200) {
//             if (response.body["status"] == 400) {
//               CustomToast.failToast(msg: response.body["error"]);
//               return;
//             } else {
//               final ApiResponse<ForgetPasswordModel> model = ApiResponse.fromJson(response.body, ForgetPasswordModel.fromJson);
//               if (model.status == 200) {
//                 CustomToast.successToast(msg: model.message.toString());
//                 storedEmail = email;
//                 clearForgotPasswordFields();
//                 Get.off(() => ConfirmEmailOtp(),
//                 );
//               } else {
//                 Get.snackbar('Error', 'Invalid response from the server',);
//               }
//             }
//           } else {
//             CustomToast.serverErrorToast();
//           }
//         });
//       }
//     });
//   }
//
//   Future<void> resendOtp1() async {
//     if (storedEmail == null || storedEmail!.isEmpty) {
//       Get.snackbar('Error', 'No email stored. Please request OTP first.',);
//       return;
//     }
//     Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//     await authRepo.forgetPasswordRepo(email: storedEmail!).then((response) async {
//       Get.back();
//       if (response.statusCode == 200) {
//         if (response.body["status"] == 400) {
//           Get.snackbar('Error', response.body['message'] ?? 'Failed to resend OTP',
//           );
//         } else {
//           Get.snackbar('Success', 'OTP resent to your email',
//           );
//         }
//       } else {
//         CustomToast.serverErrorToast();
//       }
//     });
//   }
//
//   verifyEmailOtp(String otp) async {
//     Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//     connectionService.checkConnection().then((value) async {
//       if (!value) {
//         Get.back();
//         CustomToast.noInternetToast();
//       } else {
//         await authRepo.verifyOtpRepo(
//           otp: otp,
//           email: storedEmail!,
//         ).then((response) async {
//           Get.back();
//           if (response.statusCode == 200) {
//             if (response.body["status"] == 400) {
//               CustomToast.failToast(msg: "Invalid Otp or email");
//             } else if (response.body["status"] != 400) {
//               final ApiResponse<OtpVerificationModel> model = ApiResponse.fromJson(response.body, OtpVerificationModel.fromJson);
//               if (model.status == 200) {
//                 CustomToast.successToast(msg: model.message);
//                 Get.off(() => NewPasswordScreen());
//                 verifyEmailOtpController.clear();
//               } else {
//                 CustomToast.failToast(msg: response.body["message"] ?? "Verification failed");
//               }
//             }
//           } else {
//             Get.back();
//             CustomToast.serverErrorToast();
//           }
//         });
//       }
//     });
//   }
//
//   updatePassword(String email) async {
//     Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//     connectionService.checkConnection().then((value) async {
//       if (!value) {
//         Get.back();
//         CustomToast.noInternetToast();
//       } else {
//         await authRepo.updatePasswordRepo(
//           email: email,
//           newPassword: newPasswordController.text,
//           confirmPassword: confirmNewPasswordController.text,
//         ).then((response) {
//           Get.back();
//           if (response.statusCode == 200) {
//             if (response.body["status"] == 400) {
//               CustomToast.failToast(msg: response.body["error"]);
//             } else if (response.body["status"] != 400) {
//               final ApiResponse<NewPasswordModel> model = ApiResponse.fromJson(response.body, NewPasswordModel.fromJson);
//               if (response.body["status"] == 201) {
//                 CustomToast.successToast(msg: model.message);
//                 clearUpdatePasswordField();
//                 Get.offAll(() => LoginWithEmailScreen());
//               } else {
//                 CustomToast.failToast(msg: response.body["error"] ?? "Failed to update password");
//               }
//             }
//           } else {
//             Get.back();
//             CustomToast.serverErrorToast();
//           }
//         });
//       }
//     });
//   }
//
//   logout() async {
//     //logout method
//     Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//     final accessToken = sharedPreferences.getString(Constants.accessToken);
//     final refreshToken = sharedPreferences.getString(Constants.refreshToken);
//     if (accessToken == null && refreshToken == null) {
//       CustomToast.failToast(msg: "Session expired or not saved correctly. Please log in again.");
//       Get.offAll(() => const LoginScreen());
//       return;
//     }
//     connectionService.checkConnection().then((value) async {
//       if (!value) {
//         Get.back();
//         CustomToast.noInternetToast();
//       } else {
//         await authRepo.logoutRepo(
//             accessToken: accessToken.toString(),
//             refreshToken: refreshToken.toString()).then((response) {
//           Get.back();
//           if (response.statusCode == 200) {
//             if (response.body["status"] == 400) {
//               CustomToast.failToast(msg: response.body["error"]);
//             } else if (response.body["status"] != 400) {
//               final ApiResponse<NewPasswordModel> model = ApiResponse.fromJson(response.body, NewPasswordModel.fromJson);
//               if (response.body["status"] == 200) {
//                 sharedPreferences.remove(Constants.userId);
//                 sharedPreferences.remove(Constants.accessToken);
//                 sharedPreferences.remove(Constants.refreshToken);
//                 sharedPreferences.remove(Constants.userName);
//                 sharedPreferences.remove(Constants.businessName);
//                 sharedPreferences.remove(Constants.userEmail);
//                 sharedPreferences.remove(Constants.userType);
//                 sharedPreferences.remove(Constants.deviceToken);
//                 clearSelectedTopics();
//                 //CustomToast.successToast(msg: model.message);
//                 debugPrint(model.message);
//                 isGuestUser.value = true;
//                 Get.offAll(() => const LoginScreen());
//               } else {
//                 CustomToast.failToast(msg: response.body["error"] ?? "Failed to update password");
//               }
//             }
//           } else {
//             Get.back();
//             CustomToast.serverErrorToast();
//           }
//         });
//       }
//     });
//   }
//
//   // verifyPhoneNoOtp() async {
//   //   Get.dialog(const Center(child: CustomLoadingIndicator()),
//   //       barrierDismissible: false);
//   //   connectionService.checkConnection().then((value) async {
//   //     if (!value) {
//   //       Get.back();
//   //       CustomToast.noInternetToast();
//   //     } else {
//   //       authRepo.verifyPhoneRepo(phoneNumber: noController.text).then((response) async {
//   //         Get.back();
//   //         if (response.statusCode == 200) {
//   //           if (response.body["status"] == 400) {
//   //             CustomToast.failToast(msg: response.body["error"]);
//   //           } else if (response.body["status"] != 400) {
//   //             final ApiResponse<LoginModel> model = ApiResponse.fromJson(response.body, LoginModel.fromJson);
//   //             if (model.status == 201) {
//   //               await sharedPreferences.setString(Constants.accessToken, model.data!.token?.access ?? 'PLEASE CHECK YOUR ACCESS TOKEN');
//   //               await sharedPreferences.setString(Constants.refreshToken, model.data!.token?.refresh ?? 'PLEASE CHECK YOUR REFRESH TOKEN');
//   //               debugPrint("Stored Refresh Token: ${sharedPreferences.getString(Constants.refreshToken)}");
//   //               debugPrint("Stored Access Token: ${sharedPreferences.getString(Constants.accessToken)}");
//   //               noController.clear();
//   //               isGuestUser.value = false;
//   //             } else {
//   //               CustomToast.failToast(msg: "Some Error has occurred, Try Again Later");
//   //             }
//   //           } else {
//   //             CustomToast.failToast(msg: "Some Error has occurred,");
//   //           }
//   //         } else {
//   //           CustomToast.serverErrorToast();
//   //         }
//   //       });
//   //     }
//   //   });
//   // }
// // 03276846591
//   // 3134066064
//   socialLogin({String? token, UserCredential? credential, String? loginType} ) async {
//     Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//     connectionService.checkConnection().then((value) async {
//       if (!value) {
//         Get.back();
//         CustomToast.noInternetToast();
//       } else {
//         await authRepo.googleSignInRepo(
//           name: credential?.additionalUserInfo!.profile?["name"] ?? "",
//           firstName: credential?.additionalUserInfo!.profile?["given_name"] ?? "",
//           lastName: credential?.additionalUserInfo!.profile?["family_name"] ?? "",
//           email: credential?.additionalUserInfo!.profile?["email"] ?? "",
//           googleId: credential?.additionalUserInfo!.profile?["sub"] ?? "",
//           isEmailVerified: credential?.additionalUserInfo!.profile?["email_verified"] ?? false,
//           loginType: loginType.toString(),
//           phoneNo:  numbers.value.phoneNumber ?? '+923276846591',
//         ).then((response) async {
//           Get.back();
//           if (response.statusCode == 200) {
//             if (response.body["status"] == 400) {
//               CustomToast.failToast(msg: response.body["message"]);
//             } else if (response.body["status"] != 400) {
//               final ApiResponse<LoginModel> model = ApiResponse.fromJson(response.body, LoginModel.fromJson);
//               if (model.status == 200) {
//                 await sharedPreferences.setString(Constants.accessToken, model.data!.token?.access ?? 'PLEASE CHECK YOUR ACCESS TOKEN');
//                 await sharedPreferences.setString(Constants.refreshToken, model.data!.token?.refresh ?? 'PLEASE CHECK YOUR REFRESH TOKEN');
//                 await sharedPreferences.setString(Constants.userEmail, model.data!.email ?? 'PLEASE CHECK YOUR YOUR EMAIL');
//                 await sharedPreferences.setBool(Constants.businessStatus, model.data!.businessStatus ?? false);
//                 await sharedPreferences.setString(Constants.userName, model.data?.name ?? "Guest user");
//                 await sharedPreferences.setString(Constants.businessName, model.data?.businessName ?? '');
//                 debugPrint("Stored userName: ${sharedPreferences.getString(Constants.userName)}");
//                 debugPrint("Stored business name: ${sharedPreferences.getString(Constants.businessName)}");
//                 debugPrint("Stored Refresh Token: ${sharedPreferences.getString(Constants.refreshToken)}");
//                 debugPrint("Stored Access Token: ${sharedPreferences.getString(Constants.accessToken)}");
//                 debugPrint("Stored email: ${sharedPreferences.getString(Constants.userEmail)}");
//                 CustomToast.successToast(msg: model.message.toString());
//                 isGuestUser.value = false;
//                 await deviceToken();
//                 Get.offAll(() => const HomePages());
//               } else {
//                 CustomToast.failToast(msg: "Some Error has occurred, Try Again Later");
//               }
//             }
//           } else {
//             CustomToast.serverErrorToast();
//           }
//         });
//       }
//     });
//   }
//
//   void validatePhoneNumber() {
//     if (numbers.value.phoneNumber == null || numbers.value.phoneNumber!.isEmpty) {
//       phoneError.value = "Please enter a valid phone number";
//       return;
//     } else if (numbers.value.phoneNumber!.length < 11){
//       phoneError.value = "Please enter 11-digit phone number";
//       return;
//     }
//     phoneError.value = ""; // Clear error if phone number is valid
//   }
//
//
//   final noController = TextEditingController();
//   var phoneError = ''.obs;
//   var isPhoneLoading = false.obs;
//   var numbers = Rx<PhoneNumber>(PhoneNumber(isoCode: 'US'));
//
//   void onPhoneNumberChange(PhoneNumber number) {
//     numbers.value = number;
//     debugPrint(number.phoneNumber);
//   }
//
//   verifyPhoneNumberWithFirebase() async {
//     final String phoneNumber = numbers.value.phoneNumber ?? '+923251099601';
//     if (phoneNumber.isEmpty || phoneNumber.length < 10) {// Check if the phone number is empty or invalid
//       phoneError.value = "Please enter a valid phone number";
//       debugPrint('Invalid phone number: $phoneNumber');
//       return;
//     }
//     debugPrint('Verifying phone number: $phoneNumber');
//     Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//     _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,  // <-- Correct phone number is passed here
//       timeout: const Duration(seconds: 30),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         debugPrint('Verification completed with credential: $credential');
//         try {
//           await _auth.signInWithCredential(credential);
//           debugPrint('Successfully signed in with phone number.');
//           Get.back();
//         } catch (e) {
//           Get.back();
//           debugPrint('Sign in failed: $e');
//           CustomToast.failToast(msg: "Sign in failed");
//         }
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         CustomToast.failToast(msg: "Verification failed");
//         debugPrint('Verification failed: ${e.message}');
//         Get.back();
//       },
//       codeSent: (String verificationId, int? token) {
//         CustomToast.successToast(msg: "Code sent successfully");
//         debugPrint('Code sent with verification ID: $verificationId');
//         debugPrint('Token: $token');
//         Get.back();
//         Get.to(() => VerifyOtpNumber( verificationId: verificationId, phoneNumber: phoneNumber,));
//         noController.clear();
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         //CustomToast.failToast(msg: "Code auto-retrieval time out");
//         Get.back();
//         debugPrint('Code auto-retrieval timeout with verification ID: $verificationId');
//       },
//     );
//     debugPrint('Phone number verification process initiated.');
//   }
//
//
// // ###########
//   final otpController = TextEditingController();
//   RxBool canResend = false.obs;
//   late String verificationId;
// // method for verify OTP
//   verifyOtp(String otp) async {
//     // methods for verify OTP
//     final credential = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: otp,
//     );
//     try {
//       // Show the loading dialog
//       Get.dialog(const Center(child: CustomLoadingIndicator()), barrierDismissible: false);
//       await _auth.signInWithCredential(credential); // Try signing in with the credential
//       Get.back(); // Close the loading dialog
//       //CustomToast.successToast(msg: "Welcome, Login successful");
//       await socialLogin(loginType: "phone");
//       // Get.offAll(() => const HomePages());
//     } catch (e) {
//       Get.back(); // Close the loading dialog
//       CustomToast.failToast(msg: "Verification Failed!");
//       debugPrint('Sign-in failed: ${e.toString()}');
//     }
//   }
//
//   resendCode(String phoneNumber) async {
//     // Firebase methods for resend OTP Code
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       timeout: const Duration(seconds: 30),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         Get.offAll(() => const HomePages());
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         CustomToast.failToast(msg: "Verification failed");
//         debugPrint('Verification failed: ${e.message}');
//       },
//       codeSent: (String verificationId, int? token) {
//         this.verificationId = verificationId;
//         canResend.value = false;
//         CustomToast.successToast(msg: "Code resend Successfully");
//         startTimer();
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         CustomToast.failToast(msg: "Code auto-retrieval time out");
//         debugPrint('Code auto-retrieval timeout: $verificationId');
//       },
//     );
//   }
//
//   // method for checking OTP Timer
//   void startTimer() {
//     //timer for resend OTP
//     Future.delayed(const Duration(seconds: 60), () {
//       canResend.value = true;
//     });
//   }
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   User? _user;
//   Future<void> signInWithGoogle() async { // Sign in with google method
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         CustomToast.failToast(msg: "Login failed");
//         return;
//       }
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       debugPrint("Access Token: ${googleAuth.accessToken}");
//       debugPrint("ID Token: ${googleAuth.idToken}");
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       final UserCredential userCredential = await _auth.signInWithCredential(credential);
//       debugPrint("user Credential: ${userCredential.additionalUserInfo}");
//       final User? user = userCredential.user;
//       _user = user;
//       _user = userCredential.user;
//       if (user != null) {
//         await socialLogin(credential: userCredential, token: googleAuth.idToken, loginType: "google");
//       } else {
//         CustomToast.failToast(msg: "Login failed");
//       }
//     } catch (e) {
//       CustomToast.failToast(msg: "Error during login: $e");
//     }
//   }
//
//   // Method for sign out from google
//   Future<void> signOutFromGoogle() async { // Sign out from google 3276846591
//     // logout with google
//     await _googleSignIn.signOut();
//     await _auth.signOut();
//   }
//
//   Future<User?> signInWithApple() async { // Sign-in with Apple
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     User? user;
//
//     if (kIsWeb) {
//       // Web-specific implementation
//       try {
//         final OAuthProvider authProvider = OAuthProvider("apple.com");
//         final UserCredential userCredential = await auth.signInWithPopup(authProvider);
//         user = userCredential.user;
//       } catch (e) {
//         if (kDebugMode) {
//           print(e);
//         }
//       }
//     } else {
//       // iOS and macOS implementation
//       try {  // Request Apple ID credentials
//         final AuthorizationCredentialAppleID appleCredential =
//         await SignInWithApple.getAppleIDCredential(
//           scopes: [
//             AppleIDAuthorizationScopes.email,
//             AppleIDAuthorizationScopes.fullName,
//           ],
//         );
//         // Create Firebase credential
//         final OAuthCredential credential = OAuthProvider("apple.com").credential(
//           idToken: appleCredential.identityToken,
//           accessToken: appleCredential.authorizationCode,
//         );
//         // Sign in to Firebase
//         final UserCredential userCredential = await auth.signInWithCredential(credential);
//         user = userCredential.user;
//         // await addUserDetailsToFirestore(user!);
//         prefs.setBool('isLogin', true);
//         prefs.setBool('isGuest', false);
//         await socialLogin(loginType: "apple");
//         // Get.to(() => const HomePages());
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'account-exists-with-different-credential') {
//           log('Account exists with different credential');
//         } else if (e.code == 'invalid-credential') {
//           log('Invalid Credential');
//         }
//       } catch (e) {
//         log(e.toString());
//       }
//     }
//     return user;
//   }

}
