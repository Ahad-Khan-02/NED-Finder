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


// --- Navigation Labels ---
  static const String home = 'Home';
  static const String myItems = 'My Items';
  static const String settings = 'Settings';




  // -------------------------
  // -- Dashboard / Home --
  // -------------------------

  static const String dashboardTitle = "Welcome,";
  static const String dashboardSubTitle = "Manage lost and found items efficiently.";

  static const String searchItems = "Search"; 
  
  static const String addItem = "Report Found Item"; 
  static const String reportItem = "Report Lost Item"; 
  
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

  // -- My Items Screen --
  static const String myItemsTitle = "My Items";
  static const String allItemsFilter = "All Items";
  static const String lostItemsFilter = "Lost Items";
  static const String foundItemsFilter = "Found Items";
  static const String filterBy = "Filter by:"; 
  static const String editItemTitle = "Edit Item Details";
  static const String saveChanges = "Save Changes";
  static const String noMyItems = 'You haven\'t reported any items yet.';

  // -- Profile --
  static const String profile = "Profile";
  static const String viweProfile = "View Profile";


  // -------------------------
  // -- Dashboard / Amin --
  // -------------------------

  // -- Dashboard --
  static const String lostItemsTabletitle = "Lost Items";
  static const String foundItemsTableTitle = "Found Items";
  static const String timeLost = "Time lost";
  static const String timeFound = "Time Found";
  static const String locationLost = "Location Lost";
  static const String locationFound = "Location Found";


  // -- Item --
  static const String itemId = "Item ID";
  static const String userId = "User ID";
  static const String itemType = "Item Type";
  static const String status = "Status";


  // -- Tabs --
  static const String dashboardTab = 'Dashboard'; 
  static const String pendingItemsTab = 'Pending Items';
  static const String pendingClaimsTab = 'Pending Claims'; 
  static const String completedItemsTab = 'Completed Items';

  // -- Completed  Items --
  static const String completedItemsStatus = 'STATUS: COMPLETED (ITEM RETURNED)';
  static const String compltedItemandSubmitterDetails = 'Item & Submitter Details';
  static const String dateSubmitted = 'Date Submitted';
  static const String timeSubmitted = 'Time Submitted';
  static const String locationReported = 'Location Reported';
  static const String noCompletedItemsFound = 'No completed (found) items found.';
  static const String noPendingItemsFound = 'No pending items required for approval.';
  static const String noPendingClaimsFound = 'No pending claims found.';
  static const String completedItemsTitle = 'Completed Items';


  // -- Pending Claims --
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
  static const String darkMode = "Dark Mode";
  static const String darkModeOn = 'Dark Mode Is On';
  static const String darkModeOff = 'Dark Mode Is Off';

}
