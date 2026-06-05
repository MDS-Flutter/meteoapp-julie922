import 'package:flutter/material.dart';
import 'main.dart' show WeatherData;

class WeatherDetailPage extends StatelessWidget {
  final WeatherData weather;

  const WeatherDetailPage({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weather.city),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                      weather.city,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weather.country,
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
              icon: Icons.thermostat,
              label: 'Ressenti',
              value: '${weather.feelsLike.toStringAsFixed(1)}°C',
            ),
            _DetailRow(
              icon: Icons.water_drop,
              label: 'Humidité',
              value: '${weather.humidity.toStringAsFixed(0)} %',
            ),
            _DetailRow(
              icon: Icons.air,
              label: 'Vent',
              value: '${weather.wind.toStringAsFixed(1)} km/h',
            ),
            _DetailRow(
              icon: Icons.compress,
              label: 'Pression',
              value: '${weather.pressure.toStringAsFixed(0)} hPa',
            ),
            _DetailRow(
              icon: Icons.visibility,
              label: 'Visibilité',
              value: '${weather.visibility.toStringAsFixed(1)} km',
            ),

            const Spacer(),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, '${weather.city} ajouté aux favoris !');
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
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(
            value,
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
