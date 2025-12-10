import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({
    super.key,
    this.cityName = 'London, UK',
  });

  final String cityName;

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final preview = weatherProvider.threeDayPreview; // from provider

    // Fallback dummy data if preview is empty
    final List<_ForecastItem> forecastItems = preview.isEmpty
        ? [
            _ForecastItem(
              dayLabel: 'Today',
              dateLabel: 'Dec 9',
              description: 'Partly Cloudy',
              minTemp: 19,
              maxTemp: 24,
              icon: Icons.wb_sunny_outlined,
            ),
            _ForecastItem(
              dayLabel: 'Tomorrow',
              dateLabel: 'Dec 10',
              description: 'Cloudy',
              minTemp: 19,
              maxTemp: 24,
              icon: Icons.cloud_queue,
            ),
            _ForecastItem(
              dayLabel: 'Day 3',
              dateLabel: 'Dec 11',
              description: 'Light Rain',
              minTemp: 19,
              maxTemp: 24,
              icon: Icons.grain,
            ),
          ]
        : preview.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final date = day['date'] as String;
            final max = (day['max'] as double).toStringAsFixed(0);
            final min = (day['min'] as double).toStringAsFixed(0);

            return _ForecastItem(
              dayLabel: index == 0 ? 'Today' : 'Day ${index + 1}',
              dateLabel: date,
              description: 'Forecast',
              minTemp: int.parse(min),
              maxTemp: int.parse(max),
              icon: Icons.wb_sunny_outlined,
            );
          }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // blue header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              color: Colors.blue,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '5-Day Forecast',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // city name card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cityName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Weekly forecast',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // today big card
                    _buildTodayCard(forecastItems.first),

                    const SizedBox(height: 16),

                    // list of other days
                    for (int i = 1; i < forecastItems.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildSmallDayCard(forecastItems[i]),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // big card like in your design (Today + feels like/humidity/wind)
  Widget _buildTodayCard(_ForecastItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.dayLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.dateLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(item.icon, color: Colors.orange, size: 28),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.maxTemp} / ${item.minTemp}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // feels like / humidity / wind mini cards (still dummy for now)
          Row(
            children: [
              Expanded(
                child: _miniMetricCard(
                  icon: Icons.thermostat,
                  iconColor: Colors.redAccent,
                  label: 'Feels Like',
                  value: '20',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _miniMetricCard(
                  icon: Icons.water_drop_outlined,
                  iconColor: Colors.blue,
                  label: 'Humidity',
                  value: '18%',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _miniMetricCard(
                  icon: Icons.air,
                  iconColor: Colors.teal,
                  label: 'Wind',
                  value: '5 km/h',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // small row card for each next day
  Widget _buildSmallDayCard(_ForecastItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.dayLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.dateLabel,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(item.icon, color: Colors.orange, size: 22),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.maxTemp} / ${item.minTemp}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniMetricCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// simple data holder for each day
class _ForecastItem {
  final String dayLabel;
  final String dateLabel;
  final String description;
  final int minTemp;
  final int maxTemp;
  final IconData icon;

  _ForecastItem({
    required this.dayLabel,
    required this.dateLabel,
    required this.description,
    required this.minTemp,
    required this.maxTemp,
    required this.icon,
  });
}
