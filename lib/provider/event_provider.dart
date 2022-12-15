import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tsec_app/models/event_model/event_model.dart';
import 'package:tsec_app/screens/event_detail_screen/event_details.dart';
import 'package:tsec_app/services/event_services.dart';

final eventProvider = Provider((ref) {
  return EventProvider(eventServices: ref.read(eventServicesProvider));
});

final eventListProvider = StreamProvider((ref) {
  final eventStreamProvider = ref.read(eventProvider);
  return eventStreamProvider.getEventDetails();
});

class EventProvider {
  final EventServices _eventServices;

  EventProvider({required EventServices eventServices})
      : _eventServices = eventServices;

  Stream<List<EventModel>?> getEventDetails() {
    return _eventServices.getEventDetails();
  }



  
}
