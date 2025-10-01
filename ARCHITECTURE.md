# Flutter App Architecture Guide

## 📱 Project Overview

This Flutter application follows a **clean architecture pattern** with **GetX state management**, implementing a modular and scalable structure for building responsive, maintainable UI screens.

## 🏗️ Architecture Layers

### 1. **Core Layer** (`/lib/core/`)
Contains shared utilities, common widgets, constants, and configurations.

### 2. **Features Layer** (`/lib/features/`)
Contains feature-specific modules organized by domain (authentication, home, etc.).

### 3. **Routes Layer** (`/lib/routes/`)
Centralized navigation management using GetX routing.

---

## 📂 Project Structure

```
lib/
├── app.dart                 # Main app configuration
├── main.dart               # App entry point
├── core/                   # Shared core functionality
│   ├── common/
│   │   ├── styles/
│   │   │   └── global_text_style.dart    # Centralized text styling
│   │   └── widgets/
│   │       ├── common_background.dart    # Reusable background system
│   │       ├── customize_filled_button.dart
│   │       ├── customize_unfilled_button.dart
│   │       └── custom_text_field.dart    # Common text field component
│   ├── utils/
│   │   └── constants/
│   │       └── colors.dart              # Color constants
│   └── models/                          # Shared data models
├── features/                            # Feature modules
│   ├── authentication/
│   │   ├── controllers/
│   │   │   ├── login_controller.dart
│   │   │   ├── login_form_controller.dart
│   │   │   ├── forgot_password_controller.dart
│   │   │   └── check_email_controller.dart
│   │   └── presentation/
│   │       └── screens/
│   │           ├── login_screen.dart
│   │           ├── login_form_screen.dart
│   │           ├── forgot_password_screen.dart
│   │           └── check_email_screen.dart
│   ├── splash_screen/
│   │   ├── controller/
│   │   │   └── splash_screen_controller.dart
│   │   └── screen/
│   │       └── splash_screen.dart
│   └── home/                           # Future home features
└── routes/
    └── app_routes.dart                 # Navigation configuration
```

---

## 🎨 Design System Implementation

### **1. Responsive Design with ScreenUtil**

```dart
// Setup in main.dart
ScreenUtil.init(
  designSize: const Size(375, 812), // iPhone X dimensions
  minTextAdapt: true,
);

// Usage throughout the app
width: 160.w,           // Responsive width
height: 48.h,           // Responsive height
fontSize: 16.sp,        // Responsive font size
borderRadius: 12.r,     // Responsive radius
margin: 16.h,           // Responsive margin

// Spacing utilities
16.verticalSpace,       // SizedBox(height: 16.h)
20.horizontalSpace,     // SizedBox(width: 20.w)
```

### **2. Typography System**

**File**: `/lib/core/common/styles/global_text_style.dart`

```dart
TextStyle getTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
  double? lineHeight,
  String fontFamily = 'SF Pro Display',
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: lineHeight != null ? lineHeight / fontSize : null,
    fontFamily: fontFamily,
  );
}

// Usage in screens
Text(
  'Welcome Back!',
  style: getTextStyle(
    fontSize: 32.sp,          // H2 heading
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textPrimary,
  ),
)
```

**Typography Scale**:
- **H1**: 36sp, Bold (700)
- **H2**: 32sp, Bold (700) 
- **Body/Button**: 16sp, Medium (500)
- **Body/B1**: 16sp, Regular (400)
- **Body/B2**: 14sp, Regular (400)
- **Body/B3**: 12sp, Regular (400)

### **3. Color System**

**File**: `/lib/core/utils/constants/colors.dart`

```dart
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF4A7BFF);
  static const Color secondary = Color(0xFF34C759);
  
  // Text colors
  static const Color textPrimary = Color(0xFF161618);
  static const Color textSecondary = Color(0xFF8E8E93);
  
  // Background colors
  static const Color backgroundLight = Color(0xFFF6F6F6);
  static const Color backgroundNeutral = Color(0xFFF5F5F7);
  
  // Input field colors
  static const Color inputBackground = Color(0xFFF8F8F8);
  static const Color inputBorder = Color(0xFFE8E8E8);
}
```

---

## 🧩 Common Widgets Architecture

### **1. Reusable Background System**

**File**: `/lib/core/common/widgets/common_background.dart`

```dart
class CommonBackground extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;
  final EdgeInsetsGeometry? padding;
  
  // Three-layer gradient system
  // 1. Base light gray background
  // 2. Blue radial gradient (top-left)
  // 3. Green radial gradient (bottom-center + left corner)
}

class CommonBackgroundScaffold extends StatelessWidget {
  // Wrapper that provides background + scaffold structure
}
```

**Usage**:
```dart
CommonBackgroundScaffold(
  body: YourContent(),
)
```

### **2. Custom Button Components**

