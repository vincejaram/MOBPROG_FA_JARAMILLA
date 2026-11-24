import 'dart:math';

import 'package:fa5_creativity_app/constants.dart';
import 'package:fa5_creativity_app/service/pokemon_service.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen(this.changeThemeMode, this.loadedAllPokemon, this.loadedPokemonTypes, this.loadedPokemonGens, {super.key});

  final void Function() changeThemeMode;
  final List<String> loadedAllPokemon;
  final List<String> loadedPokemonTypes;
  final List<String> loadedPokemonGens;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PokemonService pokemonService = PokemonService();
  var isLoading = false;
  var isHidden = true;
  var isLoadingPokemon = false;
  String? quizErrorMessage;
  var pokemonCount = 0;
  var quizType = 'ALL TYPES';
  var quizGen = 'ALL GENERATIONS';
  List<String> pokemonQuestionsByType = [];
  List<String> pokemonQuestionsByGen = [];
  List<String> whosThatPokemonList = [];
  List<String> answeredPokemon = [];
  String randomPokemon = '';
  int randomPokemonId = 0;
  int quizScore = 0;
  String correctOrNot = '';
  final _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadQuizSettings();
  }

  void backScreen() {
    Navigator.of(context).pop();
  }

  void loadQuizSettings() async {
    setState(() {
      isLoading = true;
      quizErrorMessage = null;
    });

    try {
      pokemonCount = await pokemonService.fetchPokemonCount();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        quizErrorMessage = 'Could not load quiz settings. Please try again.';
      });
    }
  }

  void getPokemonPool() async {
    setState(() {
      isLoadingPokemon = true;
      isHidden = true;
      quizErrorMessage = null;
      whosThatPokemonList = [];
      answeredPokemon = [];
      quizScore = 0;
      _answerController.text = '';
    });

    try {
      if(quizType == 'ALL TYPES') {
        pokemonQuestionsByType = widget.loadedAllPokemon.take(pokemonCount).toList();
      } else {
        pokemonQuestionsByType = await pokemonService.fetchPokemonByType(quizType);
      }

      if (quizGen == 'ALL GENERATIONS') {
        pokemonQuestionsByGen = widget.loadedAllPokemon.take(pokemonCount).toList();
      } else {
        pokemonQuestionsByGen = await pokemonService.fetchPokemonByGen(quizGen);
      }

      for(var pokeItemType in pokemonQuestionsByType){
        if(pokemonQuestionsByGen.contains(pokeItemType)) {
          whosThatPokemonList.add(pokeItemType);
        }
      }

      if (whosThatPokemonList.isEmpty) {
        setState(() {
          isLoadingPokemon = false;
          quizErrorMessage = 'No Pokémon found for that type and generation filter.';
        });
        return;
      }
      
      int randomIndex = Random().nextInt(whosThatPokemonList.length);
      randomPokemon = whosThatPokemonList[randomIndex];

      final fetchedPokemon = await pokemonService.fetchPokemonInfo(randomPokemon);
      if (fetchedPokemon != null) {
        randomPokemonId = fetchedPokemon.natlDexNumber;
      }

      answeredPokemon.add(randomPokemon);

      setState(() {
        isLoadingPokemon = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPokemon = false;
        quizErrorMessage = 'Could not start quiz right now. Check your connection and try again.';
      });
    }
  }

  void randomizePokemon() async{
    setState(() {
      isLoadingPokemon = true;
      isHidden = true;
      quizErrorMessage = null;
    });

    try {
      do {
        int randomIndex = Random().nextInt(whosThatPokemonList.length);
        randomPokemon = whosThatPokemonList[randomIndex];
      } while (answeredPokemon.contains(randomPokemon));

      final fetchedPokemon = await pokemonService.fetchPokemonInfo(randomPokemon);
      if (fetchedPokemon != null) {
        randomPokemonId = fetchedPokemon.natlDexNumber;
      }

      answeredPokemon.add(randomPokemon);
      setState(() {
        isLoadingPokemon = false;
      });
    } catch (e) {
      setState(() {
        isLoadingPokemon = false;
        quizErrorMessage = 'Failed to load next Pokémon. Please try again.';
      });
    }
  }

  void submitAnswer(){
    if (_answerController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          alignment: Alignment.bottomCenter,
          title: Text('Invalid Input'),
          content: Text(
            'Please make sure you enter an answer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );

      return;
    } else if(_answerController.text.trim() == randomPokemon.trim().replaceAll('-', ' ')) {
      correctOrNot = 'Correct!';
      quizScore++;
    } else {
      correctOrNot = 'Wrong!';
    }

    setState(() {
      isHidden = false;
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        alignment: Alignment.bottomCenter,
        title: Text(correctOrNot),
        content: Text(
          'The hidden pokémon is $randomPokemon.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if(answeredPokemon.length == whosThatPokemonList.length || correctOrNot == 'Wrong!'){
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    alignment: Alignment.bottomCenter,
                    title: Text('Quiz Done!'),
                    content: Text(
                      'Final Score: $quizScore/${answeredPokemon.length}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            randomPokemonId = 0;
                          });
                        },
                        child: Text('Okay'),
                      ),
                    ],
                  ),
                );
              } else {
                randomizePokemon();
              }
              _answerController.text = '';
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      content = SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Who\'s That Pokémon?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 32)),
              SizedBox(height: 16),
              if(randomPokemonId == 0 && !isLoadingPokemon)...{
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        value: quizType,
                        items: widget.loadedPokemonTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                type.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            quizType = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        value: quizGen,
                        items: widget.loadedPokemonGens
                          .map(
                            (gen) => DropdownMenuItem(
                              value: gen,
                              child: Text(
                                gen.replaceAll('-', ' ').toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            quizGen = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: getPokemonPool,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Start Quiz'),
                    ),
                  ),
                ),
              },
              if(quizErrorMessage != null)...[
                SizedBox(height: 14),
                Text(
                  quizErrorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (pokemonCount == 0) {
                      loadQuizSettings();
                    } else if (whosThatPokemonList.isEmpty) {
                      getPokemonPool();
                    } else {
                      randomizePokemon();
                    }
                  },
                  child: Text('Try Again'),
                ),
              ],
              SizedBox(height: 28),
              SizedBox(
                height: 200,
                width: 200,
                child: isLoadingPokemon
                    ? const Center(child: CircularProgressIndicator())
                    : randomPokemonId == 0
                        ? Image.asset(
                            'assets/whos-that-pokemon-logo.png',
                            width: 200,
                          )
                        : Image.network(
                            '$spriteBaseUrl$randomPokemonId.png',
                            color: isHidden 
                              ? Theme.of(context).textTheme.titleLarge!.color
                              : null,
                            width: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.catching_pokemon, size: 90);
                            },
                          ),
              ),
              SizedBox(height: 28),
              if (randomPokemonId != 0) ...[
                TextField(
                  controller: _answerController,
                  maxLength: 50,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    label: Text('Wrong spelling is wrong!'),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      submitAnswer();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Submit Answer'),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon Quiz'),
        leading: IconButton(
          onPressed: backScreen, 
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: widget.changeThemeMode,
            icon: Icon(Icons.brightness_medium),
          ),
        ],
      ),
      body: content,
    );
  }
}