import 'package:flutter/material.dart';
import 'package:ned_finder/Providers/Admin/completed_items_provider.dart';
import 'package:ned_finder/features/Admin/Completed_Items/widgets/completed_items_card.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';
import 'package:provider/provider.dart';

class CompletedItemsScreen extends StatelessWidget {
  const CompletedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompletedItemsProvider(),
      child: const _CompletedItemsView(),
    );
  }
}

class _CompletedItemsView extends StatelessWidget {
  const _CompletedItemsView();

  // Calculate responsive cross axis count based on screen width
  int _getCrossAxisCount(double width) {
    if (width < 600) return 1;
    if (width < 900) return 2;
    if (width < 1200) return 3;
    if (width < 1600) return 4;
    return 5;
  }

  // Calculate responsive child aspect ratio
  double _getChildAspectRatio(double width) {
    if (width < 600) return 0.85;
    if (width < 900) return 0.70;
    if (width < 1200) return 0.65;
    return 0.70;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompletedItemsProvider>();
    final isDark = HelperFunctions.isDarkMode(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    final padding = isSmallScreen ? 16.0 : (isTablet ? 20.0 : 24.0);
    final titleFontSize = isSmallScreen ? 24.0 : 28.0;
    final spacingAfterTitle = isSmallScreen ? 16.0 : 24.0;
    final gridSpacing = isSmallScreen ? 12.0 : (isTablet ? 16.0 : 20.0);

    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      body: RefreshIndicator(
        onRefresh: provider.fetchCompletedItems,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CustomTexts.completedItemsTitle,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacingAfterTitle),
              _buildBodyContent(context, provider, size, gridSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, CompletedItemsProvider provider, Size size, double gridSpacing) {
    if (provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 64, color: CustomColors.error),
            const SizedBox(height: 16),
            Text(provider.error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: provider.fetchCompletedItems,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.completedItems.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(CustomTexts.noCompletedItemsFound, style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(size.width),
        childAspectRatio: _getChildAspectRatio(size.width),
        crossAxisSpacing: gridSpacing,
        mainAxisSpacing: gridSpacing,
      ),
      itemCount: provider.completedItems.length,
      itemBuilder: (context, index) {
        return AdminCompletedItemsCard(item: provider.completedItems[index]);
      },
    );
  }
}