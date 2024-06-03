class Validator {
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name can\'t be empty';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email can\'t be empty';
    }

    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }
}
