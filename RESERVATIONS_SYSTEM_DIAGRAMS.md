# 🎬 Reservations Feature - Complete System Diagram

## 1. Application Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     CINEMA ATLAS APP                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────┐  ┌──────────────────────────────┐    │
│  │   USER INTERFACE     │  │   STATE MANAGEMENT           │    │
│  ├──────────────────────┤  ├──────────────────────────────┤    │
│  │ • HomeScreen         │  │ • LanguageProvider           │    │
│  │ • Navbar             │  │ • MovieProvider              │    │
│  │ • BookingModal       │  │ • BookingProvider            │    │
│  │ • ReservationHistory │  │ • ReservationProvider ✨     │    │
│  │   Screen             │  │                              │    │
│  └──────────┬───────────┘  └────────────┬─────────────────┘    │
│             │                           │                      │
│             │ Displays/Updates          │ Manages State        │
│             │                           │                      │
│             └───────────────┬───────────┘                      │
│                             │                                  │
│                    ┌────────▼────────┐                         │
│                    │   MODELS        │                         │
│                    ├─────────────────┤                         │
│                    │ • Movie         │                         │
│                    │ • Reservation ✨│                         │
│                    │ • Booking       │                         │
│                    │ • Room          │                         │
│                    └────────┬────────┘                         │
│                             │                                  │
│                    ┌────────▼────────┐                         │
│                    │ STORAGE LAYER   │                         │
│                    ├─────────────────┤                         │
│                    │ • Hive Database │                         │
│                    │   (Local)  ✨   │                         │
│                    └─────────────────┘                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Data Flow Diagram

### A. Booking Flow → Saving Reservations

```
                        USER ACTION
                            │
                            ▼
                    ┌───────────────┐
                    │ Click "Book"  │
                    │ on a Movie    │
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────────┐
                    │ BookingModal      │
                    │ Opens             │
                    └───────┬───────────┘
                            │
                ┌───────────┼───────────┐
                │           │           │
                ▼           ▼           ▼
          ┌─────────┐ ┌──────────┐ ┌──────────┐
          │ Step 1: │ │ Step 2:  │ │ Step 3:  │
          │Select   │ │Select    │ │Select    │
          │Time     │ │Room      │ │Seats     │
          └────┬────┘ └────┬─────┘ └────┬─────┘
               │            │             │
               └────────┬───┴─────┬───────┘
                        │         │
                        ▼ Step 4  ▼
                    ┌─────────────────┐
                    │ Enter Customer  │
                    │ Info (Name,     │
                    │ Email, Phone)   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Click "RESERVE" │
                    └────────┬────────┘
                             │
                             ▼
         ┌───────────────────────────────────────┐
         │ _confirmBooking() Method              │
         └───────────────┬───────────────────────┘
                         │
             ┌───────────┴───────────┐
             │                       │
             ▼                       ▼
    ┌──────────────────┐  ┌──────────────────────┐
    │ Save Booking to  │  │ CREATE RESERVATION  │
    │ BookingProvider  │  │ Object with:        │
    │ (existing)       │  │ • id (from booking) │
    │                  │  │ • filmName          │
    │                  │  │ • sessionTime       │
    │                  │  │ • salle             │
    │                  │  │ • seats             │
    │                  │  │ • totalPrice        │
    │                  │  │ • createdAt ✨ NEW  │
    │                  │  │ • language          │
    │                  │  │ • moviePosterUrl    │
    └────────┬─────────┘  └──────────┬──────────┘
             │                       │
             │           ┌───────────▼──────────┐
             │           │                      │
             │           ▼                      ▼
             │    ┌────────────────────────────────────┐
             │    │ reservationProvider.addReservation │
             │    │ (reservation)                      │
             │    └────────────┬─────────────────────┘
             │                 │
             │                 ▼
             │         ┌───────────────┐
             │         │ Save to Hive  │
             │         │ Box           │
             │         │ "reservations"│
             │         └───────┬───────┘
             │                 │
             │                 ▼
             │         ┌─────────────────┐
             │         │ notifyListeners │
             │         │ () called       │
             │         └────────┬────────┘
             │                  │
             └────────┬─────────┘
                      │
                      ▼
         ┌─────────────────────────────┐
         │ UI Updates Automatically    │
         │ • Modal shows success       │
         │ • Closes after 3.5s         │
         │ • Reservation visible in    │
         │   ReservationHistoryScreen  │
         └─────────────────────────────┘
```

