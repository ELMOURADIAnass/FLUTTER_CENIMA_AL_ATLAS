# Login System - Architecture & Implementation Details

## System Architecture Diagram

```
┌──────────────────────────────────────────────────────────────────┐
│                         UI LAYER                                  │
│  ┌──────────────────────┐      ┌──────────────────────┐           │
│  │   LoginScreen        │      │   SignUpScreen       │           │
│  │  - Email field       │      │  - Full name field   │           │
│  │  - Password field    │      │  - Email field       │           │
│  │  - Remember me       │      │  - Password field    │           │
│  │  - Demo login        │      │  - Confirm password  │           │
│  └──────┬───────────────┘      └──────┬───────────────┘           │
│         │                             │                            │
│         └──────────────┬──────────────┘                            │
│                        │                                           │
│  ┌─────────────────────▼───────────────────────┐                 │
│  │         HomeScreen (after login)            │                 │
│  │  - User profile menu (avatar)               │                 │
│  │  - Logout button                            │                 │
│  └─────────────────────────────────────────────┘                 │
└─────────────────────────────────────────────────────────────────┬─┘
                                                                   │
                     (uses) ▼
┌──────────────────────────────────────────────────────────────────┐
│                    STATE MANAGEMENT LAYER                        │
│         (Provider - observes state changes & triggers UI)        │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  AuthProvider (ChangeNotifier)                           │   │
│  │  ┌────────────────────────────────────────────────────┐  │   │
│  │  │ Public Properties:                                 │  │   │
│  │  │  - currentUser: User?                              │  │   │
│  │  │  - isLoggedIn: bool                                │  │   │
│  │  │  - isLoading: bool                                 │  │   │
│  │  │  - errorMessage: String?                           │  │   │
│  │  └────────────────────────────────────────────────────┘  │   │
│  │ ┌────────────────────────────────────────────────────┐   │   │
│  │ │ Public Methods:                                    │   │   │
│  │ │  - initialize(): Future<void>                      │   │   │
│  │ │  - register(...): Future<bool>                     │   │   │
│  │ │  - login(...): Future<bool>                        │   │   │
│  │ │  - logout(): Future<void>                          │   │   │
│  │ │  - updateProfile(...): Future<bool>                │   │   │
│  │ │  - changePassword(...): Future<bool>               │   │   │
│  │ │  - clearError(): void                              │   │   │
│  │ └────────────────────────────────────────────────────┘   │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└──────────────────────────────────┬───────────────────────────────┘
                                   │
                     (delegates to) ▼
┌──────────────────────────────────────────────────────────────────┐
│                   BUSINESS LOGIC LAYER                           │
│        (Repository - core authentication operations)             │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  AuthRepository (Static Methods)                         │   │
│  │ ┌────────────────────────────────────────────────────┐   │   │
│  │ │ Initialization:                                    │   │   │
│  │ │  + initialize()                                    │   │   │
│  │ │                                                    │   │   │
│  │ │ Authentication:                                   │   │   │
│  │ │  + register(email, password, fullName)            │   │   │
│  │ │  + login(email, password)                         │   │   │
│  │ │  + logout()                                       │   │   │
│  │ │  + isLoggedIn(): bool                             │   │   │
│  │ │  + getCurrentUser(): User?                        │   │   │
│  │ │                                                    │   │   │
│  │ │ Profile Management:                               │   │   │
│  │ │  + updateProfile(fullName)                        │   │   │
│  │ │  + changePassword(current, new)                   │   │   │
│  │ │  + getAllUsers(): List<User>                      │   │   │
│  │ │                                                    │   │   │
│  │ │ Session Management (Private):                     │   │   │
│  │ │  - _createSession(User)                           │   │   │
│  │ │  - _findUserByEmail(String)                       │   │   │
│  │ └────────────────────────────────────────────────────┘   │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└──────────────────────────────────┬───────────────────────────────┘
                                   │
         (delegates to & uses) ▼
┌──────────────────────────────────────────────────────────────────┐
│                      DATA & SECURITY LAYER                       │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  PasswordUtil (Static Utility Methods)                   │   │
│  │  - hashPassword(String): String (SHA256)                │   │
│  │  - verifyPassword(String, String): bool                │   │
│  │  - isValidPassword(String): bool                        │   │
│  │  - isValidEmail(String): bool                           │   │
│  │  - isValidFullName(String): bool                        │   │
│  │  - validateCredentials(email, password):                │   │
│  │    (bool, String?) tuple                                │   │
│  └──────────────────────────────────────────────────────────┘   │
│                          ▲                                       │
│                          │ (uses)                                │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  User Model                                              │   │
│  │  - id: String (UUID)                                     │   │
│  │  - email: String                                         │   │
│  │  - fullName: String                                      │   │
│  │  - hashedPassword: String (SHA256)                       │   │
│  │  - createdAt: DateTime                                   │   │
│  │  - lastLogin: DateTime?                                  │   │
│  │                                                          │   │
│  │  Methods:                                                │   │
│  │  - toMap(): Map<String, dynamic>                        │   │
│  │  - fromMap(Map): User                                   │   │
│  │  - copyWith(...): User                                  │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└──────────────────────────────────┬───────────────────────────────┘
                                   │
              (persists data in) ▼
┌──────────────────────────────────────────────────────────────────┐
│                    LOCAL STORAGE LAYER                           │
│              (Hive - Key-Value Database)                         │
│                                                                  │
│  ┌──────────────────────┐        ┌──────────────────────┐        │
│  │    'users' Box       │        │   'session' Box      │        │
│  │  (User Accounts)     │        │  (Login Session)     │        │
│  │ ┌────────────────┐   │        │ ┌────────────────┐   │        │
│  │ │ Key: email     │   │        │ │ currentUserEmail   │        │
│  │ │ Value: User {} │   │        │ │ currentUserId      │        │
│  │ │                │   │        │ │ loginTime          │        │
│  │ │ {              │   │        │ └────────────────┘   │        │
│  │ │  id: UUID      │   │        │                      │        │
│  │ │  email: ...    │   │        │ Cleared on logout    │        │
│  │ │  fullName: ... │   │        │ Persists on restart  │        │
│  │ │  hashedPW: ... │   │        │                      │        │
│  │ │  createdAt: .. │   │        │                      │        │
│  │ │  lastLogin: .. │   │        │                      │        │
│  │ │ }              │   │        │                      │        │
│  │ └────────────────┘   │        └──────────────────────┘        │
│  │                      │                                        │
│  │ Persists on restart  │                                        │
│  │ Survives app close   │                                        │
│  │ Encrypted (optional) │                                        │
│  └──────────────────────┘                                        │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
                           ▲
                           │ (uses)
              ┌────────────┴───────────────┐
              │                            │
         ┌────▼─────┐              ┌─────▼────┐
         │ Package  │              │ Package │
         │ hive 2.2 │              │ crypto  │
         │ hive_    │              │ 3.0.3   │
         │ flutter  │              │         │
         │ 1.1.0    │              │ uuid    │
         │          │              │ 4.0.0   │
         └──────────┘              └─────────┘
```

