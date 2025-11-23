import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Admin_Dashboard/lost_item_model.dart'; 
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:ned_finder/utils/http/http_client.dart'; 


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

    final String title = widget.isLostItemTable ? CustomTexts.lostItemsTabletitle : CustomTexts.foundItemsTableTitle;
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

    final String dateLabel = isLost ? CustomTexts.dateLost : CustomTexts.dateFound;
    final String timeLabel = isLost ? CustomTexts.timeLost : CustomTexts.timeFound;
    final String locationLabel = isLost ? CustomTexts.locationLost : CustomTexts.locationFound;
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
            const DataColumn(label: Text(CustomTexts.itemId)),
            const DataColumn(label: Text(CustomTexts.userId)),
            const DataColumn(label: Text(CustomTexts.itemName)),
            const DataColumn(label: Text(CustomTexts.description)),
            DataColumn(label: Text(dateLabel)), 
            DataColumn(label: Text(timeLabel)), 
            DataColumn(label: Text(locationLabel)), 
            const DataColumn(label: Text(CustomTexts.itemType)),
            const DataColumn(label: Text(CustomTexts.status)),
          ],
          rows: items.map((item) {
           
            final String date = item.dateFound; 
            final String time = item.timeFound; 
            
            return DataRow(cells: [
              DataCell(Text(item.id.toString())),
              DataCell(Text(item.userId.toString())),
              DataCell(SizedBox(width: 100, child: Text(item.name, overflow: TextOverflow.ellipsis))),
              DataCell(SizedBox(width: 150, child: Text(item.description, overflow: TextOverflow.ellipsis))),
              DataCell(Text(date)),
              DataCell(Text(time)),
              DataCell(Text(item.location,overflow: TextOverflow.ellipsis,)),
              DataCell(Text(item.itemType, style: TextStyle(color: itemTypeColor))),
              DataCell(_buildStatusCell(item.status)), 
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
