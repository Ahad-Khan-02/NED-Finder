import 'package:flutter/material.dart';
import 'package:ned_finder/Providers/Admin/pending_items_provider.dart';
import 'package:provider/provider.dart';
import 'package:ned_finder/features/Admin/Pending_items/widgets/pending_items_card.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class PendingItemsScreen extends StatefulWidget {
  const PendingItemsScreen({super.key});

  @override
  State<PendingItemsScreen> createState() => _PendingItemsScreenState();
}

class _PendingItemsScreenState extends State<PendingItemsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PendingItemsProvider>().fetchPendingItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final size = MediaQuery.of(context).size;
    
    // Responsive UI Tokens
    final bool isSmallScreen = size.width < 600;
    final bool isTablet = size.width >= 600 && size.width < 1024;
    final padding = isSmallScreen ? 16.0 : (isTablet ? 20.0 : 24.0);
    final titleFontSize = isSmallScreen ? 24.0 : 28.0;
    final spacingAfterTitle = isSmallScreen ? 16.0 : 24.0;
    final gridSpacing = isSmallScreen ? 16.0 : 20.0;
    final mainAxisSpacing = isSmallScreen ? 24.0 : (isTablet ? 32.0 : 40.0);

    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      body: Consumer<PendingItemsProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.fetchPendingItems,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CustomTexts.pendingItemsTitle,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: spacingAfterTitle),
                  _buildBody(
                    context, 
                    provider, 
                    size.width, 
                    gridSpacing, 
                    mainAxisSpacing, 
                    isSmallScreen
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, 
    PendingItemsProvider provider, 
    double width, 
    double gridSpacing, 
    double mainAxisSpacing,
    bool isSmallScreen
  ) {
    // 1. Loading State
    if (provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 2. Error State
    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: isSmallScreen ? 48 : 64, color: CustomColors.error),
            const SizedBox(height: 16),
            Text(
              provider.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: CustomColors.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: provider.fetchPendingItems,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // 3. Empty State
    if (provider.pendingItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: isSmallScreen ? 64 : 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              CustomTexts.noPendingItemsFound,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 4. Data State
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(width),
        childAspectRatio: 0.5, // Consistent aspect ratio as per original code
        crossAxisSpacing: gridSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: provider.pendingItems.length,
      itemBuilder: (context, index) {
        return AdminPendingItemCard(
          item: provider.pendingItems[index],
          onUpdate: provider.fetchPendingItems,
        );
      },
    );
  }

  // Helper methods for responsive grid
  int _getCrossAxisCount(double width) {
    if (width < 600) return 2;
    if (width < 900) return 2;
    if (width < 1200) return 3;
    if (width < 1600) return 4;
    return 5;
  }
}