# مرجع ملفات ومجلدات مشروع Weather & Notes

> هذا الملف يشرح **كل ملف فعلي** في المشروع الحالي. المسارات وأرقام الأسطر مأخوذة من النسخة المقروءة أثناء إعداد الدليل.
>
> **ملاحظة:** المشروع الحالي يختلف عن أي وصف قديم في `C:\flutter_app\project_dump.txt`؛ الاعتماد هنا على `C:\flutter_app\weather_notes\lib` كما هو الآن.

---

## 1. شجرة المشروع الحقيقية

```text
weather_notes/
├── android/                    مشروع Android الأصلي (Gradle)
├── ios/                        مشروع iOS الأصلي
├── linux/                      مشروع Linux
├── macos/                      مشروع macOS
├── web/                        مشروع الويب
├── windows/                    مشروع Windows
├── test/
│   └── widget_test.dart        اختبار placeholder
├── lib/
│   ├── main.dart               نقطة الدخول
│   ├── theme.dart              الثيم
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   ├── controllers/
│   │   ├── notes_controller.dart
│   │   └── weather_controller.dart
│   ├── models/
│   │   ├── location.dart
│   │   ├── note.dart
│   │   └── weather.dart
│   ├── screen/
│   │   ├── home_screen.dart
│   │   ├── note_form_screen.dart
│   │   ├── notes_screen.dart
│   │   ├── weather_screen.dart
│   │   └── weather_search_screen.dart
│   ├── services/
│   │   ├── database_service.dart
│   │   └── weather_service.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── error_widget.dart
│       ├── fade_slide_in.dart
│       ├── floating_nav_bar.dart
│       ├── glass_background.dart
│       ├── glass_card.dart
│       ├── loading_widget.dart
│       └── skeleton_widgets.dart
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
├── README.md
└── weather_notes.iml
```

**عدد ملفات Dart داخل `lib`:** 24 ملفًا.

---

## 2. ترتيب القراءة المقترح

1. `main.dart`
2. `constants/app_colors.dart`, `constants/app_strings.dart`
3. `models/*`
4. `services/*`
5. `controllers/*`
6. `screen/*`
7. `widgets/*`
8. `theme.dart`
9. `pubspec.yaml`

---

## 3. الملفات الأساسية

### 3.1 `lib/main.dart`

| البند | التفاصيل |
|---|---|
| **المسار الكامل** | `C:\flutter_app\weather_notes\lib\main.dart` |
| **عدد الأسطر** | 36 |
| **الوظيفة** | نقطة بداية التطبيق، تهيئة التاريخ العربي، وتشغيل `GetMaterialApp`. |
| **لماذا أُنشئ؟** | كل تطبيق Flutter يحتاج `main()` و`runApp`. |
| **الكلاسات** | `MyApp extends StatelessWidget` |
| **الدوال** | `main()`، `MyApp.build()` |
| **المتغيرات** | لا توجد حقول حالة؛ يستخدم `const` في البناء. |
| **الاستيرادات** | `flutter/material.dart`, `flutter_localizations`, `get`, `intl/date_symbol_data_local`, `theme.dart`, `screen/home_screen.dart` |
| **يعتمد على** | `theme.dart`, `home_screen.dart` |
| **يستدعيه** | Flutter runtime عند تشغيل التطبيق |
| **يرتبط بـ** | الجذر لكل الشجرة |

