import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Completed_items/completed_items_model.dart';
import 'package:ned_finder/features/Admin/Completed_Items/widgets/completed_items_card.dart'; 
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
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

   Future<void> _fetchCompletedItems() async {
     setState(() {
        _isLoading = true;
        _error = null;
     });

     try {
        final responseData = await Http.get('items/approved'); 

        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final List itemsJson = responseData['data']['items'] ?? [];

          final List<CompletedItemModel> fetchedItems = itemsJson
               .map((item) => CompletedItemModel.fromJson(item))
               .toList();

          final List<CompletedItemModel> completedAndFoundItems = fetchedItems
               .where((item) => item.isFound)
               .toList();

          setState(() {
             _completedItems = completedAndFoundItems;
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
             CustomTexts.noCompletedItemsFound,
             style: TextStyle(fontSize: 18),
          ),
        );
     } else {
        bodyContent = GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            childAspectRatio: 0.45,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: _completedItems.length,
          itemBuilder: (context, index) {
            return AdminCompletedItemsCard(item: _completedItems[index]);
          },
        );
     }
     
     return Scaffold(
        backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
        body: RefreshIndicator(
          onRefresh: _fetchCompletedItems,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Text(
                    CustomTexts.completedItemsTitle,
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