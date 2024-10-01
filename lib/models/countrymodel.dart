class Country {
  final String commonName;
  final String officialName;
  final String currencyName;
  final String currencySymbol;
  final String flagUrl;
  final String region; // Added region property

  Country({
    required this.commonName,
    required this.officialName,
    required this.currencyName,
    required this.currencySymbol,
    required this.flagUrl,
    required this.region, // Added region to the constructor
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      commonName: json['name']['common'],
      officialName: json['name']['official'],
      currencyName: json['currencies'] != null
          ? json['currencies'].values.first['name']
          : 'N/A',
      currencySymbol: json['currencies'] != null
          ? json['currencies'].values.first['symbol']
          : 'N/A',
      flagUrl: json['flags']['png'],
      region: json['region'], // Extract region from JSON
    );
  }
}
