import 'dart:math';

class Comment {
  final String username;
  final String message;

  Comment({required this.username, required this.message});
}

String getRandomElement(List<String> list) {
  final random = Random();
  return list[random.nextInt(list.length)];
}

Comment generateRandomComment(int commentNumber) {
  List<String> positiveAdjectives = [
    "amazing", "incredible", "awesome", "fantastic", "brilliant", "exceptional",
    "outstanding", "remarkable", "impressive", "marvelous", "excellent",
    "spectacular", "wonderful", "magnificent", "extraordinary", "stunning",
    "delightful", "superb", "enchanting", "radiant", "fabulous", "splendid",
    "admirable", "charming", "exquisite", "flawless", "ideal", "perfect",
    "phenomenal", "captivating", "breathtaking", "alluring", "glorious",
    "heavenly", "majestic", "divine", "sublime", "graceful", "dazzling",
    "elegant", "exalted", "illustrious", "magnanimous", "noble", "praiseworthy",
    "resplendent", "vibrant", "vivacious", "wondrous"
  ];
  List<String> streamerActions = [
    "how you handled today's topic.", "your explanation of the subject.", "the way you engage with your audience.", // ... more actions
  ];
  List<String> nextPersonPhrases = [
    "And hey, the person next to you is looking great!", "Also, your co-host is adding so much value!", // ... more phrases
  ];
  List<String> emojis = [
    "😄", "👍", "🔥", "💡", // ... more emojis
  ];
  List<String> sarcasticRemarks = [
    "Never heard that before...", "Wow, that's a first!", // ... more remarks
  ];

  Random random = Random();
  bool mentionNextPerson = random.nextInt(100) < 30; // 30% chance to mention the next person
  bool isSarcastic = random.nextInt(100) < 20; // 20% chance of being sarcastic

  String message;
  if (isSarcastic) {
    message = getRandomElement(sarcasticRemarks);
  } else {
    message = "It's ${getRandomElement(positiveAdjectives)} ${getRandomElement(streamerActions)}";
    if (mentionNextPerson) {
      message += " ${getRandomElement(nextPersonPhrases)}";
    }
    message += " ${getRandomElement(emojis)}";
  }

  return Comment(
    username: "Viewer$commentNumber",
    message: message,
  );
}

List<Comment> generateMockComments(int numberOfComments) {
  List<Comment> comments = [];
  for (int i = 0; i < numberOfComments; i++) {
    comments.add(generateRandomComment(i));
  }
  return comments;
}
