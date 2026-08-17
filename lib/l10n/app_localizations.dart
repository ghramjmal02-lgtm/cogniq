import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Cogniq'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings ⚙️'**
  String get settingsTitle;

  /// No description provided for @yourInfo.
  ///
  /// In en, this message translates to:
  /// **'👤 Your Info'**
  String get yourInfo;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @studyYear.
  ///
  /// In en, this message translates to:
  /// **'Study Year'**
  String get studyYear;

  /// No description provided for @waterGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'💧 Daily Water Goal'**
  String get waterGoalTitle;

  /// No description provided for @cupsEqualsMl.
  ///
  /// In en, this message translates to:
  /// **'{cups} cups = {ml} ml'**
  String cupsEqualsMl(int cups, int ml);

  /// No description provided for @liters.
  ///
  /// In en, this message translates to:
  /// **'{liters} L'**
  String liters(String liters);

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'🎨 Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode 🌙'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode ☀️'**
  String get lightMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'🌐 Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'✅ Settings saved!'**
  String get settingsSaved;

  /// No description provided for @resetApp.
  ///
  /// In en, this message translates to:
  /// **'Reset App'**
  String get resetApp;

  /// No description provided for @resetConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'All data will be deleted and you\'ll return to the registration screen!\nAre you sure?'**
  String get resetConfirmMessage;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yesDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete'**
  String get yesDelete;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning ☀️'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon 🌤️'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening 🌙'**
  String get greetingEvening;

  /// No description provided for @defaultStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get defaultStudent;

  /// No description provided for @cupsOfWater.
  ///
  /// In en, this message translates to:
  /// **'cups of water'**
  String get cupsOfWater;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get sessions;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @examSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get examSchedule;

  /// No description provided for @exams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get exams;

  /// No description provided for @pomodoro.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro'**
  String get pomodoro;

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focus;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @recordThoughts.
  ///
  /// In en, this message translates to:
  /// **'Record your thoughts'**
  String get recordThoughts;

  /// No description provided for @game.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// No description provided for @memory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memory;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @tracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get tracker;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @newExam.
  ///
  /// In en, this message translates to:
  /// **'New Exam 🗓️'**
  String get newExam;

  /// No description provided for @subjectName.
  ///
  /// In en, this message translates to:
  /// **'Subject Name'**
  String get subjectName;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get chooseDate;

  /// No description provided for @chooseColor.
  ///
  /// In en, this message translates to:
  /// **'Choose Color:'**
  String get chooseColor;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @examScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam Schedule 🗓️'**
  String get examScheduleTitle;

  /// No description provided for @noExamsYet.
  ///
  /// In en, this message translates to:
  /// **'No exams yet!\nTap + to add'**
  String get noExamsYet;

  /// No description provided for @examEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get examEnded;

  /// No description provided for @examToday.
  ///
  /// In en, this message translates to:
  /// **'Today!'**
  String get examToday;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String daysLeft(int days);

  /// No description provided for @pomodoroTitle.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro ⏱️'**
  String get pomodoroTitle;

  /// No description provided for @fourSessionsDone.
  ///
  /// In en, this message translates to:
  /// **'🎉 4 sessions completed! Time for a long break ☕'**
  String get fourSessionsDone;

  /// No description provided for @sessionDoneShortBreak.
  ///
  /// In en, this message translates to:
  /// **'✅ Session complete! Take a short break 😊'**
  String get sessionDoneShortBreak;

  /// No description provided for @breakDoneFocusTime.
  ///
  /// In en, this message translates to:
  /// **'🎯 Break\'s over! Time to focus'**
  String get breakDoneFocusTime;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @longBreakLabel.
  ///
  /// In en, this message translates to:
  /// **'🛋️ Long Break'**
  String get longBreakLabel;

  /// No description provided for @breakTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'☕ Break Time'**
  String get breakTimeLabel;

  /// No description provided for @focusTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'🎯 Focus Time'**
  String get focusTimeLabel;

  /// No description provided for @sessionsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions completed'**
  String sessionsCompleted(int count);

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @pomodoroInfo.
  ///
  /// In en, this message translates to:
  /// **'{focusMin} min focus ← {breakMin} min break\nAfter 4 sessions: {longBreakMin} min long break 🛋️'**
  String pomodoroInfo(int focusMin, int breakMin, int longBreakMin);

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @newNote.
  ///
  /// In en, this message translates to:
  /// **'New Note 📝'**
  String get newNote;

  /// No description provided for @titleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleField;

  /// No description provided for @subjectField.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subjectField;

  /// No description provided for @contentField.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contentField;

  /// No description provided for @saveNote.
  ///
  /// In en, this message translates to:
  /// **'Save Note'**
  String get saveNote;

  /// No description provided for @generalSubject.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalSubject;

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes 📝'**
  String get notesTitle;

  /// No description provided for @noNotesYet.
  ///
  /// In en, this message translates to:
  /// **'No notes yet!\nTap + to add'**
  String get noNotesYet;

  /// No description provided for @memoryGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Memory Game 🧠'**
  String get memoryGameTitle;

  /// No description provided for @replay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replay;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level: '**
  String get level;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'⏱️ Time'**
  String get timeLabel;

  /// No description provided for @attemptsLabel.
  ///
  /// In en, this message translates to:
  /// **'🎯 Attempts'**
  String get attemptsLabel;

  /// No description provided for @matchedLabel.
  ///
  /// In en, this message translates to:
  /// **'✅ Matched'**
  String get matchedLabel;

  /// No description provided for @wellDone.
  ///
  /// In en, this message translates to:
  /// **'🏆 Well done!'**
  String get wellDone;

  /// No description provided for @gameFinishedStats.
  ///
  /// In en, this message translates to:
  /// **'You finished in {moves} moves\nand {time}'**
  String gameFinishedStats(int moves, String time);

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again 🔄'**
  String get playAgain;

  /// No description provided for @waterTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Tracker 💧'**
  String get waterTrackerTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @resetTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetTooltip;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'💧 Reminder!'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to drink water!\nYour body needs you 💪'**
  String get reminderBody;

  /// No description provided for @drankCup.
  ///
  /// In en, this message translates to:
  /// **'I drank a cup! ✅'**
  String get drankCup;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @settingsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings ⚙️'**
  String get settingsDialogTitle;

  /// No description provided for @notificationsSection.
  ///
  /// In en, this message translates to:
  /// **'🔔 Notifications'**
  String get notificationsSection;

  /// No description provided for @waterReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Water Reminder'**
  String get waterReminderTitle;

  /// No description provided for @everyHour.
  ///
  /// In en, this message translates to:
  /// **'Every hour'**
  String get everyHour;

  /// No description provided for @fontSizeSection.
  ///
  /// In en, this message translates to:
  /// **'🔤 Font Size'**
  String get fontSizeSection;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'🌍 Language'**
  String get languageSection;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'ℹ️ About the App'**
  String get aboutSection;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A smart student companion app that helps organize studying, track exams, and improve focus through Pomodoro technique, a memory game, and water tracking.'**
  String get appDescription;

  /// No description provided for @developerLabel.
  ///
  /// In en, this message translates to:
  /// **'👩‍💻 Developer'**
  String get developerLabel;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'📱 Type'**
  String get typeLabel;

  /// No description provided for @typeValue.
  ///
  /// In en, this message translates to:
  /// **'Educational App'**
  String get typeValue;

  /// No description provided for @techLabel.
  ///
  /// In en, this message translates to:
  /// **'🛠️ Technology'**
  String get techLabel;

  /// No description provided for @yearLabel.
  ///
  /// In en, this message translates to:
  /// **'📅 Year'**
  String get yearLabel;

  /// No description provided for @okDone.
  ///
  /// In en, this message translates to:
  /// **'OK ✅'**
  String get okDone;

  /// No description provided for @cupsUnit.
  ///
  /// In en, this message translates to:
  /// **'cups'**
  String get cupsUnit;

  /// No description provided for @mlOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{ml} ml / 2000 ml'**
  String mlOfTotal(int ml);

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'🎉 Great! You reached your daily goal!'**
  String get goalReached;

  /// No description provided for @cupsLeftForGoal.
  ///
  /// In en, this message translates to:
  /// **'{left} cups left to complete 2 liters 💪'**
  String cupsLeftForGoal(int left);

  /// No description provided for @reminderEveryHourOn.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be reminded every hour to drink water 🔔'**
  String get reminderEveryHourOn;

  /// No description provided for @notificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off 🔕'**
  String get notificationsOff;

  /// No description provided for @cupButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Cup'**
  String get cupButtonLabel;

  /// No description provided for @addCupButton.
  ///
  /// In en, this message translates to:
  /// **'Add a cup of water'**
  String get addCupButton;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
