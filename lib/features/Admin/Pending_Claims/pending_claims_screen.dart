import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Claims/pending_claim_model.dart';
import 'package:ned_finder/features/Admin/Pending_Claims/widgets/pending_claims_card.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; 

// Renamed from TrackingItemsScreen to PendingClaimsScreen for clarity
class PendingClaimsScreen extends StatefulWidget {
  const PendingClaimsScreen({super.key});

  @override
  State<PendingClaimsScreen> createState() => _PendingClaimsScreenState();
}

class _PendingClaimsScreenState extends State<PendingClaimsScreen> {
  // Use the new model type
  List<PendingClaimModel> _pendingClaims = []; 
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPendingClaims();
  }

  // --- API FETCHING METHOD ---
  Future<void> _fetchPendingClaims() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // CHANGE: Use the correct endpoint for fetching pending claims
    try {
      final responseData = await Http.get('claims/pending'); 

      // Data structure change: data['claims'] instead of data['items']
      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List claimsJson = responseData['data']['claims'] ?? [];

        final List<PendingClaimModel> fetchedClaims = claimsJson
            .map((claim) => PendingClaimModel.fromJson(claim))
            .toList();
        
        // Debug print to confirm new data is parsed correctly
        debugPrint('Fetched Claims: ${fetchedClaims.length}');
        if (fetchedClaims.isNotEmpty) {
          debugPrint('First Claim Username: ${fetchedClaims.first.username}');
          debugPrint('First Claim Item Image Bytes length: ${fetchedClaims.first.itemImageBytes.length}');
        }


        setState(() {
          _pendingClaims = fetchedClaims;
          _isLoading = false;
        });

      } else {
        throw Exception(responseData['message'] ?? 'Failed to retrieve pending claims.');
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching data: ${e.toString()}';
        _isLoading = false;
      });
      debugPrint('API Error: $_error');
    }
    // Re-fetch after 5 seconds to get real-time updates (Optional feature)
    // Timer(const Duration(seconds: 5), _fetchPendingClaims); 
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    
    // --- Conditional Content based on State ---
    Widget bodyContent;

    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      bodyContent = Center(
        child: Text(
          _error!,
          style: const TextStyle(color: CustomColors.error),
        ),
      );
    } else if (_pendingClaims.isEmpty) {
      bodyContent = const Center(
        child: Text(
          'No claims are currently pending administrative review.',
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      // Data Loaded Successfully
      bodyContent = GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 350,
          childAspectRatio: 1.0, // Adjusted aspect ratio for claim data
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: _pendingClaims.length,
        itemBuilder: (context, index) {
          // Pass the actual fetched model data to the card
          return AdminPendingClaimsCard(
            claim: _pendingClaims[index],
            // Pass the refresh function so the list can be updated after approval/rejection
            onClaimProcessed: _fetchPendingClaims, 
          );
        },
      );
    }
    
    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      body: RefreshIndicator(
        onRefresh: _fetchPendingClaims,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pending Claims Review', // Updated Title
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              bodyContent,
            ],
          ),
        ),
      ),
    );
  }
}