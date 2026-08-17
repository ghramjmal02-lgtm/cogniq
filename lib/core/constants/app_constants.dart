class AppConstants {
  // ═══════════════════════════
  //      إعدادات البومودورو
  // ═══════════════════════════
  static const int pomodoroMinutes = 25;
  static const int breakMinutes = 5;

  // ═══════════════════════════
  //       هدف الماء اليومي
  // ═══════════════════════════
  static const int waterGoalCups = 8; // 8 كوبات
  static const int cupSizeMl = 250; // حجم الكوب
  static const int waterGoalLiters = 2; // 2 لتر
  static const int waterGoalMl = 2000; // 2000 مل

  // ═══════════════════════════
  //     المكتبات المفتوحة
  // ═══════════════════════════
  static const List<Map<String, String>> openLibraries = [
    {
      'name': 'Library Genesis',
      'description': 'ملايين الكتب لكل التخصصات مجاناً',
      'url': 'https://libgen.is',
      'icon': '📚',
    },
    {
      'name': 'OpenStax',
      'description': 'كتب جامعية مجانية ومراجعة أكاديمياً',
      'url': 'https://openstax.org',
      'icon': '🎓',
    },
    {
      'name': 'MIT OpenCourseWare',
      'description': 'مواد دراسية من جامعة MIT مجاناً',
      'url': 'https://ocw.mit.edu',
      'icon': '🏛️',
    },
    {
      'name': 'Internet Archive',
      'description': 'ملايين الكتب والمقالات المجانية',
      'url': 'https://archive.org',
      'icon': '🌐',
    },
    {
      'name': 'Google Scholar',
      'description': 'أبحاث ومقالات علمية لكل التخصصات',
      'url': 'https://scholar.google.com',
      'icon': '🔬',
    },
    {
      'name': 'Khan Academy',
      'description': 'دروس مجانية لكل المراحل والتخصصات',
      'url': 'https://www.khanacademy.org',
      'icon': '✏️',
    },
  ];

  // ═══════════════════════════
  //     جمل التحفيز العشوائية
  // ═══════════════════════════
  static const List<String> motivationalQuotes = [
    "🧠 عقلك أقوى سلاح عندك — استخدمه!",
    "⏱️ 25 دقيقة تركيز دلوقتي = راحة بال بكره",
    "📚 كل صفحة بتقراها بتقربك من هدفك",
    "💡 النجاح مش موهبة — هو عادة يومية",
    "🔥 ابدأ حتى لو مش حاسس بالمود",
    "🎯 مش لازم تكون مثالي — بس لازم تكون مستمر",
    "⭐ الامتحان مش بيجي فجأة — إنت اللي جاهز فجأة",
    "💪 كل ما ذاكرت وإنت تعبان، كل ما قويت",
    "🌙 النوم الكافي جزء من المذاكرة",
    "📖 الفهم أهم من الحفظ — اسأل لحد ما تفهم",
  ];
}