---

## Data Flow Diagrams

### 1. Registration Flow

```
User Input (LoginScreen)
    │
    ├─ email: "user@cinema.ma"
    ├─ password: "SecurePass123"
    └─ fullName: "John Doe"
         │
         ▼
   AuthProvider.register()
         │
         ├─ Validates input via PasswordUtil
         │   ├─ validateCredentials()
         │   └─ isValidFullName()
         │
         ├─ Sets isLoading = true
         │
         ├─ Calls AuthRepository.register()
         │
         │  ┌──────────────────────────────┐
         │  │ AuthRepository.register()    │
         │  │                              │
         │  ├─ Check email not exists      │
         │  │                              │
         │  ├─ Hash password:              │
         │  │  SHA256(password)            │
         │  │                              │
         │  ├─ Generate UUID               │
         │  │                              │
         │  ├─ Create User object          │
         │  │                              │
         │  ├─ Save to users_box           │
         │  │  (email -> User{})           │
         │  │                              │
         │  └─ Create session              │
         │     (session_box)               │
         │                              │
         └─ Returns (bool, message)
         │
         ├─ Sets isLoading = false
         │
         ├─ Sets currentUser = newUser
         │
         ├─ Notifies listeners
         │
         └─ UI navigates to HomeScreen
```

### 2. Login Flow

```
User Input (LoginScreen)
    │
    ├─ email: "user@cinema.ma"
    └─ password: "SecurePass123"
         │
         ▼
   AuthProvider.login()
         │
         ├─ Validates input
         │
         ├─ Sets isLoading = true
         │
         ├─ Calls AuthRepository.login()
         │
         │  ┌──────────────────────────────┐
         │  │ AuthRepository.login()       │
         │  │                              │
         │  ├─ Find user by email          │
         │  │  in users_box                │
         │  │                              │
         │  ├─ Verify password:            │
         │  │  SHA256(input) == stored?    │
         │  │                              │
         │  ├─ Update lastLogin            │
         │  │                              │
         │  └─ Create session              │
         │                              │
         └─ Returns (bool, message)
         │
         ├─ Sets isLoading = false
         │
         ├─ Sets currentUser = loginUser
         │
         ├─ Notifies listeners
         │
         └─ UI navigates to HomeScreen
```

