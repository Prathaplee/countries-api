
import 'package:country/models/countrymodel.dart';
import 'package:dio/dio.dart';

class CountryService {
  final List<String> urls = [
    'https://restcountries.com/v3.1/translation/germany',
    'https://restcountries.com/v3.1/translation/india',
    'https://restcountries.com/v3.1/translation/israel',
    'https://restcountries.com/v3.1/translation/lanka',
    'https://restcountries.com/v3.1/translation/italy',
    'https://restcountries.com/v3.1/translation/china',
    'https://restcountries.com/v3.1/translation/korea',
  ];

  final Dio _dio = Dio();

  Future<List<Country>> fetchCountries() async {
    List<Country> countries = [];

    for (var url in urls) {
      try {
        final response = await _dio.get(url);
        if (response.statusCode == 200) {
          var data = response.data[0];
          var name = data['name'];
          var currency = data['currencies'].entries.first.value;

          countries.add(Country(
            commonName: name['common'],
            officialName: name['official'],
            currencyName: currency['name'],
            currencySymbol: currency['symbol'],
            flagUrl: data['flags']['png'], region: data['region'],
          ));
        } else {
          throw Exception('Failed to load country data');
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    }
    return countries;
  }
}
