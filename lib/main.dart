import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para decodificar JSON

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Consulta HTTP - PokeAPI',
      home: PokemonScreen(),
    );
  }
}

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  Map<String, dynamic>? pokemonData;
  bool isLoading = true;

  // 🔹 Función para obtener los datos del Pokémon
  Future<void> fetchPokemon() async {
    const String apiUrl = "https://pokeapi.co/api/v2/pokemon/eve";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          pokemonData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Error al obtener datos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPokemon(); // Llamamos a la API al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeAPI - Datos desde Internet'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pokemonData!['name'].toString().toUpperCase(),
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Image.network(
                    pokemonData!['sprites']['front_default'],
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  Text("Altura: ${pokemonData!['height']}"),
                  Text("Peso: ${pokemonData!['weight']}"),
                  Text("Experiencia base: ${pokemonData!['base_experience']}"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: fetchPokemon,
                    child: const Text("Actualizar Datos"),
                  ),
                ],
              ),
      ),
    );
  }
}

