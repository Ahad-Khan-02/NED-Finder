import 'package:flutter/material.dart';
import 'package:ned_finder/Providers/Admin/pending_claims_provider.dart';
import 'package:provider/provider.dart';
import 'package:ned_finder/features/Admin/Pending_Claims/widgets/pending_claims_card.dart';
import 'package:ned_finder/utils/constants/colors.dart';
import 'package:ned_finder/utils/constants/texts.dart';
import 'package:ned_finder/utils/helpers/helper_functions.dart';

class PendingClaimsScreen extends StatefulWidget {
  const PendingClaimsScreen({super.key});

  @override
  State<PendingClaimsScreen> createState() => _PendingClaimsScreenState();
}

class _PendingClaimsScreenState extends State<PendingClaimsScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize data fetch once screen mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PendingClaimsProvider>().fetchPendingClaims();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    // Responsive UI tokens
    final padding = isSmallScreen ? 16.0 : (isTablet ? 20.0 : 24.0);
    final titleFontSize = isSmallScreen ? 24.0 : 28.0;
    final spacingAfterTitle = isSmallScreen ? 8.0 : 10.0;
    final gridSpacing = isSmallScreen ? 12.0 : (isTablet ? 16.0 : 20.0);

    return Scaffold(
      backgroundColor: isDark ? CustomColors.darkBackground : CustomColors.lightBackground,
      body: Consumer<PendingClaimsProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.fetchPendingClaims,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CustomTexts.pendingClaimsTitle,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: spacingAfterTitle),
                  
                  // Main Content Switcher
                  _buildContent(
                    context, 
                    provider, 
                    size, 
                    gridSpacing, 
                    padding, 
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

  Widget _buildContent(
    BuildContext context, 
    PendingClaimsProvider provider, 
    Size size, 
    double gridSpacing, 
    double padding,
    bool isSmallScreen,
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60, horizontal: padding),
          child: Column(
            children: [
              const Icon(Icons.error_outline, size: 64, color: CustomColors.error),
              const SizedBox(height: 16),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: CustomColors.error),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: provider.fetchPendingClaims,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Empty State
    if (provider.pendingClaims.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 100, horizontal: padding),
          child: Column(
            children: [
              const Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No claims are currently pending administrative review.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // 4. Data State (Grid)
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: _getMaxCrossAxisExtent(size.width),
        childAspectRatio: _getChildAspectRatio(size.width),
        crossAxisSpacing: gridSpacing,
        mainAxisSpacing: gridSpacing,
      ),
      itemCount: provider.pendingClaims.length,
      itemBuilder: (context, index) {
        return AdminPendingClaimsCard(
          claim: provider.pendingClaims[index],
          // When a claim is approved/rejected, we refresh the list
          onClaimProcessed: provider.fetchPendingClaims,
        );
      },
    );
  }

  // --- Responsive Helpers ---

  double _getMaxCrossAxisExtent(double width) {
    if (width < 600) return width - 32;
    if (width < 900) return 400.0;
    if (width < 1200) return 380.0;
    if (width < 1600) return 360.0;
    return 350.0;
  }

  double _getChildAspectRatio(double width) {
    if (width < 600) return 1.2;
    if (width < 900) return 0.70;
    return 0.75;
  }
}