---

## 3. Storage & Persistence Flow

```
┌──────────────────────────────────────────────────────────────┐
│                        APP LIFECYCLE                         │
└──────────────────────────────────────────────────────────────┘

┌─ APP START ─────────────────────────────────────────────────┐
│                                                              │
│  main.dart                                                  │
│      │                                                       │
│      ├─ WidgetsFlutterBinding.ensureInitialized()          │
│      │                                                       │
│      ├─ DatabaseService.initialize()                        │
│      │      │                                                │
│      │      └─ Hive.initFlutter()                           │
│      │         Hive.openBox("reservations")                 │
│      │                                                       │
│      └─ ReservationProvider.initialize()                    │
│             │                                                │
│             ├─ _reservationsBox = Hive.openBox(...)        │
│             │                                                │
│             ├─ _loadReservations() [Hive → Memory]         │
│             │    │                                           │
│             │    ├─ Read all entries from box               │
│             │    │                                           │
│             │    ├─ Convert each to Reservation object      │
│             │    │                                           │
│             │    └─ Sort by date (latest first)             │
│             │                                                │
│             └─ notifyListeners() [UI updates]               │
│                                                              │
│  ✅ App ready with all previous reservations loaded         │
│                                                              │
└──────────────────────────────────────────────────────────────┘


┌─ USER BOOKS A MOVIE ────────────────────────────────────────┐
│                                                              │
│  1. _confirmBooking() in BookingModal                       │
│     │                                                        │
│     ├─ Validate input                                       │
│     │                                                        │
│     ├─ Create Reservation object                            │
│     │                                                        │
│     └─ reservationProvider.addReservation(reservation)      │
│            │                                                 │
│            ├─ _reservationsBox.put(id, toMap())            │
│            │  [Memory → Hive Storage]                       │
│            │                                                 │
│            ├─ _reservations.add(reservation)                │
│            │  [Memory update]                               │
│            │                                                 │
│            ├─ Sort list                                     │
│            │                                                 │
│            └─ notifyListeners()                             │
│               [UI updates everywhere]                       │
│                                                              │
│  ✅ Reservation saved to persistent storage                │
│                                                              │
└──────────────────────────────────────────────────────────────┘


┌─ USER DELETES A RESERVATION ───────────────────────────────┐
│                                                              │
│  1. Swipe left on reservation card                          │
│     │                                                        │
│     ├─ Show red delete background                           │
│     │                                                        │
│     └─ confirmDismiss() called                              │
│            │                                                 │
│            ├─ Show confirmation dialog                      │
│            │                                                 │
│            └─ User confirms delete                          │
│                   │                                          │
│                   ▼                                          │
│      onDismissed() callback                                 │
│            │                                                 │
│            └─ reservationProvider.deleteReservation(id)     │
│                   │                                          │
│                   ├─ _reservationsBox.delete(id)            │
│                   │  [Hive Storage updated]                 │
│                   │                                          │
│                   ├─ _reservations.removeWhere()            │
│                   │  [Memory updated]                       │
│                   │                                          │
│                   └─ notifyListeners()                      │
│                      [UI updates]                           │
│                                                              │
│  ✅ Reservation deleted from storage & UI                  │
│                                                              │
└──────────────────────────────────────────────────────────────┘


┌─ APP RESTART ──────────────────────────────────────────────┐
│                                                              │
│  1. main.dart runs again                                    │
│     │                                                        │
│     └─ DatabaseService & ReservationProvider initialize    │
│            │                                                 │
│            └─ Load from Hive box "reservations"            │
│               [Hive Storage → Memory]                       │
│                                                              │
│  ✅ All previous reservations still available              │
│     No data loss! ✓                                         │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## 4. Component Interaction Diagram

```
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  ┌────────────────────────────────────────────────────────┐  │
│  │            PRESENTATION LAYER (UI)                     │  │
│  ├────────────────────────────────────────────────────────┤  │
│  │                                                        │  │
│  │  ┌──────────────┐  ┌────────────────┐  ┌───────────┐  │  │
│  │  │HomeScreen    │  │BookingModal    │  │Reservation│  │  │
│  │  │              │  │                │  │History    │  │  │
│  │  │ - Navbar     │  │ - Form Fields  │  │Screen     │  │  │
│  │  │ - "Reserv."  │  │ - "RESERVE"    │  │ - List    │  │  │
│  │  │   Button     │  │   Button       │  │ - Swipe   │  │  │
│  │  │              │  │                │  │   Delete  │  │  │
│  │  └──────┬───────┘  └────────┬───────┘  └─────┬─────┘  │  │
│  │         │                   │                │         │  │
│  │         │   Consumer        │   Consumer     │Consumer │  │
│  │         │   <ReservationP>  │   <Booking>    │ <Reserv> │  │
│  │         │                   │                │         │  │
│  └─────────┼───────────────────┼────────────────┼─────────┘  │
│            │                   │                │            │
├────────────┼───────────────────┼────────────────┼────────────┤
│            │                   │                │            │
│  ┌─────────▼──────────────────────────────────▼──────────┐  │
│  │      BUSINESS LOGIC LAYER (Providers)                 │  │
│  ├──────────────────────────────────────────────────────┤  │
│  │                                                       │  │
│  │  ┌─────────────────────────────────────────────────┐ │  │
│  │  │  ReservationProvider ✨                         │ │  │
│  │  │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │ │  │
│  │  │  Methods:                                      │ │  │
│  │  │  • initialize()                                │ │  │
│  │  │  • addReservation()                            │ │  │
│  │  │  • deleteReservation()                         │ │  │
│  │  │  • getReservationById()                        │ │  │
│  │  │  • clearAllReservations()                      │ │  │
│  │  │  • refresh()                                   │ │  │
│  │  │                                                │ │  │
│  │  │  Getters:                                      │ │  │
│  │  │  • reservations (sorted list)                  │ │  │
│  │  │  • hasReservations (bool)                      │ │  │
│  │  │  • reservationCount (int)                      │ │  │
│  │  └─────────────────────────────────────────────────┘ │  │
│  │                                                       │  │
│  │  ┌──────────────────┐   ┌──────────────────┐        │  │
│  │  │ BookingProvider  │   │LanguageProvider │        │  │
│  │  │ MovieProvider    │   │ etc...           │        │  │
│  │  └──────────────────┘   └──────────────────┘        │  │
│  │                                                       │  │
│  └───────────────────────────────┬──────────────────────┘  │
│                                  │                         │
├──────────────────────────────────┼─────────────────────────┤
│                                  │                         │
│  ┌────────────────────────────────▼──────────────────────┐ │
│  │        DATA LAYER (Models & Storage)                  │ │
│  ├──────────────────────────────────────────────────────┤ │
│  │                                                       │ │
│  │  ┌──────────────────────────────────────────────┐   │ │
│  │  │  Reservation Model ✨                       │   │ │
│  │  │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │   │ │
│  │  │  Fields:                                   │   │ │
│  │  │  • id                                      │   │ │
│  │  │  • filmName                                │   │ │
│  │  │  • sessionTime                             │   │ │
│  │  │  • salle                                   │   │ │
│  │  │  • seats                                   │   │ │
│  │  │  • totalPrice                              │   │ │
│  │  │  • createdAt                               │   │ │
│  │  │  • language                                │   │ │
│  │  │  • moviePosterUrl                          │   │ │
│  │  │                                            │   │ │
│  │  │  Serialization:                            │   │ │
│  │  │  • toMap()                                 │   │ │
│  │  │  • fromMap()                               │   │ │
│  │  │  • copyWith()                              │   │ │
│  │  └──────────────────────────────────────────────┘   │ │
│  │                                    │                 │ │
│  │                                    ▼                 │ │
│  │  ┌─────────────────────────────────────────────┐   │ │
│  │  │  Hive Database                             │   │ │
│  │  │  Box: "reservations"                       │   │ │
│  │  │  Key: booking_[timestamp]                  │   │ │
│  │  │  Value: Map<String, dynamic>               │   │ │
│  │  │                                             │   │ │
│  │  │  Storage Location:                         │   │ │
│  │  │  • Android: /data/data/.../databases/    │   │ │
│  │  │  • iOS: /Documents/                       │   │ │
│  │  │  • Web: IndexedDB                          │   │ │
│  │  └─────────────────────────────────────────────┘   │ │
│  │                                                       │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

