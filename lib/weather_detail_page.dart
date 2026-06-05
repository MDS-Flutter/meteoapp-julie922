import 'package:flutter/material.dart';
import 'main.dart' show WeatherData;

class WeatherDetailPage extends StatelessWidget {
  final WeatherData weather;

  const WeatherDetailPage({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weather.ville),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,    
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carte principale
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Text(
                      weather.ville,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weather.pays,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w300,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.condition,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Données détaillées',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            _DetailRow(
              icone: Icons.thermostat,
              label: 'Ressenti',
              valeur: '${weather.ressenti.toStringAsFixed(1)}°C',
            ),
            _DetailRow(
              icone: Icons.water_drop,
              label: 'Humidité',
              valeur: '${weather.humidite.toStringAsFixed(0)} %',
            ),
            _DetailRow(
              icone: Icons.air,
              label: 'Vent',
              valeur: '${weather.vent.toStringAsFixed(1)} km/h',
            ),
            _DetailRow(
              icone: Icons.compress,
              label: 'Pression',
              valeur: '${weather.pression.toStringAsFixed(0)} hPa',
            ),
            _DetailRow(
              icone: Icons.visibility,
              label: 'Visibilité',
              valeur: '${weather.visibilite.toStringAsFixed(1)} km',
            ),

            const Spacer(),

            // Bouton "Ajouter aux favoris" (bonus)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, '${weather.ville} ajouté aux favoris !');
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Ajouter aux favoris'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valeur;

  const _DetailRow({
    required this.icone,
    required this.label,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icone, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(
            valeur,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
