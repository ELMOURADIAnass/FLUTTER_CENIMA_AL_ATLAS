import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import '../utils/password_util.dart';
import 'login_screen.dart';

/// Sign up screen for new user registration
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handle sign up button press
  Future<void> _handleSignUp() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validate inputs
    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    if (!_agreeToTerms) {
      _showErrorSnackBar('Please agree to the terms and conditions');
      return;
    }

    if (password != confirmPassword) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    // Validate email and password
    final (isValid, error) = PasswordUtil.validateCredentials(email, password);
    if (!isValid) {
      _showErrorSnackBar(error ?? 'Invalid email or password');
      return;
    }

    // Perform registration
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      email: email,
      password: password,
      fullName: fullName,
    );

    if (!mounted) return;

    if (success) {
      // Navigate to home screen
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Show error
      _showErrorSnackBar(
        authProvider.errorMessage ?? 'Registration failed. Please try again.',
      );
    }
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Join Cinéma Al-ATLAS',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 40),

              // Full name field
              _buildTextField(
                controller: _fullNameController,
                label: 'Full Name',
                hint: 'Enter your full name',
                icon: Icons.person_outlined,
              ),

              const SizedBox(height: 20),

              // Email field
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              // Password field
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Create a password (min. 6 characters)',
                obscure: _obscurePassword,
                icon: Icons.lock_outlined,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm password field
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hint: 'Re-enter your password',
                obscure: _obscureConfirmPassword,
                icon: Icons.lock_outlined,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                  child: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Terms and conditions checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() => _agreeToTerms = value ?? false);
                    },
                    activeColor: AppColors.secondary,
                  ),
                  Expanded(
                    child: Text(
                      'I agree to the Terms & Conditions and Privacy Policy',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Sign up button
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return ElevatedButton(
                    onPressed:
                        authProvider.isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      disabledBackgroundColor: AppColors.secondary.withAlpha(128),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.textPrimary,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build text field widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.textSecondary)
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.surface,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.surface,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.secondary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