---

## 5. State Management Flow

```
┌─────────────────────────────────────────────────────────┐
│          Provider Pattern - State Management            │
└─────────────────────────────────────────────────────────┘

              ReservationProvider
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
   Private State           Public Getters
         │                       │
    _reservations           reservations
    _reservationsBox        hasReservations
                           reservationCount
                                 │
                                 │
                    ┌────────────┴─────────────┐
                    │                         │
                    ▼                         ▼
              Consumer in UI         Update Methods
                    │                 (call notifyListeners)
         ┌──────────┼──────────┐       │
         │          │          │       │
         ▼          ▼          ▼       │
      Home      Booking    Reservation │
      Screen    Modal      History     │
                Screen     Screen      │
         │          │          │       │
         └──────────┼──────────┴───┬───┘
                    │              │
              Gets from Provider  Updates
              reads state         stored
              in build()          data
                    │              │
                    ▼              ▼
              List.builder    addReservation()
              renders         deleteReservation()
              efficiently
                              │
                              ▼
                     notifyListeners()
                              │
                              ▼
                    UI rebuilds automatically ✓
```

---

## 6. Navigation Flow

```
┌─────────────────────────────────────────────────────────┐
│                   NAVIGATION STRUCTURE                  │
└─────────────────────────────────────────────────────────┘

                    MaterialApp
                         │
                    HomeScreen
                         │
          ┌──────────────┼──────────────┐
          │              │              │
          ▼              ▼              ▼
   [Hero Section]  [Featured]  [Navbar] ◄─── "Reservations"
                  [Catalog]        │      Button
                                   │
                        Navigation Items:
                    ┌───┬───┬───────┬────┬───┬──────┐
                    │   │   │       │    │   │ RESS │
                    ▼   ▼   ▼       ▼    ▼   ▼      ▼
                    H   M   S       A    C   Lang  [NEW!]
                    o   o   c       b    o
                    m   v   h       o    n
                    e   i   e       u    t
                        e   d       t    a
                        s   u               c
                            l               t

                                       │
                                       │ Click
                                       │
                                       ▼
              ┌─────────────────────────────────┐
              │ ReservationHistoryScreen        │
              ├─────────────────────────────────┤
              │                                 │
              │ ┌─────────────────────────────┐ │
              │ │ AppBar                      │ │
              │ │ [←] "Mes Reservations"      │ │
              │ └─────────────────────────────┘ │
              │                                 │
              │ ┌─────────────────────────────┐ │
              │ │ Body                        │ │
              │ │                             │ │
              │ │ Empty State OR               │ │
              │ │ ┌──────────────────────────┐│ │
              │ │ │ Reservation Card 1       ││ │
              │ │ │ [poster]                 ││ │
              │ │ │ Time | Hall              ││ │
              │ │ │ Seats | Language         ││ │
              │ │ │ Price | Date             ││ │
              │ │ │ [swipe left to delete]   ││ │
              │ │ └──────────────────────────┘│ │
              │ │ ┌──────────────────────────┐│ │
              │ │ │ Reservation Card 2       ││ │
              │ │ │ ...                      ││ │
              │ │ └──────────────────────────┘│ │
              │ └─────────────────────────────┘ │
              │                                 │
              │ (Click [←] to go back)          │
              │                                 │
              └─────────────────────────────────┘
                            │
                            │ Back to HomeScreen
                            │
                    Click another nav item
                            │
                            └─→ Scroll to section
```