**مقتطف:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  runApp(const MyApp());
}
```

**ماذا يحدث عند التشغيل؟**

- يهيئ Flutter.
- يحمّل بيانات `ar` للتواريخ.
- يبني `MyApp`.
- `GetMaterialApp` يفتح `HomeScreen`.

**ملاحظة:** `initState` الخاصة بـ`HomeScreen` هي التي تسجل المتحكمين، وليس `main`.

---

### 3.2 `lib/theme.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/theme.dart` |
| **عدد الأسطر** | 87 |
| **الوظيفة** | تعريف `ThemeData` الموحد (ألوان، نصوص، أزرار، حقول إدخال). |
| **الكلاسات** | `AppTheme` |
| **الدوال/الخصائص** | `static ThemeData get lightTheme` |
| **المتغيرات** | `base` داخل getter |
| **الاستيرادات** | `flutter/material.dart`, `constants/app_colors.dart` |
| **يستدعيه** | `main.dart:22` |
| **مثال** | `AppTheme.lightTheme` يضبط خلفية `Scaffold`، ألوان `AppBar`، وحقول الإدخال. |

**مقتطف:**

```dart
static ThemeData get lightTheme {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.gradientTop,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primary,
      ...
    ),
  );
}
```

**شرح:** ينشئ ثيمًا فاتحًا، ثم ينسخه ويعدل بعض الخصائص. `copyWith` لا يعدل الأصل، بل يعيد نسخة جديدة.

---

### 3.3 `lib/constants/app_colors.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/constants/app_colors.dart` |
| **عدد الأسطر** | 109 |
| **الوظيفة** | تجميع ألوان التطبيق، تدرجات الزجاج، الظلال، وخلفية الـBlobs. |
| **الكلاسات** | `AppColors` |
| **المتغيرات المهمة** | `primary`, `primaryDark`, `glassTop`, `glassBottom`, `glassShadows`, `primaryGlassGradient`, `appBackgroundGradient`, `shimmerBase` |
| **الاستيرادات** | `flutter/material.dart` |
| **يستدعيه** | `theme.dart`، كل الشاشات، `glass_card.dart`, `floating_nav_bar.dart`, `skeleton_widgets.dart` |
| **مثال** | `GlassCard` يقرأ `AppColors.glassTop` و`glassBottom`. |

**ملاحظة:** بعض القيم مثل `glassWhite` و`glassMedium` هي أسماء بديلة (alias) لقيم `glassTop` و`glassBottom`، وليست ألوانًا مستقلة.

---

### 3.4 `lib/constants/app_strings.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/constants/app_strings.dart` |
| **عدد الأسطر** | 53 |
| **الوظيفة** | تجميع النصوص العربية/الإنجليزية في مكان واحد. |
| **الكلاسات** | `AppStrings` |
| **المتغيرات المهمة** | `appName`, `welcome`, `notesTitle`, `addNote`, `saveSuccess`, `searchHint` |
| **الاستيرادات** | لا يوجد |
| **يستدعيه** | الشاشات والـWidgets |
| **مثال** | `AppStrings.retry` في زر إعادة المحاولة. |

**فائدة:** تغيير نص في مكان واحد ينعكس على كل التطبيق، ويقلل الأخطاء المطبعية.

---

## 4. النماذج (Models)

### 4.1 `lib/models/weather.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/models/weather.dart` |
| **عدد الأسطر** | 105 |
| **الوظيفة** | تمثيل الطقس الحالي والتوقعات، وتحويل JSON إلى كائنات. |
| **الكلاسات** | `Weather`, `DailyForecast` |
| **الدوال** | `Weather.fromJson`, `DailyForecast(...)`, `weatherDescription`, `weatherIcon` |
| **الخصائص المحسوبة** | `Weather.description`, `Weather.icon`, `DailyForecast.description`, `DailyForecast.icon` |
| **الاستيرادات** | لا يوجد |
| **يستدعيه** | `weather_service.dart`, `weather_controller.dart`, `weather_screen.dart`, `home_screen.dart` |
| **مثال** | `Weather.fromJson(jsonDecode(response.body), cityName)` |

**الكلاس `Weather`:** يحمل `cityName`, `temperature`, `feelsLike`, `humidity`, `windSpeed`, `weatherCode`, `tempMax`, `tempMin`, `lastUpdated`, `forecast`.

**الكلاس `DailyForecast`:** يحمل `date`, `tempMax`, `tempMin`, `weatherCode`.

**أهم دالة:**

```dart
factory Weather.fromJson(Map<String, dynamic> json, String cityName) { ... }
```

**ماذا تفعل؟** تقرأ `current` و`daily`، تبني قائمة توقعات، وتعيد `Weather` كاملًا.

**دالة مساعدة:**

```dart
String weatherDescription(int code) { ... }
```

تحوّل كود Open-Meteo إلى وصف عربي. أمثلة: `0` → «سماء صافية»، `61-67` → «مطر»، `95-99` → «عاصفة رعدية».

---

### 4.2 `lib/models/location.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/models/location.dart` |
| **عدد الأسطر** | 56 |
| **الوظيفة** | تمثيل نتيجة بحث المدينة (اسم، دولة، إحداثيات). |
| **الكلاسات** | `Location` |
| **الدوال** | `Location.fromJson` |
| **الخصائص المحسوبة** | `region`, `subtitle`, `flag` |
| **الاستيرادات** | لا يوجد |
| **يستدعيه** | `weather_service.dart`, `weather_controller.dart`, `weather_search_screen.dart` |
| **مثال** | كل عنصر في `searchResults` هو `Location`. |

**الحقول:** `id`, `name`, `admin1?`, `admin2?`, `country?`, `countryCode?`, `latitude`, `longitude`.

**`flag`:** يبني إيموجي علم الدولة من `countryCode` عبر تحويل الحروف إلى رموز يونيكود إقليمية.

---

### 4.3 `lib/models/note.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/models/note.dart` |
| **عدد الأسطر** | 47 |
| **الوظيفة** | تمثيل ملاحظة، وتحويلها إلى/من `Map` الخاص بـSQLite. |
| **الكلاسات** | `Note` |
| **الدوال** | `Note(...)`, `toMap`, `Note.fromMap`, `copyWith` |
| **الاستيرادات** | لا يوجد |
| **يستدعيه** | `database_service.dart`, `notes_controller.dart`, `notes_screen.dart`, `note_form_screen.dart` |
| **مثال** | `Note.fromMap(m)` لتحويل صف SQLite. |

**لا يوجد `fromJson` ولا `toJson`** لأن الملاحظات لا تُرسل إلى API.

**`copyWith`:** تستخدم في التعديل للحفاظ على `id` و`createdAt` وتغيير `updatedAt`.

---

## 5. الخدمات (Services)

### 5.1 `lib/services/weather_service.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/services/weather_service.dart` |
| **عدد الأسطر** | 92 |
| **الوظيفة** | التعامل مع HTTP وOpen-Meteo وتحويل JSON إلى Models. |
| **الكلاسات** | `WeatherService` |
| **الدوال** | `WeatherService(...)`, `searchLocations`, `fetchWeatherForCoords`, `fetchWeatherForCity` |
| **المتغيرات** | `_client`, `_geoUrl`, `_weatherUrl` |
| **الاستيرادات** | `dart:async`, `dart:convert`, `dart:io`, `http`, `models/weather.dart`, `models/location.dart` |
| **يستدعيه** | `WeatherController` فقط |
| **مثال** | `await _service.fetchWeatherForCity('صنعاء')` |

**الدوال:**

1. `searchLocations(String query)`:
   - يتحقق من طول النص.
   - يبني رابط Geocoding.
   - يرسل GET مع مهلة 15 ثانية.
   - يتحقق من `200`.
   - يحوّل `results` إلى `List<Location>`.
   - يعالج `SocketException`, `TimeoutException`, `FormatException`.

2. `fetchWeatherForCoords(lat, lon, cityName)`:
   - يبني رابط Forecast.
   - يطلب الحقول الحالية واليومية.
   - يعيد `Weather.fromJson`.

3. `fetchWeatherForCity(cityName)`:
   - يبحث عن المدينة.
   - إذا لم يجد نتائج، يرمي استثناءً.
   - يأخذ أول نتيجة.
   - يجلب الطقس بإحداثياتها.

**سبب الفصل:** الواجهة لا تتعامل مع HTTP؛ الخدمة تخفي التفاصيل.

---

### 5.2 `lib/services/database_service.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/services/database_service.dart` |
| **عدد الأسطر** | 58 |
| **الوظيفة** | فتح SQLite وإنشاء جدول `notes` وتنفيذ CRUD. |
| **الكلاسات** | `DatabaseService` |
| **الدوال/الخصائص** | `database` getter, `_initDatabase`, `insertNote`, `fetchNotes`, `updateNote`, `deleteNote` |
| **المتغيرات** | `_database`, `_dbName`, `_dbVersion`, `_tableName` |
| **الاستيرادات** | `sqflite`, `path`, `models/note.dart` |
| **يستدعيه** | `NotesController` فقط |
| **مثال** | `await _service.fetchNotes()` |

**ملاحظة:** `_database` من نوع `static Database?`، أي اتصال واحد مشترك.

**لا يوجد `onUpgrade`:** الإصدار 1 فقط.

**CRUD:**

| العملية | الدالة | SQL |
|---|---|---|
| Create | `insertNote` | `INSERT INTO notes ...` |
| Read | `fetchNotes` | `SELECT * FROM notes ORDER BY updated_at DESC` |
| Update | `updateNote` | `UPDATE notes ... WHERE id = ?` |
| Delete | `deleteNote` | `DELETE FROM notes WHERE id = ?` |

---

## 6. المتحكمات (Controllers)

### 6.1 `lib/controllers/weather_controller.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/controllers/weather_controller.dart` |
| **عدد الأسطر** | 131 |
| **الوظيفة** | إدارة حالة الطقس والبحث، واستدعاء `WeatherService`. |
| **الكلاسات** | `WeatherController extends GetxController` |
| **الدوال** | `onInit`, `onClose`, `loadWeather`, `selectLocation`, `refreshWeather`, `onSearchChanged`, `_cancelAndClear`, `_performSearch`, `clearSearch`, `retrySearch` |
| **المتغيرات التفاعلية** | `weather`, `currentCity`, `isLoading`, `errorMessage`, `searchResults`, `isSearching`, `searchError`, `searchQuery` |
| **متغيرات عادية** | `_service`, `_debounce`, `_searchRequestId` |
| **الاستيرادات** | `dart:async`, `get`, `models/weather.dart`, `models/location.dart`, `services/weather_service.dart` |
| **يستدعيه** | `HomeScreen` (Get.put), `WeatherScreen`, `WeatherSearchScreen`, `_HomeTab` |
| **مثال** | `weather.value` تقرأها بطاقة الطقس. |

**دورة الحياة:**

- `onInit` → `loadWeather('صنعاء')`.
- `onClose` → إلغاء الـDebounce.

**البحث:**

- `onSearchChanged` يتحقق من الطول ويؤجل الطلب 400ms.
- `_performSearch` يمنع النتائج القديمة عبر `_searchRequestId`.
- `retrySearch` يعيد المحاولة.

**لماذا `_service` خاص؟** لأن الواجهة يجب ألا تعرف تفاصيل HTTP.

---

### 6.2 `lib/controllers/notes_controller.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/controllers/notes_controller.dart` |
| **عدد الأسطر** | 66 |
| **الوظيفة** | إدارة قائمة الملاحظات والبحث والعمليات CRUD. |
| **الكلاسات** | `NotesController extends GetxController` |
| **الدوال** | `filteredNotes` getter, `onInit`, `loadNotes`, `addNote`, `updateNote`, `deleteNote`, `setSearchQuery` |
| **المتغيرات** | `_service`, `notes`, `isLoading`, `searchQuery` |
| **الاستيرادات** | `get`, `models/note.dart`, `services/database_service.dart` |
| **يستدعيه** | `HomeScreen`, `NotesScreen`, `NoteFormScreen` |
| **مثال** | `notes.length` في بطاقة عدد الملاحظات. |

**`filteredNotes`:** إذا كان البحث فارغًا تعيد كل الملاحظات؛ وإلا تفلتر حسب `title` أو `content` دون حساسية لحالة الأحرف.

**`loadNotes`:** تقرأ من SQLite وتستبدل القائمة بـ`assignAll`.

**`addNote` / `updateNote` / `deleteNote`:** تنفذ العملية ثم تعيد `loadNotes` لضمان التزامن مع القاعدة.

---

## 7. الشاشات (Screens)

### 7.1 `lib/screen/home_screen.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/screen/home_screen.dart` |
| **عدد الأسطر** | 291 |
| **الوظيفة** | الشاشة الرئيسية: تسجيل المتحكمين، 3 تبويبات، بطاقة طقس مختصرة، بطاقة عدد الملاحظات. |
| **الكلاسات** | `HomeScreen`, `_HomeScreenState`, `_HomeTab`, `_HomeTabState` |
| **الدوال** | `initState`, `dispose`, `_onTabTap`, `build`, `_handleRefresh`, `_buildWeatherCard`, `_buildNotesCard` |
| **المتغيرات** | `_currentIndex`, `_pageController`, `_weatherController`, `_notesController` |
| **الاستيرادات** | `material`, `get`, controllers, constants, widgets, `weather_screen.dart`, `notes_screen.dart` |
| **يستدعيه** | `main.dart:23` |
| **مثال** | `Get.put(WeatherController(), permanent: true)` |

**`HomeScreen`:** StatefulWidget يحتوي `Scaffold` و`GlassBackground` و`PageView` و`FloatingNavBar`.

**`_HomeTab`:** StatefulWidget مع `AutomaticKeepAliveClientMixin`؛ يحافظ على حالة التمرير ولا يعيد البناء عند تبديل التبويب.

**`_handleRefresh`:** ينتظر تحديث الطقس والملاحظات معًا (سحب للتحديث في الرئيسية).

**`_buildWeatherCard`:** `Obx` يعرض:
- Skeleton إذا لا توجد بيانات ولا خطأ.
- `AppErrorWidget` إذا وُجد خطأ.
- بطاقة زرقاء إذا وُجد طقس.

**`_buildNotesCard`:** `Obx` يعرض عدد الملاحظات.

---

### 7.2 `lib/screen/weather_screen.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/screen/weather_screen.dart` |
| **عدد الأسطر** | 412 |
| **الوظيفة** | عرض الطقس الكامل: البطاقة الرئيسية، الرطوبة/الرياح/المحسوسة، توقعات 5 أيام، التحديث والخطأ. |
| **الكلاسات** | `WeatherScreen`, `_WeatherScreenState`, `_ScrollableError`, `_WeatherContent`, `_ErrorBanner`, `_MainWeatherCard`, `_InfoGrid`, `_ForecastCard` |
| **الدوال** | `initState`, `_refresh`, `_openSearch`, `build`, `_infoTile`, `_forecastRow` |
| **المتغيرات** | `controller`, `weather`, `onRefresh`, `errorMessage`, `isRefreshing` |
| **الاستيرادات** | `material`, `get`, `intl`, controller, constants, widgets, `models/weather.dart`, `weather_search_screen.dart` |
| **يستدعيه** | `PageView` في `home_screen.dart:65` |
| **مثال** | `Get.to(() => const WeatherSearchScreen())` |

**`initState`:** إذا لم تكن هناك بيانات طقس، يطلبها.

**`build`:** `Obx` يقرأ `weather` و`errorMessage` و`isLoading`.

**`_MainWeatherCard`:** بطاقة زجاجية زرقاء كبيرة.

**`_InfoGrid`:** `LayoutBuilder` + `Wrap`؛ يتحول إلى عمودين عند العرض الضيق أو تكبير الخط.

**`_ForecastCard`:** يعرض `forecast.take(5)`.

---

### 7.3 `lib/screen/weather_search_screen.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/screen/weather_search_screen.dart` |
| **عدد الأسطر** | 233 |
| **الوظيفة** | البحث الفوري عن مدينة وعرض الاقتراحات. |
| **الكلاسات** | `WeatherSearchScreen`, `_WeatherSearchScreenState`, `_SuggestionTile` |
| **الدوال** | `initState`, `dispose`, `_selectLocation`, `build`, `_buildResults`, `_centeredScrollable` |
| **المتغيرات** | `controller`, `_textController` |
| **الاستيرادات** | `material`, `get`, controller, constants, widgets, `models/location.dart` |
| **يستدعيه** | `Get.to` من `WeatherScreen` |
| **مثال** | كتابة «Sana» ثم اختيار صنعاء |

**`initState`:** `clearSearch()` لبدء صفحة نظيفة.

**`_selectLocation`:** `Get.back()` ثم `selectLocation(loc)`.

**`_buildResults`:** حالات: تحميل، خطأ، نص فارغ، لا نتائج، قائمة.

**`_SuggestionTile`:** بطاقة زجاجية قابلة للنقر تعرض العلم والاسم والمنطقة.

---

### 7.4 `lib/screen/notes_screen.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/screen/notes_screen.dart` |
| **عدد الأسطر** | 283 |
| **الوظيفة** | عرض الملاحظات، البحث فيها، إضافة/تعديل/حذف. |
| **الكلاسات** | `NotesScreen`, `_NotesScreenState`, `_EmptyState`, `_NoteCard` |
| **الدوال** | `build`, `_openForm`, `_confirmDelete` |
| **المتغيرات** | `controller` |
| **الاستيرادات** | `material`, `get`, `intl`, controller, constants, widgets, `models/note.dart`, `note_form_screen.dart` |
| **يستدعيه** | `PageView` في `home_screen.dart:66` |
| **مثال** | `Get.to<bool>(NoteFormScreen(...))` |

**`build`:** حقل بحث + `Obx` + `ListView.builder` + `FloatingActionButton`.

**`_openForm`:** يفتح النموذج، وإن عاد `true` يعرض Snackbar.

**`_confirmDelete`:** حوار تأكيد، ثم `deleteNote`.

**`_NoteCard`:** بطاقة زجاجية فيها العنوان والسطور الثلاثة الأولى والتاريخ وزرّا التعديل/الحذف.

**`_EmptyState`:** تفرق بين «لا ملاحظات» و«لا نتائج بحث».

---

### 7.5 `lib/screen/note_form_screen.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/screen/note_form_screen.dart` |
| **عدد الأسطر** | 139 |
| **الوظيفة** | نموذج إضافة/تعديل ملاحظة مع تحقق وحفظ. |
| **الكلاسات** | `NoteFormScreen`, `_NoteFormScreenState` |
| **الدوال** | `initState`, `dispose`, `_save`, `build` |
| **المتغيرات** | `_formKey`, `_titleController`, `_contentController`, `_notesController`, `_isSaving` |
| **الاستيرادات** | `material`, `get`, controller, constants, widgets, `models/note.dart` |
| **يستدعيه** | `Get.to` من `NotesScreen` |
| **مثال** | `note = null` للإضافة، `note != null` للتعديل |

**`initState`:** يعبئ الحقول إن كان تعديلًا.

**`_save`:**

- يتحقق من `Form`.
- `setState(_isSaving = true)`.
- إذا تعديل → `updateNote`، وإلا → `addNote`.
- `Get.back<bool>(result: true)`.
- عند الخطأ → Snackbar.
- `finally` يعيد `_isSaving = false`.

**`build`:** `Form` داخل `GlassCard`، حقلا عنوان/محتوى، زر حفظ، زر إلغاء.

---

## 8. الـWidgets المشتركة

### 8.1 `lib/widgets/glass_card.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/widgets/glass_card.dart` |
| **عدد الأسطر** | 217 |
| **الوظيفة** | البطاقة الزجاجية الموحدة (Frosted Glass) مع Blur وحدود وانعكاس وظل. |
| **الكلاسات** | `GlassCard extends StatelessWidget` |
| **المعاملات** | `child`, `padding`, `borderRadius`, `blurSigma`, `tint`, `gradient`, `borderColor`, `topBorderColor`, `borderWidth`, `shadows`, `withBlur`, `showHighlight`, `highlightColor`, `glowColor` |
| **الاستيرادات** | `dart:ui`, `material`, `constants/app_colors.dart` |
| **يستدعيه** | `home_screen`, `weather_screen`, `notes_screen`, `note_form_screen`, `weather_search_screen` |
| **مثال** | `GlassCard(blurSigma: 24, child: ...)` |

**ترتيب الطبقات:**

```text
DecoratedBox (الظل الخارجي)
└── ClipRRect
    └── BackdropFilter (Blur)
        └── Stack
            ├── تعبئة زجاجية + حدود
            ├── تظليل سفلي
            ├── انعكاس علوي + لمعة قطرية
            ├── حافة داخلية
            └── Padding + child
