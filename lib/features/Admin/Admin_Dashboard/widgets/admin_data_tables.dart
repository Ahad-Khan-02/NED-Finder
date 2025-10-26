import 'package:flutter/material.dart';
import 'package:ned_finder/Models/Admin_Dashboard/lost_item_model.dart';
import 'package:ned_finder/Models/Admin_Dashboard/report_item_model.dart';
import 'package:ned_finder/utils/constants/colors.dart';



// --- Dummy Data ---
final List<LostItemData> _lostItems = [
  LostItemData(
    id: 1, userId: '1', submitterName: 'User A', name: 'Wallet', 
    description: 'This is for testing for found item', 
    dateFound: '2024-06-24', timeFound: '08:15:00', 
    locationFound: 'CAS - ROOM 404', itemType: 'found',
    status: 'Pending',
  ),
];

final List<ReportItemData> _reportItems = [
  ReportItemData(
    id: 1, userId: '2', submitterName: 'Joem', 
    name: 'Mklkling walking watermelon na brainrotted tuwing 3am', 
    description: '...', 
    dateLost: '2024-05-08', timeLost: '20:23:00', 
    locationLost: 'Sa earist po', itemType: 'lost',
    status: 'pending'
  ),
  ReportItemData(
    id: 2, userId: '3', submitterName: 'Sandok ko', 
    name: 'mahaba', 
    description: '...', 
    dateLost: '2024-06-24', timeLost: '11:00:00', 
    locationLost: 'Sa may earist', itemType: 'lost',
    status: 'claimed'
  ),
];


class AdminDataTables extends StatelessWidget {
  const AdminDataTables({super.key, required this.isLostItemTable});

  final bool isLostItemTable;

  @override
  Widget build(BuildContext context) {
    return isLostItemTable? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. Lost Items Table (Found Items waiting to be matched) ---
        _buildTableTitle('Lost Items'),
        _buildLostItemsTable(),
        const SizedBox(height: 40),   
      ],
    ): Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. Lost Items Table (Found Items waiting to be matched) ---
        _buildTableTitle('Found Items'),
        _buildReportItemsTable(),
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
          color: Colors.black87,
        ),
      ),
    );
  }

  // --- Table for Lost Items (Found by users) ---
  Widget _buildLostItemsTable() {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.lboxColor,
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
          columns: const [
            DataColumn(label: Text('Item ID')),
            DataColumn(label: Text('User ID')),
            DataColumn(label: Text('Submitter Name')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Date Found')),
            DataColumn(label: Text('Time Found')),
            DataColumn(label: Text('Location Found')),
            DataColumn(label: Text('Item Type')),
            DataColumn(label: Text('Status')),
          ],
          rows: _lostItems.map((item) {
            return DataRow(cells: [
              DataCell(Text(item.id.toString())),
              DataCell(Text(item.userId)),
              DataCell(Text(item.submitterName)),
              DataCell(
                // Use Flexible/Expanded to wrap long text in DataTable
                SizedBox(width: 100, child: Text(item.name, overflow: TextOverflow.ellipsis)),
              ),
              DataCell(
                SizedBox(width: 150, child: Text(item.description, overflow: TextOverflow.ellipsis)),
              ),
              DataCell(Text(item.dateFound)),
              DataCell(Text(item.timeFound)),
              DataCell(Text(item.locationFound)),
              DataCell(Text(item.itemType, style: const TextStyle(color: CustomColors.success))),
              DataCell(Text(item.status)),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // --- Table for Report Items (Lost by users) ---
  Widget _buildReportItemsTable() {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.lboxColor,
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
          columns: const [
            DataColumn(label: Text('Item ID')),
            DataColumn(label: Text('User ID')),
            DataColumn(label: Text('Submitter Name')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Date Lost')),
            DataColumn(label: Text('Time Lost')),
            DataColumn(label: Text('Location Lost')),
            DataColumn(label: Text('Item Type')),
            DataColumn(label: Text('Status')),
          ],
          rows: _reportItems.map((item) {
            return DataRow(cells: [
              DataCell(Text(item.id.toString())),
              DataCell(Text(item.userId)),
              DataCell(Text(item.submitterName)),
              DataCell(
                SizedBox(width: 100, child: Text(item.name, overflow: TextOverflow.ellipsis)),
              ),
              DataCell(
                SizedBox(width: 150, child: Text(item.description, overflow: TextOverflow.ellipsis)),
              ),
              DataCell(Text(item.dateLost)),
              DataCell(Text(item.timeLost)),
              DataCell(Text(item.locationLost)),
              DataCell(Text(item.itemType, style: const TextStyle(color: CustomColors.error))),
              DataCell(Text(item.status)),

            ]);
          }).toList(),
        ),
      ),
    );
  }
}