import 'package:fa5_creativity_app/constants.dart';
import 'package:fa5_creativity_app/model/pokemon.dart';
import 'package:fa5_creativity_app/service/pokemon_service.dart';
import 'package:flutter/material.dart';

class PokemonSearch extends StatefulWidget {
  const PokemonSearch(this.loadedAllPokemon, this.loadedPokemonTypes, this.loadedPokemonGens, this.slotIndex, this.selectedPokemon, {super.key});

  final List<String> loadedAllPokemon;
  final List<String> loadedPokemonTypes;
  final List<String> loadedPokemonGens;
  final int slotIndex;
  final Pokemon? selectedPokemon;

  @override
  State<PokemonSearch> createState() => _PokemonSearchState();
}

class _PokemonSearchState extends State<PokemonSearch> {
  final PokemonService pokemonService = PokemonService();
  final _pokemonSearchController = TextEditingController();
  String _selectedType = 'ALL TYPES';
  String _selectedGen = 'ALL GENERATIONS';
  var isLoadingList = false;
  String? searchErrorMessage;
  List<String> loadedPokemonByType = [];
  List<String> loadedPokemonByGen = [];
  List<String> searchPokemonList = [];

  @override
  void initState() {
    super.initState();
    loadedPokemonByType = widget.loadedAllPokemon;
    loadedPokemonByGen = widget.loadedAllPokemon;
    searchPokemonList = widget.loadedAllPokemon;

    if (widget.selectedPokemon != null) {
      _pokemonSearchController.text = widget.selectedPokemon!.name.replaceAll('-', ' ');
      _applyTextFilter();
    }
  }

  void _applyTextFilter() {
    var searchText = _pokemonSearchController.text.trim().toLowerCase().replaceAll(' ', '-');
    List<String> tempPokemonList = [];

    for(var pokeItem in loadedPokemonByType) {
      if(loadedPokemonByGen.contains(pokeItem) && pokeItem.contains(searchText)) {
        tempPokemonList.add(pokeItem);
      }
    }

    setState(() {
      searchPokemonList = tempPokemonList;
    });
  }

  void _updateDropdownFilters() async {
    setState(() {
      isLoadingList = true;
      searchErrorMessage = null;
    });

    try {
      if(_selectedType == 'ALL TYPES') {
        loadedPokemonByType = widget.loadedAllPokemon;
      } else {
        loadedPokemonByType = await pokemonService.fetchPokemonByType(_selectedType);
      }

      if (_selectedGen == 'ALL GENERATIONS') {
        loadedPokemonByGen = widget.loadedAllPokemon;
      } else {
        loadedPokemonByGen = await pokemonService.fetchPokemonByGen(_selectedGen);
      }

      _applyTextFilter();

      setState(() {
        isLoadingList = false;
      });
    } catch (e) {
      setState(() {
        isLoadingList = false;
        searchErrorMessage = 'Could not filter Pokémon right now. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _pokemonSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        children: [
          Text(
            'Slot ${widget.slotIndex + 1}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 12),
          TextField(
            onChanged: (value) {
              _applyTextFilter();
            },
            controller: _pokemonSearchController,
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              label: Text('Search Pokemon'),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedType,
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
                      _selectedType = value;
                    });
                    _updateDropdownFilters();
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedGen,
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
                      _selectedGen = value;
                    });
                    _updateDropdownFilters();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: isLoadingList
                ? Center(child: CircularProgressIndicator())
                : searchErrorMessage != null
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                searchErrorMessage!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  _updateDropdownFilters();
                                },
                                child: Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : searchPokemonList.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'No Pokémon found matching your search or filters.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: searchPokemonList.length,
                            itemBuilder: (ctx, index) {
                              var pokemonName = searchPokemonList[index];
                              var pokemonId = widget.loadedAllPokemon.indexOf(pokemonName) + 1;
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                leading: Image.network(
                                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png',
                                  width: 40,
                                  height: 40,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.catching_pokemon, size: 30);
                                  },
                                ),
                                title: Text(pokemonName.replaceAll('-', ' ').toUpperCase()),
                                onTap: () {
                                  Navigator.pop(context, pokemonName);
                                },
                              );
                            },
                          ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.selectedPokemon != null) ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, removePokemonAction);
                  },
                  child: Text('Remove'),
                ),
                Spacer(),
              ],
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}