```

**ملاحظة:** الظل خارج `ClipRRect` كي لا يُقص. الـBlur داخل القص كي لا يتسرب خارج الزوايا.

---

### 8.2 `lib/widgets/glass_background.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/widgets/glass_background.dart` |
| **عدد الأسطر** | 77 |
| **الوظيفة** | خلفية متدرجة مع دوائر ضبابية (Blobs) تظهر خلف الزجاج. |
| **الكلاسات** | `GlassBackground`, `_Blob` |
| **الاستيرادات** | `material`, `constants/app_colors.dart` |
| **يستدعيه** | `home_screen`, `note_form_screen`, `weather_search_screen` |
| **مثال** | `GlassBackground(child: Scaffold(...))` |

**التركيب:** `Stack` فيه `DecoratedBox` للتدرج، ثم `Positioned` لعدة `_Blob`، ثم `child`.

**`_Blob`:** دائرة بتدرج شعاعي يبدأ بلون بشفافية 0.70 وينتهي شفافًا.

---

### 8.3 `lib/widgets/floating_nav_bar.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/widgets/floating_nav_bar.dart` |
| **عدد الأسطر** | 142 |
| **الوظيفة** | شريط تنقل عائم زجاجي بثلاثة أيقونات. |
| **الكلاسات** | `FloatingNavBar`, `_NavIcon` |
| **المعاملات** | `currentIndex`, `onTap`, `icons`, `activeIcons` |
| **الاستيرادات** | `dart:ui`, `material`, `constants/app_colors.dart` |
| **يستدعيه** | `home_screen.dart:70` |
| **مثال** | `FloatingNavBar(currentIndex: _currentIndex, onTap: _onTabTap, ...)` |

**التركيب:** `SafeArea` → `Padding` → ظل خارجي → `ClipRRect` → `BackdropFilter` → `Container` (تدرج + حدود) → `Row` من `_NavIcon`.

**`_NavIcon`:** `Semantics` + `GestureDetector` + `AnimatedContainer` + `AnimatedSwitcher`.

**ملاحظة:** الأيقونة النشطة تأخذ خلفية زرقاء متدرجة، وغير النشطة شفافة.

---

### 8.4 `lib/widgets/app_button.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/widgets/app_button.dart` |
| **عدد الأسطر** | 45 |
| **الوظيفة** | زر أساسي بعرض كامل يدعم أيقونة وحالة تحميل. |
| **الكلاسات** | `AppButton extends StatelessWidget` |
| **المعاملات** | `text`, `onPressed`, `icon`, `isLoading` |
| **الاستيرادات** | `material` |
| **يستدعيه** | `note_form_screen.dart:116` |
| **مثال** | زر الحفظ يعرض `CircularProgressIndicator` أثناء الحفظ. |

**مهم:** عندما `isLoading` تكون `true`، يصبح `onPressed` مساويًا `null`، أي تعطيل الزر لمنع الحفظ المزدوج.

---

### 8.5 `lib/widgets/error_widget.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/widgets/error_widget.dart` |
| **عدد الأسطر** | 38 |
| **الوظيفة** | عرض رسالة خطأ مع زر إعادة محاولة اختياري. |
| **الكلاسات** | `AppErrorWidget` |
| **المعاملات** | `message`, `onRetry?` |
| **الاستيرادات** | `material`, `app_colors.dart`, `app_strings.dart` |
| **يستدعيه** | `home_screen.dart:163`, `weather_screen.dart:96` |
| **مثال** | خطأ الشبكة مع زر «إعادة المحاولة». |

---

### 8.6 `lib/widgets/loading_widget.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/widgets/loading_widget.dart` |
| **عدد الأسطر** | 26 |
| **الوظيفة** | مؤشر تحميل دائري مع رسالة اختيارية. |
| **الكلاسات** | `LoadingWidget` |
| **المعاملات** | `message?` |
| **الاستيرادات** | `material`, `app_colors.dart` |
| **يستدعيه** | `weather_search_screen.dart:96` و`138` |
| **مثال** | `LoadingWidget(message: AppStrings.searching)` |

---

### 8.7 `lib/widgets/skeleton_widgets.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/widgets/skeleton_widgets.dart` |
| **عدد الأسطر** | 108 |
| **الوظيفة** | هياكل تحميل وهمية بتأثير Shimmer. |
| **الكلاسات** | `SkeletonBox`, `WeatherSkeleton`, `NotesSkeleton`, `HomeSkeleton` |
| **الاستيرادات** | `material`, `shimmer`, `app_colors.dart` |
| **يستدعيه** | `home_screen.dart:169`, `weather_screen.dart:77`, `notes_screen.dart:65` |
| **مثال** | `NotesSkeleton` يعرض 4 بطاقات رمادية أثناء القراءة. |

**`SkeletonBox`:** `Shimmer.fromColors` حول `Container` أبيض.

**فائدة:** تحسين الإحساس بالسرعة بدل شاشة فارغة.

---

### 8.8 `lib/widgets/fade_slide_in.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `lib/widgets/fade_slide_in.dart` |
| **عدد الأسطر** | 56 |
| **الوظيفة** | حركة دخول (Fade + Slide) تُنفذ مرة واحدة. |
| **الكلاسات** | `FadeSlideIn`, `_FadeSlideInState` |
| **المعاملات** | `child`, `delay`, `duration` |
| **الاستيرادات** | `material` |
| **يستدعيه** | `home_screen`, `weather_screen`, `notes_screen` |
| **مثال** | `FadeSlideIn(delay: 80ms, child: card)` |

