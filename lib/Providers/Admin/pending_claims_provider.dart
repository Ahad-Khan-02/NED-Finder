import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Claims/pending_claim_model.dart';
import 'package:ned_finder/utils/http/http_client.dart';

class PendingClaimsProvider extends ChangeNotifier {
  List<PendingClaimModel> _pendingClaims = [];
  bool _isLoading = true;
  String? _error;

  // Getters
  List<PendingClaimModel> get pendingClaims => _pendingClaims;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch pending claims from API
  Future<void> fetchPendingClaims() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final responseData = await Http.get('claims/pending');

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List claimsJson = responseData['data']['claims'] ?? [];

        _pendingClaims = claimsJson
            .map((claim) => PendingClaimModel.fromJson(claim))
            .toList();
        
        _error = null;
      } else {
        _error = responseData['message'] ?? 'Failed to retrieve pending claims.';
      }
    } catch (e) {
      _error = 'Error fetching data: ${e.toString()}';
      debugPrint('API Error: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear data (useful on logout)
  void clear() {
    _pendingClaims = [];
    _isLoading = true;
    _error = null;
    notifyListeners();
  }
}