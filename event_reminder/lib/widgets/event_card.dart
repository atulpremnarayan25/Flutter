import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../screens/event_detail_screen.dart';
import 'package:animations/animations.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onToggleCompletion;
  final VoidCallback onDelete;

  const EventCard({
    super.key,
    required this.event,
    required this.onToggleCompletion,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPast = event.dateTime.isBefore(DateTime.now()) && !event.isCompleted;

    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, _) => EventDetailScreen(event: event),
      closedElevation: 0,
      closedColor: Colors.transparent,
      openElevation: 0,
      middleColor: Colors.transparent,
      closedBuilder: (context, openContainer) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: isPast
                ? Border.all(color: theme.colorScheme.error.withValues(alpha: 0.5), width: 1.5)
                : Border.all(color: Colors.transparent, width: 0),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: openContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: event.isCompleted,
                        activeColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        side: BorderSide(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        onChanged: (value) {
                          onToggleCompletion();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: event.isCompleted
                                  ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                                  : theme.colorScheme.onSurface,
                              decoration: event.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                isPast ? Icons.warning_amber_rounded : Icons.access_time_rounded,
                                size: 16,
                                color: isPast 
                                    ? theme.colorScheme.error 
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('MMM d, y • h:mm a').format(event.dateTime),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isPast 
                                      ? theme.colorScheme.error 
                                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                  decoration: event.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.error),
                        onPressed: onDelete,
                        tooltip: 'Delete Event',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