**كيف تعمل؟**

- `AnimationController` يدير الحركة.
- `CurvedAnimation` ينعّم المنحنى.
- `Tween<Offset>` يحرك من `(0, 0.08)` إلى `(0, 0)`.
- `Future.delayed` يؤخر البدء إن وُجدت قيمة.
- `mounted` يمنع البدء بعد التدمير.

---

## 9. ملفات الإعداد والاختبار

### 9.1 `pubspec.yaml`

| البند | التفاصيل |
|---|---|
| **المسار** | `pubspec.yaml` |
| **الوظيفة** | اسم المشروع، إصدار Dart، الحزم، إعدادات Flutter. |
| **اسم المشروع** | `weather_notes` |
| **إصدار Dart** | `^3.13.2` |
| **الحزم الأساسية** | `get`, `http`, `sqflite`, `path`, `intl`, `flutter_localizations`, `shimmer` |
| **الحزم التطويرية** | `flutter_test`, `flutter_lints` |
| **`uses-material-design`** | `true` لتضمين أيقونات Material |

**لا يوجد `assets` مفعّل** (كل الأقسام معلقة).

**لا يوجد `fonts` مفعّل.**

**لا يوجد `path_provider`.**

---

### 9.2 `analysis_options.yaml`

| البند | التفاصيل |
|---|---|
| **الوظيفة** | تفعيل `flutter_lints` واستبعاد مجلدات المنصات من التحليل. |
| **المستبعدات** | `build`, `android`, `ios`, `web`, `windows`, `macos`, `linux` |
| **الفائدة** | `flutter analyze` يركز على كود Dart الخاص بالتطبيق. |

