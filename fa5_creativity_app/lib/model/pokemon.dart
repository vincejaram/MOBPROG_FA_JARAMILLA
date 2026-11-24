class Pokemon {
  Pokemon({
    required this.id,
    required this.natlDexNumber,
    required this.name,
    required this.type,
    required this.generation,
    required this.stats,
    required this.abilities,
    required this.moves,
    required this.flavorTextEntry,
  });

  Pokemon.fromData({
    required this.id,
    required this.natlDexNumber,
    required this.name,
    required this.type,
    required this.generation,
    required this.stats,
    required this.abilities,
    required this.moves,
    required this.flavorTextEntry,
  });

  final int id;
  final int natlDexNumber;
  final String name;
  final List<String> type;
  final String generation;
  final Map<String, int> stats;
  final List<String> abilities;
  final List<String> moves;
  final String flavorTextEntry;


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'natlDexNumber': natlDexNumber,
      'name': name,
      'type': type,
      'generation': generation,
      'stats': stats,
      'abilities': abilities,
      'moves': moves,
      'flavorTextEntry': flavorTextEntry,
    };
  }

  factory Pokemon.fromJson(Map<String, dynamic> pokemonJson, Map<String, dynamic> speciesJson) {
    List<String> typeList = [];
    for (var pokeItem in pokemonJson['types']) {
      typeList.add(pokeItem['type']['name']);
    }
    
    Map<String, int> statMap = {};
    for (var pokeItem in pokemonJson['stats']) {
      String statName = pokeItem['stat']['name'];
      int baseStats = pokeItem['base_stat'];
      statMap[statName] = baseStats;
    }

    List<String> abilityList = [];
    for (var pokeItem in pokemonJson['abilities']) {
      abilityList.add(pokeItem['ability']['name']);
    }

    List<String> moveList = [];
    for (var pokeItem in pokemonJson['moves']) {
      moveList.add(pokeItem['move']['name']);
    }

    String dexCription = 'No description available.';
    for (var entry in speciesJson['flavor_text_entries']) {
      if (entry['language']['name'] == 'en') {
        dexCription = entry['flavor_text'].replaceAll('\n', ' ').replaceAll('\f', ' ');
        break;
      }
    }

    return Pokemon.fromData(
      id: pokemonJson['id'] ?? 0,
      natlDexNumber: speciesJson['id'] ?? 0,
      name: pokemonJson['name'] ?? '',
      type: typeList,
      generation: speciesJson['generation']['name'] ?? '',
      stats: statMap,
      abilities: abilityList,
      moves: moveList,
      flavorTextEntry: dexCription,
    );
  }
}