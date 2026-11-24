import 'package:fa5_creativity_app/constants.dart';
import 'package:fa5_creativity_app/main.dart';
import 'package:fa5_creativity_app/service/pokemon_service.dart';
import 'package:fa5_creativity_app/widget/quiz_screen.dart';
import 'package:fa5_creativity_app/widget/single_pokemon_screen.dart';
import 'package:fa5_creativity_app/widget/team_builder_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonService pokemonService = PokemonService();
  var isLoading = false;
  String? errorMessage;
  List<String> loadedAllPokemon = [];
  List<String> loadedPokemonTypes = ['ALL TYPES'];
  List<String> loadedPokemonGens = ['ALL GENERATIONS'];

  void changeThemeMode() {
    themeModeNotifier.value = 
      themeModeNotifier.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  @override
  void initState() {
    super.initState();
    loadAllPokemon();
  }

  void loadAllPokemon() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      loadedAllPokemon = await pokemonService.fetchAllPokemon();
      var tempPokemonTypes = await pokemonService.fetchAllTypes();
      loadedPokemonTypes = ['ALL TYPES'];
      for(var pokeItem in tempPokemonTypes){
        loadedPokemonTypes.add(pokeItem);
      }
      var tempPokemonGens = await pokemonService.fetchAllGens();
      loadedPokemonGens = ['ALL GENERATIONS'];
      for(var pokeItem in tempPokemonGens){
        loadedPokemonGens.add(pokeItem);
      }

      if (loadedAllPokemon.isEmpty) {
        setState(() {
          errorMessage = 'No Pokémon data was found right now.';
          isLoading = false;
        });
        return;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Could not load Pokémon data. Check your internet connection and try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    void openTeamBuilderScreen() async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TeamBuilderScreen(changeThemeMode, loadedAllPokemon, loadedPokemonTypes, loadedPokemonGens),
        )
      ); 
    }

    void openSinglePokemonScreen() async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SinglePokemonScreen(changeThemeMode, loadedAllPokemon, loadedPokemonTypes, loadedPokemonGens),
        )
      ); 
    }

    void openQuizScreen() async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QuizScreen(changeThemeMode, loadedAllPokemon, loadedPokemonTypes, loadedPokemonGens),
        )
      ); 
    }

    if (isLoading) {
      content = Center(
        child: CircularProgressIndicator(),
      );
    } else if(errorMessage != null) {
      content = Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  loadAllPokemon();
                },
                child: Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    } else {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              pokeballAsset,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              width: 180,
            ),
            SizedBox(height: 16),
            Text('Pokemon Champion Dex',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 34)),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () {
                  openTeamBuilderScreen();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Use That Pokemon\n(Team Builder)',
                  textAlign: TextAlign.center,),
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () {
                  openSinglePokemonScreen();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Choose That Pokémon!\n(Pokémon Viewer and Contraster)',
                  textAlign: TextAlign.center,),
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () {
                  openQuizScreen();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Who\'s That Pokémon?\n(Pokémon Quiz)',
                  textAlign: TextAlign.center,),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: changeThemeMode,
            icon: Icon(Icons.brightness_medium),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: content,
      ),
    );
  }
}