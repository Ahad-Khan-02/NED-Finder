import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Item/item_model.dart';
import 'package:ned_finder/features/Home/widgets/custom_drawer.dart';
import 'package:ned_finder/features/Home/widgets/home_header_section.dart';
import 'package:ned_finder/features/Home/widgets/item_card_list.dart';
import 'package:ned_finder/features/My_Items/my_items_screen.dart';
import 'package:ned_finder/features/Settings/settings_screen.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
   const HomeScreen({super.key});

   @override
   State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   int _selectedIndex = 0;
  
  
   List<ItemModel> items = [];
   List<ItemModel> _filteredItems = [];
   String _searchQuery = ''; 
   bool _isLoading = true; 
   int? currentUserId;

   void _runSearchFilter(String query) {
     setState(() {
        _searchQuery = query;

        if (query.isEmpty) {
          _filteredItems = items;
        } else {
          final searchLower = query.toLowerCase();
          _filteredItems = items.where((item) {
             final nameLower = item.name.toLowerCase();
             final descriptionLower = item.description.toLowerCase();

             return nameLower.contains(searchLower) || descriptionLower.contains(searchLower);
          }).toList();
        }
     });
   }


   Future<void> _fetchItems() async {
     final prefs = await SharedPreferences.getInstance();
     final userId = prefs.getInt('user_id');

     try {
        setState(() {
          _isLoading = true;
          currentUserId = userId; 
        });

        final responseData = await Http.get('items/approved'); 

        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final List itemsJson = responseData['data']['items'];

          final List<ItemModel> fetchedItems = itemsJson
               .map((item) => ItemModel.fromJson(item))
               .toList();

          final List<ItemModel> notFoundItems = fetchedItems
               .where((item) => !item.isFound)
               .toList();

          setState(() {
             items = notFoundItems;
             _filteredItems = notFoundItems; 
             _isLoading = false; 
          });

        } else {
          throw Exception('API call successful but failed to retrieve items (Status: ${responseData['status']}).');
        }
     } catch (e) {
        setState(() {
          _isLoading = false; 
        });
     }
   }

   @override
   void initState() {
     super.initState();
     _fetchItems(); 
   }

   Widget _buildMainContent() {
     if (_isLoading || currentUserId == null) {
        return const Center(child: CircularProgressIndicator());
     }

     switch(_selectedIndex){
        case 0:
          return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               HomeHeaderSection(
                  isSettingsScreen: false,
                  onSearchChanged: _runSearchFilter,
               ),
               _filteredItems.isEmpty? Center(child: Text("No items found.")) :Expanded(child: ItemCardList(items: _filteredItems,isMyItem: false,userID : currentUserId!,onRefresh: _fetchItems)), 
             ],
          );
        case 1:
          return  const MyItemsContent();

        default:
          return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                 HomeHeaderSection(isSettingsScreen: true,),
                 SettingsContent(userID:currentUserId! ,),
             ],
          );
     }
   }

   void _onDrawerItemSelected(int index) {
     setState(() {
        _selectedIndex = index;
        _fetchItems();
     });
   }

   @override
   Widget build(BuildContext context) {
     final bool isDark = HelperFunctions.isDarkMode(context);

     if (currentUserId == null && _isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
     }

     return Scaffold(
        backgroundColor: isDark? CustomColors.darkBackground : CustomColors.lightBackground,
        appBar: AppBar(
          title: const Text(
             CustomTexts.appName,
             style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: isDark? CustomColors.darkBackground : CustomColors.lightBackground,
          elevation: 0,
          foregroundColor: isDark? Colors.white : Colors.black,
        ),

        drawer: CustomDrawer(
          selectedIndex: _selectedIndex,
          onItemSelected: _onDrawerItemSelected,
          userId: currentUserId!,
        ),

        body: _buildMainContent(),
     );
   }
}