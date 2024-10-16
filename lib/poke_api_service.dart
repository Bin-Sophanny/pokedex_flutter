import 'dart:convert';

import 'package:pokedex/pokemon_model.dart';
import 'package:http/http.dart' as http;
import 'pokemon_model.dart';

class PokeApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=100'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      List<Pokemon> pokemons = [];
      for (var result in results) {
        final pokeResponse = await http.get(Uri.parse(result['url']));
        if (pokeResponse.statusCode == 200) {
          final pokeData = jsonDecode(pokeResponse.body);
          pokemons.add(Pokemon.fromJson(pokeData));
        }
      }
      return pokemons;
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }
}
