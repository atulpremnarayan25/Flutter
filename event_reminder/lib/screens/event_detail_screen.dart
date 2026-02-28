import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import 'add_event_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // Listen to changes for the specific event to keep details updated
    final evt = Provider.of<EventProvider>(context)
        .events
        .firstWhere((e) => e.id == event.id, orElse: () => event);

    final theme = Theme.of(context);
    final isPast = evt.dateTime.isBefore(DateTime.now()) && !evt.isCompleted;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Event Details', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit_rounded, size: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEventScreen(event: evt),
                ),
              );
            },
            tooltip: 'Edit Event',
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline_rounded, size: 20, color: theme.colorScheme.error),
            ),
            onPressed: () {
              _confirmDelete(context, evt.id);
            },
            tooltip: 'Delete Event',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    evt.isCompleted
                        ? Colors.green.withValues(alpha: 0.2)
                        : (isPast ? theme.colorScheme.error.withValues(alpha: 0.2) : theme.colorScheme.primary.withValues(alpha: 0.2)),
                    theme.colorScheme.surface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: evt.isCompleted
                          ? Colors.green.withValues(alpha: 0.2)
                          : (isPast ? theme.colorScheme.errorContainer : theme.colorScheme.primaryContainer),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          evt.isCompleted ? Icons.check_circle_rounded : (isPast ? Icons.warning_rounded : Icons.schedule_rounded),
                          size: 16,
                          color: evt.isCompleted
                              ? Colors.green
                              : (isPast ? theme.colorScheme.error : theme.colorScheme.primary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          evt.isCompleted ? 'Completed' : (isPast ? 'Past Due' : 'Upcoming'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: evt.isCompleted
                                ? Colors.green
                                : (isPast ? theme.colorScheme.error : theme.colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    evt.title,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      letterSpacing: -1,
                      color: theme.colorScheme.onSurface,
                      decoration: evt.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          context,
                          Icons.calendar_month_rounded,
                          'Date',
                          DateFormat('EEEE, MMMM d, y').format(evt.dateTime),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(height: 1),
                        ),
                        _buildInfoRow(
                          context,
                          Icons.access_time_rounded,
                          'Time',
                          DateFormat('h:mm a').format(evt.dateTime),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'About Event',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
                    ),
                    child: Text(
                      evt.description.isNotEmpty ? evt.description : 'No description provided.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: evt.description.isNotEmpty 
                            ? theme.colorScheme.onSurface 
                            : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontStyle: evt.description.isNotEmpty ? FontStyle.normal : FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Provider.of<EventProvider>(context, listen: false).toggleEventCompletion(evt);
        },
        backgroundColor: evt.isCompleted ? theme.colorScheme.surface : theme.colorScheme.primary,
        foregroundColor: evt.isCompleted ? theme.colorScheme.primary : theme.colorScheme.onPrimary,
        icon: Icon(evt.isCompleted ? Icons.undo_rounded : Icons.check_rounded),
        label: Text(
          evt.isCompleted ? 'Mark Undone' : 'Mark Completed',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, String eventId) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Event', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this event? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<EventProvider>(context, listen: false)
                  .deleteEvent(eventId);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back from details screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
