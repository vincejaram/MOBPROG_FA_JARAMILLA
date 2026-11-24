import 'dart:async';
import 'dart:convert';
import 'package:fa5_creativity_app/constants.dart';
import 'package:fa5_creativity_app/model/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonService {
  Future<Pokemon?> fetchPokemonInfo(String name) async{
    String urlName = name.trim().toLowerCase()
        .replaceAll('.', '')
        .replaceAll("'", '')
        .replaceAll(':', '')
        .replaceAll('♀', '-f')
        .replaceAll('♂', '-m')
        .replaceAll(' ', '-')
        .replaceAll(' ', '-');

    try{
      final pokemonResponse = await http.get(Uri.https(pokeApiUrl, '/api/v2/pokemon/$urlName'));

      if(pokemonResponse.statusCode != 200) {
        return null;
      }

      final pokemonJson = json.decode(pokemonResponse.body);
      final speciesUrl = pokemonJson['species']['url'];
      final speciesResponse = await http.get(Uri.parse(speciesUrl));

      if(speciesResponse.statusCode == 200) {
        final speciesJson = json.decode(speciesResponse.body);
        return Pokemon.fromJson(pokemonJson, speciesJson);
      } else {
        return null;
      }
    } catch(e) {
      print('Error fetching Pokemon: $e');
      return null;
    }
  }

  Future<List<String>> fetchAllPokemon() async{
    final response = await http.get(Uri.https(pokeApiUrl, '/api/v2/pokemon', {'offset': '0', 'limit': '1500'}));
    final data = json.decode(response.body);
    final results = data['results'];

    List<String> allPokemonNames = [];

    for(var pokeItem in results) {
      allPokemonNames.add(pokeItem['name']);
    }
    return allPokemonNames;
  }

  Future<List<String>> fetchAllTypes() async{
    final response = await http.get(Uri.https(pokeApiUrl, '/api/v2/type', {'offset': '0', 'limit': '$totalPokemonTypes'}));
    final data = json.decode(response.body);
    final results = data['results'];

    List<String> allPokemonTypes = [];

    for(var pokeItem in results) {
      allPokemonTypes.add(pokeItem['name']);
    }
    return allPokemonTypes;
  }

  Future<List<String>> fetchAllGens() async{
    final response = await http.get(Uri.https(pokeApiUrl, '/api/v2/generation', {'offset': '0', 'limit': '15'}));
    final data = json.decode(response.body);
    final results = data['results'];

    List<String> allPokemonGens = [];

    for(var pokeItem in results) {
      allPokemonGens.add(pokeItem['name']);
    }
    return allPokemonGens;
  }

  Future<List<String>> fetchPokemonByType(String type) async{
    String urlType = type.trim().replaceAll(' ', '-').toLowerCase();
    final response = await http.get(Uri.https(pokeApiUrl, 'api/v2/type/$urlType', {'offset': '0', 'limit': '1500'}));
    final data = json.decode(response.body);
    final results = data['pokemon'];

    List<String> typePokemon = [];

    for(var pokeItem in results) {
      typePokemon.add(pokeItem['pokemon']['name']);
    }
    print(typePokemon);
    return typePokemon;
  }

  Future<List<String>> fetchPokemonByGen(String gen) async{
    String urlGen = gen.trim().replaceAll(' ', '-').toLowerCase();
    final response = await http.get(Uri.https(pokeApiUrl, 'api/v2/generation/$urlGen', {'offset': '0', 'limit': '1500'}));
    final data = json.decode(response.body);
    final results = data['pokemon_species'];

    List<String> genPokemon = [];

    for(var pokeItem in results) {
      genPokemon.add(pokeItem['name']);
    }
    return genPokemon;
  }

  Future<int> fetchPokemonCount() async{
    try {
      final response = await http.get(Uri.https(pokeApiUrl, '/api/v2/pokemon-species'));

      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['count'];
      }
      return defaultPokemonCount;
    } catch (e){
      return defaultPokemonCount;
    }
  }

  Future fetchTypeMatchup(String type) async{
    String urlType = type.trim().replaceAll(' ', '-').replaceAll(' ', '-').toLowerCase();
    final response = await http.get(Uri.https(pokeApiUrl, 'api/v2/type/$urlType', {'offset': '0', 'limit': '1500'}));
    final data = json.decode(response.body);
    final results = data['damage_relations'];

    List<String> strengths = [];
    List<String> weaknesses = [];
    List<String> resistances = [];
    List<String> immunities = [];
    List<String> halfDamageTo = [];
    List<String> noDamageTo = [];

    for(var pokeItem in results['double_damage_to']) {
      strengths.add(pokeItem['name']);
    }

    for(var pokeItem in results['double_damage_from']) {
      weaknesses.add(pokeItem['name']);
    }

    for(var pokeItem in results['half_damage_from']) {
      resistances.add(pokeItem['name']);
    }

    for(var pokeItem in results['no_damage_from']) {
      immunities.add(pokeItem['name']);
    }

    for(var pokeItem in results['half_damage_to']) {
      halfDamageTo.add(pokeItem['name']);
    }

    for(var pokeItem in results['no_damage_to']) {
      noDamageTo.add(pokeItem['name']);
    }

    return {
      'strengths': strengths,
      'weaknesses': weaknesses,
      'resistances': resistances,
      'immunities': immunities,
      'halfDamageTo': halfDamageTo,
      'noDamageTo': noDamageTo,
    };
  }
}