import 'package:admin/app/data/model/enums/user_role.dart';
import 'package:admin/app/modules/auth/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  late RegisterController registerController;

  setUp(() {
    // Initialize GetX for testing
    Get.testMode = true;
    registerController = RegisterController();
  });

  tearDown(() {
    Get.reset();
  });

  group('RegisterController - Initialization', () {
    test('should initialize with correct default values', () {
      expect(registerController.obscurePassword, true);
      expect(registerController.fName.text, isEmpty);
      expect(registerController.lName.text, isEmpty);
      expect(registerController.email.text, isEmpty);
      expect(registerController.phone.text, isEmpty);
      expect(registerController.password.text, isEmpty);
      expect(registerController.cpassword.text, isEmpty);
      expect(registerController.formKey, isNotNull);
    });

    test('should have success status after onInit', () {
      registerController.onInit();
      expect(registerController.status.isSuccess, true);
    });
  });

  group('RegisterController - Text Controllers', () {
    test('should update first name controller', () {
      const firstName = 'John';
      registerController.fName.text = firstName;
      expect(registerController.fName.text, firstName);
    });

    test('should update last name controller', () {
      const lastName = 'Doe';
      registerController.lName.text = lastName;
      expect(registerController.lName.text, lastName);
    });

    test('should update email controller', () {
      const email = 'john.doe@example.com';
      registerController.email.text = email;
      expect(registerController.email.text, email);
    });

    test('should update phone controller', () {
      const phone = '+1234567890';
      registerController.phone.text = phone;
      expect(registerController.phone.text, phone);
    });

    test('should update password controller', () {
      const password = 'password123';
      registerController.password.text = password;
      expect(registerController.password.text, password);
    });

    test('should update confirm password controller', () {
      const cpassword = 'password123';
      registerController.cpassword.text = cpassword;
      expect(registerController.cpassword.text, cpassword);
    });

    test('should clear all controllers', () {
      registerController.fName.text = 'John';
      registerController.lName.text = 'Doe';
      registerController.email.text = 'john@example.com';
      registerController.phone.text = '+1234567890';
      registerController.password.text = 'password123';
      registerController.cpassword.text = 'password123';

      registerController.fName.clear();
      registerController.lName.clear();
      registerController.email.clear();
      registerController.phone.clear();
      registerController.password.clear();
      registerController.cpassword.clear();

      expect(registerController.fName.text, isEmpty);
      expect(registerController.lName.text, isEmpty);
      expect(registerController.email.text, isEmpty);
      expect(registerController.phone.text, isEmpty);
      expect(registerController.password.text, isEmpty);
      expect(registerController.cpassword.text, isEmpty);
    });
  });

  group('RegisterController - Toggle Functions', () {
    test('should toggle obscurePassword from true to false', () {
      expect(registerController.obscurePassword, true);
      registerController.toggleObscurePwd();
      expect(registerController.obscurePassword, false);
    });

    test('should toggle obscurePassword from false to true', () {
      registerController.obscurePassword = false;
      registerController.toggleObscurePwd();
      expect(registerController.obscurePassword, true);
    });

    test('should toggle obscurePassword multiple times', () {
      expect(registerController.obscurePassword, true);
      registerController.toggleObscurePwd();
      expect(registerController.obscurePassword, false);
      registerController.toggleObscurePwd();
      expect(registerController.obscurePassword, true);
      registerController.toggleObscurePwd();
      expect(registerController.obscurePassword, false);
    });
  });

  group('RegisterController - User Getter', () {
    test('should create user object with correct data', () {
      registerController.fName.text = 'John';
      registerController.lName.text = 'Doe';
      registerController.email.text = 'john.doe@example.com';
      registerController.phone.text = '+1234567890';
      registerController.password.text = 'password123';

      final user = registerController.user;

      expect(user.firstname, 'John');
      expect(user.lastname, 'Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.phone, '+1234567890');
      expect(user.password, 'password123');
      expect(user.type, UserType.admin);
    });

    test('should create user with empty fields when controllers are empty', () {
      final user = registerController.user;

      expect(user.firstname, isEmpty);
      expect(user.lastname, isEmpty);
      expect(user.email, isEmpty);
      expect(user.phone, isEmpty);
      expect(user.password, isEmpty);
      expect(user.type, UserType.admin);
    });

    test('should update user object when controllers change', () {
      registerController.fName.text = 'Jane';
      registerController.lName.text = 'Smith';
      registerController.email.text = 'jane@example.com';
      registerController.phone.text = '+9876543210';
      registerController.password.text = 'newpass123';

      final user = registerController.user;

      expect(user.firstname, 'Jane');
      expect(user.lastname, 'Smith');
      expect(user.email, 'jane@example.com');
      expect(user.phone, '+9876543210');
      expect(user.password, 'newpass123');
    });

    test('should always set user type to admin', () {
      registerController.fName.text = 'Test';
      registerController.lName.text = 'User';

      final user1 = registerController.user;
      expect(user1.type, UserType.admin);

      registerController.fName.text = 'Another';
      final user2 = registerController.user;
      expect(user2.type, UserType.admin);
    });
  });

  group('RegisterController - State Management', () {
    test('should maintain independent state for all controllers', () {
      registerController.fName.text = 'John';
      registerController.lName.text = 'Doe';

      expect(registerController.fName.text, 'John');
      expect(registerController.lName.text, 'Doe');
      expect(registerController.email.text, isEmpty);
      expect(registerController.phone.text, isEmpty);
      expect(registerController.password.text, isEmpty);
      expect(registerController.cpassword.text, isEmpty);
    });

    test('should update one controller without affecting others', () {
      registerController.fName.text = 'John';
      registerController.lName.text = 'Doe';
      registerController.email.text = 'john@example.com';
      registerController.phone.text = '+1234567890';
      registerController.password.text = 'password123';
      registerController.cpassword.text = 'password123';

      registerController.email.text = 'newemail@example.com';

      expect(registerController.fName.text, 'John');
      expect(registerController.lName.text, 'Doe');
      expect(registerController.email.text, 'newemail@example.com');
      expect(registerController.phone.text, '+1234567890');
      expect(registerController.password.text, 'password123');
      expect(registerController.cpassword.text, 'password123');
    });
  });

  group('RegisterController - Password Matching', () {
    test('should have matching passwords', () {
      const password = 'password123';
      registerController.password.text = password;
      registerController.cpassword.text = password;

      expect(
        registerController.password.text,
        registerController.cpassword.text,
      );
    });

    test('should have non-matching passwords', () {
      registerController.password.text = 'password123';
      registerController.cpassword.text = 'password456';

      expect(
        registerController.password.text,
        isNot(equals(registerController.cpassword.text)),
      );
    });

    test('should detect password mismatch after update', () {
      registerController.password.text = 'password123';
      registerController.cpassword.text = 'password123';

      expect(
        registerController.password.text,
        registerController.cpassword.text,
      );

      registerController.cpassword.text = 'differentpassword';

      expect(
        registerController.password.text,
        isNot(equals(registerController.cpassword.text)),
      );
    });
  });

  group('RegisterController - Form Key', () {
    test('should have a valid form key', () {
      expect(registerController.formKey, isA<GlobalKey<FormState>>());
    });

    test('should have a form key that is not null', () {
      expect(registerController.formKey, isNotNull);
    });
  });

  group('RegisterController - Edge Cases', () {
    test('should handle special characters in names', () {
      registerController.fName.text = "O'Brien";
      registerController.lName.text = 'José-María';

      expect(registerController.fName.text, "O'Brien");
      expect(registerController.lName.text, 'José-María');
    });

    test('should handle international phone numbers', () {
      const phones = [
        '+1234567890',
        '+44 20 7946 0958',
        '+33 1 42 86 82 00',
        '+81 3-3580-3311',
      ];

      for (final phone in phones) {
        registerController.phone.text = phone;
        expect(registerController.phone.text, phone);
      }
    });

    test('should handle various email formats', () {
      const emails = [
        'simple@example.com',
        'very.common@example.com',
        'disposable.style.email.with+symbol@example.com',
        'user@subdomain.example.com',
      ];

      for (final email in emails) {
        registerController.email.text = email;
        expect(registerController.email.text, email);
      }
    });

    test('should handle empty password', () {
      registerController.password.text = '';
      expect(registerController.password.text, isEmpty);
    });

    test('should handle very long password', () {
      final longPassword = 'p' * 200;
      registerController.password.text = longPassword;
      expect(registerController.password.text, longPassword);
    });

    test('should handle whitespace in names', () {
      registerController.fName.text = '  John  ';
      registerController.lName.text = ' Doe ';

      expect(registerController.fName.text, '  John  ');
      expect(registerController.lName.text, ' Doe ');
    });
  });

  group('RegisterController - Multiple Operations', () {
    test('should handle complete registration flow data', () {
      // Fill all fields
      registerController.fName.text = 'Ahmed';
      registerController.lName.text = 'Maalej';
      registerController.email.text = 'ahmed.maalej@example.com';
      registerController.phone.text = '+21612345678';
      registerController.password.text = 'securePassword123';
      registerController.cpassword.text = 'securePassword123';

      // Toggle password visibility
      registerController.toggleObscurePwd();

      // Verify all data
      expect(registerController.fName.text, 'Ahmed');
      expect(registerController.lName.text, 'Maalej');
      expect(registerController.email.text, 'ahmed.maalej@example.com');
      expect(registerController.phone.text, '+21612345678');
      expect(registerController.password.text, 'securePassword123');
      expect(registerController.cpassword.text, 'securePassword123');
      expect(registerController.obscurePassword, false);

      // Verify user object
      final user = registerController.user;
      expect(user.firstname, 'Ahmed');
      expect(user.lastname, 'Maalej');
      expect(user.email, 'ahmed.maalej@example.com');
      expect(user.phone, '+21612345678');
      expect(user.password, 'securePassword123');
      expect(user.type, UserType.admin);
    });

    test('should handle sequential updates correctly', () {
      // First update
      registerController.fName.text = 'John';
      expect(registerController.fName.text, 'John');

      // Second update
      registerController.fName.text = 'Jane';
      expect(registerController.fName.text, 'Jane');

      // Third update
      registerController.fName.text = 'Jack';
      expect(registerController.fName.text, 'Jack');
    });

    test('should reset all fields properly', () {
      // Set all fields
      registerController.fName.text = 'Test';
      registerController.lName.text = 'User';
      registerController.email.text = 'test@example.com';
      registerController.phone.text = '+1234567890';
      registerController.password.text = 'password';
      registerController.cpassword.text = 'password';
      registerController.toggleObscurePwd();

      // Clear all
      registerController.fName.clear();
      registerController.lName.clear();
      registerController.email.clear();
      registerController.phone.clear();
      registerController.password.clear();
      registerController.cpassword.clear();

      // Verify cleared
      expect(registerController.fName.text, isEmpty);
      expect(registerController.lName.text, isEmpty);
      expect(registerController.email.text, isEmpty);
      expect(registerController.phone.text, isEmpty);
      expect(registerController.password.text, isEmpty);
      expect(registerController.cpassword.text, isEmpty);
      expect(
        registerController.obscurePassword,
        false,
      ); // Should remain toggled
    });
  });
}
