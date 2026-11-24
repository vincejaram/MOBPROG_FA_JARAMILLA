import 'package:fa5_creativity_app/constants.dart';
import 'package:fa5_creativity_app/model/pokemon.dart';
import 'package:fa5_creativity_app/service/pokemon_service.dart';
import 'package:fa5_creativity_app/widget/pokemon_search.dart';
import 'package:flutter/material.dart';

class SinglePokemonScreen extends StatefulWidget {
  const SinglePokemonScreen(this.changeThemeMode, this.loadedAllPokemon, this.loadedPokemonTypes, this.loadedPokemonGens, {this.initialPokemon, super.key});

  final void Function() changeThemeMode;
  final List<String> loadedAllPokemon;
  final List<String> loadedPokemonTypes;
  final List<String> loadedPokemonGens;
  final Pokemon? initialPokemon;

  @override
  State<SinglePokemonScreen> createState() => _SinglePokemonScreenState();
}

class _SinglePokemonScreenState extends State<SinglePokemonScreen> {
  final PokemonService pokemonService = PokemonService();
  List<Pokemon?> pokemonSlots = List.filled(maxCompareSize, null);
  List<bool?> isLoadingSlot = [false, false];
  List<String?> slotErrorMessages = [null, null];
  List<String?> lastFailedQueries = [null, null];
  var isLoadingMatchup = false;
  String? matchupErrorMessage;
  String attackerMatchupText = '';

  @override
  void initState() {
    super.initState();
    if(widget.initialPokemon != null) {
      pokemonSlots[0] = widget.initialPokemon;
    }
  }

  Color _getStatColor(int statValue) {
    if (statValue <= 29) {
      return Colors.red;
    } else if(statValue <= 59) {
      return Colors.orange;
    } else if (statValue <= 89) {
      return Colors.yellow;
    } else if(statValue <= 119) {
      return Colors.green;
    } else if (statValue <= 149) {
      return Colors.green[800]!;
    } else {
      return Colors.cyan;
    }
  }

  int _getBaseStatTotal(Pokemon pokemon) {
    int total = 0;
    for (var value in pokemon.stats.values) {
      total += value;
    }
    return total;
  }

  void _swapSlots() {
    if (pokemonSlots[0] == null || pokemonSlots[1] == null) {
      return;
    }

    setState(() {
      var tempPokemon = pokemonSlots[0];
      pokemonSlots[0] = pokemonSlots[1];
      pokemonSlots[1] = tempPokemon;

      var tempError = slotErrorMessages[0];
      slotErrorMessages[0] = slotErrorMessages[1];
      slotErrorMessages[1] = tempError;

      var tempQuery = lastFailedQueries[0];
      lastFailedQueries[0] = lastFailedQueries[1];
      lastFailedQueries[1] = tempQuery;
    });

    _updateContrastMatchup();
  }

