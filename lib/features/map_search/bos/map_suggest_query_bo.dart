class MapySuggestQueryBO {
  const MapySuggestQueryBO({
    required this.query,
    required this.language,
    required this.limit,
    required this.types,
  });

  final String query;
  final String language;
  final int limit;
  final List<String> types;

  Map<String, dynamic> toQueryParameters(String apiKey) {
    return <String, dynamic>{
      'lang': language,
      'limit': limit,
      'type': types.join(','),
      'apikey': apiKey,
      'query': query,
    };
  }
}
