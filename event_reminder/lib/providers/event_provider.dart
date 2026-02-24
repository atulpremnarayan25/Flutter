import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/event_model.dart';
import '../services/notification_service.dart';

class EventProvider extends ChangeNotifier {
  static const String _boxName = 'events';
  final NotificationService _notificationService = NotificationService();
  
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  List<Event> get upcomingEvents => _events.where((e) => !e.isCompleted).toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  List<Event> get completedEvents => _events.where((e) => e.isCompleted).toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  bool get isLoading => _isLoading;

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final box = Hive.box<Event>(_boxName);
      _events = box.values.toList();
    } catch (e) {
      debugPrint('Error fetching events: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(Event event, {bool setReminder = false}) async {
    try {
      final box = Hive.box<Event>(_boxName);
      await box.put(event.id, event);
      _events.add(event);

      if (setReminder && event.dateTime.isAfter(DateTime.now())) {
        await _notificationService.scheduleNotification(
          id: event.id.hashCode,
          title: 'Event Reminder: ${event.title}',
          body: event.description.isNotEmpty ? event.description : 'You have an upcoming event.',
          scheduledDate: event.dateTime,
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding event: $e');
    }
  }

  Future<void> updateEvent(Event event, {bool setReminder = false}) async {
    try {
      final box = Hive.box<Event>(_boxName);
      await box.put(event.id, event);
      
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = event;
      }
      
      // Cancel previous notification just in case
      await _notificationService.cancelNotification(event.id.hashCode);

      if (!event.isCompleted && setReminder && event.dateTime.isAfter(DateTime.now())) {
        await _notificationService.scheduleNotification(
          id: event.id.hashCode,
          title: 'Event Reminder: ${event.title}',
          body: event.description.isNotEmpty ? event.description : 'You have an upcoming event.',
          scheduledDate: event.dateTime,
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating event: $e');
    }
  }

  Future<void> toggleEventCompletion(Event event) async {
    final updatedEvent = event.copyWith(isCompleted: !event.isCompleted);
    await updateEvent(updatedEvent);
    
    if (updatedEvent.isCompleted) {
      await _notificationService.cancelNotification(event.id.hashCode);
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      final box = Hive.box<Event>(_boxName);
      await box.delete(id);
      _events.removeWhere((e) => e.id == id);
      
      await _notificationService.cancelNotification(id.hashCode);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting event: $e');
    }
  }
}
