import 'dart:math';
import 'names.dart'; // Import your names file

String generateRandomName() {
  Random random = Random();
  String firstName = FirstNames[random.nextInt(FirstNames.length)];
  String lastName = LastNames[random.nextInt(LastNames.length)];
  int number = random.nextInt(9999); // Random 4-digit number
  int position = random.nextInt(4); // Random position for the number (0-3)

  // Avatars: 👩 for woman, 👨 for man
  String avatar = random.nextBool() ? '' : '' ;

  switch (position) {
    case 0: // "@" symbol at the start
      return "$avatar@$firstName$lastName";
    case 1: // "_" symbol in the middle
      return "$avatar$firstName\_$lastName";
    case 2: // Number at the end
      return "$avatar$firstName$lastName$number";
    default: // No special character or number
      return "$avatar$firstName$lastName";
  }
}
