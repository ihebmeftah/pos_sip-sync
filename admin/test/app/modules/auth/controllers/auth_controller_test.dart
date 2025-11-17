import 'package:admin/app/modules/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  late AuthController authController;

  setUp(() {
    // Initialize GetX for testing
    Get.testMode = true;
    authController = AuthController();
  });

  tearDown(() {
    Get.reset();
  });

  group('AuthController - Initialization', () {
    test('should initialize with correct default values', () {
      expect(authController.rememberMe, false);
      expect(authController.obscurePassword, true);
      expect(authController.emailController.text, isEmpty);
      expect(authController.passwordController.text, isEmpty);
      expect(authController.formKey, isNotNull);
    });

    test('should have success status after onInit', () {
      authController.onInit();
      expect(authController.status.isSuccess, true);
    });
  });

  group('AuthController - Text Controllers', () {
    test('should update email controller text', () {
      const testEmail = 'test@example.com';
      authController.emailController.text = testEmail;
      expect(authController.emailController.text, testEmail);
    });

    test('should update password controller text', () {
      const testPassword = 'password123';
      authController.passwordController.text = testPassword;
      expect(authController.passwordController.text, testPassword);
    });

    test('should clear email controller', () {
      authController.emailController.text = 'test@example.com';
      authController.emailController.clear();
      expect(authController.emailController.text, isEmpty);
    });

    test('should clear password controller', () {
      authController.passwordController.text = 'password123';
      authController.passwordController.clear();
      expect(authController.passwordController.text, isEmpty);
    });
  });

  group('AuthController - Toggle Functions', () {
    test('should toggle obscurePassword from true to false', () {
      expect(authController.obscurePassword, true);
      authController.toggleObscurePwd();
      expect(authController.obscurePassword, false);
    });

    test('should toggle obscurePassword from false to true', () {
      authController.obscurePassword = false;
      authController.toggleObscurePwd();
      expect(authController.obscurePassword, true);
    });

    test('should toggle obscurePassword multiple times', () {
      expect(authController.obscurePassword, true);
      authController.toggleObscurePwd();
      expect(authController.obscurePassword, false);
      authController.toggleObscurePwd();
      expect(authController.obscurePassword, true);
      authController.toggleObscurePwd();
      expect(authController.obscurePassword, false);
    });

    test('should toggle rememberMe from false to true', () {
      expect(authController.rememberMe, false);
      authController.toggleRemebreMe();
      expect(authController.rememberMe, true);
    });

    test('should toggle rememberMe from true to false', () {
      authController.rememberMe = true;
      authController.toggleRemebreMe();
      expect(authController.rememberMe, false);
    });

    test('should toggle rememberMe multiple times', () {
      expect(authController.rememberMe, false);
      authController.toggleRemebreMe();
      expect(authController.rememberMe, true);
      authController.toggleRemebreMe();
      expect(authController.rememberMe, false);
      authController.toggleRemebreMe();
      expect(authController.rememberMe, true);
    });
  });

  group('AuthController - State Management', () {
    test(
      'should maintain independent state for obscurePassword and rememberMe',
      () {
        expect(authController.obscurePassword, true);
        expect(authController.rememberMe, false);

        authController.toggleObscurePwd();
        expect(authController.obscurePassword, false);
        expect(authController.rememberMe, false);

        authController.toggleRemebreMe();
        expect(authController.obscurePassword, false);
        expect(authController.rememberMe, true);
      },
    );

    test(
      'should update emailController without affecting passwordController',
      () {
        authController.emailController.text = 'test@example.com';
        authController.passwordController.text = 'password123';

        authController.emailController.text = 'new@example.com';

        expect(authController.emailController.text, 'new@example.com');
        expect(authController.passwordController.text, 'password123');
      },
    );

    test(
      'should update passwordController without affecting emailController',
      () {
        authController.emailController.text = 'test@example.com';
        authController.passwordController.text = 'password123';

        authController.passwordController.text = 'newpassword';

        expect(authController.emailController.text, 'test@example.com');
        expect(authController.passwordController.text, 'newpassword');
      },
    );
  });

  group('AuthController - Form Key', () {
    test('should have a valid form key', () {
      expect(authController.formKey, isA<GlobalKey<FormState>>());
    });

    test('should have a form key that is not null', () {
      expect(authController.formKey, isNotNull);
    });
  });

  group('AuthController - Edge Cases', () {
    test('should handle empty email', () {
      authController.emailController.text = '';
      expect(authController.emailController.text, isEmpty);
    });

    test('should handle empty password', () {
      authController.passwordController.text = '';
      expect(authController.passwordController.text, isEmpty);
    });

    test('should handle very long email', () {
      final longEmail = 'a' * 100 + '@example.com';
      authController.emailController.text = longEmail;
      expect(authController.emailController.text, longEmail);
    });

    test('should handle very long password', () {
      final longPassword = 'p' * 200;
      authController.passwordController.text = longPassword;
      expect(authController.passwordController.text, longPassword);
    });

    test('should handle special characters in email', () {
      const specialEmail = 'test+tag@example.com';
      authController.emailController.text = specialEmail;
      expect(authController.emailController.text, specialEmail);
    });

    test('should handle special characters in password', () {
      const specialPassword = 'P@ssw0rd!#\$%^&*()';
      authController.passwordController.text = specialPassword;
      expect(authController.passwordController.text, specialPassword);
    });
  });

  group('AuthController - Multiple Operations', () {
    test('should handle multiple sequential operations', () {
      // Set email
      authController.emailController.text = 'user1@example.com';
      expect(authController.emailController.text, 'user1@example.com');

      // Toggle obscurePassword
      authController.toggleObscurePwd();
      expect(authController.obscurePassword, false);

      // Set password
      authController.passwordController.text = 'password123';
      expect(authController.passwordController.text, 'password123');

      // Toggle rememberMe
      authController.toggleRemebreMe();
      expect(authController.rememberMe, true);

      // Change email
      authController.emailController.text = 'user2@example.com';
      expect(authController.emailController.text, 'user2@example.com');
      expect(authController.passwordController.text, 'password123');
      expect(authController.obscurePassword, false);
      expect(authController.rememberMe, true);
    });

    test('should reset controllers properly', () {
      // Set initial values
      authController.emailController.text = 'test@example.com';
      authController.passwordController.text = 'password123';
      authController.toggleObscurePwd();
      authController.toggleRemebreMe();

      // Clear controllers
      authController.emailController.clear();
      authController.passwordController.clear();

      expect(authController.emailController.text, isEmpty);
      expect(authController.passwordController.text, isEmpty);
      expect(authController.obscurePassword, false);
      expect(authController.rememberMe, true);
    });
  });
}
