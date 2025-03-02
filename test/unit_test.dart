import 'package:flutter_test/flutter_test.dart';
import 'package:eventify/data/repositories/event_repository.dart';
import 'package:eventify/data/services/api_client.dart';
import 'package:eventify/models/event_model.dart';
import 'package:eventify/utils/result.dart';
import 'package:eventify/utils/date_formatter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:intl/date_symbol_data_local.dart';

@GenerateNiceMocks([MockSpec<ApiClient>()])
import 'unit_test.mocks.dart';

void provideDummyValues() {
  provideDummy<Result<void>>(Result.ok(null));
  provideDummy<Result<EventModel>>(Result.ok(EventModel(
    eventId: 'dummy-id',
    profileImage: 'dummy-profile.jpg',
    username: 'dummy-user',
    eventImage: 'dummy-event.jpg',
    title: 'Dummy Event',
    description: 'Dummy Description',
    locationId: 'dummy-location',
    latitude: '0',
    longitude: '0',
    startsAt: '2024-03-01T10:00:00Z',
    endsAt: '2024-03-01T12:00:00Z',
    date: '2024-03-01',
    category: 'Dummy Category',
    categoryId: '1',
    musicUrl: 'dummy-music.mp3',
    userId: 'dummy-user-id',
    isLiked: false,
  )));
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
  });

  group('Date Formatter Tests', () {
    group('parseDate Tests', () {
      test('should correctly parse valid date strings', () {
        final testCases = {
          '01/01/2024': DateTime.parse('2024-01-01T16:00:00.000Z'),
          '15/06/2023': DateTime.parse('2023-06-15T16:00:00.000Z'),
          '31/12/2025': DateTime.parse('2025-12-31T16:00:00.000Z'),
          '29/02/2024': DateTime.parse('2024-02-29T16:00:00.000Z'),
        };

        testCases.forEach((input, expected) {
          final result = parseDate(input);
          expect(
            result, 
            expected, 
            reason: 'Failed parsing date: $input'
          );
        });
      });

      test('should throw FormatException for invalid date strings', () {
        final invalidDates = [
          '32/01/2024',
          '01/13/2024',
          '29/02/2023',
          'invalid',
          '',
        ];

        for (final invalidDate in invalidDates) {
          expect(
            () => parseDate(invalidDate),
            throwsA(isA<FormatException>()),
            reason: 'Should throw FormatException for $invalidDate'
          );
        }
      });
    });

    group('formatDateToLocalString Tests', () {
      test('should format dates correctly with padding', () {
        final testCases = {
          DateTime(2024, 1, 1): '01/01/2024',
          DateTime(2023, 6, 15): '15/06/2023',
          DateTime(2025, 12, 31): '31/12/2025',
          DateTime(2024, 2, 29): '29/02/2024',
        };

        testCases.forEach((input, expected) {
          final result = formatDateToLocalString(input);
          expect(
            result, 
            expected,
            reason: 'Failed formatting date: ${input.toIso8601String()}'
          );
        });
      });
    });

    group('formatTime Tests', () {
      test('should format time correctly with 24-hour format', () {
        final testCases = {
          DateTime(2024, 1, 1, 9, 30): '09:30',
          DateTime(2024, 1, 1, 15, 45): '15:45',
          DateTime(2024, 1, 1, 0, 0): '00:00',
          DateTime(2024, 1, 1, 23, 59): '23:59',
          DateTime(2024, 1, 1, 12, 0): '12:00',
          DateTime(2024, 1, 1, 5, 5): '05:05',
        };

        testCases.forEach((input, expected) {
          final result = formatTime(input);
          expect(
            result, 
            expected,
            reason: 'Failed formatting time: ${input.toIso8601String()}'
          );
        });
      });
    });
  });

  group('EventRepository Tests', () {
    late MockApiClient mockApiClient;
    late EventRepository eventRepository;

    setUp(() {
      provideDummyValues(); 
      mockApiClient = MockApiClient();
      eventRepository = EventRepository(mockApiClient);
    });

    test('createEvent should return success when API call succeeds', () async {
      // Arrange
      final userId = 'test-user-id';
      final eventImage = 'test-image.jpg';
      final categoryId = 1;
      final locationId = 'test-location-id';
      final title = 'Test Event';
      final description = 'Test Description';
      final date = DateTime(2024, 3, 1);
      final startsAt = DateTime(2024, 3, 1, 10, 0);
      final endsAt = DateTime(2024, 3, 1, 12, 0);
      final eventMusic = 'test-music.mp3';

      when(mockApiClient.createEvent(
        userId: userId,
        eventImage: eventImage,
        categoryId: categoryId,
        locationId: locationId,
        title: title,
        description: description,
        date: date,
        startsAt: startsAt,
        endsAt: endsAt,
        eventMusic: eventMusic,
      )).thenAnswer((_) async => Result.ok(null));

      // Act
      final result = await eventRepository.createEvent(
        userId: userId,
        eventImage: eventImage,
        categoryId: categoryId,
        locationId: locationId,
        title: title,
        description: description,
        date: date,
        startsAt: startsAt,
        endsAt: endsAt,
        eventMusic: eventMusic,
      );

      // Assert
      expect(result, isA<Ok<void>>());
      verify(mockApiClient.createEvent(
        userId: userId,
        eventImage: eventImage,
        categoryId: categoryId,
        locationId: locationId,
        title: title,
        description: description,
        date: date,
        startsAt: startsAt,
        endsAt: endsAt,
        eventMusic: eventMusic,
      )).called(1);
    });

    test('createEvent should return error when API call fails', () async {
      // Arrange
      final userId = 'test-user-id';
      final eventImage = 'test-image.jpg';
      final categoryId = 1;
      final locationId = 'test-location-id';
      final title = 'Test Event';
      final description = 'Test Description';
      final date = DateTime(2024, 3, 1);
      final startsAt = DateTime(2024, 3, 1, 10, 0);
      final endsAt = DateTime(2024, 3, 1, 12, 0);
      final eventMusic = 'test-music.mp3';
      final expectedError = Exception('API Error');

      when(mockApiClient.createEvent(
        userId: userId,
        eventImage: eventImage,
        categoryId: categoryId,
        locationId: locationId,
        title: title,
        description: description,
        date: date,
        startsAt: startsAt,
        endsAt: endsAt,
        eventMusic: eventMusic,
      )).thenAnswer((_) async => Result.error(expectedError));

      // Act
      final result = await eventRepository.createEvent(
        userId: userId,
        eventImage: eventImage,
        categoryId: categoryId,
        locationId: locationId,
        title: title,
        description: description,
        date: date,
        startsAt: startsAt,
        endsAt: endsAt,
        eventMusic: eventMusic,
      );

      // Assert
      expect(result, isA<Error<void>>());
      expect((result as Error).error, equals(expectedError));
    });

    test('getEventDetails should return event when API call succeeds', () async {
      // Arrange
      final eventId = 'test-event-id';
      final userId = 'test-user-id';
      final expectedEvent = EventModel(
        eventId: eventId,
        profileImage: 'profile.jpg',
        username: 'testuser',
        eventImage: 'event.jpg',
        title: 'Test Event',
        description: 'Test Description',
        locationId: 'location-1',
        latitude: '123',
        longitude: '456',
        startsAt: '2024-03-01T10:00:00Z',
        endsAt: '2024-03-01T12:00:00Z',
        date: '2024-03-01',
        category: 'Test Category',
        categoryId: '1',
        musicUrl: 'music.mp3',
        userId: userId,
        isLiked: false,
      );

      when(mockApiClient.getEventDetails(eventId, userId))
          .thenAnswer((_) async => Result.ok(expectedEvent));

      // Act
      final result = await eventRepository.getEventDetails(eventId, userId);

      // Assert
      expect(result, isA<Ok<EventModel>>());
      expect((result as Ok<EventModel>).value.eventId, equals(eventId));
      expect(result.value.title, equals('Test Event'));
      verify(mockApiClient.getEventDetails(eventId, userId)).called(1);
    });
  });
}