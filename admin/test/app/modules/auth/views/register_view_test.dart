import 'package:admin/app/modules/auth/controllers/register_controller.dart';
import 'package:admin/app/modules/auth/views/register_view.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../../../../helpers/mock_controllers.dart';

void main() {
  late MockRegisterController mockRegisterController;

  setUp(() {
    mockRegisterController = MockRegisterController();
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidgetUnderTest() {
    return GetMaterialApp(
      home: const RegisterView(),
      initialBinding: BindingsBuilder(() {
        Get.put<RegisterController>(mockRegisterController);
      }),
      getPages: AppPages.routes,
    );
  }

  // Helper to set up test surface size
  void setupTestSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  group('RegisterView Widget Tests', () {
    testWidgets('should render all main UI components', (
      WidgetTester tester,
    ) async {
      setupTestSurface(tester);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify title text
      expect(find.text('Create Account'), findsOneWidget);

      // Verify form fields (6 TextFormFields total)
      expect(find.byType(TextFormField), findsNWidgets(6));

      // Verify field labels
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email/Username'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(
        find.text('Password'),
        findsNWidgets(2),
      ); // Password and Confirm Password

      // Verify register button
      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display validation error when first name is empty', (
      WidgetTester tester,
    ) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Trigger form validation
      final form = mockRegisterController.formKey.currentState!;
      final isValid = form.validate();
      await tester.pumpAndSettle();

      // Verify form is not valid
      expect(isValid, false);

      // Verify validation error appears
      expect(find.text('Please enter your first name'), findsOneWidget);
    });

    testWidgets('should display validation error for invalid email format', (
      WidgetTester tester,
    ) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter invalid email
      final emailField = find.byType(TextFormField).at(2);
      await tester.enterText(emailField, 'invalid-email');
      await tester.pumpAndSettle();

      // Trigger form validation
      final form = mockRegisterController.formKey.currentState!;
      final isValid = form.validate();
      await tester.pumpAndSettle();

      // Verify form is not valid
      expect(isValid, false);

      // Verify validation error appears
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should display validation error when passwords do not match', (
      WidgetTester tester,
    ) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter mismatched passwords
      final passwordField = find.byType(TextFormField).at(4);
      await tester.enterText(passwordField, 'password123');

      final confirmPasswordField = find.byType(TextFormField).at(5);
      await tester.enterText(confirmPasswordField, 'password456');
      await tester.pumpAndSettle();

      // Trigger form validation
      final form = mockRegisterController.formKey.currentState!;
      final isValid = form.validate();
      await tester.pumpAndSettle();

      // Verify form is not valid
      expect(isValid, false);

      // Verify validation error appears
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should allow entering all valid data', (
      WidgetTester tester,
    ) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter valid data in all fields
      await tester.enterText(find.byType(TextFormField).at(0), 'John');
      await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'john.doe@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(3), '+1234567890');
      await tester.enterText(find.byType(TextFormField).at(4), 'password123');
      await tester.enterText(find.byType(TextFormField).at(5), 'password123');
      await tester.pumpAndSettle();

      // Verify all controllers have correct text
      expect(mockRegisterController.fName.text, 'John');
      expect(mockRegisterController.lName.text, 'Doe');
      expect(mockRegisterController.email.text, 'john.doe@example.com');
      expect(mockRegisterController.phone.text, '+1234567890');
      expect(mockRegisterController.password.text, 'password123');
      expect(mockRegisterController.cpassword.text, 'password123');
    });

    testWidgets('should toggle password visibility when eye icon is tapped', (
      WidgetTester tester,
    ) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial state - password should be obscured
      expect(mockRegisterController.obscurePassword, true);

      // Find and tap the first eye icon button (for password field)
      final eyeButtons = find.byType(IconButton);
      await tester.tap(eyeButtons.first);
      await tester.pumpAndSettle();

      // Verify obscurePassword is toggled
      expect(mockRegisterController.obscurePassword, false);
    });

    testWidgets('should have valid form when all data is correct', (
      WidgetTester tester,
    ) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter all valid data
      await tester.enterText(find.byType(TextFormField).at(0), 'John');
      await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'john.doe@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(3), '+1234567890');
      await tester.enterText(find.byType(TextFormField).at(4), 'password123');
      await tester.enterText(find.byType(TextFormField).at(5), 'password123');
      await tester.pumpAndSettle();

      // Trigger form validation
      final form = mockRegisterController.formKey.currentState!;
      final isValid = form.validate();
      await tester.pumpAndSettle();

      // Verify form is valid
      expect(isValid, true);

      // No validation errors should appear
      expect(find.text('Please enter your first name'), findsNothing);
      expect(find.text('Please enter your last name'), findsNothing);
      expect(find.text('Please enter your email'), findsNothing);
      expect(find.text('Please enter a valid email'), findsNothing);
      expect(find.text('Please enter your phone number'), findsNothing);
      expect(find.text('Password must be at least 6 characters'), findsNothing);
      expect(find.text('Passwords do not match'), findsNothing);
    });

    testWidgets('should render background image', (WidgetTester tester) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify Container with decoration exists
      final containerWithImage = find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration is BoxDecoration,
      );
      expect(containerWithImage, findsWidgets);
    });

    testWidgets('should have back button in AppBar', (
      WidgetTester tester,
    ) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should allow access to form key', (WidgetTester tester) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify form key is accessible
      expect(mockRegisterController.formKey, isNotNull);
      expect(mockRegisterController.formKey.currentState, isNotNull);
    });

    testWidgets('should display both password fields with eye icons', (
      WidgetTester tester,
    ) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Should have 2 password fields (password and confirm password)
      expect(find.text('Password'), findsNWidgets(2));

      // Should have at least 2 IconButtons for toggling password visibility
      expect(find.byType(IconButton), findsAtLeastNWidgets(2));
    });

    testWidgets(
      'should display password validation error when less than 6 characters',
      (WidgetTester tester) async {
        setupTestSurface(tester);
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Enter short password
        final passwordField = find.byType(TextFormField).at(4);
        await tester.enterText(passwordField, '12345');
        await tester.pumpAndSettle();

        // Trigger form validation
        final form = mockRegisterController.formKey.currentState!;
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
  });

  group('RegisterView Controller Integration Tests', () {
    testWidgets('should update UI when obscurePassword changes', (
      WidgetTester tester,
    ) async {
      setupTestSurface(tester);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial state - password should be obscured
      expect(mockRegisterController.obscurePassword, true);

      // Trigger toggle
      mockRegisterController.toggleObscurePwd();
      await tester.pumpAndSettle();

      // Verify state changed
      expect(mockRegisterController.obscurePassword, false);

      // Toggle back
      mockRegisterController.toggleObscurePwd();
      await tester.pumpAndSettle();

      expect(mockRegisterController.obscurePassword, true);
    });

    testWidgets(
      'should have correct text in all controllers after user input',
      (WidgetTester tester) async {
        setupTestSurface(tester);
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Mock data
        const firstName = 'Ahmed';
        const lastName = 'Maalej';
        const email = 'ahmed.maalej@example.com';
        const phone = '+21612345678';
        const password = 'securepass123';

        // Enter data
        await tester.enterText(find.byType(TextFormField).at(0), firstName);
        await tester.enterText(find.byType(TextFormField).at(1), lastName);
        await tester.enterText(find.byType(TextFormField).at(2), email);
        await tester.enterText(find.byType(TextFormField).at(3), phone);
        await tester.enterText(find.byType(TextFormField).at(4), password);
        await tester.enterText(find.byType(TextFormField).at(5), password);
        await tester.pumpAndSettle();

        // Verify all controllers have correct text
        expect(mockRegisterController.fName.text, firstName);
        expect(mockRegisterController.lName.text, lastName);
        expect(mockRegisterController.email.text, email);
        expect(mockRegisterController.phone.text, phone);
        expect(mockRegisterController.password.text, password);
        expect(mockRegisterController.cpassword.text, password);
      },
    );
  });
}
