import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_weather01/screens/favourites_screen.dart';
import 'package:simple_weather01/screens/forecast_screen.dart';
import 'package:simple_weather01/screens/home_screen.dart';
import 'package:simple_weather01/services/database/db_helper.dart';
import '../providers/weather_provider.dart';
import 'package:simple_weather01/services/database/record.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController(text: 'London');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

void _onSearch() async {
  final city = _searchController.text.trim();
  if (city.isEmpty) return;

  final weather = context.read<WeatherProvider>();

  await weather.loadWeatherForCity(city);
  await weather.loadForecastForCity(city);

  if (mounted) Navigator.of(context).pop(); // go back to Home
}


  

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Blue header with back + search bar
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              color: Colors.blue,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Search City',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter city name',
                            ),
                            onSubmitted: (_) => _onSearch(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body scroll area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Weather result card (uses dummy / provider data)
                    _buildResultCard(weatherProvider),

                    const SizedBox(height: 16),

                    // Bottom "Searching..." card
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
                      child: Text(
                        weatherProvider.isLoading
                            ? 'Searching...'
                            : weatherProvider.errorMessage != null
                                ? 'Error: ${weatherProvider.errorMessage}'
                                : 'Enter a city and tap search.',
                      ),
                    ),
                  ],
                  
                ),
              ),
            ),
            
            

            // Bottom navigation (simple, not wired yet)
            BottomNavigationBar(
              currentIndex: 1, // Search
              onTap: (index) {
                if (index == 0) {
                  // Home
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                } else if (index == 1) {
                  // already on Search
                  return;
                } else if (index == 2) {
                  // Favourites
                  Navigator.of(context).pushReplacement(
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
          ],
        ),
        
      ),
      
      floatingActionButton: SafeArea(
          child: FloatingActionButton(
            onPressed: _onSearch,
            child: const Icon(Icons.search),
          ),
  ),
    );
  }

  Widget _buildResultCard(WeatherProvider provider) {
    // If no data yet, show a placeholder card
    if (provider.currentWeather == null) {
      return _placeholderCard();
    }

    // Very basic parsing from the JSON map
    final data = provider.currentWeather!;
    final cityName = '${data['name'] ?? ''}, ${data['sys']?['country'] ?? ''}';
    final double temp = (data['main']?['temp'] ?? 0).toDouble();
    final double tempMax = (data['main']?['temp_max'] ?? 0).toDouble();
    final double tempMin = (data['main']?['temp_min'] ?? 0).toDouble();
    final int humidity = (data['main']?['humidity'] ?? 0).toInt();
    final String description =
        (data['weather'] != null && data['weather'].isNotEmpty)
            ? data['weather'][0]['description']
            : '';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City + description
          Text(
            cityName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),

          // Temp + icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                temp.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '°C',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.wb_sunny,
                color: Colors.orange,
                size: 40,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // High / Low / Humidity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _smallMetric('High', tempMax.toStringAsFixed(0)),
              _smallMetric('Low', tempMin.toStringAsFixed(0)),
              _smallMetric('Humidity', '$humidity%'),
            ],
          ),
          const SizedBox(height: 16),

          // Buttons row: Add to favourites + 5-day
          Row(
            children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // 1. Create Record from current city
                      final record = Record(
                        city: cityName,      // e.g. "London, UK"
                        label: 'Home',       // default label, user can edit later
                        region: 'Europe',    // for now hard-code or decide by user
                        note: '',            // empty note
                      );

                      // 2. Save to database
                      await DbHelper.instance.insertRecord(record);

                      // 3. Show confirmation
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to favourites')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Add to Favourites'),
                  ),
                ),

              const SizedBox(width: 8),
              Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ForecastScreen(cityName: cityName),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('5 - Day'),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholderCard() {
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
      child: const Center(
        child: Text(
          'Search for a city to see weather details.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _smallMetric(String label, String value) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