---

### 9.3 `test/widget_test.dart`

| البند | التفاصيل |
|---|---|
| **المسار** | `test/widget_test.dart` |
| **الوظيفة** | اختبار placeholder فقط. |
| **المحتوى** | `test('placeholder test', () { expect(1 + 1, 2); });` |
| **ملاحظة** | لا يختبر التطبيق فعليًا؛ لا يوجد `pumpWidget`. |

---

### 9.4 `README.md`

قالب Flutter الافتراضي. لا يحتوي توثيقًا للمشروع ولا متطلبات.

---

### 9.5 `pubspec.lock`

يقفل إصدارات الحزم الفعلية. لا يُعدّل يدويًا عادة.

---

## 10. مجلدات المنصات (ليست Dart)

| المجلد | وظيفته |
|---|---|
| `android/` | إعداد Gradle وAndroidManifest ونقطة `MainActivity`. |
| `ios/` | إعداد Xcode وInfo.plist. |
| `web/` | `index.html` وmanifest. |
| `windows/` | مشروع C++ لتشغيل Flutter على Windows. |
| `linux/` | مشروع CMake. |
| `macos/` | مشروع Xcode. |
| `build/` | مخرجات البناء (لا تُعدّل). |
| `.dart_tool/` | ملفات مؤقتة لـDart (لا تُعدّل). |