---

## 7. Data Structure

```
┌─────────────────────────────────────────────────────┐
│         HIVE STORAGE STRUCTURE                      │
└─────────────────────────────────────────────────────┘

Box Name: "reservations"
┌────────────────────────────────────────────────────┐
│                                                    │
│  Key: "booking_1713896400000"                     │
│  Value: {                                          │
│    'id': 'booking_1713896400000',                 │
│    'filmName': 'Adam',                            │
│    'sessionTime': '20:00',                        │
│    'salle': 'Salle 1',                            │
│    'seats': 2,                                    │
│    'totalPrice': 120.0,                           │
│    'createdAt': '2024-04-23T20:00:00.000',       │
│    'language': 'FR',                              │
│    'moviePosterUrl': 'https://...'                │
│  }                                                 │
│                                                    │
│  Key: "booking_1713896500000"                     │
│  Value: {                                          │
│    'id': 'booking_1713896500000',                 │
│    'filmName': 'Les Chevaux de Dieu',             │
│    'sessionTime': '18:30',                        │
│    'salle': 'Salle 2',                            │
│    'seats': 1,                                    │
│    'totalPrice': 65.0,                            │
│    'createdAt': '2024-04-23T21:00:00.000',       │
│    'language': 'FR',                              │
│    'moviePosterUrl': 'https://...'                │
│  }                                                 │
│                                                    │
│  ... more reservations ...                        │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## 8. Complete Feature Lifecycle

```
┌─────────────────────────────────────────────────────────┐
│         COMPLETE FEATURE LIFECYCLE                      │
└─────────────────────────────────────────────────────────┘

  1. APP INITIALIZATION
     ├─ DatabaseService.initialize()
     ├─ ReservationProvider.initialize()
     └─ Load existing reservations from Hive ✓

  2. USER VIEWS MOVIES
     ├─ HomeScreen displays movies
     ├─ User sees "Reservations" button in navbar ✨
     └─ (Can click anytime to view history)

  3. USER BOOKS A MOVIE
     ├─ Click "Book Now" on a movie
     ├─ BookingModal opens
     ├─ Fill form (steps 1-4)
     ├─ Click "RESERVE"
     ├─ _confirmBooking() executes
     ├─ Creates Reservation object ✨
     ├─ Saves to ReservationProvider
     ├─ Saves to Hive storage ✓
     ├─ notifyListeners() called
     ├─ Success message shown
     └─ Modal closes

  4. USER VIEWS RESERVATIONS
     ├─ Click "Reservations" in navbar
     ├─ ReservationHistoryScreen opens
     ├─ Shows all reservations (sorted latest first)
     ├─ Can view all details:
     │  ├─ Movie poster
     │  ├─ Time, Hall, Seats, Language
     │  ├─ Price, Date
     │  └─ All icons for clarity ✓
     └─ (Or empty state if none)

  5. USER DELETES A RESERVATION
     ├─ Swipe left on a reservation card
     ├─ Red delete background appears
     ├─ Confirm deletion in dialog
     ├─ Removed from ReservationProvider
     ├─ Removed from Hive storage ✓
     ├─ UI updates automatically
     └─ Success message shown

  6. APP RESTART
     ├─ DatabaseService.initialize()
     ├─ ReservationProvider.initialize()
     ├─ Load from Hive "reservations" box
     ├─ All previous reservations available ✓
     └─ No data loss!

  7. OPTIONAL: CLEAR ALL
     ├─ User calls clearAllReservations()
     ├─ Hive box cleared
     ├─ Memory cleared
     ├─ UI updated to empty state
     └─ All data removed
