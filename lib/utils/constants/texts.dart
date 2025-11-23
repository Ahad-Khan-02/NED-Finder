/* -- App Text Strings -- */

/// This class contains all the text strings used in the NED Finder app.
class CustomTexts {
  // -- GLOBAL Texts --
  static const String appName = "NED Finder";
  static const String yes = "Yes";
  static const String no = "No";
  static const String ok = "OK";
  static const String next = "Next";
  static const String back = "Back";
  static const String submit = "Submit Report";
  static const String close = "Close";
  static const String edit = "Edit";
  static const String done = "Done";
  static const String continueText = "Continue";
  static const String success = "Success";
  static const String error = "Error";
  static const String alert = "Alert";
  static const String loading = "Loading...";

  // -- Splash & Onboarding --
  static const String splashTitle = "NED Finder";
  static const String splashTagLine = "Lost Something? Find It Fast!";

  static const String onboardingTitle1 = "Welcome to NED Finder";
  static const String onboardingSubTitle1 =
      "An efficient way to manage lost and found items at NED University.";

  static const String onboardingTitle2 = "Report Lost or Found Items";
  static const String onboardingSubTitle2 =
      "Submit details, upload photos, and help others reclaim their belongings.";

  static const String onboardingTitle3 = "Connect and Retrieve";
  static const String onboardingSubTitle3 =
      "Easily connect with finders or claim lost items securely.";

  // -- Authentication Screens --
  static const String login = "Login";
  static const String signup = "Signup";
  static const String logout = "Logout";
  static const String email = "E-Mail";
  static const String password = "Password";
  static const String username = "Username";
  static const String fullName = "Full Name";
  static const String year = "Year";
  static const String selectUser = 'Select User';
  static const String selectDepartment = 'Select Department';
  static const String rememberMe = "Remember Me?";
  static const String dontHaveAccount = "Don't have an account?";
  static const String signUpHere = 'Sign Up Here';
  static const String alreadyHaveAccount = "Already have an account?";
  static const String forgotPassword = "Forgot Password?";
  static const String resetPassword = "Reset Password";
  static const String verifyEmail = "Verify Email";
  static const String resendEmail = "Resend Email";

  static const String loginTitle = "Welcome Back!";
  static const String loginSubTitle =
      "Login to continue reporting or claiming lost items.";
  static const String signUpTitle = "Create an Account";
  static const String signUpSubTitle =
      "Join NED Finder to help others and recover your belongings.";
  static const String verifyEmailSubTitle =
      "A verification link has been sent to your email. Please verify to continue.";

  // -- OTP Verification --
  static const String otpVerification = "OTP Verification";
  static const String otpSubTitle =
      "Enter the 6-digit code sent to your registered phone number.";
  static const String resendOTP = "Resend OTP";
  static const String otpNotReceived = "Didn’t receive OTP?";
  static const String otpSent = "OTP sent successfully.";



// --- Navigation Labels ---
  static const String home = 'Home';
  static const String myItems = 'My Items';
  static const String settings = 'Settings';
  static const String userName= 'Ahad';
  static const String userRole = 'Student';



  // -------------------------
  // -- Dashboard / Home --
  // -------------------------

  // The UI doesn't show a large "Welcome" header, just the page title "Home".
  // Keeping these for potential future use or if the original design included it.
  static const String dashboardTitle = "Welcome,";
  static const String dashboardSubTitle = "Manage lost and found items efficiently.";

  static const String searchItems = "Search"; // Simplified to match the input field hint
  
  static const String addItem = "Report Found Item"; // New button text
  static const String reportItem = "Report Lost Item"; // Button text
  
  // Card Status Tags (Used in the item card)
  static const String statusFound = "Found";
  static const String statusMissing = "Missing";
  
  // Card Actions
  static const String viewItem = "View Item";
  
  // --- General ---
  static const String noItemsFound = "No items found.";


  // -- Report / Claim Forms --
  static const String reportLostItem = "Report Lost Item";
  static const String reportLostItemTitle = "Lost Something?";
  static const String reportFoundItemTitle = "Found Something?";
  static const String reportLostItemDescription = "Provide details so we can help you find it.";
  static const String reportFoundItem = "Report Found Item";
  static const String reportFoundItemDescription = "Provide details so we can help you claim it.";
  static const String claimItemButton = "Claim This Item";


