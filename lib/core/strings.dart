/// All user-facing text lives here so it is easy to translate.
class AppStrings {
  AppStrings._();

  static const appName = 'Banking App';
  static const tagline = 'Your money, simply.';

  // Common
  static const email = 'Email';
  static const emailHint = 'you@example.com';
  static const password = 'Password';
  static const cancel = 'Cancel';
  static const genericError = 'Something went wrong. Please try again.';
  static const comingSoon = 'Coming soon';

  // Login
  static const loginTitle = 'Welcome back';
  static const loginSubtitle = 'Sign in to continue';
  static const signIn = 'Sign in';
  static const forgotPassword = 'Forgot password?';
  static const noAccount = "Don't have an account?";
  static const signUp = 'Sign up';

  // Register
  static const registerTitle = 'Create account';
  static const registerSubtitle = 'It only takes a minute';
  static const name = 'Full name';
  static const confirmPassword = 'Confirm password';
  static const createAccount = 'Create account';
  static const haveAccount = 'Already have an account?';

  // Forgot password
  static const forgotTitle = 'Reset password';
  static const forgotSubtitle =
      "Enter your email and we'll send you a link to reset your password.";
  static const sendResetLink = 'Send reset link';
  static String resetSent(String email) => 'Reset link sent to $email';

  // Validation
  static const emailRequired = 'Please enter your email';
  static const emailInvalid = 'Please enter a valid email';
  static const passwordRequired = 'Please enter your password';
  static const passwordTooShort = 'Password must be at least 6 characters';
  static const nameRequired = 'Please enter your name';
  static const nameTooShort = 'Name is too short';
  static const confirmRequired = 'Please confirm your password';
  static const passwordsDontMatch = "Passwords don't match";

  // Auth errors (mock)
  static const emailTaken = 'An account with this email already exists';

  // Tabs
  static const tabHome = 'Home';
  static const tabSearch = 'Search';
  static const tabProfile = 'Profile';

  // Home
  static const goodMorning = 'Good morning';
  static const goodAfternoon = 'Good afternoon';
  static const goodEvening = 'Good evening';
  static const accountReady = 'Your account is ready';
  static const recentActivity = 'Recent activity';
  static const noActivity = 'Nothing here yet';
  static const noActivityHint = 'Your transactions will show up here.';

  // Search
  static const searchHint = 'Search';
  static const searchEmpty = 'Search transactions, contacts and more';
  static String noResults(String query) => 'No results for "$query"';

  // Profile
  static const account = 'Account';
  static const notifications = 'Notifications';
  static const privacy = 'Privacy & security';
  static const signOut = 'Sign out';
  static const signOutTitle = 'Sign out?';
  static const signOutMessage = 'You will need to sign in again to continue.';
}
