import 'package:fa5_creativity_app/constants.dart';
import 'package:fa5_creativity_app/model/pokemon.dart';
import 'package:fa5_creativity_app/service/pokemon_service.dart';
import 'package:fa5_creativity_app/widget/pokemon_search.dart';
import 'package:fa5_creativity_app/widget/single_pokemon_screen.dart';
import 'package:flutter/material.dart';

class TeamBuilderScreen extends StatefulWidget {
  const TeamBuilderScreen(this.changeThemeMode, this.loadedAllPokemon, this.loadedPokemonTypes, this.loadedPokemonGens, {super.key});

  final void Function() changeThemeMode;
  final List<String> loadedAllPokemon;
  final List<String> loadedPokemonTypes;
  final List<String> loadedPokemonGens;

  @override
  State<TeamBuilderScreen> createState() => _TeamBuilderScreenState();
}

class _TeamBuilderScreenState extends State<TeamBuilderScreen> {
  final PokemonService pokemonService = PokemonService();
  var isLoading = false;
  List<Pokemon?> teamSlots = List.filled(maxTeamSize, null);
  List<bool?> isLoadingSlot = List.filled(maxTeamSize, false);
  List<String?> slotErrors = List.filled(maxTeamSize, null);
  List<String?> lastFailedQueries = List.filled(maxTeamSize, null);
  List<String> teamStrength = [];
  List<String> teamWeakness = [];
  List<String> teamResistance = [];
  List<String> teamImmunity = [];
  var isLoadingMatchup = false;
  String? matchupErrorMessage;

  @override
  void initState() {
    super.initState();
  }

  void _updateTeamMatchup() async {
    setState(() {
      isLoadingMatchup = true;
      matchupErrorMessage = null;
    });

    try {
      List<String> allStrengths = [];
      List<String> allWeaknesses = [];
      List<String> allResistances = [];
      List<String> allImmunities = [];

      for(var poke in teamSlots) {
        if(poke != null) {
          for(var type in poke.type) {
            var matchup = await pokemonService.fetchTypeMatchup(type);

            for(var strongType in matchup['strengths']!) {
              if(!allStrengths.contains(strongType)) {
                allStrengths.add(strongType);
              }
            }

            for(var weakType in matchup['weaknesses']!) {
              if(!allWeaknesses.contains(weakType)) {
                allWeaknesses.add(weakType);
              }
            }

            for(var resistType in matchup['resistances']!) {
              if(!allResistances.contains(resistType)) {
                allResistances.add(resistType);
              }
            }

            for(var immuneType in matchup['immunities']!) {
              if(!allImmunities.contains(immuneType)) {
                allImmunities.add(immuneType);
              }
            }
          }
        }
      }

      setState(() {
        teamStrength = allStrengths;
        teamWeakness = allWeaknesses;
        teamResistance = allResistances;
        teamImmunity = allImmunities;
        isLoadingMatchup = false;
      });
    } catch (e) {
      setState(() {
        matchupErrorMessage = 'Could not load team matchups. Please try again.';
        isLoadingMatchup = false;
      });
    }
  }

  Future<void> _fetchTeamSlot(int index, String query) async {
    setState(() {
      isLoadingSlot[index] = true;
      slotErrors[index] = null;
      lastFailedQueries[index] = query;
    });

    try {
      var fetchedPokemon = await pokemonService.fetchPokemonInfo(query);
      if (fetchedPokemon == null) {
        setState(() {
          isLoadingSlot[index] = false;
          slotErrors[index] = 'Pokémon details could not be loaded.';
        });
        return;
      }

      setState(() {
        teamSlots[index] = fetchedPokemon;
        isLoadingSlot[index] = false;
        slotErrors[index] = null;
        lastFailedQueries[index] = null;
      });

      _updateTeamMatchup();
    } catch (e) {
      setState(() {
        isLoadingSlot[index] = false;
        slotErrors[index] = 'Failed to load Pokémon. Check your connection and try again.';
      });
    }
  }

