import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/farm_state_provider.dart';
import '../../core/constants/app_colors.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmState = Provider.of<FarmStateProvider>(context);
    final weather = farmState.weather;
    final farm = farmState.currentFarm;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orchard Weather Station'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Weather Hero Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0288D1), Color(0xFF01579B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withAlpha(100),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            farm.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'GPS: ${farm.latitude.toStringAsFixed(3)}°N, ${farm.longitude.toStringAsFixed(3)}°E',
                            style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 11),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('LIVE STATION', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wb_cloudy_outlined, size: 64, color: Colors.white),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather.temperature.toInt()}°C',
                            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, height: 1),
                          ),
                          Text(
                            weather.conditionText,
                            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Atmospheric Sub-metrics
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeroStat('Humidity', '${weather.humidity.toInt()}%', Icons.water_drop),
                        _buildHeroStat('Rain Chance', '${weather.rainProbability}%', Icons.umbrella),
                        _buildHeroStat('Wind Speed', '${weather.windSpeedKmh.toInt()} km/h', Icons.air),
                        _buildHeroStat('Rainfall', '${weather.rainfallMm} mm', Icons.grain),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Smart Irrigation Advisory Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.orangeSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryOrange.withAlpha(80)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.tips_and_updates_outlined, color: AppColors.primaryOrange, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Microclimate Advisory',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.orangeDark),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          weather.smartAdvisory,
                          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 7-Day Agricultural Forecast
            const Text(
              '7-Day Farm Weather Forecast',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            ...weather.forecast7Days.map((f) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.dayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(f.date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            f.iconName == 'rain' ? Icons.grain : Icons.wb_sunny_outlined,
                            size: 20,
                            color: f.iconName == 'rain' ? AppColors.blueAccent : Colors.amber.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(f.condition, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                      Row(
                        children: [
                          if (f.rainProbability > 20)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: AppColors.blueSurface,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${f.rainProbability}%',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.blueAccent),
                              ),
                            ),
                          Text(
                            '${f.tempMax.toInt()}° / ${f.tempMin.toInt()}°',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        Text(label, style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 10)),
      ],
    );
  }
}