**Filled Button**: `/lib/core/common/widgets/customize_filled_button.dart`
```dart
CustomFilledButton(
  text: 'Log In',
  onPressed: () => controller.onLoginPressed(),
  padding: EdgeInsets.zero,
)
```

**Unfilled Button**: `/lib/core/common/widgets/customize_unfilled_button.dart`
```dart
CustomUnfilledButton(
  text: 'Create Account',
  onPressed: () => controller.onCreateAccount(),
  textColor: AppColors.primary,
  borderColor: AppColors.primary,
  backgroundColor: Colors.transparent,
)
```

### **3. Custom Text Field Component**

**Common Text Field**: `/lib/core/common/widgets/custom_text_field.dart`
```dart
CustomTextField(
  label: 'Email or Phone',
  hintText: 'Enter your email address',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  suffixIcon: Icon(
    Icons.email_outlined,
    size: 16.w,
    color: AppColors.textSecondary,
  ),
)

// For password fields
CustomTextField(
  label: 'Password',
  hintText: 'Enter your password',
  controller: passwordController,
  obscureText: true,
  suffixIcon: GestureDetector(
    onTap: () => controller.togglePasswordVisibility(),
    child: Icon(
      controller.isPasswordHidden.value 
        ? Icons.visibility_off_outlined 
        : Icons.visibility_outlined,
      size: 16.w,
      color: AppColors.textSecondary,
    ),
  ),
)
```

**Features**:
- Consistent styling across all screens
- No border (clean design)
- Responsive sizing with ScreenUtil
- Built-in label and hint text support
- Prefix and suffix icon support
- Password visibility toggle support
- Multi-line support
- Form validation support

---

## 🎮 State Management with GetX

### **Controller Architecture**

**Base Controller Structure**:
```dart
class LoginController extends GetxController {

//never mentioned fontSize any size in this file

  // Observable variables
  final RxBool _isLoading = false.obs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  
  // Navigation methods
  void onLoginPressed() {
    _setLoading(true);
    // Navigation logic
    Get.toNamed('/loginFormScreen');
  }
  
  // Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    debugPrint('Controller initialized');
  }
  
  @override
  void onClose() {
    super.onClose();
    debugPrint('Controller disposed');
  }
}
```

### **Form Controller Pattern**

```dart
class LoginFormController extends GetxController {
  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Reactive state
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  
  // Form validation
  void onLoginPressed() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }
    // Handle login logic
  }
  
  // UI interactions
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
```

---

## 📱 Screen Implementation Pattern

### **1. Screen Structure Template**

```dart
class ScreenName extends StatelessWidget {
  const ScreenName({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerName controller = Get.put(ControllerName());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection1(controller),
              _buildSection2(controller),
              _buildSection3(controller),
            ],
          ),
        ),
      ),
    );
  }

  // Extract widgets into separate methods
  Widget _buildSection1(ControllerName controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          // Content
        ],
      ),
    );
  }
}
```

### **2. UI Spacing Guidelines**

```dart
// Vertical spacing - ALWAYS use .verticalSpace instead of SizedBox(height:)
8.verticalSpace     // Small spacing
12.verticalSpace    // Small-medium spacing
16.verticalSpace    // Medium spacing  
20.verticalSpace    // Medium-large spacing
24.verticalSpace    // Large spacing
32.verticalSpace    // Extra large spacing
40.verticalSpace    // Extra extra large spacing

// Horizontal spacing - ALWAYS use .horizontalSpace instead of SizedBox(width:)
8.horizontalSpace   // Small spacing
12.horizontalSpace  // Small-medium spacing
16.horizontalSpace  // Medium spacing
20.horizontalSpace  // Large spacing

// Container margins and padding
EdgeInsets.symmetric(horizontal: 16.w)  // Screen padding
EdgeInsets.only(left: 12.w, right: 12.w) // Custom padding

// Margins
EdgeInsets.only(top: 8.h, bottom: 16.h)
EdgeInsets.all(16.w)

// ❌ WRONG - Don't use SizedBox for spacing
SizedBox(height: 20.h)
SizedBox(width: 16.w)

// ✅ CORRECT - Use spacing extensions
20.verticalSpace
16.horizontalSpace
```

### **3. Form Field Implementation**

```dart
// ✅ RECOMMENDED - Use CustomTextField for all form inputs
Widget _buildEmailField(ControllerName controller) {
  return CustomTextField(
    label: 'Email or Phone',
    hintText: 'Enter your email address',
    controller: controller.emailController,
    keyboardType: TextInputType.emailAddress,
    suffixIcon: Icon(
      Icons.email_outlined,
      size: 16.w,
      color: AppColors.textSecondary,
    ),
  );
}

Widget _buildPasswordField(ControllerName controller) {
  return Obx(() => CustomTextField(
    label: 'Password',
    hintText: 'Enter your password',
    controller: controller.passwordController,
    obscureText: controller.isPasswordHidden.value,
    suffixIcon: GestureDetector(
      onTap: controller.togglePasswordVisibility,
      child: Icon(
        controller.isPasswordHidden.value
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        size: 16.w,
        color: AppColors.textSecondary,
      ),
    ),
  ));
}

// ❌ OLD WAY - Don't create custom form field methods anymore
// Use CustomTextField instead for consistency
```

