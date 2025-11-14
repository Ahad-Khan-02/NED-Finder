import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Admin_Dashboard/lost_item_model.dart'; // Assuming this is the unified model
// import 'package:ned_finder/Models/Admin_Dashboard/report_item_model.dart'; // Not needed if using one model
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; // API client

// --- Converted to StatefulWidget for API calls ---
class AdminDataTables extends StatefulWidget {
  const AdminDataTables({
    super.key,
    required this.isLostItemTable,
  });

  final bool isLostItemTable;

  @override
  State<AdminDataTables> createState() => _AdminDataTablesState();
}

class _AdminDataTablesState extends State<AdminDataTables> {
  // Use a single list for the currently displayed table data
  List<LostItemModel> items = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // --- API FETCHING LOGIC ---
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final String itemType = widget.isLostItemTable ? 'lost' : 'found';
    final String endpoint = 'items/all?item_type=$itemType';

    try {
      final responseData = await Http.get(endpoint);

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List itemsJson = responseData['data']['items'] ?? [];

        final List<LostItemModel> fetchedItems = itemsJson
            // You must ensure LostItemModel has a working fromJson factory
            .map((item) => LostItemModel.fromJson(item)) 
            .toList();

        setState(() {
          items = fetchedItems;
          _isLoading = false;
        });
      } else {
        throw Exception(responseData['message'] ?? 'Failed to retrieve $itemType items.');
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching data: ${e.toString()}';
        _isLoading = false;
      });
      debugPrint('API Error: $_error');
    }
  }

  // --- BUILD METHODS ---

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    // Determine the title based on the table type
    final String title = widget.isLostItemTable ? 'Lost Items' : 'Found Items';
    final bool isDark = HelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTableTitle(title),
        _buildDataTable(isDark, widget.isLostItemTable), // Use one dynamic table method
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTableTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- Unified Dynamic Data Table ---
  Widget _buildDataTable(bool isDark, bool isLost) {
    if (items.isEmpty) {
      return Center(child: Text('No ${isLost ? 'Lost' : 'Found'} Items submitted yet.'));
    }

    final String dateLabel = isLost ? 'Date Lost' : 'Date Found';
    final String timeLabel = isLost ? 'Time Lost' : 'Time Found';
    final String locationLabel = isLost ? 'Location Lost' : 'Location Found';
    final Color itemTypeColor = isLost ? CustomColors.error : CustomColors.success;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? CustomColors.dark : CustomColors.lboxColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 30,
          columns: [
            const DataColumn(label: Text('Item ID')),
            const DataColumn(label: Text('User ID')),
            const DataColumn(label: Text('Submitter Name')), // Needs API join
            const DataColumn(label: Text('Name')),
            const DataColumn(label: Text('Description')),
            DataColumn(label: Text(dateLabel)), // Dynamic label
            DataColumn(label: Text(timeLabel)), // Dynamic label
            DataColumn(label: Text(locationLabel)), // Dynamic label
            const DataColumn(label: Text('Item Type')),
            const DataColumn(label: Text('Status')),
          ],
          rows: items.map((item) {
            // Assuming your LostItemModel now has the following getters:
            // .dateFound (or .dateString)
            // .timeFound (or .timeString)
            // .submitterName (needs to be implemented, defaults to placeholder)
            
            // Placeholder for submitterName since it's not in the base item API response
            final String submitterName = item.name.isEmpty ? 'User ${item.userId}' : 'Ahad';
            
            // Placeholder for date/time if your model names differ from item.dateFound/item.timeFound
            final String date = item.dateFound; // Assuming this maps to the date part
            final String time = item.timeFound; // Assuming this maps to the time part
            
            return DataRow(cells: [
              DataCell(Text(item.id.toString())),
              DataCell(Text(item.userId.toString())),
              DataCell(Text(submitterName)),
              DataCell(SizedBox(width: 100, child: Text(item.name, overflow: TextOverflow.ellipsis))),
              DataCell(SizedBox(width: 150, child: Text(item.description, overflow: TextOverflow.ellipsis))),
              DataCell(Text(date)),
              DataCell(Text(time)),
              DataCell(Text(item.location)),
              DataCell(Text(item.itemType, style: TextStyle(color: itemTypeColor))),
              DataCell(_buildStatusCell(item.status)), // Use a helper for status styling
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // Helper method for styling the status cell
  Widget _buildStatusCell(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'approved':
        color = CustomColors.success;
        break;
      case 'rejected':
        color = CustomColors.error;
        break;
      case 'pending':
      default:
        color = CustomColors.warning;
        break;
    }
    return Text(
      status.toUpperCase(),
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }
}

// ⚠️ IMPORTANT: You MUST ensure your LostItemModel (or ItemModel) has these fields/getters:
/*
class LostItemModel {
    // ... fields matching the API ...
    final int userId;
    final String itemType;
    final String status;
    final String location;
    // ...
    String get dateFound;  // Must format the DateTime to a Date string
    String get timeFound;  // Must format the DateTime to a Time string
    String get submitterName; // Must be handled (either fetched or placeholder)
    // ... fromJson factory 
}
*/