  void _openSearchModal(int index) async {
    var result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, 
      builder: (ctx) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.72,
        child: PokemonSearch(widget.loadedAllPokemon, widget.loadedPokemonTypes, widget.loadedPokemonGens,  index, teamSlots[index], ),
      ),
    );

    if (result == null) {
      return;
    }

    if (result == removePokemonAction) {
      setState(() {
        teamSlots[index] = null;
        slotErrors[index] = null;
        lastFailedQueries[index] = null;
      });
      _updateTeamMatchup();
      return;
    }

    await _fetchTeamSlot(index, result);
  }

  void _confirmViewPokemon(Pokemon pokemon) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'View Pokémon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Do you want to analyze ${pokemon.name.replaceAll('-', ' ').toUpperCase()} in another screen?',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SinglePokemonScreen(
                    widget.changeThemeMode,
                    widget.loadedAllPokemon,
                    widget.loadedPokemonTypes,
                    widget.loadedPokemonGens,
                    initialPokemon: pokemon,
                  ),
                ),
              );
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon Team Builder'),
        actions: [
          IconButton(
            onPressed: widget.changeThemeMode,
            icon: Icon(Icons.brightness_medium),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Use That Pokémon!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 32)),
              SizedBox(height: 10),
              Image.asset(
                pokeballAsset,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                width: 90,
              ),
              SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final pokemon = teamSlots[index];
                  var isSlotDisabled = index > 0 && teamSlots[index - 1] == null;

                  if (isLoadingSlot[index] == true) {
                    return Card(
                      margin: EdgeInsets.zero,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if(slotErrors[index] != null) {
                    return Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slotErrors[index]!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            SizedBox(height: 8),
                            if (lastFailedQueries[index] != null)
                              ElevatedButton(
                                onPressed: () {
                                  _fetchTeamSlot(index, lastFailedQueries[index]!);
                                },
                                child: Text('Try Again'),
                              ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (pokemon == null) {
                    return Card(
                      margin: EdgeInsets.zero,
                      child: InkWell(
                        onTap: isSlotDisabled ? null : () {
                          _openSearchModal(index);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isSlotDisabled ? Icons.lock : Icons.add,
                                size: 32,
                                color: isSlotDisabled
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                              SizedBox(height: 6),
                              Text(
                                isSlotDisabled ? 'Fill previous slot first' : 'Tap to add pokémon',
                                textAlign: TextAlign.center,
                                style: isSlotDisabled
                                    ? Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey)
                                    : Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return Card(
                    margin: EdgeInsets.zero,
                    child: InkWell(
                      onTap: () {
                        _openSearchModal(index);
                      },
                      onDoubleTap: () {
                        _confirmViewPokemon(pokemon);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                '$spriteBaseUrl${pokemon.natlDexNumber}.png',
                                height: 74,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.catching_pokemon, size: 56);
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                pokemon.name.replaceAll('-', ' ').toUpperCase(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: maxTeamSize,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.15,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
              SizedBox(height: 16),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: isLoadingMatchup
                      ? Center(child: CircularProgressIndicator())
                      : matchupErrorMessage != null
                          ? Center(
                              child: Column(
                                children: [
                                  Text(
                                    matchupErrorMessage!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      _updateTeamMatchup();
                                    },
                                    child: Text('Try Again'),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Strengths (Super Effective Against)',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${teamStrength.length}/$totalPokemonTypes',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                teamStrength.isEmpty
                                    ? Text(
                                        'Add a Pokémon to see team strengths.',
                                        style: Theme.of(context).textTheme.titleSmall,
                                      )
                                    : Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: teamStrength
                                            .map((type) => Card(
                                                  margin: EdgeInsets.zero,
                                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                    child: Text(
                                                      type.toUpperCase(),
                                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Weaknesses (Weak Against)',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${teamWeakness.length}/$totalPokemonTypes',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                teamWeakness.isEmpty
                                    ? Text(
                                        'Add a Pokémon to see team weaknesses.',
                                        style: Theme.of(context).textTheme.titleSmall,
                                      )
                                    : Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: teamWeakness
                                            .map((type) => Card(
                                                  margin: EdgeInsets.zero,
                                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                    child: Text(
                                                      type.toUpperCase(),
                                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Resistances (Resistant Against)',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${teamResistance.length}/$totalPokemonTypes',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                teamResistance.isEmpty
                                    ? Text(
                                        'Add a Pokémon to see team resistances.',
                                        style: Theme.of(context).textTheme.titleSmall,
                                      )
                                    : Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: teamResistance
                                            .map((type) => Card(
                                                  margin: EdgeInsets.zero,
                                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                    child: Text(
                                                      type.toUpperCase(),
                                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Immunities (Immune Against)',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${teamImmunity.length}/$totalPokemonTypes',
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                teamImmunity.isEmpty
                                    ? Text(
                                        'Add a Pokémon to see team immunities.',
                                        style: Theme.of(context).textTheme.titleSmall,
                                      )
                                    : Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: teamImmunity
                                            .map((type) => Card(
                                                  margin: EdgeInsets.zero,
                                                  color: Theme.of(context).colorScheme.secondaryContainer,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                    child: Text(
                                                      type.toUpperCase(),
                                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                              ],
                            ),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}