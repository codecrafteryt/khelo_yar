/*
  ---------------------------------------
  Project: Khelo yar Mobile Application
  Date: March 30, 2026
  Author: Ameer Salman
  ---------------------------------------
  Description: Constants.
*/
int currentIndex = 0;

class Constants {
  static const String baseUrl = 'https://braelo-v1-bdaqhdc4c7d9fdb7.canadacentral-01.azurewebsites.net/';
  static const String socketsBaseUrl = 'wss://braelo-v1-bdaqhdc4c7d9fdb7.canadacentral-01.azurewebsites.net/';
      //'https://braelo-fug5gcb6c0hpbpdn.canadacentral-01.azurewebsites.net/';
  //static const String baseUrl = 'http://192.168.18.4:8000/';

  //Local Storage keys
  static const String accessToken = 'access';
  static const String refreshToken = 'refresh';
  static const String userId = 'userId';
  static const String userStatus = 'userStatus';
  static const String name = 'name';
  static const String userType = 'userType';
  static const String userEmail = 'userEmail';
  static const String businessStatus = 'user_status';
  static const String businessStatusAuth = 'user_status';
  static const String userPhoneNo = 'userPhoneNo';
  static const String deviceToken = 'deviceToken';
  static const String userName = 'userName';
  static const String businessName = 'business_name';
  // Business Local Storage keys
  static const String businessUserId = "user_id";
  static const String businessUrl = "business_url";
  static const String qrCodeUrl = "qr_code_url";
  // chat local strogae keys
  static const String chatId = 'chatId';


  //Api End points
  static const String session = 'auth/token/refresh';
  static const String login = 'auth/login/email';
  static const String register = 'auth/signup/email';
  static const String forgotPassword = 'auth/forgot/password';
  static const String verifyOtp = 'auth/verifyotp';
  static const String updatePassword = 'auth/new/password';
  static const String interests = 'auth/interests';
  static const String changePassword = 'auth/change/password';
  static const String socialLogin = 'auth/login';
  static const String logout = 'auth/api/logout';
  // static const String signupPhone = 'auth/signup/phone';
  static const String deviceTokens = 'auth/device/token';

  // End points for the add listing
  static const String vehicleListing = 'listing/vehicle';
  static const String realEstateListing = 'listing/realestate';
  static const String servicesListing = 'listing/services';
  static const String eventListing = 'listing/events';
  static const String jobListing = 'listing/jobs';
  static const String electronicListing = 'listing/electronics';
  static const String furnitureListing = 'listing/furniture';
  static const String fashionListing = 'listing/fashion';
  static const String sportsHobbyListing = 'listing/sportshobby';
  static const String kidsListing = 'listing/kids';

  // End points for get listing
  static const String allUserListings = 'listing/user/all';
  static const String getVehicleListings = 'listing/paginate/vehicle';
  static const String getRealStateListings = 'listing/paginate/realestate';
  static const String getServicesListings = 'listing/paginate/services';
  static const String getEventsListings = 'listing/paginate/events';
  static const String getJobsListings = 'listing/paginate/jobs';
  static const String getElectronicListings = 'listing/paginate/electronics';
  static const String getFurnitureListings = 'listing/paginate/furniture';
  static const String getFashionListings = 'listing/paginate/fashion';
  static const String getKidsListings = 'listing/paginate/kids';
  static const String getSportAndHobbyListings = 'listing/paginate/sportshobby';

  //End Points for Home (Recent listing & Recommended Listing)
  static const String getRecentListing = 'listing/recent';
  static const String getRecommendedListing = 'listing/recommendations';
  static const String saveListing = 'listing/save';
  static const String businessBanner = 'auth/business/banner';
  static const String lookUpListing = 'listing/lookup';

  // End points for Search Module
  static const String searches = 'listing/search_svgs';
  static const String deleteSearches = 'listing/delete/searches';
  static const String recentSearches = 'listing/recent/searches';

  // End points for Accounts Module
  static const String userFeedback = 'report/feedback';
  static const String userSubmitRequest = 'report/request';
  static const String deleteUserAccount = 'auth/user/delete';
  static const String userProfile = 'auth/user/profile';
  static const String publicProfile = 'auth/public-profile';
  static const String editProfile = 'auth/update/profile';
  static const String saveItem = 'listing/get-save';
  static const String postSaveItem = 'listing/save';

  // business dashboard endpoints
  static const String createBusiness = 'auth/business';
  static const String dashBoardData = 'auth/business/dashboard';
  static const String flipStatus = 'auth/user/flip-status';
  static const String deActiveBusiness = 'auth/business/deactivate';
  static const String activeBusiness = 'auth/business/activate';
  static const String businessListing = 'auth/business/listings';
  static const String fetchBusiness = 'auth/business/fetch';
  static const String editBusiness = 'auth/business/update';
  static const String fetchSingleBusiness = 'auth/business/fetch-single';

  //notification End points
  static const String getNotification = 'notifications/paginate';
  static const String deleteNotification = 'notifications/delete';
  static const String readNotification = 'notifications/read';

  //chat End points
  static const String createChats = 'chats/create';
  static const String getChatPaginate = 'chats/paginate';
  static const String getChatDetails = 'chats/detail';
  static const String deleteChatRoomAndMessages = 'chats/delete';
  static const String markMessagesAsRead = 'chats';
  static const String sendMedia = 'chats';

  // explore end points
  static const String explore = 'auth/business/explore';

  // recent pari ha abhi
//Message Card API pari ha abhi
// Send notification for chat alert pari ha abhi

//
}
