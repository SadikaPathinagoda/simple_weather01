import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_weather01/screens/favourites_screen.dart';
import 'package:simple_weather01/screens/search_screen.dart';
import '../providers/weather_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final preview = weatherProvider.threeDayPreview;
    final data = weatherProvider.currentWeather;

    // fallback values if no data yet
    final cityName =
        data != null ? '${data['name']}, ${data['sys']?['country'] ?? ''}' : 'No city';
    final double temp = (data?['main']?['temp'] ?? 0).toDouble();
    final double tempMax = (data?['main']?['temp_max'] ?? 0).toDouble();
    final double tempMin = (data?['main']?['temp_min'] ?? 0).toDouble();
    final int humidity = (data?['main']?['humidity'] ?? 0).toInt();
    final String description =
        (data?['weather'] != null && data!['weather'].isNotEmpty)
            ? data['weather'][0]['description']
            : 'Tap Search City to load weather';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'SimpleWeather',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Big weather card
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
                  // City row
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          cityName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Temp + icon aligned vertically
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temp.toStringAsFixed(0),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          '°C',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Icon(
                            Icons.wb_sunny_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // High / Low / Humidity row
                  Row(
                    children: [
                      _smallInfoChip('High', tempMax.toStringAsFixed(0)),
                      const SizedBox(width: 10),
                      _smallInfoChip('Low', tempMin.toStringAsFixed(0)),
                      const SizedBox(width: 10),
                      _smallInfoChip('Humidity', '$humidity%'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Action rows
            _actionRow(
              icon: Icons.search,
              iconColor: Colors.blue,
              label: 'Search City',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            ),
            const SizedBox(height: 8),
            _actionRow(
              icon: Icons.near_me,
              iconColor: Colors.green,
              label: 'Use My Location',
              onTap: () {
                // later: get location + call provider.loadWeatherForCity(...)
                // for now just show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Location feature coming soon')),
                );
              },
            ),
            const SizedBox(height: 8),
            _actionRow(
              icon: Icons.favorite_border,
              iconColor: Colors.pink,
              label: 'View Favorites',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FavouritesScreen()),
                );
              },
            ),

            const SizedBox(height: 16),

            // 3-day preview card – for now still dummy, later use forecast API
            Container(
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
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      '3-Day Preview',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
    const SizedBox(height: 4),
    Text(
      cityName == 'No city'
          ? 'Select a city from Search'
          : 'For $cityName',
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    ),
    const SizedBox(height: 8),
    const Divider(),
    const SizedBox(height: 8),

    if (cityName == 'No city' || preview.isEmpty)
      const Text(
        'No forecast yet. Tap "Search City" and choose a location.',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      )
    else ...[
      for (final day in preview)
        _previewRow(
          day['date'] as String,
          '${(day['max'] as double).toStringAsFixed(0)} / '
          '${(day['min'] as double).toStringAsFixed(0)}',
        ),
    ],
  ],
),

            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this is Home
        onTap: (index) {
          if (index == 0) {
            // already on Home
            return;
          } else if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FavouritesScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }

  Widget _smallInfoChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _previewRow(String label, String temps) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          const Icon(Icons.wb_sunny_outlined, size: 18, color: Colors.orange),
          const SizedBox(width: 6),
          Text(temps),
        ],
      ),
    );
  }
}
