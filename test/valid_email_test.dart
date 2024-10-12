import 'package:cardsapps/utils/validations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isValidEmail', () {
    expect(
      isValidEmail('text'),
      false,
    );
    expect(
      isValidEmail('Emaipr@gmail.com'),
      true,
    );
    expect(
      isValidEmail('Emai#pr@gmail.com'),
      false,
    );
  });

  test('isValidPassword', () {
    var errors = isValidPassword('test');
    expect(
      errors.length, 
      3
    );
    errors = isValidPassword('Testabc');
    expect(
      errors.contains(PasswordErrors.atLeast6Characters), 
      false
    );

    errors = isValidPassword('Testabc1');
    expect(
      errors.contains(PasswordErrors.atLeast1Number), 
      false
    );

    errors = isValidPassword('Testa bc1A');
    expect(
      errors.isEmpty, 
      false
    );

    errors = isValidPassword('Testabc1A');
    expect(
      errors.isEmpty, 
      true
    );
  });
}
