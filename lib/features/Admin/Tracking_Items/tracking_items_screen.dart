import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Tracking_items/tracking_items_model.dart';
import 'package:ned_finder/features/Admin/Tracking_Items/widgets/tracking_items_card.dart'; 
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; // Import Http client

class TrackingItemsScreen extends StatefulWidget {
  const TrackingItemsScreen({super.key});

  @override
  State<TrackingItemsScreen> createState() => _TrackingItemsScreenState();
}

class _TrackingItemsScreenState extends State<TrackingItemsScreen> {
  List<TrackingItemModel> _trackingItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTrackingItems();
  }

  // --- API FETCHING METHOD ---
  Future<void> _fetchTrackingItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Reuse the /items/approved endpoint assuming Tracking is Approved status
    try {
      final responseData = await Http.get('items/approved'); 

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List itemsJson = responseData['data']['items'] ?? [];

        final List<TrackingItemModel> fetchedItems = itemsJson
            .map((item) => TrackingItemModel.fromJson(item)) // Use new model
            .toList();

        setState(() {
          _trackingItems = fetchedItems;
          _isLoading = false;
        });

      } else {
        throw Exception(responseData['message'] ?? 'Failed to retrieve tracking items.');
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
    
    // --- Conditional Content based on State ---
    Widget bodyContent;

    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      bodyContent = Center(
        child: Text(
          _error!,
          style: TextStyle(color: CustomColors.error),
        ),
      );
    } else if (_trackingItems.isEmpty) {
      bodyContent = const Center(
        child: Text(
          'No items are currently approved and awaiting tracking.',
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
          childAspectRatio: 0.8,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: _trackingItems.length,
        itemBuilder: (context, index) {
          // Pass the actual fetched model data to the card
          return AdminTrackingItemCard(item: _trackingItems[index]);
        },
      );
    }
    
    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tracking Items',
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
    );
  }
}