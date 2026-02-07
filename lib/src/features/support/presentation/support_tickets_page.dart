import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_system.dart';
import '../../../core/theme/custom_theme_extension.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/info_row.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import 'support_tickets_notifier.dart';
import 'create_support_ticket_page.dart';
import 'support_ticket_details_page.dart';

class SupportTicketsPage extends ConsumerWidget {
  const SupportTicketsPage({super.key});

  /// Map support ticket status to order status equivalent for color consistency
  int _mapTicketStatusToColor(int status) {
    switch (status) {
      case 1: return 1; // Open -> Pending (orange)
      case 2: return 2; // In Progress -> Confirmed (blue)
      case 3: return 5; // Resolved -> Delivered (green)
      case 4: return 6; // Closed -> Cancelled (grey, using default)
      default: return 0;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsState = ref.watch(supportTicketsProvider);
    final appTheme = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Tickets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(supportTicketsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: ticketsState.when(
        data: (tickets) {
          if (tickets.isEmpty) {
            return const EmptyState(
              icon: Icons.support_agent,
              title: 'No support tickets yet',
              subtitle: 'Tap + to create a new ticket',
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(supportTicketsProvider.notifier).refresh(),
            child: ListView.builder(
              padding: AppSpacing.allMd,
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupportTicketDetailsPage(ticketId: ticket.id),
                        ),
                      );
                    },
                    borderRadius: AppRadius.radiusMd,
                    child: Padding(
                      padding: AppSpacing.allMd,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ticket.subject,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              AppSpacing.horizontalGapXs,
                              StatusBadge(
                                label: ticket.statusName,
                                statusCode: _mapTicketStatusToColor(ticket.status),
                              ),
                            ],
                          ),
                          AppSpacing.verticalGapXs,
                          Text(
                            ticket.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: appTheme.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AppSpacing.verticalGapSm,
                          Row(
                            children: [
                              Icon(Icons.priority_high, size: AppSpacing.iconSm, color: appTheme.textTertiary),
                              AppSpacing.horizontalGapXxs,
                              Text(
                                ticket.priority,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: appTheme.textTertiary,
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.access_time, size: AppSpacing.iconSm, color: appTheme.textTertiary),
                              AppSpacing.horizontalGapXxs,
                              Text(
                                _formatDateTime(ticket.createdAt),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: appTheme.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorState(
          title: 'Error loading tickets',
          message: error.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.read(supportTicketsProvider.notifier).refresh(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateSupportTicketPage(),
            ),
          );
          
          if (created == true) {
            ref.read(supportTicketsProvider.notifier).refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