  void _updateContrastMatchup() async {
    if(pokemonSlots[0] == null || pokemonSlots[1] == null) {
      setState(() {
        attackerMatchupText = '';
        matchupErrorMessage = null;
      });
      return;
    }

    setState(() {
      isLoadingMatchup = true;
      matchupErrorMessage = null;
    });

    try {
      var attacker = pokemonSlots[0]!;
      var defender = pokemonSlots[1]!;

      var attackerName = attacker.name.replaceAll('-', ' ').toUpperCase();
      var defenderName = defender.name.replaceAll('-', ' ').toUpperCase();
      var defenderTypesLabel = defender.type.map((t) => t.toUpperCase()).join(' / ');

      List<String> lines = [];

      for (var atkType in attacker.type) {
        var matchup = await pokemonService.fetchTypeMatchup(atkType);
        List<String> doubleTo = List<String>.from(matchup['strengths'] ?? []);
        List<String> halfTo = List<String>.from(matchup['halfDamageTo'] ?? []);
        List<String> noTo = List<String>.from(matchup['noDamageTo'] ?? []);

        double mult = 1.0;
        for(var defType in defender.type) {
          if (noTo.contains(defType)) {
            mult = mult * 0.0;
          } else if(doubleTo.contains(defType)) {
            mult = mult * 2.0;
          } else if (halfTo.contains(defType)) {
            mult = mult * 0.5;
          }
        }

        var atkLabel = atkType.toUpperCase();
        if (mult == 0.0) {
          lines.add('$atkLabel attack vs $defenderName ($defenderTypesLabel): No effect (0x)');
        } else if(mult > 1.0) {
          lines.add('$atkLabel attack vs $defenderName ($defenderTypesLabel): Super effective (${mult}x)');
        } else if (mult < 1.0) {
          lines.add('$atkLabel attack vs $defenderName ($defenderTypesLabel): Not very effective (${mult}x)');
        } else {
          lines.add('$atkLabel attack vs $defenderName ($defenderTypesLabel): Neutral (1x)');
        }
      }

      setState(() {
        attackerMatchupText = '$attackerName (Attacker) vs $defenderName (Defender)\n\n${lines.join('\n')}';
        isLoadingMatchup = false;
      });
    } catch (e) {
      setState(() {
        matchupErrorMessage = 'Could not load type matchup. Check your connection and try again.';
        isLoadingMatchup = false;
      });
    }
  }

  Future<void> _fetchSlotPokemon(int index, String query) async {
    setState(() {
      isLoadingSlot[index] = true;
      slotErrorMessages[index] = null;
      lastFailedQueries[index] = query;
    });

    try {
      var fetchedPokemon = await pokemonService.fetchPokemonInfo(query);
      if (fetchedPokemon == null) {
        setState(() {
          isLoadingSlot[index] = false;
          slotErrorMessages[index] = 'Failed to load Pokémon data. Please try again.';
        });
        return;
      }
      setState(() {
        pokemonSlots[index] = fetchedPokemon;
        isLoadingSlot[index] = false;
        slotErrorMessages[index] = null;
        lastFailedQueries[index] = null;
      });
      _updateContrastMatchup();
    } catch (e) {
      setState(() {
        isLoadingSlot[index] = false;
        slotErrorMessages[index] = 'Failed to load Pokémon data. Please try again.';
      });
    }
  }

