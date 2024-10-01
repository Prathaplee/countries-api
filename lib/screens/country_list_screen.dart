import 'package:country/models/countrymodel.dart';
import 'package:country/services/country_services.dart';
import 'package:country/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late Future<List<Country>> futureCountries;
  String? _selectedSortOption = 'Alphabetical'; // Default sort option
  List<String> sortOptions = ['Alphabetical', 'Region'];

  @override
  void initState() {
    super.initState();
    futureCountries = CountryService().fetchCountries();
  }

  List<Country> _sortCountries(List<Country> countries) {
    if (_selectedSortOption == 'Alphabetical') {
      countries.sort((a, b) => a.commonName.compareTo(b.commonName));
    } else if (_selectedSortOption == 'Region') {
      countries.sort((a, b) => a.region.compareTo(b.region));
    }
    return countries;
  }

  void _showImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewGallery(
          pageOptions: [
            PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(imageUrl),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          ],
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Container(
        color: Colors.white,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Countries'),
        actions: [
          DropdownButton<String>(
            value: _selectedSortOption,
            items: sortOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedSortOption = newValue;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Country>>(
        future: futureCountries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No countries found'));
          } else {
            List<Country> countries = snapshot.data!;
            countries = _sortCountries(countries); // Sort the countries

            return AnimationLimiter(
              child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: GestureDetector(
                            onTap: () => _showImage(context, country.flagUrl),
                            child: SizedBox(
                              width: 50,
                              height: 30,
                              child: FadeInImage(
                                placeholder: const AssetImage(
                                    'assets/images/placeholder.jpg'),
                                image: NetworkImage(country.flagUrl),
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return _buildShimmer(); // Show shimmer effect on error
                                },
                              ),
                            ),
                          ),
                          title: Text(
                            country.commonName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(country.officialName),
                              Text('Currency: ${country.currencyName} (${country.currencySymbol})'),
                              Text('Region: ${country.region}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
