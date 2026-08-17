// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cogniq';

  @override
  String get settingsTitle => 'Settings ⚙️';

  @override
  String get yourInfo => '👤 Your Info';

  @override
  String get name => 'Name';

  @override
  String get studyYear => 'Study Year';

  @override
  String get waterGoalTitle => '💧 Daily Water Goal';

  @override
  String cupsEqualsMl(int cups, int ml) {
    return '$cups cups = $ml ml';
  }

  @override
  String liters(String liters) {
    return '$liters L';
  }

  @override
  String get appearance => '🎨 Appearance';

  @override
  String get darkMode => 'Dark Mode 🌙';

  @override
  String get lightMode => 'Light Mode ☀️';

  @override
  String get language => '🌐 Language';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get settingsSaved => '✅ Settings saved!';

  @override
  String get resetApp => 'Reset App';

  @override
  String get resetConfirmMessage => 'All data will be deleted and you\'ll return to the registration screen!\nAre you sure?';

  @override
  String get no => 'No';

  @override
  String get yesDelete => 'Yes, delete';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get greetingMorning => 'Good Morning ☀️';

  @override
  String get greetingAfternoon => 'Good Afternoon 🌤️';

  @override
  String get greetingEvening => 'Good Evening 🌙';

  @override
  String get defaultStudent => 'Student';

  @override
  String get cupsOfWater => 'cups of water';

  @override
  String get sessions => 'sessions';

  @override
  String get today => 'Today';

  @override
  String get examSchedule => 'Schedule';

  @override
  String get exams => 'Exams';

  @override
  String get pomodoro => 'Pomodoro';

  @override
  String get focus => 'Focus';

  @override
  String get notes => 'Notes';

  @override
  String get recordThoughts => 'Record your thoughts';

  @override
  String get game => 'Game';

  @override
  String get memory => 'Memory';

  @override
  String get water => 'Water';

  @override
  String get tracker => 'Tracker';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get newExam => 'New Exam 🗓️';

  @override
  String get subjectName => 'Subject Name';

  @override
  String get chooseDate => 'Choose Date';

  @override
  String get chooseColor => 'Choose Color:';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get examScheduleTitle => 'Exam Schedule 🗓️';

  @override
  String get noExamsYet => 'No exams yet!\nTap + to add';

  @override
  String get examEnded => 'Ended';

  @override
  String get examToday => 'Today!';

  @override
  String daysLeft(int days) {
    return '$days days';
  }

  @override
  String get pomodoroTitle => 'Pomodoro ⏱️';

  @override
  String get fourSessionsDone => '🎉 4 sessions completed! Time for a long break ☕';

  @override
  String get sessionDoneShortBreak => '✅ Session complete! Take a short break 😊';

  @override
  String get breakDoneFocusTime => '🎯 Break\'s over! Time to focus';

  @override
  String get ok => 'OK';

  @override
  String get longBreakLabel => '🛋️ Long Break';

  @override
  String get breakTimeLabel => '☕ Break Time';

  @override
  String get focusTimeLabel => '🎯 Focus Time';

  @override
  String sessionsCompleted(int count) {
    return '$count sessions completed';
  }

  @override
  String get pause => 'Pause';

  @override
  String get start => 'Start';

  @override
  String pomodoroInfo(int focusMin, int breakMin, int longBreakMin) {
    return '$focusMin min focus ← $breakMin min break\nAfter 4 sessions: $longBreakMin min long break 🛋️';
  }

  @override
  String get all => 'All';

  @override
  String get newNote => 'New Note 📝';

  @override
  String get titleField => 'Title';

  @override
  String get subjectField => 'Subject';

  @override
  String get contentField => 'Content';

  @override
  String get saveNote => 'Save Note';

  @override
  String get generalSubject => 'General';

  @override
  String get notesTitle => 'Notes 📝';

  @override
  String get noNotesYet => 'No notes yet!\nTap + to add';

  @override
  String get memoryGameTitle => 'Memory Game 🧠';

  @override
  String get replay => 'Replay';

  @override
  String get level => 'Level: ';

  @override
  String get easy => 'Easy';

  @override
  String get hard => 'Hard';

  @override
  String get timeLabel => '⏱️ Time';

  @override
  String get attemptsLabel => '🎯 Attempts';

  @override
  String get matchedLabel => '✅ Matched';

  @override
  String get wellDone => '🏆 Well done!';

  @override
  String gameFinishedStats(int moves, String time) {
    return 'You finished in $moves moves\nand $time';
  }

  @override
  String get playAgain => 'Play Again 🔄';

  @override
  String get waterTrackerTitle => 'Water Tracker 💧';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get resetTooltip => 'Reset';

  @override
  String get reminderTitle => '💧 Reminder!';

  @override
  String get reminderBody => 'Don\'t forget to drink water!\nYour body needs you 💪';

  @override
  String get drankCup => 'I drank a cup! ✅';

  @override
  String get later => 'Later';

  @override
  String get settingsDialogTitle => 'Settings ⚙️';

  @override
  String get notificationsSection => '🔔 Notifications';

  @override
  String get waterReminderTitle => 'Water Reminder';

  @override
  String get everyHour => 'Every hour';

  @override
  String get fontSizeSection => '🔤 Font Size';

  @override
  String get small => 'Small';

  @override
  String get normal => 'Normal';

  @override
  String get large => 'Large';

  @override
  String get languageSection => '🌍 Language';

  @override
  String get aboutSection => 'ℹ️ About the App';

  @override
  String get appDescription => 'A smart student companion app that helps organize studying, track exams, and improve focus through Pomodoro technique, a memory game, and water tracking.';

  @override
  String get developerLabel => '👩‍💻 Developer';

  @override
  String get typeLabel => '📱 Type';

  @override
  String get typeValue => 'Educational App';

  @override
  String get techLabel => '🛠️ Technology';

  @override
  String get yearLabel => '📅 Year';

  @override
  String get okDone => 'OK ✅';

  @override
  String get cupsUnit => 'cups';

  @override
  String mlOfTotal(int ml) {
    return '$ml ml / 2000 ml';
  }

  @override
  String get goalReached => '🎉 Great! You reached your daily goal!';

  @override
  String cupsLeftForGoal(int left) {
    return '$left cups left to complete 2 liters 💪';
  }

  @override
  String get reminderEveryHourOn => 'You\'ll be reminded every hour to drink water 🔔';

  @override
  String get notificationsOff => 'Notifications are off 🔕';

  @override
  String get cupButtonLabel => 'Cup';

  @override
  String get addCupButton => 'Add a cup of water';
}