---

## 🧭 Navigation Architecture

### **Route Configuration**

**File**: `/lib/routes/app_routes.dart`

```dart
class AppRoute {
  // Route constants
  static String splashScreen = "/splashScreen";
  static String loginScreen = "/loginScreen";
  static String loginFormScreen = "/loginFormScreen";
  static String homeScreen = "/homeScreen";
  
  // Route getters
  static String getSplashScreen() => splashScreen;
  static String getLoginScreen() => loginScreen;
  
  // Route definitions
  static List<GetPage> routes = [
    GetPage(
      name: splashScreen, 
      page: () => SplashScreen()
    ),
    GetPage(
      name: loginScreen, 
      page: () => const LoginScreen()
    ),
    GetPage(
      name: loginFormScreen, 
      page: () => const LoginFormScreen()
    ),
  ];
}
```

### **Navigation Usage**

```dart
// Navigate to screen
Get.toNamed('/loginFormScreen');

// Replace current screen
Get.offNamed('/homeScreen');

// Replace all screens
Get.offAllNamed('/homeScreen');

// Go back
Get.back();

// Pass arguments
Get.toNamed('/profileScreen', arguments: {'userId': 123});
```

---

## 🔄 Reactive UI with Obx

### **Reactive Widgets**

```dart
// Simple reactive text
Obx(() => Text(
  controller.isLoading.value ? 'Loading...' : 'Login',
  style: getTextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
))

// Reactive button state
Obx(() => CustomFilledButton(
  text: 'Log In',
  onPressed: controller.isLoading.value 
    ? () {} 
    : controller.onLoginPressed,
))

// Reactive form field
Obx(() => TextField(
  obscureText: controller.isPasswordHidden.value,
  // ... other properties
))
```

---

## 🎯 Best Practices Applied

### **1. Clean Code Principles**

- **Single Responsibility**: Each widget method has one purpose
- **Extract Methods**: Complex widgets broken into smaller methods
- **Descriptive Naming**: Method names clearly describe functionality
- **Separation of Concerns**: UI logic separated from business logic

### **2. Performance Optimizations**

- **Selective Reactivity**: Only wrap necessary widgets with `Obx()`
- **Controller Disposal**: Proper cleanup in `onClose()`
- **Asset Optimization**: Proper image sizing and formats
- **Lazy Loading**: Controllers created only when needed with `Get.put()`

### **3. Maintainability**

- **Consistent Structure**: All screens follow same pattern
- **Centralized Styling**: Typography and colors in shared files
- **Reusable Components**: Common widgets for buttons, forms, backgrounds
- **Clear Documentation**: Comments explaining complex logic

### **4. Responsive Design**

- **ScreenUtil Integration**: All dimensions use responsive units
- **Flexible Layouts**: `SingleChildScrollView` for content overflow
- **Safe Areas**: Proper handling of device notches and status bars
- **Cross-Platform**: Works on iOS, Android, and web

---

## 🚀 Getting Started

### **1. Setup New Screen**

1. Create controller in `/lib/features/[feature]/controllers/`
2. Create screen in `/lib/features/[feature]/presentation/screens/`
3. Add route in `/lib/routes/app_routes.dart`
4. Follow the screen structure template
5. Use common widgets and styling system

### **2. Creating Custom Widgets**

1. Place in `/lib/core/common/widgets/`
2. Make them reusable and configurable
3. Follow the responsive design guidelines
4. Include proper documentation

### **3. Adding New Features**

1. Create feature folder in `/lib/features/`
2. Add controllers, screens, and models
3. Update routing configuration
4. Test navigation flow

---

## 📋 Development Workflow

1. **Design Analysis**: Study Figma designs for exact specifications
2. **Structure Planning**: Break screen into logical widget methods
3. **Controller Setup**: Create reactive state management
4. **UI Implementation**: Build responsive widgets with proper spacing
5. **Navigation Integration**: Connect screens with routing
6. **Testing**: Verify functionality and responsiveness
7. **Code Review**: Ensure consistency with architecture patterns

This architecture ensures scalable, maintainable, and responsive Flutter applications with clean separation of concerns and reusable components.


//Example of how to use this template

"I'm working on a new screen for this Flutter app. Please read the ARCHITECTURE.md 
file to understand our established patterns and conventions. 

I need to create a [Profile Settings Screen] that should follow the same 
architecture as the login screens. Here's the Figma design: [link]

Please use:
- GetX state management
- Common background system  
- Responsive design with .verticalSpace/.horizontalSpace
- Same typography and color system
- Extract widget methods pattern"