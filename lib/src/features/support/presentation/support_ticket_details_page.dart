import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_system.dart';
import '../../../core/theme/custom_theme_extension.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../data/support_ticket_model.dart';
import '../data/support_ticket_repository.dart';

final ticketDetailsProvider = FutureProvider.family<SupportTicket, int>((ref, ticketId) async {
  final repository = ref.watch(supportTicketRepositoryProvider);
  return await repository.getTicketById(ticketId);
});

class SupportTicketDetailsPage extends ConsumerWidget {
  final int ticketId;

  const SupportTicketDetailsPage({super.key, required this.ticketId});

  Color _getStatusColor(BuildContext context, int status) {
    final appTheme = context.appTheme;
    switch (status) {
      case 1:
        return appTheme.warningColor;
      case 2:
        return appTheme.infoColor;
      case 3:
        return appTheme.successColor;
      case 4:
        return appTheme.textTertiary;
      default:
        return appTheme.textTertiary;
    }
  }

  Color _getPriorityColor(BuildContext context, String priority) {
    final appTheme = context.appTheme;
    switch (priority) {
      case 'Low':
        return appTheme.successColor;
      case 'Normal':
        return appTheme.infoColor;
      case 'High':
        return appTheme.warningColor;
      case 'Urgent':
        return appTheme.errorColor;
      default:
        return appTheme.textTertiary;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = context.appTheme;
    final ticketState = ref.watch(ticketDetailsProvider(ticketId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
      ),
      body: ticketState.when(
        data: (ticket) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(ticketDetailsProvider(ticketId).future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.allMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: AppSpacing.statusBadge,
                    decoration: BoxDecoration(
                      color: _getStatusColor(context, ticket.status).withOpacity(0.2),
                      borderRadius: AppRadius.radiusPill,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: _getStatusColor(context, ticket.status),
                        ),
                        AppSpacing.horizontalGapXs,
                        Text(
                          ticket.statusName,
                          style: TextStyle(
                            color: _getStatusColor(context, ticket.status),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.verticalGapMd,

                  // Subject
                  Text(
                    'Subject',
                    style: TextStyle(
                      fontSize: 12,
                      color: appTheme.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AppSpacing.verticalGapXxs,
                  Text(
                    ticket.subject,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalGapMd,

                  // Priority
                  Row(
                    children: [
                      Icon(Icons.priority_high, size: 20, color: appTheme.textTertiary),
                      AppSpacing.horizontalGapXs,
                      Text(
                        'Priority:',
                        style: TextStyle(
                          fontSize: 14,
                          color: appTheme.textTertiary,
                        ),
                      ),
                      AppSpacing.horizontalGapXs,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(context, ticket.priority).withOpacity(0.2),
                          borderRadius: AppRadius.radiusMd,
                        ),
                        child: Text(
                          ticket.priority,
                          style: TextStyle(
                            color: _getPriorityColor(context, ticket.priority),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.verticalGapXs,
                  Container(
                    width: double.infinity,
                    padding: AppSpacing.allMd,
                    decoration: BoxDecoration(
                      color: appTheme.surfaceVariant,
                      borderRadius: AppRadius.radiusMd,
                    ),
                    child: Text(
                      ticket.description,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                  AppSpacing.verticalGapLg,

                  // Admin Notes (if any)
                  if (ticket.adminNotes != null && ticket.adminNotes!.isNotEmpty) ...[
                    const Text(
                      'Support Response',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.verticalGapXs,
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.allMd,
                      decoration: BoxDecoration(
                        color: appTheme.infoContainerColor,
                        borderRadius: AppRadius.radiusMd,
                        border: Border.all(color: appTheme.infoColor.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.support_agent, size: 20, color: appTheme.infoColor),
                              AppSpacing.horizontalGapXs,
                              Text(
                                'Support Team',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.verticalGapXs,
                          Text(
                            ticket.adminNotes!,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.verticalGapLg,
                  ],

                  // Timestamps
                  Card(
                    child: Padding(
                      padding: AppSpacing.allMd,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 20, color: appTheme.textTertiary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Created',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: appTheme.textTertiary,
                                      ),
                                    ),
                                    Text(
                                      _formatDateTime(ticket.createdAt),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (ticket.updatedAt != null) ...[
                            const Divider(height: 24),
                            Row(
                              children: [
                                Icon(Icons.update, size: 20, color: appTheme.textTertiary),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Updated',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: appTheme.textTertiary,
                                        ),
                                      ),
                                      Text(
                                        _formatDateTime(ticket.updatedAt!),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorState(
          title: 'Error loading ticket',
          message: error.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.invalidate(ticketDetailsProvider(ticketId)),
        ),
      ),
    );
  }
}