  // -- Report Item Form Fields --
  static const String itemName = "Item Name";
  static const String category = "Category";
  static const String selectCategory = "Select Category";
  static const String dateLost = "Date Lost";
  static const String dateFound = "Date Found";
  static const String locationLostHint = "Location Lost (e.g., Library, 1st floor)";
  static const String locationFoundHint = "Location Found (e.g., Library, 1st floor)";
  static const String description = "Description";
  static const String uploadImage = "Upload Image (Optional)";

  static const String reportSubmitted =
      "Your report has been submitted successfully.";
  static const String claimItem = "Claim Item";
  static const String claimSubmitted =
      "Your claim request has been sent successfully.";

  // -- Validation Messages --
  static const String fieldCannotEmpty = "This field cannot be empty";
  static const String invalidEmail = "Invalid email format";
  static const String noRecordFound = "No record found";
  static const String invalidPhone = "Invalid phone number";
  static const String uploadImageError = "Please upload at least one image";

  // -- My Items Screen --
  static const String myItemsTitle = "My Items";
  static const String allItemsFilter = "All Items";
  static const String lostItemsFilter = "Lost Items";
  static const String foundItemsFilter = "Found Items";
  static const String filterBy = "Filter by:"; 
  static const String editItemTitle = "Edit Item Details";
  static const String saveChanges = "Save Changes";




  // -- Profile --
  static const String profile = "Profile";
  static const String editProfile = "Edit Profile";
  static const String updateProfile = "Update Profile";
  static const String deleteAccount = "Delete Account";
  static const String joined = "Joined";
  static const String myReports = "My Reports";
  static const String myClaims = "My Claims";
  static const String aboutApp = "About App";

  // -- Network & Errors --
  static const String noInternet = "No Internet Connection";
  static const String checkInternet =
      "Please check your internet connection and try again.";
  static const String somethingWentWrong = "Something went wrong!";
  static const String tryAgain = "Try Again";

  // -- Admin --
  static const String lostItemsTabletitle = "Lost Items";
  static const String foundItemsTableTitle = "Found Items";
  static const String timeLost = "Time lost";
  static const String timeFound = "Time Found";
  static const String locationLost = "Location Lost";
  static const String locationFound = "Location Found";

  static const String itemId = "Item ID";
  static const String userId = "User ID";
  static const String itemType = "Item Type";
  static const String status = "Status";



  static const String darkMode = "Dark Mode";
  static const String darkModeOn = 'Dark Mode Is On';
  static const String darkModeOff = 'Dark Mode Is Off';



  static const String dashboardTab = 'Dashboard'; 
  static const String pendingItemsTab = 'Pending Items';
  static const String pendingClaimsTab = 'Pending Claims'; 
  static const String completedItemsTab = 'Completed Items';


  static const String completedItemsStatus = 'STATUS: COMPLETED (ITEM RETURNED)';
  static const String compltedItemandSubmitterDetails = 'Item & Submitter Details';
  static const String dateSubmitted = 'Date Submitted';
  static const String timeSubmitted = 'Time Submitted';
  static const String locationReported = 'Location Reported';
  static const String noCompletedItemsFound = 'No completed (found) items found.';
  static const String noPendingItemsFound = 'No pending items required for approval.';
  static const String noPendingClaimsFound = 'No pending claims found.';
  static const String completedItemsTitle = 'Completed Items';




  static const String pendingClaimsTitle = 'Pending Claims';
  static const String reviewPendingClaim = 'Review Pending Claim';
  static const String claimerDetailsAndJustification = 'Claimer Details & Justification';
  static const String claimerJustification = 'Justification';
  static const String pendingItemsTitle = 'Pending Items';
  static const String reasonForRejection = 'Reason for Rejection';
  static const String reasonForRejectionHint = "Enter reason (e.g., Inappropriate content, Duplicate post)...";
  static const String submitRejection = 'Submit Rejection';



  



  // -- Settins --
  static const String settingsTitle = 'Settings';

}
