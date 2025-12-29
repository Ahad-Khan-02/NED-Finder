import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Admin_Dashboard/lost_item_model.dart';
import 'package:ned_finder/features/Home/widgets/custom_search_bar.dart';
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
  List<LostItemModel> filteredItems = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter items based on search query
  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = items;
      } else {
        filteredItems = items.where((item) {
          final searchLower = query.toLowerCase();
          return item.name.toLowerCase().contains(searchLower) ||
              item.description.toLowerCase().contains(searchLower) ||
              item.location.toLowerCase().contains(searchLower) ||
              item.itemType.toLowerCase().contains(searchLower) ||
              item.status.toLowerCase().contains(searchLower) ||
              item.id.toString().contains(searchLower) ||
              item.userId.toString().contains(searchLower);
        }).toList();
      }
    });
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
          filteredItems = fetchedItems;
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

  // Show item details in bottom sheet
  void _showItemDetails(BuildContext context, LostItemModel item) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: size.height * 0.75,
        decoration: BoxDecoration(
          color: isDark ? CustomColors.dark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Item Details',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item image if available
                    if (item.imageBytes.isNotEmpty)
                      Container(
                        height: isSmallScreen ? 200 : 300,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            item.imageBytes,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    _buildDetailRow(
                      icon: Icons.tag,
                      label: 'Item ID',
                      value: item.id.toString(),
                      isDark: isDark,
                    ),
                    _buildDetailRow(
                      icon: Icons.person,
                      label: 'User ID',
                      value: item.userId.toString(),
                      isDark: isDark,
                    ),
                    _buildDetailRow(
                      icon: Icons.label,
                      label: 'Item Name',
                      value: item.name,
                      isDark: isDark,
                    ),
                    _buildDetailRow(
                      icon: Icons.description,
                      label: 'Description',
                      value: item.description,
                      isDark: isDark,
                      multiline: true,
                    ),
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      label: widget.isLostItemTable ? 'Date Lost' : 'Date Found',
                      value: item.dateFound,
                      isDark: isDark,
                    ),
                    _buildDetailRow(
                      icon: Icons.access_time,
                      label: widget.isLostItemTable ? 'Time Lost' : 'Time Found',
                      value: item.timeFound,
                      isDark: isDark,
                    ),
                    _buildDetailRow(
                      icon: Icons.location_on,
                      label: widget.isLostItemTable ? 'Location Lost' : 'Location Found',
                      value: item.location,
                      isDark: isDark,
                    ),
                    _buildDetailRow(
                      icon: Icons.category,
                      label: 'Item Type',
                      value: item.itemType,
                      isDark: isDark,
                      valueColor: widget.isLostItemTable
                          ? CustomColors.error
                          : CustomColors.success,
                    ),
                    _buildDetailRow(
                      icon: Icons.info,
                      label: 'Status',
                      value: item.status.toUpperCase(),
                      isDark: isDark,
                      valueColor: _getStatusColor(item.status),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    bool multiline = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: CustomColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: valueColor ?? (isDark ? Colors.white : Colors.black87),
                  ),
                  maxLines: multiline ? null : 2,
                  overflow: multiline ? null : TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return CustomColors.success;
      case 'rejected':
        return CustomColors.error;
      case 'pending':
      default:
        return CustomColors.warning;
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

    final String title = widget.isLostItemTable
        ? CustomTexts.lostItemsTabletitle
        : CustomTexts.foundItemsTableTitle;
    final bool isDark = HelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTableTitle(title),
        _buildSearchBar(isDark),
        const SizedBox(height: 16),
        _buildDataTable(isDark, widget.isLostItemTable),
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

  Widget _buildSearchBar(bool isDark) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    return CustomSearchBar(
      text: 'Search by name, description, location, status...',
      color: isDark ? Colors.white : Colors.black,
      onChanged: _filterItems,
    );
  }

  // --- Unified Dynamic Data Table ---
  Widget _buildDataTable(bool isDark, bool isLost) {
    if (filteredItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            _searchController.text.isEmpty
                ? 'No ${isLost ? 'Lost' : 'Found'} Items submitted yet.'
                : 'No items found matching "${_searchController.text}"',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    final String dateLabel = isLost ? CustomTexts.dateLost : CustomTexts.dateFound;
    final String timeLabel = isLost ? CustomTexts.timeLost : CustomTexts.timeFound;
    final String locationLabel =
        isLost ? CustomTexts.locationLost : CustomTexts.locationFound;
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
          showCheckboxColumn: false, // This removes the checkbox
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
          rows: filteredItems.map((item) {
            final String date = item.dateFound;
            final String time = item.timeFound;

            return DataRow(
              cells: [
                DataCell(Text(item.id.toString())),
                DataCell(Text(item.userId.toString())),
                DataCell(SizedBox(
                    width: 100,
                    child: Text(item.name, overflow: TextOverflow.ellipsis))),
                DataCell(SizedBox(
                    width: 150,
                    child:
                        Text(item.description, overflow: TextOverflow.ellipsis))),
                DataCell(Text(date)),
                DataCell(Text(time)),
                DataCell(Text(
                  item.location,
                  overflow: TextOverflow.ellipsis,
                )),
                DataCell(Text(item.itemType,
                    style: TextStyle(color: itemTypeColor))),
                DataCell(_buildStatusCell(item.status)),
              ],
              onSelectChanged: (_) => _showItemDetails(context, item),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Helper method for styling the status cell
  Widget _buildStatusCell(String status) {
    Color color = _getStatusColor(status);
    return Text(
      status.toUpperCase(),
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }
}