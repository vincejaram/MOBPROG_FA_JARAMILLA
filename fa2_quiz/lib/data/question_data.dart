import 'package:fa2_quiz/model/question.dart';

const questionData = [
  //first choice is always the correct answer
  Question(
  'Which beast guards the center of the Labyrinth?',
  ['Minotaur', 'Hydra', 'Chimera', 'Pegasus', 'Cerberus'],
  ),
  Question(
  'Who was the mastermind behind the Trojan Horse which won the Achaeans the Trojan War?',
  ['Odysseus', 'Athena', 'Ares', 'Agamemnon', 'Ajax the Great'],
  ),
  Question(
  'Which hero became invincible after being almost fully submerged in the River Styx?',
  ['Achilles', 'Odysseus', 'Heracles', 'Jason', 'Theseus'],
  ),
  Question(
  'Which hero is known for slaying Medusa?',
  ['Perseus', 'Theseus', 'Aeneas', 'Heracles', 'Diomedes'],
  ),
  Question(
  'Who was famously born by coming out of Zeus\' head fully grown and armored?',
  ['Athena', 'Ares', 'Hephaestus', 'Apollo', 'Artemis'],
  ),
  Question(
  'Which among the following is NOT one of the 12 Olympians?',
  ['Hades', 'Dionysus', 'Demeter', 'Poseidon', 'Aphrodite'],
  ),
  Question(
  'Which pairing of the gods built the impenetrable walls of Troy?',
  ['Poseidon & Apollo', 'Zeus & Poseidon', 'Apollo & Artemis', 'Zeus & Hera', 'Hera & Artemis'],
  ),
  Question(
  'Which titan was punished to hold up the heavens for eternity after siding against the Olympians during the Titanomachy?',
  ['Atlas', 'Prometheus', 'Cronus', 'Epimetheus', 'Hyperion'],
  ),
  Question(
  'Which titan gave humans fire?',
  ['Prometheus', 'Atlas', 'Cronus', 'Epimetheus', 'Hyperion'],
  ),
  Question(
  'Who is the primordial goddess of the earth from which the term \'Mother Nature\' come from?',
  ['Gaia', 'Hera', 'Rhea', 'Demeter', 'Leto'],
  ),
];

String finalResult = "RESULTS\n";
int finalScore = 0;