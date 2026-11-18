class LocationService {
  Future<Map<String, dynamic>> getCurrentLocation() async {
    return {
      'lat': 12.9716,
      'lng': 77.5946,
      'address': 'Mock location - Bengaluru Civic Zone',
    };
  }
}