---

## 11. جدول سريع: من يستدعي من؟

| الملف | يُستدعى من |
|---|---|
| `main.dart` | Flutter |
| `home_screen.dart` | `main.dart` |
| `weather_screen.dart` | `home_screen.dart` (PageView) |
| `notes_screen.dart` | `home_screen.dart` (PageView) |
| `weather_search_screen.dart` | `weather_screen.dart` (Get.to) |
| `note_form_screen.dart` | `notes_screen.dart` (Get.to) |
| `weather_controller.dart` | `home_screen`, `weather_screen`, `weather_search_screen` |
| `notes_controller.dart` | `home_screen`, `notes_screen`, `note_form_screen` |
| `weather_service.dart` | `weather_controller.dart` |
| `database_service.dart` | `notes_controller.dart` |
| `glass_card.dart` | كل الشاشات |
| `glass_background.dart` | `home`, `note_form`, `weather_search` |
| `floating_nav_bar.dart` | `home_screen` |
| `app_button.dart` | `note_form_screen` |
| `error_widget.dart` | `home_screen`, `weather_screen` |
| `loading_widget.dart` | `weather_search_screen` |
| `skeleton_widgets.dart` | `home`, `weather`, `notes` |
| `fade_slide_in.dart` | `home`, `weather`, `notes` |

---

### انتهى مرجع الملفات

> ارجع إلى `Weather_Notes_Full_Study_Guide.md` لفهم المفاهيم، و`Teacher_Questions_and_Answers.md` للأسئلة.
