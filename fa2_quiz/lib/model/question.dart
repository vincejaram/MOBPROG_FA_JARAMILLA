class Question {
  const Question(this.question, this.choice);

  final String question;
  final List<String> choice;

  List<String> getShuffledList() {
    final shuffledList = List<String>.from(choice);
    shuffledList.shuffle();
    
    return shuffledList;
  }
}