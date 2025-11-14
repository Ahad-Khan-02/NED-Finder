import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Completed_items/completed_items_model.dart';
import 'package:ned_finder/features/Admin/Completed_Items/widgets/completed_items_card.dart'; 
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; // Import Http client

class CompletedItemsScreen extends StatefulWidget {
  const CompletedItemsScreen({super.key});

  @override
  State<CompletedItemsScreen> createState() => _CompletedItemsScreenState();
}

class _CompletedItemsScreenState extends State<CompletedItemsScreen> {
  List<CompletedItemModel> _completedItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCompletedItems();
  }

  // --- API FETCHING METHOD ---
  Future<void> _fetchCompletedItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Assumption: Endpoint for items with status 'approved' or 'completed'
    // You must implement this FastAPI endpoint: GET /items/approved
    try {
      final responseData = await Http.get('items/approved'); 

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List itemsJson = responseData['data']['items'] ?? [];

        final List<CompletedItemModel> fetchedItems = itemsJson
            .map((item) => CompletedItemModel.fromJson(item))
            .toList();

        setState(() {
          _completedItems = fetchedItems;
          _isLoading = false;
        });

      } else {
        throw Exception(responseData['message'] ?? 'Failed to retrieve approved items.');
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
    } else if (_completedItems.isEmpty) {
      bodyContent = const Center(
        child: Text(
          'No approved items found. Start approving items in the Pending screen!',
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
        itemCount: _completedItems.length,
        itemBuilder: (context, index) {
          // Pass the actual fetched model data to the card
          return AdminCompletedItemsCard(item: _completedItems[index]);
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
              'Completed Items',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Display the determined content (Loading, Error, Empty, or Grid)
            bodyContent,
          ],
        ),
      ),
    );
  }
}