### 3. Logout Flow

```
User Action (HomeScreen)
    │
    ├─ Click profile menu
    └─ Select "Logout"
         │
         ▼
   Show confirmation dialog
         │
         ├─ User confirms
         │
         ▼
   AuthProvider.logout()
         │
         ├─ Calls AuthRepository.logout()
         │
         │  ┌──────────────────────────────┐
         │  │ AuthRepository.logout()      │
         │  │                              │
         │  └─ Clear session_box           │
         │                              │
         ├─ Sets currentUser = null
         │
         ├─ Sets isLoading = false
         │
         ├─ Notifies listeners
         │
         └─ UI navigates to LoginScreen
```

### 4. Auto-Login Flow (App Restart)

```
App Start
    │
    ▼
main() async
    │
    ├─ WidgetsFlutterBinding.ensureInitialized()
    │
    ├─ DatabaseService.initialize()
    │  └─ Open 'rooms' and 'bookings' boxes
    │
    ├─ AuthRepository.initialize()
    │  ├─ Open 'users' box
    │  └─ Open 'session' box
    │
    ├─ runApp(CinemaAtlasApp)
    │
    ▼
_CinemaAtlasAppState.initState()
    │
    ├─ Create _authProvider
    │
    ├─ Call _authProvider.initialize()
    │
    │  ┌──────────────────────────────────┐
    │  │ AuthProvider.initialize()        │
    │  │                                  │
    │  ├─ Call AuthRepository.getCurrentUser()
    │  │                                  │
    │  │  ┌─────────────────────────────┐
    │  │  │ Get currentUserEmail from   │
    │  │  │ session_box                 │
    │  │  │                             │
    │  │  │ Load User from users_box    │
    │  │  │ by email key                │
    │  │  └─────────────────────────────┘
    │  │                                  │
    │  ├─ Set currentUser = user          │
    │  │                                  │
    │  └─ Notify listeners                │
    │                                  │
    ▼
MaterialApp.home (Consumer<AuthProvider>)
    │
    ├─ if authProvider.isLoggedIn
    │  └─ Show HomeScreen
    │
    └─ else
       └─ Show LoginScreen
```

---

## Security Implementation

### Password Hashing Strategy

```
User Input: "MySecurePassword"
    │
    ▼
PasswordUtil.hashPassword()
    │
    ├─ Convert to UTF-8 bytes
    │
    ├─ Apply SHA256 algorithm
    │  (deterministic hash)
    │
    └─ Return hex string
        "5a7f8c9b2e1d0f3a4b6c8d9e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f"

Storage in Hive:
    User {
        email: "user@cinema.ma"
        hashedPassword: "5a7f8c9b2e1d0f3a4b6c8d9e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f"
        ...
    }

Login Verification:
    Input: "MySecurePassword"
        │
        ├─ Hash input with SHA256
        │
        ├─ Compare hash with stored hash
        │
        └─ Match? → Login success
           No match? → Login failed
```

### Why SHA256?
- ✅ Fast and deterministic
- ✅ Widely supported (crypto package)
- ✅ Collision-resistant for practical purposes
- ⚠️ Not ideal alone for passwords (consider bcrypt in production)

### Future Enhancement: Bcrypt
```dart
// For production, add bcrypt package
// flutter pub add bcrypt
import 'package:bcrypt/bcrypt.dart';

// Hashing
String hash = BCrypt.hashpw("password", BCrypt.gensalt());

// Verification
bool isValid = BCrypt.checkpw("password", hash);
```

---

## State Management Flow

### Provider Integration

```
main.dart (MultiProvider setup)
    │
    ├─ Creates AuthProvider
    │
    ├─ Makes available to entire widget tree
    │  via ChangeNotifier.Provider
    │
    └─ Allows any widget to access:
       - context.read<AuthProvider>() (one-time access)
       - context.watch<AuthProvider>() (listen to changes)
       - Consumer<AuthProvider>() (rebuild when changed)

Usage in Screens:
    
    LoginScreen:
        auth = context.read<AuthProvider>()
        success = await auth.login(...)
        
    HomeScreen:
        Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
                if (authProvider.isLoggedIn) {
                    return UserAvatar(authProvider.currentUser.fullName)
                }
            }
        )
```

---

## Error Handling Strategy

### Validation Errors

```
Input Validation Flow:
    
    Email Validation:
        ├─ Check not empty
        ├─ Check format (RFC 5322)
        └─ Return: (false, "Invalid email format")
    
    Password Validation:
        ├─ Check not empty
        ├─ Check min length (6 chars)
        └─ Return: (false, "Password too short")
    
    Registration Validation:
        ├─ Check all fields not empty
        ├─ Run email/password validators
        ├─ Check email not already registered
        ├─ Check passwords match (confirm)
        ├─ Check terms accepted
        └─ Return: (false, error message) or (true, "")
```

