// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Cogniq';

  @override
  String get settingsTitle => 'الإعدادات ⚙';

  @override
  String get yourInfo => '👤 بياناتك';

  @override
  String get name => 'الاسم';

  @override
  String get studyYear => 'السنة الدراسية';

  @override
  String get waterGoalTitle => '💧 هدف الماء اليومي';

  @override
  String cupsEqualsMl(int cups, int ml) {
    return '$cups كوب = $ml مل';
  }

  @override
  String liters(String liters) {
    return '$liters لتر';
  }

  @override
  String get appearance => '🎨 المظهر';

  @override
  String get darkMode => 'الوضع الداكن 🌙';

  @override
  String get lightMode => 'الوضع الفاتح ☀️';

  @override
  String get language => '🌐 اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'English';

  @override
  String get saveSettings => 'حفظ الإعدادات';

  @override
  String get settingsSaved => '✅ تم حفظ الإعدادات بنجاح';

  @override
  String get resetApp => 'إعادة تعيين التطبيق';

  @override
  String get resetConfirmMessage =>
      'سيتم مسح جميع البيانات والعودة إلى شاشة التسجيل\nهل أنت متأكد؟';

  @override
  String get no => 'لا';

  @override
  String get yesDelete => 'نعم، احذف';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String get greetingMorning => 'صباح الخير ☀️';

  @override
  String get greetingAfternoon => 'مساء النور 🌤️';

  @override
  String get greetingEvening => 'مساء الخير 🌙';

  @override
  String get defaultStudent => 'طالب';

  @override
  String get cupsOfWater => 'كوب ماء';

  @override
  String get sessions => 'جلسات';

  @override
  String get today => 'اليوم';

  @override
  String get examSchedule => 'جدول';

  @override
  String get exams => 'امتحانات';

  @override
  String get pomodoro => 'بومودورو';

  @override
  String get focus => 'تركيز';

  @override
  String get notes => 'ملاحظات';

  @override
  String get recordThoughts => 'سجّل أفكارك';

  @override
  String get game => 'لعبة';

  @override
  String get memory => 'الذاكرة';

  @override
  String get water => 'ماء';

  @override
  String get tracker => 'متابعة';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get sunday => 'الأحد';

  @override
  String get january => 'يناير';

  @override
  String get february => 'فبراير';

  @override
  String get march => 'مارس';

  @override
  String get april => 'إبريل';

  @override
  String get may => 'مايو';

  @override
  String get june => 'يونيو';

  @override
  String get july => 'يوليو';

  @override
  String get august => 'أغسطس';

  @override
  String get september => 'سبتمبر';

  @override
  String get october => 'أكتوبر';

  @override
  String get november => 'نوفمبر';

  @override
  String get december => 'ديسمبر';

  @override
  String get newExam => 'امتحان جديد 🗓️';

  @override
  String get subjectName => 'اسم المادة';

  @override
  String get chooseDate => 'اختيار التاريخ';

  @override
  String get chooseColor => 'اختيار اللون:';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get examScheduleTitle => 'جدول الامتحانات 🗓️';

  @override
  String get noExamsYet => 'لا توجد امتحانات بعد\nاضغط على + لإضافة امتحان';

  @override
  String get examEnded => 'انتهى';

  @override
  String get examToday => 'اليوم';

  @override
  String daysLeft(int days) {
    return '$days يوم متبقٍ';
  }

  @override
  String get pomodoroTitle => 'بومودورو ⏱️';

  @override
  String get fourSessionsDone =>
      '🎉 لقد أكملت أربع جلسات، حان وقت الاستراحة الطويلة ☕';

  @override
  String get sessionDoneShortBreak => '✅ اكتملت الجلسة، خذ استراحة قصيرة 😊';

  @override
  String get breakDoneFocusTime => '🎯 انتهت الاستراحة، حان وقت التركيز';

  @override
  String get ok => 'حسناً';

  @override
  String get longBreakLabel => '🛋️ استراحة طويلة';

  @override
  String get breakTimeLabel => '☕ وقت الاستراحة';

  @override
  String get focusTimeLabel => '🎯 وقت التركيز';

  @override
  String sessionsCompleted(int count) {
    return 'اكتملت الجلسة رقم $count';
  }

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get start => 'ابدأ';

  @override
  String pomodoroInfo(int focusMin, int breakMin, int longBreakMin) {
    return '$focusMin دقيقة تركيز ← $breakMin دقائق استراحة\nبعد أربع جلسات: $longBreakMin دقيقة استراحة طويلة 🛋️';
  }

  @override
  String get all => 'الكل';

  @override
  String get newNote => 'ملاحظة جديدة 📝';

  @override
  String get titleField => 'العنوان';

  @override
  String get subjectField => 'المادة';

  @override
  String get contentField => 'المحتوى';

  @override
  String get saveNote => 'حفظ الملاحظة';

  @override
  String get generalSubject => 'عام';

  @override
  String get notesTitle => 'الملاحظات 📝';

  @override
  String get noNotesYet => 'لا توجد ملاحظات بعد\nاضغط على + لإضافة ملاحظة';

  @override
  String get memoryGameTitle => 'لعبة الذاكرة 🧠';

  @override
  String get replay => 'إعادة اللعب';

  @override
  String get level => 'المستوى: ';

  @override
  String get easy => 'سهل';

  @override
  String get hard => 'صعب';

  @override
  String get timeLabel => '⏱️ الوقت';

  @override
  String get attemptsLabel => '🎯 المحاولات';

  @override
  String get matchedLabel => '✅ المتطابق';

  @override
  String get wellDone => '🏆 أحسنت!';

  @override
  String gameFinishedStats(int moves, String time) {
    return 'أنهيت اللعبة في $moves محاولة\nخلال $time';
  }

  @override
  String get playAgain => 'العب مرة أخرى 🔄';

  @override
  String get waterTrackerTitle => 'متابعة شرب الماء 💧';

  @override
  String get settingsTooltip => 'الإعدادات';

  @override
  String get resetTooltip => 'إعادة تعيين';

  @override
  String get reminderTitle => '💧 تذكير!';

  @override
  String get reminderBody => 'لا تنسَ شرب الماء\nجسمك بحاجة إليك 💪';

  @override
  String get drankCup => 'تم شرب كوب ✅';

  @override
  String get later => 'لاحقاً';

  @override
  String get settingsDialogTitle => 'الإعدادات ⚙️';

  @override
  String get notificationsSection => '🔔 الإشعارات';

  @override
  String get waterReminderTitle => 'تذكير شرب الماء';

  @override
  String get everyHour => 'كل ساعة';

  @override
  String get fontSizeSection => '🔤 حجم الخط';

  @override
  String get small => 'صغير';

  @override
  String get normal => 'عادي';

  @override
  String get large => 'كبير';

  @override
  String get languageSection => '🌍 اللغة';

  @override
  String get aboutSection => 'ℹ️ حول التطبيق';

  @override
  String get appDescription =>
      'تطبيق مساعد ذكي للطلاب يساعدهم على تنظيم دراستهم، ومتابعة امتحاناتهم، وتحسين تركيزهم من خلال تقنية البومودورو، ولعبة الذاكرة، ومتابعة شرب الماء.';

  @override
  String get developerLabel => '👩‍💻 المطورة';

  @override
  String get typeLabel => '📱 النوع';

  @override
  String get typeValue => 'تطبيق تعليمي';

  @override
  String get techLabel => '🛠️ التقنية';

  @override
  String get yearLabel => '📅 السنة';

  @override
  String get okDone => 'حسناً ✅';

  @override
  String get cupsUnit => 'كوب';

  @override
  String mlOfTotal(int ml) {
    return '$ml مل / 2000 مل';
  }

  @override
  String get goalReached => '🎉 أحسنت! لقد بلغت هدفك اليومي';

  @override
  String cupsLeftForGoal(int left) {
    return 'تبقّى $left كوب لإكمال اللترين 💪';
  }

  @override
  String get reminderEveryHourOn => 'سيتم تذكيرك كل ساعة بشرب الماء 🔔';

  @override
  String get notificationsOff => 'الإشعارات متوقفة 🔕';

  @override
  String get cupButtonLabel => 'كوب';

  @override
  String get addCupButton => 'إضافة كوب ماء';

  @override
  String get quiz => 'اختبار';

  @override
  String get generateQuiz => 'توليد اختبار';

  @override
  String get summary => 'تلخيص';

  @override
  String get summarizeFile => 'تلخيص الملف';

  @override
  String get quizScreenTitle => 'توليد اختبار من ملف';

  @override
  String get choosePdfFile => 'اختيار ملف PDF';

  @override
  String get noReadableText => 'لم يُعثر على نص قابل للقراءة في الملف';

  @override
  String errorOccurred(String error) {
    return 'حدث خطأ: $error';
  }

  @override
  String get summaryResultTitle => 'ملخص الملف';

  @override
  String get progress => 'تقدمك';

  @override
  String get trackProgress => 'إحصائياتك';

  @override
  String get quizzesLabel => 'الاختبارات';

  @override
  String get correctAnswersLabel => 'الإجابات الصحيحة';

  @override
  String get averageLabel => 'المعدل';

  @override
  String get noQuizzesYet => 'لم تقم بأي اختبار بعد';

  @override
  String get yourProgress => 'تقدمك';

  @override
  String get quizResultTitle => 'نتيجة الاختبار';

  @override
  String get exit => 'خروج';

  @override
  String get submitQuiz => 'إرسال الاختبار';

  @override
  String get savedSummaries => 'التلخيصات المحفوظة';

  @override
  String get noSummariesYet => 'لا توجد تلخيصات  محفوظة بعد';
  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get college => 'الكلية';

  @override
  String get major => 'التخصص';

  @override
  String get loginButton => 'دخول';

  @override
  String get registerButton => 'ابدأ رحلتك';

  @override
  String get noAccountYet => 'ليس لديك حساب؟ سجّل الآن';

  @override
  String get haveAccountAlready => 'لديك حساب بالفعل؟ سجّل الدخول';

  @override
  String get pleaseeFillAllFields => 'يرجى ملء جميع البيانات';
}
