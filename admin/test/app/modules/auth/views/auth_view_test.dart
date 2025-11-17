import 'package:admin/app/modules/auth/controllers/auth_controller.dart';
import 'package:admin/app/modules/auth/views/auth_view.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../../../helpers/mock_controllers.dart';

void main() {
  late MockAuthController mockAuthController;

  setUp(() {
    mockAuthController = MockAuthController();
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidgetUnderTest() {
    return GetMaterialApp(
      home: const AuthView(),
      initialBinding: BindingsBuilder(() {
        Get.put<AuthController>(mockAuthController);
      }),
      getPages: AppPages.routes,
    );
  }

  group('AuthView Widget Tests', () {
    testWidgets('should render all main UI components', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify welcome text
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Please sign in to your account'), findsOneWidget);

      // Verify form fields
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Verify email/username field
      expect(find.text('Email/Username'), findsOneWidget);

      // Verify password field
      expect(find.text('Password'), findsOneWidget);

      // Verify remember me checkbox
      expect(find.text('Remember me'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);

      // Verify forgot password button
      expect(find.text('Forgot Password?'), findsOneWidget);

      // Verify sign in button
      expect(find.text('SIGN IN'), findsOneWidget);

      // Verify sign up link
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('should display email validation error when empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find the form and trigger validation
      final form = mockAuthController.formKey.currentState!;
      final isValid = form.validate();

      await tester.pumpAndSettle();

      // Verify form is not valid
      expect(isValid, false);

      // Verify validation error appears
      expect(find.text('Please enter your email/username'), findsOneWidget);
    });

    testWidgets('should display password validation error when empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter email but leave password empty
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Trigger form validation
      final form = mockAuthController.formKey.currentState!;
      final isValid = form.validate();
      await tester.pumpAndSettle();

      // Verify form is not valid
      expect(isValid, false);

      // Verify validation error appears
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets(
      'should display password validation error when less than 6 characters',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Enter valid email
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'test@example.com');

        // Enter short password
        final passwordField = find.byType(TextFormField).last;
        await tester.enterText(passwordField, '12345');
        await tester.pumpAndSettle();

        // Trigger form validation
        final form = mockAuthController.formKey.currentState!;
        final isValid = form.validate();
        await tester.pumpAndSettle();

        // Verify form is not valid
        expect(isValid, false);

        // Verify validation error appears
        expect(
          find.text('Password must be at least 6 characters'),
          findsOneWidget,
        );
      },
    );

    testWidgets('should toggle password visibility when eye icon is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter password
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // Initial state - password should be obscured
      expect(mockAuthController.obscurePassword, true);

      // Find and tap the eye icon button
      final eyeButton = find.byType(IconButton).first;
      await tester.tap(eyeButton);
      await tester.pumpAndSettle();

      // Verify obscurePassword is toggled
      expect(mockAuthController.obscurePassword, false);
    });

    testWidgets('should toggle remember me checkbox', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial state
      expect(mockAuthController.rememberMe, false);

      // Tap checkbox
      final checkbox = find.byType(Checkbox);
      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      // Verify rememberMe is toggled
      expect(mockAuthController.rememberMe, true);
    });

    testWidgets('should have Sign Up link visible', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify Sign Up link is visible and can be tapped
      final signUpLink = find.text('Sign Up');
      expect(signUpLink, findsOneWidget);

      // Verify it's a TextButton
      final textButton = find.ancestor(
        of: signUpLink,
        matching: find.byType(TextButton),
      );
      expect(textButton, findsOneWidget);
    });

    testWidgets('should allow entering email and password', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      expect(mockAuthController.emailController.text, 'test@example.com');

      // Enter password
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');
      expect(mockAuthController.passwordController.text, 'password123');

      await tester.pumpAndSettle();

      // Verify text was entered
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets(
      'should have correct form validation when valid data is entered',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Enter valid email
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'test@example.com');

        // Enter valid password
        final passwordField = find.byType(TextFormField).last;
        await tester.enterText(passwordField, 'password123');
        await tester.pumpAndSettle();

        // Trigger form validation
        final form = mockAuthController.formKey.currentState!;
        final isValid = form.validate();
        await tester.pumpAndSettle();

        // Verify form is valid
        expect(isValid, true);

        // No validation errors should appear
        expect(find.text('Please enter your email/username'), findsNothing);
        expect(find.text('Please enter your password'), findsNothing);
        expect(
          find.text('Password must be at least 6 characters'),
          findsNothing,
        );
      },
    );

    testWidgets('should render background image', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify Container with decoration exists
      final containerWithImage = find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration is BoxDecoration,
      );
      expect(containerWithImage, findsWidgets);
    });

    testWidgets('should have "Or sign in with" text displayed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Or sign in with'), findsOneWidget);
    });

    testWidgets('should allow access to form key', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify form key is accessible
      expect(mockAuthController.formKey, isNotNull);
      expect(mockAuthController.formKey.currentState, isNotNull);
    });
  });

  group('AuthView Controller Integration Tests', () {
    testWidgets('should update UI when obscurePassword changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial state - password should be obscured
      expect(mockAuthController.obscurePassword, true);

      // Trigger toggle
      mockAuthController.toggleObscurePwd();
      await tester.pumpAndSettle();

      // Verify state changed
      expect(mockAuthController.obscurePassword, false);

      // Toggle back
      mockAuthController.toggleObscurePwd();
      await tester.pumpAndSettle();

      expect(mockAuthController.obscurePassword, true);
    });

    testWidgets('should update UI when rememberMe changes', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial state
      expect(mockAuthController.rememberMe, false);

      // Trigger toggle
      mockAuthController.toggleRemebreMe();
      await tester.pumpAndSettle();

      // Verify state changed
      expect(mockAuthController.rememberMe, true);

      // Toggle back
      mockAuthController.toggleRemebreMe();
      await tester.pumpAndSettle();

      expect(mockAuthController.rememberMe, false);
    });
  });
}