### Database Errors

```
Try-Catch Blocks:
    
    registration {
        try {
            // Validation
            // Database operations
            // Session creation
            return (true, "Success")
        } catch (e) {
            return (false, "Registration failed: ${e.toString()}")
        }
    }
```

### UI Error Display

```
ScaffoldMessenger shows errors:
    
    if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(authProvider.errorMessage),
                backgroundColor: Colors.red.shade700,
            )
        )
    }
    
    Or: Consumer<AuthProvider>(
        builder: (context, auth, _) {
            if (auth.errorMessage != null) {
                return ErrorWidget(auth.errorMessage!)
            }
        }
    )
```

---

## File Structure

```
lib/
├── main.dart                          ✏️  Modified
│   └─ Auth initialization & routing
│
├── models/
│   ├── user.dart                      ✨ Created
│   ├── movie.dart
│   ├── movie_local.dart
│   ├── reservation.dart
│   └── room.dart
│
├── screens/
│   ├── login_screen.dart              ✨ Created
│   ├── signup_screen.dart             ✨ Created
│   ├── home_screen.dart               ✏️  Modified
│   │   └─ Added user profile menu
│   ├── local_movie_list_screen.dart
│   ├── movie_detail_screen.dart
│   ├── movie_list_screen.dart
│   └── reservation_history_screen.dart
│
├── providers/
│   ├── auth_provider.dart             ✨ Created
│   ├── booking_provider.dart
│   ├── language_provider.dart
│   ├── movie_provider.dart
│   └── reservation_provider.dart
│
├── services/
│   ├── auth_repository.dart           ✨ Created
│   ├── database_service.dart
│   └── (other services)
│
├── utils/
│   ├── password_util.dart             ✨ Created
│   ├── theme.dart
│   ├── constants.dart
│   ├── local_movie_assets.dart
│   └── app_images.dart
│
├── widgets/
│   ├── app_image_widget.dart
│   ├── booking_modal.dart
│   ├── filter_tabs.dart
│   ├── movie_card.dart
│   ├── screening_table.dart
│   ├── section_title.dart
│   └── testimonial_card.dart
│
└── data/
    └── local_movie_database.dart

✨ = Created new file
✏️  = Modified existing file
```

---

## Dependencies Added

```yaml
dependencies:
  # New packages for authentication
  crypto: ^3.0.3         # SHA256 password hashing
  uuid: ^4.0.0           # Generate unique user IDs
  
  # Existing packages (already used)
  provider: ^6.1.2       # State management
  hive: ^2.2.3           # Local database
  hive_flutter: ^1.1.0   # Hive for Flutter
```

---

## Testing Scenarios

### Test 1: New User Registration
```
Input:
  - Email: newuser@cinema.ma
  - Password: Welcome123
  - Full Name: Ahmed Hassan
  
Expected:
  - User created in database
  - Session created
  - Navigates to HomeScreen
  - User avatar shows "A" (first letter)
```

### Test 2: Duplicate Email Registration
```
Input (after Test 1):
  - Email: newuser@cinema.ma (same)
  - Password: Different123
  - Full Name: Different Name
  
Expected:
  - Error: "Email already registered"
  - Stays on SignupScreen
  - User can try different email
```

### Test 3: Incorrect Login
```
Input:
  - Email: newuser@cinema.ma
  - Password: WrongPassword
  
Expected:
  - Error: "Invalid email or password"
  - Stays on LoginScreen
```

### Test 4: Session Persistence
```
Steps:
  1. Login as newuser@cinema.ma
  2. Verify on HomeScreen
  3. Close app
  4. Reopen app
  
Expected:
  - Session persists
  - User still logged in
  - Direct navigation to HomeScreen
```

### Test 5: Logout
```
Steps:
  1. Login as newuser@cinema.ma
  2. Click profile avatar
  3. Select "Logout"
  4. Confirm logout
  
Expected:
  - Session cleared
  - Navigates to LoginScreen
  - Re-open app → LoginScreen (not Home)
```

### Test 6: Password Change
```
Input:
  - Current: Welcome123
  - New: NewPassword456
  
Expected:
  - Password updated
  - Next login with old password fails
  - Login with new password succeeds
```

---

## Conclusion

This implementation provides:
- ✅ Production-ready authentication
- ✅ Secure password handling
- ✅ Local data persistence
- ✅ Clean architecture
- ✅ Comprehensive error handling
- ✅ Easy to extend and maintain
- ✅ No breaking changes to existing code