  void _openSearchModal(int index) async {
    var result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true, 
      builder: (ctx) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.72,
        child: PokemonSearch(widget.loadedAllPokemon, widget.loadedPokemonTypes, widget.loadedPokemonGens,  index, pokemonSlots[index], ),
      ),
    );

    if(result == null) {
      return;
    }

    if (result == removePokemonAction) {
      setState(() {
        pokemonSlots[index] = null;
        slotErrorMessages[index] = null;
        lastFailedQueries[index] = null;
      });
      _updateContrastMatchup();
      return;
    }

    await _fetchSlotPokemon(index, result);
  }

  void _showFlavorDialog(Pokemon pokemon) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          '${pokemon.name.replaceAll('-', ' ').toUpperCase()} - Pokédex Entry',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          pokemon.flavorTextEntry,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAbilitiesDialog(Pokemon pokemon) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          '${pokemon.name.replaceAll('-', ' ').toUpperCase()} - Abilities (${pokemon.abilities.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: pokemon.abilities.isEmpty
              ? Text('No abilities found.', style: Theme.of(context).textTheme.titleSmall)
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: pokemon.abilities.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        pokemon.abilities[index].replaceAll('-', ' ').toUpperCase(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMovesDialog(Pokemon pokemon) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          '${pokemon.name.replaceAll('-', ' ').toUpperCase()} - Moves (${pokemon.moves.length})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.sizeOf(context).height * 0.4,
          child: pokemon.moves.isEmpty
              ? Text('No moves found.', style: Theme.of(context).textTheme.titleSmall)
              : ListView.builder(
                  itemCount: pokemon.moves.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        pokemon.moves[index].replaceAll('-', ' ').toUpperCase(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon Matchup Analyzer'),
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
              Text('Choose That Pokémon!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 32)),
              SizedBox(height: 10),
              Image.asset(
                pokeballAsset,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                width: 90,
              ),
              SizedBox(height: 14),
              if(pokemonSlots[0] != null && pokemonSlots[1] != null)...[
                Card(
                  margin: EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: isLoadingMatchup
                        ? Center(child: CircularProgressIndicator())
                        : matchupErrorMessage != null
                            ? Column(
                                children: [
                                  Text(
                                    matchupErrorMessage!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      _updateContrastMatchup();
                                    },
                                    child: Text('Try Again'),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    'Type Matchup',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    attackerMatchupText,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  ElevatedButton.icon(
                                    onPressed: _swapSlots,
                                    icon: Icon(Icons.swap_vert),
                                    label: Text('Switch Attacker & Defender'),
                                  ),
                                ],
                              ),
                  ),
                ),
              ],
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: maxCompareSize,
                itemBuilder: (context, index) {
                  final pokemon = pokemonSlots[index];
                  var isSlotDisabled = index > 0 && pokemonSlots[index - 1] == null;
                  var roleLabel = index == 0 ? 'Slot 1 (Attacker)' : 'Slot 2 (Defender)';

                  if (isLoadingSlot[index] == true) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 14),
                      child: Padding(
                        padding: EdgeInsets.all(28),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  if(slotErrorMessages[index] != null) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 14),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              slotErrorMessages[index]!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                if(lastFailedQueries[index] != null)
                                  ElevatedButton(
                                    onPressed: () {
                                      _fetchSlotPokemon(index, lastFailedQueries[index]!);
                                    },
                                    child: Text('Try Again'),
                                  ),
                                ElevatedButton(
                                  onPressed: () {
                                    _openSearchModal(index);
                                  },
                                  child: Text('Choose Again'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if(pokemon == null) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 14),
                      child: InkWell(
                        onTap: isSlotDisabled ? null : () {
                          _openSearchModal(index);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                roleLabel,
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Icon(
                                isSlotDisabled ? Icons.lock : Icons.add,
                                size: 36,
                                color: isSlotDisabled
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                              SizedBox(height: 6),
                              Text(
                                isSlotDisabled ? 'Fill previous slot first' : 'Tap to add pokemon',
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
                    margin: EdgeInsets.only(bottom: 14),
                    child: InkWell(
                      onTap: () {
                        _openSearchModal(index);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              roleLabel,
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Image.network(
                              '$spriteBaseUrl${pokemon.natlDexNumber}.png',
                              height: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.catching_pokemon, size: 70);
                              },
                            ),
                            SizedBox(height: 6),
                            Text(
                              '#${pokemon.natlDexNumber} ${pokemon.name.replaceAll('-', ' ').toUpperCase()}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              alignment: WrapAlignment.center,
                              children: pokemon.type
                                  .map((t) => Card(
                                        margin: EdgeInsets.zero,
                                        color: Theme.of(context).colorScheme.secondaryContainer,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          child: Text(
                                            t.toUpperCase(),
                                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _showFlavorDialog(pokemon);
                                  },
                                  child: Text('Entry'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _showAbilitiesDialog(pokemon);
                                  },
                                  child: Text('Abilities'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _showMovesDialog(pokemon);
                                  },
                                  child: Text('Moves'),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Base Stats (Total: ${_getBaseStatTotal(pokemon)})',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 8),
                            for (var entry in pokemon.stats.entries)...[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key.replaceAll('-', ' ').toUpperCase(),
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${entry.value}/$maxBaseStat',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    LinearProgressIndicator(
                                      value: entry.value / maxBaseStat,
                                      minHeight: 8,
                                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                      color: _getStatColor(entry.value),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}