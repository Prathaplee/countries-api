import 'package:country/models/countrymodel.dart';
import 'package:country/services/country_services.dart';
import 'package:flutter/material.dart';

class CountryProvider extends ChangeNotifier {
  List<Country> countries = [];
  bool isLoading = false;
  String? error;

  final CountryService _countryService = CountryService();

  Future<void> fetchCountries(String country) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      countries = await _countryService.fetchCountries();
      if (countries.isEmpty) {
        error = "No countries found";
      }
    } catch (e) {
      error = "Error fetching countries: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