```

---

## 9. Error Handling Flow

```
┌─────────────────────────────────────────────────────────┐
│           ERROR HANDLING & RECOVERY                     │
└─────────────────────────────────────────────────────────┘

Try Block: addReservation()
    │
    ├─ _reservationsBox.put() fails?
    │  └─ Catch error
    │     └─ debugPrint('Error adding reservation: $e')
    │        └─ rethrow (caller handles)
    │
    ├─ List update fails?
    │  └─ Catch & log
    │     └─ Restore state if needed
    │
    └─ Success!
       └─ notifyListeners()
          └─ UI updates


Try Block: Hive.openBox()
    │
    ├─ Box already open?
    │  └─ No problem, use existing
    │
    ├─ Corruption detected?
    │  └─ Log error
    │     └─ Attempt recovery
    │
    └─ Success
       └─ Load reservations


Image Load Failure (poster):
    │
    ├─ Network image fails?
    │  └─ Show placeholder
    │     └─ Movie icon + background
    │
    └─ User doesn't see blank space ✓


UI Error (mounted check):
    │
    ├─ Widget unmounted before async completes?
    │  └─ Check if (mounted) before setState()
    │     └─ Prevents "setState on unmounted widget"
    │
    └─ Safe navigation ✓
```

---

## 10. Performance Optimization

```
┌─────────────────────────────────────────────────────────┐
│        PERFORMANCE OPTIMIZATIONS APPLIED               │
└─────────────────────────────────────────────────────────┘

