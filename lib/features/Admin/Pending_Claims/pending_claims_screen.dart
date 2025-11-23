import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Claims/pending_claim_model.dart';
import 'package:ned_finder/features/Admin/Pending_Claims/widgets/pending_claims_card.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; 


class PendingClaimsScreen extends StatefulWidget {
  const PendingClaimsScreen({super.key});

  @override
  State<PendingClaimsScreen> createState() => _PendingClaimsScreenState();
}

class _PendingClaimsScreenState extends State<PendingClaimsScreen> {
  List<PendingClaimModel> _pendingClaims = []; 
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPendingClaims();
  }

  Future<void> _fetchPendingClaims() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final responseData = await Http.get('claims/pending'); 

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List claimsJson = responseData['data']['claims'] ?? [];

        final List<PendingClaimModel> fetchedClaims = claimsJson
            .map((claim) => PendingClaimModel.fromJson(claim))
            .toList();
        
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
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = HelperFunctions.isDarkMode(context);
    

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
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      bodyContent = GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 350,
          childAspectRatio: 1.0,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: _pendingClaims.length,
        itemBuilder: (context, index) {
          return AdminPendingClaimsCard(
            claim: _pendingClaims[index],
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
                CustomTexts.pendingClaimsTitle,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              bodyContent,
            ],
          ),
        ),
      ),
    );
  }
}