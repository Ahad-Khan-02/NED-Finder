import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Pending_Items/pending_items_model.dart';
import 'package:ned_finder/features/Admin/Pending_items/widgets/pending_items_card.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; 


class PendingItemsScreen extends StatefulWidget {
  const PendingItemsScreen({super.key});

  @override
  State<PendingItemsScreen> createState() => _PendingItemsScreenState();
}

class _PendingItemsScreenState extends State<PendingItemsScreen> {
  List<PendingItemModel> _pendingItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPendingItems();
  }

  Future<void> _fetchPendingItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final responseData = await Http.get('items/pending');

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List itemsJson = responseData['data']['items'] ?? [];

        final List<PendingItemModel> fetchedItems = itemsJson
            .map((item) => PendingItemModel.fromJson(item))
            .toList();

        setState(() {
          _pendingItems = fetchedItems;
          _isLoading = false;
        });
        debugPrint('Successfully loaded ${_pendingItems.length} pending items.');

      } else {
        throw Exception(responseData['message'] ?? 'Failed to retrieve pending items.');
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
          style: TextStyle(color: CustomColors.error),
        ),
      );
    } else if (_pendingItems.isEmpty) {
      bodyContent = const Center(
        child: Center(
          child: Text(
            CustomTexts.noPendingItemsFound,
            style: TextStyle(fontSize: 18,),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {

      bodyContent = GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5, 
          crossAxisSpacing: 20,
          mainAxisSpacing: 40,
        ),
        itemCount: _pendingItems.length,
        itemBuilder: (context, index) {
          return AdminPendingItemCard(
            item: _pendingItems[index],
            onUpdate: _fetchPendingItems,
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      body: RefreshIndicator(
        onRefresh: _fetchPendingItems,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                CustomTexts.pendingItemsTitle,
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