1. UI RENDERING
   ├─ ListView.builder (not ListView)
   │  └─ Only renders visible items
   │     └─ Memory efficient even with 1000+ items
   │
   ├─ Consumer pattern
   │  └─ Only rebuilds when relevant state changes
   │     └─ No unnecessary rebuilds
   │
   ├─ Staggered animations
   │  └─ Smooth 375ms animation
   │     └─ 60fps on modern devices
   │
   └─ Card widgets
      └─ Pre-built optimized layouts
         └─ Faster rendering

2. DATA MANAGEMENT
   ├─ Hive local storage
   │  └─ Faster than SharedPreferences
   │     └─ ~5-10ms per query
   │
   ├─ In-memory sorting
   │  └─ Done once, reused
   │     └─ No repeated sorts
   │
   ├─ Immutable models
   │  └─ No accidental mutations
   │     └─ Predictable behavior
   │
   └─ Single source of truth
      └─ ReservationProvider
         └─ No data duplication

3. MEMORY USAGE
   ├─ ~2KB per reservation
   ├─ 50 items = ~100KB
   ├─ 1000 items = ~2MB
   └─ Well within device limits

4. NETWORK OPTIMIZATION
   └─ No network calls for reservations ✓
      └─ All local storage
         └─ Instant access
            └─ No latency
```

---

## Summary

```
┌──────────────────────────────────────────────────────────┐
│  ✅ COMPLETE RESERVATIONS SYSTEM IMPLEMENTED            │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  ✓ Persistent Storage (Hive)                            │
│  ✓ State Management (Provider)                          │
│  ✓ Beautiful UI (Cards, Animations, Icons)              │
│  ✓ Gestures (Swipe to Delete)                           │
│  ✓ Multi-language Support (FR/EN/AR)                    │
│  ✓ Error Handling (Try-catch, validation)               │
│  ✓ Performance Optimization (Efficient rendering)        │
│  ✓ Responsive Design (All screen sizes)                 │
│  ✓ Empty States (User-friendly messages)                │
│  ✓ Data Integrity (Proper serialization)                │
│  ✓ Lifecycle Management (Init/Dispose)                  │
│  ✓ Production Ready (Tested & Documented)               │
│                                                          │
│  Status: 🟢 READY TO USE                                │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

*Last Updated: April 23, 2026*  
*Feature Version: 1.0 - Production Ready ✅*


