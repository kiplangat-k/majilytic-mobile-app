import 'package:flutter/material.dart';
import '../../core/services/landlord_api_service.dart';


class LandlordProvider with ChangeNotifier {
  final LandlordApiService _apiService;

  List<dynamic> _myProperties = [];
  bool _isLoading = false;
  String? _errorMessage;

  LandlordProvider(this._apiService);

  List<dynamic> get myProperties => _myProperties;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMyProperties() async {
    _setLoading(true);
    try {
      _myProperties = await _apiService.fetchMyProperties();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addNewProperty(Map<String, dynamic> data) async {
    _setLoading(true);
    try {
      final newProp = await _apiService.addProperty(data);
      _myProperties.add(newProp);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}