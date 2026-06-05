import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'weather_detail_page.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MeteoApp());
}

// Modèle de données retourné par l'API
class WeatherData {
  final String ville;
  final double temperature;
  final String condition;
  final double humidite;
  final double vent;
  final double pression;
  final double ressenti;
  final double visibilite;
  final String pays;

  const WeatherData({
    required this.ville,
    required this.temperature,
    required this.condition,
    required this.humidite,
    required this.vent,
    required this.pression,
    required this.ressenti,
    required this.visibilite,
    required this.pays,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      ville: json['location']['name'] as String,
      pays: json['location']['country'] as String,
      temperature: (json['current']['temp_c'] as num).toDouble(),
      condition: json['current']['condition']['text'] as String,
      humidite: (json['current']['humidity'] as num).toDouble(),
      vent: (json['current']['wind_kph'] as num).toDouble(),
      pression: (json['current']['pressure_mb'] as num).toDouble(),
      ressenti: (json['current']['feelslike_c'] as num).toDouble(),
      visibilite: (json['current']['vis_km'] as num).toDouble(),
    );
  }
}

Future<WeatherData> fetchWeather(String city) async {
  final apiKey = dotenv.env['API_KEY'] ?? '';
  final uri = Uri.parse(
    'https://api.weatherapi.com/v1/current.json?key=$apiKey&q=${Uri.encodeComponent(city)}&lang=fr',
  );
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    return WeatherData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final message = body['error']?['message'] ?? 'Erreur inconnue';
    throw Exception(message);
  }
}

class MeteoApp extends StatelessWidget {
  const MeteoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Météo France',
      debugShowCheckedModeBanner: false,
      home: MeteoPage(),
    );
  }
}

class MeteoPage extends StatefulWidget {
  const MeteoPage({super.key});

  @override
  State<MeteoPage> createState() => _MeteoPageState();
}

IconData _iconeMeteo(String condition) {
  final c = condition.toLowerCase();
  if (c.contains('soleil') || c.contains('ensoleill') || c.contains('clair')) {
    return Icons.wb_sunny;
  } else if (c.contains('nuage') || c.contains('nuageux') || c.contains('couvert')) {
    return Icons.cloud;
  } else if (c.contains('pluie') || c.contains('averse') || c.contains('bruine') || c.contains('pluvieux')) {
    return Icons.beach_access;
  } else if (c.contains('neige') || c.contains('grésil') || c.contains('verglas')) {
    return Icons.ac_unit;
  } else if (c.contains('orage') || c.contains('tonnerre')) {
    return Icons.thunderstorm;
  } else if (c.contains('brouillard') || c.contains('brume')) {
    return Icons.cloud_queue;
  }
  return Icons.wb_cloudy;
}

Color _couleurFond(String condition) {
  final c = condition.toLowerCase();
  if (c.contains('soleil') || c.contains('ensoleill') || c.contains('clair')) {
    return const Color(0xFFE3F2FD);
  } else if (c.contains('pluie') || c.contains('averse') || c.contains('bruine') || c.contains('pluvieux')) {
    return const Color(0xFFB0BEC5); 
  } else if (c.contains('neige') || c.contains('grésil') || c.contains('verglas')) {
    return const Color(0xFFE0F7FA);
  } else if (c.contains('orage') || c.contains('tonnerre')) {
    return const Color(0xFF78909C); 
  } else if (c.contains('nuage') || c.contains('nuageux') || c.contains('couvert') ||
             c.contains('brouillard') || c.contains('brume')) {
    return const Color(0xFFCFD8DC);
  }
  return const Color(0xFFE3F2FD);
}

class _MeteoPageState extends State<MeteoPage> {
  final TextEditingController _controller = TextEditingController();

  WeatherData? _weather;
  bool _isLoading = false;
  String? _erreur;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _rechercher() async {
    final ville = _controller.text.trim();
    if (ville.isEmpty) return;

    setState(() {
      _isLoading = true;
      _erreur = null;
    });

    try {
      final data = await fetchWeather(ville);
      setState(() {
        _weather = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _erreur = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _voirDetails() async {
    if (_weather == null) return;
    final String? message = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => WeatherDetailPage(weather: _weather!),
      ),
    );
    if (message != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final couleur = _weather != null ? _couleurFond(_weather!.condition) : const Color(0xFFE3F2FD);
    return Scaffold(
      backgroundColor: couleur,
      appBar: AppBar(
        title: const Text(
          'Météo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _rechercher(),
                    decoration: InputDecoration(
                      hintText: 'Entrez une ville…',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _rechercher,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Rechercher'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Expanded(
              child: _buildContenu(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContenu() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erreur != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              _erreur!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.redAccent),
            ),
          ],
        ),
      );
    }

    if (_weather == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wb_cloudy_outlined, size: 80, color: Colors.blueGrey),
            SizedBox(height: 16),
            Text(
              'Recherchez une ville pour\nafficher la météo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
          ],
        ),
      );
    }

    final w = _weather!;
    return Column(
      children: [
        // Carte météo principale
        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  w.ville,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  w.pays,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Icon(
                  _iconeMeteo(w.condition),
                  size: 72,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 8),
                Text(
                  '${w.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w300,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  w.condition,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Bouton "Voir les détails"
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _voirDetails,
            icon: const Icon(Icons.info_outline),
            label: const Text('Voir les détails'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
