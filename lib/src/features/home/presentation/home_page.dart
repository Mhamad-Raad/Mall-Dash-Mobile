import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_system.dart';
import '../../../core/theme/custom_theme_extension.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../vendor/presentation/vendors_notifier.dart';
import '../../vendor/presentation/vendor_details_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorsState = ref.watch(vendorsProvider);
    final appTheme = context.appTheme;

    return vendorsState.when(
      data: (vendors) {
        if (vendors.isEmpty) {
          return const EmptyState(
            icon: Icons.store_mall_directory_outlined,
            title: 'No vendors available',
            subtitle: 'Pull down to refresh',
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(vendorsProvider.notifier).refresh(),
          child: GridView.builder(
            padding: AppSpacing.allMd,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VendorDetailsPage(vendor: vendor),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: vendor.profileImageUrl != null
                            ? Image.network(
                                vendor.profileImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: appTheme.surfaceVariant,
                                    child: Icon(
                                      Icons.store,
                                      size: AppSpacing.iconHero,
                                      color: appTheme.textTertiary,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: appTheme.surfaceVariant,
                                child: Icon(
                                  Icons.store,
                                  size: AppSpacing.iconHero,
                                  color: appTheme.textTertiary,
                                ),
                              ),
                      ),
                      Padding(
                        padding: AppSpacing.allXs,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vendor.name,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (vendor.description != null) ...[
                              AppSpacing.verticalGapXxs,
                              Text(
                                vendor.description!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: appTheme.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stack) => ErrorState(
        message: error.toString(),
        onRetry: () => ref.read(vendorsProvider.notifier).refresh(),
      ),
    );
  }
}
