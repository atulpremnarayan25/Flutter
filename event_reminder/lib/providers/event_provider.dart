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

  Future<bool> addEvent(Event event, {bool setReminder = false}) async {
    try {
      final box = Hive.box<Event>(_boxName);
      await box.put(event.id, event);
      _events.add(event);

      if (setReminder) {
        await _trySchedule(event);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding event: $e');
      return false;
    }
  }

  Future<bool> updateEvent(Event event, {bool setReminder = false}) async {
    try {
      final box = Hive.box<Event>(_boxName);
      await box.put(event.id, event);
      
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = event;
      }
      
      // Cancel previous notification just in case
      await _notificationService.cancelNotification(event.id.hashCode);

      if (!event.isCompleted && setReminder) {
        await _trySchedule(event);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating event: $e');
      return false;
    }
  }

  Future<void> _trySchedule(Event event) async {
    // Adding 1 minute buffer so we don't accidentally try to schedule 
    // a notification 1 millisecond in the past, which throws an exception.
    if (event.dateTime.isAfter(DateTime.now().subtract(const Duration(minutes: 1)))) {
      await _notificationService.scheduleNotification(
        id: event.id.hashCode,
        title: 'Event Reminder: ${event.title}',
        body: event.description.isNotEmpty ? event.description : 'You have an upcoming event.',
        scheduledDate: event.dateTime,
      );
    }
  }

  Future<bool> toggleEventCompletion(Event event) async {
    final updatedEvent = event.copyWith(isCompleted: !event.isCompleted);
    final success = await updateEvent(updatedEvent);
    
    if (success && updatedEvent.isCompleted) {
      await _notificationService.cancelNotification(event.id.hashCode);
    }
    return success;
  }

  Future<bool> deleteEvent(String id) async {
    try {
      final box = Hive.box<Event>(_boxName);
      await box.delete(id);
      _events.removeWhere((e) => e.id == id);
      
      await _notificationService.cancelNotification(id.hashCode);
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting event: $e');
      return false;
    }
  }
}
