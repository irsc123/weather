# الدليل الدراسي الشامل لمشروع Weather & Notes

> **مرجع أكاديمي لفهم المشروع من الداخل، وربط مفاهيم Dart وFlutter وGetX وHTTP وSQLite بالكود الفعلي.**
>
> إعداد: شرح تحليلي مبني على قراءة الكود الحالي داخل `C:\flutter_app\weather_notes`.
>
> **تنبيه:** هذا الملف للشرح والتوثيق فقط. لم يتم تعديل أي ملف Dart، ولا التصميم، ولا قاعدة البيانات، ولا `pubspec.yaml` أثناء إعداد هذا الدليل.

---

## فهرس المحتويات

1. [كيف تستخدم هذا الدليل](#1-كيف-تستخدم-هذا-الدليل)
2. [تنبيه مهم: ما وُجد فعلًا من المنهج ومتطلبات الأستاذة](#2-تنبيه-مهم-ما-وُجد-فعلًا-من-المنهج-ومتطلبات-الأستاذة)
3. [نبذة عن المشروع ووظائفه](#3-نبذة-عن-المشروع-ووظائفه)
4. [المعمارية العامة ومسار البيانات](#4-المعمارية-العامة-ومسار-البيانات)
5. [مفاهيم Dart الأساسية](#5-مفاهيم-dart-الأساسية)
6. [مفاهيم Flutter والواجهات](#6-مفاهيم-flutter-والواجهات)
7. [GetX: إدارة الحالة والتنقل](#7-getx-إدارة-الحالة-والتنقل)
8. [الإنترنت وAPI وJSON](#8-الإنترنت-وapi-وjson)
9. [Future وasync/await وFutureBuilder](#9-future-وasyncawait-وfuturebuilder)
10. [SQLite وsqflite وعمليات CRUD](#10-sqlite-وsqflite-وعمليات-crud)
11. [Models وتحويل البيانات](#11-models-وتحويل-البيانات)
12. [الحزم والمكتبات المستخدمة](#12-الحزم-والمكتبات-المستخدمة)
13. [مسارات التنفيذ الكاملة الثمانية](#13-مسارات-التنفيذ-الكاملة-الثمانية)
14. [جدول متطلبات المنهج مقابل المشروع](#14-جدول-متطلبات-المنهج-مقابل-المشروع)
15. [ملخص سريع للمناقشة](#15-ملخص-سريع-للمناقشة)

---

## 1. كيف تستخدم هذا الدليل

هذا الدليل مقسّم إلى ثلاثة ملفات:

| الملف | ماذا يحتوي؟ | متى تفتحه؟ |
|---|---|---|
| `Weather_Notes_Full_Study_Guide.md` | شرح المفاهيم، الكود سطرًا بسطر، مسارات التنفيذ، جدول المتطلبات | للمراجعة الدراسية وفهم الفكرة |
| `Project_Files_Reference.md` | شجرة المشروع وشرح كل ملف على حدة | عندما تريد فتح ملف معيّن ومعرفة وظيفته |
| `Teacher_Questions_and_Answers.md` | 10 أقسام من أسئلة المناقشة وإجاباتها | قبل المناقشة أو العرض |

**طريقة الدراسة المقترحة:**

1. اقرأ القسم 3 و4 لفهم الصورة الكبيرة.
2. ادرس كل مفهوم في القسم 5 ثم افتح الملف المذكور بجانبه.
3. راجع مسارات التنفيذ في القسم 13؛ لأنها تربط كل الملفات معًا.
4. اختبر نفسك بأسئلة الملف الثالث.

---

## 2. تنبيه مهم: ما وُجد فعلًا من المنهج ومتطلبات الأستاذة

### 2.1 نتيجة البحث داخل المشروع

تم البحث داخل مشروع `weather_notes` عن:

- مجلد `course_materials`
- مجلد `docs`
- ملفات PDF
- ملفات Word
- ملفات PowerPoint
- أي ملف تعليمات أو متطلبات

**النتيجة:** لا يوجد داخل المشروع أي من هذه العناصر. الموجود فقط:

| الملف/المجلد | الحالة |
|---|---|
| `README.md` | قالب Flutter الافتراضي، لا يحتوي متطلبات |
| `pubspec.yaml` | تعريف المشروع والحزم فقط |
| `test/widget_test.dart` | اختبار placeholder بسيط `expect(1 + 1, 2)` |
| باقي المجلدات | مشروع Flutter عادي (android/ios/web/windows...) |

### 2.2 ما وُجد خارج المشروع

تم العثور داخل `C:\flutter_app` على مواد مساعدة، لكنها **ليست نصًا مكتوبًا من الأستاذة**:

| المادة | نوعها | ماذا تحتوي؟ |
|---|---|---|
| `curriculum_dump.txt` | تفريغ نصي لحالة مشروع `ex_getx` | أمثلة GetX: `GetxController`, `RxInt`, `Get.put`, `Obx`, `GetMaterialApp` |
| `curriculum2_dump.txt` | تفريغ نصي لمشروع `api_ex` | HTTP و`FutureBuilder` و`Post.fromJson` و`toJson` |
| `curriculum3_dump.txt` | تفريغ نصي لمشروع `my_expenses` | sqflite وCRUD وTransactions وBatches |
| `curriculum4_dump.txt` | تفريغ نصي لمشروع `sql_app` | مشروع Flutter الافتراضي مع `setState` |
| `curriculum5_dump.txt` | تفريغ نصي لمشروع `statesmang` | `ChangeNotifier` وProvider و`Consumer` |
| `API.docx` | مستند Word | **غير متعلق بالمشروع**: محتوى عن RouterOS User Manager |
| `ex_getx`, `api_ex`, `my_expenses`, `statesmang`, `sql_app` | تطبيقات أمثلة كاملة | الكود المصدري للأمثلة |

### 2.3 الاستنتاج المنهجي الصحيح

لا يمكن القول: «الأستاذة طلبت كذا» اعتمادًا على هذه المواد فقط؛ لأن:

- لا توجد ورقة متطلبات مكتوبة.
- لا توجد محاضرات أو سلايدات.
- ملفات `curriculum*_dump.txt` هي مجرد **تفريغ لمحتويات مشاريع أمثلة**، وليست مناهج دراسية.
- `API.docx` غير مرتبط أصلًا.

لذلك سيقول هذا الدليل بصراحة:

> **«المفهوم موجود في الأمثلة التعليمية المتاحة»** بدلًا من **«الأستاذة طلبت هذا المفهوم»**، إلا إذا كان المفهوم مستخدمًا فعليًا في المشروع.

هذا هو التمييز الذي طلبته المهمة: عدم نسبة شيء إلى المنهج دون دليل.

### 2.4 ما الذي يعنيه ذلك عمليًا؟

- إذا سُئلت: «هل درستم FutureBuilder؟» تكون الإجابة: **نعم، ظهر في مثال `api_ex`، لكن المشروع الحالي لا يستخدم FutureBuilder، بل يستخدم Future مع async/await وObx.**
- إذا سُئلت: «هل درستم Provider؟» تكون الإجابة: **نعم، ظهر في مثال `statesmang`، لكن المشروع يستخدم GetX بدلًا منه.**
- إذا سُئلت: «هل درستم Transactions؟» تكون الإجابة: **نعم، ظهرت في `my_expenses`، لكن `DatabaseService` الحالي لا يستخدمها.**
- إذا سُئلت: «هل درستم GetX؟» تكون الإجابة: **نعم، ظهر في `ex_getx`، والمشروع يطبقه فعليًا.**

---

## 3. نبذة عن المشروع ووظائفه

**Weather & Notes** تطبيق Flutter عربي (RTL) يجمع وظيفتين:

1. **الطقس:** جلب حالة الطقس الحالية وتوقعات 5 أيام من Open-Meteo، مع البحث عن مدينة بالاسم أو الإحداثيات.
2. **الملاحظات:** إضافة/قراءة/تعديل/حذف ملاحظات محليًا باستخدام SQLite.

### الوظائف الفعلية الموجودة

| الوظيفة | كيف تعمل؟ | الملفات الأساسية |
|---|---|---|
| عرض الطقس الحالي | HTTP GET إلى Open-Meteo ثم تحويل JSON إلى `Weather` | `weather_service.dart`, `weather_controller.dart` |
| البحث عن مدينة | HTTP GET إلى Geocoding API مع Debounce | `weather_service.dart`, `weather_controller.dart`, `weather_search_screen.dart` |
| اختيار مدينة | إرسال Latitude/Longitude للطقس | `weather_controller.dart` |
| التوقعات | قراءة `daily` من JSON وعرض 5 صفوف | `weather.dart`, `weather_screen.dart` |
| إضافة ملاحظة | إدخال ثم `INSERT` في SQLite | `note_form_screen.dart`, `notes_controller.dart`, `database_service.dart` |
| قراءة الملاحظات | `SELECT` ثم عرض `ListView` | `notes_controller.dart`, `notes_screen.dart` |
| تعديل ملاحظة | `UPDATE` حسب `id` | `notes_controller.dart`, `database_service.dart` |
| حذف ملاحظة | `DELETE` حسب `id` مع تأكيد | `notes_screen.dart`, `notes_controller.dart` |
| بحث في الملاحظات | فلترة محلية داخل `filteredNotes` | `notes_controller.dart` |
| تنقل بين 3 صفحات | `PageView` + `FloatingNavBar` + GetX للشاشات الفرعية | `home_screen.dart`, `floating_nav_bar.dart` |

### ما لا يفعله المشروع

- لا يوجد تسجيل دخول أو مزامنة سحابية.
- لا توجد قاعدة بيانات على سيرفر؛ الملاحظات محلية فقط.
- لا يوجد `FutureBuilder` في المشروع الحالي.
- لا يوجد `Provider` أو `ChangeNotifier` في المشروع الحالي.
- لا يوجد `toJson` داخل `lib`.
- لا يوجد `path_provider` في الحزم.
- لا يوجد `Navigator.push` مباشر؛ التنقل عبر GetX (`Get.to`) أو `PageView`.

---

## 4. المعمارية العامة ومسار البيانات

### 4.1 تقسيم الطبقات

```text
lib/
├── main.dart                  نقطة البداية + GetMaterialApp
├── theme.dart                 الثيم العام
├── constants/
│   ├── app_colors.dart        الألوان
│   └── app_strings.dart       النصوص العربية
├── models/                    نماذج البيانات
│   ├── weather.dart
│   ├── location.dart
│   └── note.dart
├── services/                  التعامل مع الخارج
│   ├── weather_service.dart   HTTP + JSON
│   └── database_service.dart  SQLite
├── controllers/               الحالة والمنطق
│   ├── weather_controller.dart
│   └── notes_controller.dart
├── screen/                    الصفحات
│   ├── home_screen.dart
│   ├── weather_screen.dart
│   ├── weather_search_screen.dart
│   ├── notes_screen.dart
│   └── note_form_screen.dart
└── widgets/                   مكوّنات مشتركة
    ├── glass_card.dart
    ├── glass_background.dart
    ├── floating_nav_bar.dart
    ├── app_button.dart
    ├── error_widget.dart
    ├── loading_widget.dart
    ├── skeleton_widgets.dart
    └── fade_slide_in.dart
```

### 4.2 المخطط المعماري

```text
المستخدم
   │
   ▼
الصفحات (Screens)
   │  تقرأ الحالة وترسل الأوامر
   ▼
المتحكمات (Controllers)  ← GetX
   │  تطلب البيانات
   ▼
الخدمات (Services)
   ├── WeatherService ── HTTP ──► Open-Meteo API
   └── DatabaseService ─ SQL ──► SQLite
   │
   ▼
النماذج (Models)  ← JSON / Map
   │
   ▼
المتحكمات تحدّث Rx Variables
   │
   ▼
Obx يعيد بناء الواجهة تلقائيًا
```

### 4.3 مثال مختصر لمسار الطقس

```text
HomeScreen
  └─ Get.put(WeatherController)
       └─ onInit()
            └─ loadWeather('صنعاء')
                 └─ WeatherService.fetchWeatherForCity()
                      ├─ searchLocations('صنعاء')  → Geocoding API
                      └─ fetchWeatherForCoords(...) → Forecast API
                           └─ Weather.fromJson(...)
                 └─ weather.value = result
                      └─ Obx يعيد بناء البطاقة
```

---

## 5. مفاهيم Dart الأساسية

> **قاعدة هذا القسم:** لا نذكر مفهومًا إلا إذا وجدنا له استخدامًا فعليًا، أو نوضح صراحة أنه غير مستخدم.

### 5.1 المتغيرات: `var` و`final` و`const`

**التعريف:** المتغير مكان في الذاكرة يحمل قيمة. في Dart:

- `var`: يستنتج النوع تلقائيًا، ويمكن تغيير القيمة.
- `final`: يُسند مرة واحدة عند التشغيل، ولا يمكن تغييره بعد ذلك.
- `const`: قيمة ثابتة معروفة وقت الترجمة (compile-time).

**لماذا نستخدمها؟** لحفظ البيانات وتقليل الأخطاء؛ `final` يمنع تغيير قيمة لا يجب تغييرها، و`const` يوفّر أداءً وذاكرة.

**أين يوجد؟**

- `lib/constants/app_colors.dart:4-13` يستخدم `static const`.
- `lib/controllers/weather_controller.dart:10-13` يستخدم `final`.
- `lib/models/weather.dart:2-11` كل الحقول `final`.

**مقتطف حقيقي:**

```dart
class AppColors {
  static const primary = Color(0xFF2F6BFF);
  static const primaryDark = Color(0xFF1E4FD1);
  static const primaryLight = Color(0xFFE7EEFF);
  static const background = Color(0xFFF5F7FB);
}
```

**شرح سطر بسطر:**

| السطر | الشرح |
|---|---|
| `class AppColors {` | كلاس يحتوي ألوان التطبيق، لا يتم إنشاء كائن منه؛ وظيفته تجميع الثوابت. |
| `static const primary = Color(0xFF2F6BFF);` | `static` تعني أن القيمة تخص الكلاس نفسه لا كائنًا معينًا. `const` تعني أن اللون ثابت وقت الترجمة. `Color(0xFF2F6BFF)` لون أزرق بصيغة ARGB. |
| `primaryDark` | درجة أغمق تُستخدم في التدرجات. |
| `primaryLight` | درجة فاتحة تُستخدم في الخلفيات الصغيرة. |
| `background` | لون خلفية احتياطي. |

**ماذا لو لم نستخدم `const`؟** ستبقى الألوان تعمل، لكن Dart سينشئ قيمًا جديدة كل مرة، وسيفقد بعض التحسينات، كما أننا سنفقد ضمان عدم تغيير الهوية البصرية بالخطأ.

**مثال تطبيقي:** تغيير `AppColors.primary` في مكان واحد ينعكس على الأزرار والبطاقات وشريط التنقل لأن الجميع يقرأ نفس الثابت.

**سؤال محتمل:** ما الفرق بين `final` و`const`؟
**الإجابة:** `final` تُحدَّد مرة واحدة وقت التشغيل ويمكن أن تعتمد على قيمة متغيرة (مثل `DateTime.now()`)، بينما `const` يجب أن تكون معروفة وقت الترجمة.

---

### 5.2 أنواع البيانات: `String` و`int` و`double` و`bool`

**التعريف:**

- `String`: نص.
- `int`: عدد صحيح.
- `double`: عدد عشري.
- `bool`: صحيح/خطأ.

**أين يوجد؟**

- `lib/models/weather.dart:2-11`
- `lib/models/note.dart:2-5`
- `lib/controllers/weather_controller.dart:12` (`bool` ضمنيًا عبر `false.obs`).

**مقتطف حقيقي:**

```dart
class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final double? tempMax;
  final double? tempMin;
  final DateTime lastUpdated;
  final List<DailyForecast> forecast;
}
```

**شرح:**

- `cityName` نص لأن اسم المدينة ليس رقمًا.
- `temperature` و`feelsLike` من نوع `double` لأن Open-Meteo قد يعيد `23.4`.
- `humidity` من نوع `int` لأن الرطوبة نسبة صحيحة غالبًا.
- `weatherCode` من نوع `int` لأن API يستخدم أكوادًا مثل `0` و`61`.
- `tempMax` و`tempMin` من نوع `double?`؛ علامة `?` تعني أنهما قد تكون `null` إذا لم تصل توقعات.
- `DateTime` نوع مخصص للتاريخ والوقت.
- `List<DailyForecast>` قائمة من كائنات التوقعات.

**لماذا `double` وليس `int` للحرارة؟** لأن حرارة `23.7` لا يجب تقريبها أثناء التخزين؛ التقريب يحدث عند العرض فقط عبر `.round()`.

**ملاحظة مهمة:** في JSON كل الأرقام تصل غالبًا كـ`num`، ولهذا نستخدم `(current['temperature_2m'] as num).toDouble()` بدل التحويل المباشر إلى `double`، لأن `num` يشمل `int` و`double`.

---

### 5.3 القوائم `List` والخرائط `Map`

**التعريف:**

- `List`: قائمة مرتبة، عناصرها من نوع واحد غالبًا.
- `Map`: أزواج مفتاح/قيمة (`key/value`).

**أين يوجد؟**

- `weather.dart:11` قائمة توقعات.
- `weather.dart:30-35` قوائم JSON.
- `note.dart:16-22` خريطة `toMap`.
- `location.dart:42` قائمة نصوص مؤقتة.

**مقتطف حقيقي:**

```dart
final dailyList = <DailyForecast>[];
if (daily != null) {
  final dates = (daily['time'] as List).cast<String>();
  final maxTemps = (daily['temperature_2m_max'] as List).cast<num>();
  final minTemps = (daily['temperature_2m_min'] as List).cast<num>();
  final codes = (daily['weather_code'] as List).cast<num>();
  for (var i = 0; i < dates.length; i++) {
    dailyList.add(DailyForecast(
      date: DateTime.parse(dates[i]),
      tempMax: maxTemps[i].toDouble(),
      tempMin: minTemps[i].toDouble(),
      weatherCode: codes[i].toInt(),
    ));
  }
}
```

**شرح سطر بسطر:**

| السطر | الشرح |
|---|---|
| `final dailyList = <DailyForecast>[];` | ينشئ قائمة فارغة من نوع `DailyForecast`. |
| `final daily = json['daily'] as Map<String, dynamic>?;` (من السطر 28) | يقرأ مفتاح `daily` من JSON، وقد يكون `null`. |
| `(daily['time'] as List).cast<String>()` | يأخذ قائمة التواريخ ويحوّل عناصرها إلى `String`. |
| `maxTemps` و`minTemps` | قوائم أرقام من نوع `num`. |
| `codes` | قائمة أكواد الطقس. |
| `for (...) { ... }` | يمر على كل يوم. |
| `maxTemps[i].toDouble()` | يحوّل الرقم إلى `double` بأمان. |
| `dailyList.add(...)` | يضيف كائن توقع جديدًا إلى القائمة. |

**لماذا `List` وليس `Map` للتوقعات؟** لأن الترتيب مهم (اليوم الأول، الثاني...)، والقائمة تحفظ الترتيب.

**مثال تطبيقي:** `_ForecastCard` تستخدم `...forecast.take(5).map(_forecastRow)` لعرض أول 5 أيام.

---

### 5.4 الدوال: Parameters وReturn Values

**التعريف:** الدالة (Function) كتلة كود لها اسم، قد تستقبل مدخلات (Parameters) وقد تعيد قيمة (Return).

**أين يوجد؟**

- `weather_service.dart:18` دالة `searchLocations` تعيد `Future<List<Location>>`.
- `weather_controller.dart:35` دالة `loadWeather` تعيد `Future<void>`.
- `note.dart:32` دالة `copyWith` تعيد `Note`.

**مقتطف حقيقي:**

```dart
Future<void> loadWeather(String cityName) async {
  isLoading.value = true;
  errorMessage.value = null;
  try {
    final result = await _service.fetchWeatherForCity(cityName);
    weather.value = result;
    currentCity.value = result.cityName;
  } catch (e) {
    errorMessage.value = e.toString().replaceFirst('Exception: ', '');
  } finally {
    isLoading.value = false;
  }
}
```

**شرح:**

- `Future<void>`: دالة غير متزامنة، ولا تعيد قيمة عند الانتهاء (`void`).
- `String cityName`: مدخل إلزامي.
- `async`: تسمح باستخدام `await`.
- `try/catch/finally`: معالجة الأخطاء مع تنفيذ نهائي.
- `return` غير مكتوب لأن النوع `void`.

**دالة تعيد قيمة:**

```dart
Future<List<Location>> searchLocations(String query) async {
  ...
  return results
      .map((r) => Location.fromJson(r as Map<String, dynamic>))
      .toList();
}
```

- النوع `Future<List<Location>>` يعني: عند انتهاء العملية ستحصل على قائمة `Location`.
- `map` تحوّل كل عنصر، و`toList` تجمع الناتج في قائمة.

**ماذا لو حذفنا `return`؟** سيصبح نوع الإرجاع غير متوافق، ولن تعمل الدالة، أو سيعيد `null` مع خطأ ترجمة.

---

### 5.5 الكلاسات والكائنات والمُنشئات (Classes, Objects, Constructors)

**التعريف:** الكلاس قالب، والكائن نسخة منه. المُنشئ (Constructor) دالة خاصة تُنشئ الكائن وتضع قيمه الأولية.

**أين يوجد؟**

- `class Note` في `lib/models/note.dart:1`.
- `class WeatherController extends GetxController` في `lib/controllers/weather_controller.dart:7`.
- المُنشئ `Weather({...})` في `weather.dart:13-24`.
- المُنشئ `Note({...})` في `note.dart:8-14`.

**مقتطف حقيقي:**

```dart
class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}
```

**شرح سطر بسطر:**

| السطر | الشرح |
|---|---|
| `class Note {` | يعرّف نموذج ملاحظة. |
| `final int? id;` | رقم معرف اختياري؛ `null` قبل الحفظ. |
| `final String title;` | عنوان إلزامي. |
| `final String content;` | محتوى إلزامي. |
| `final DateTime createdAt;` | وقت الإنشاء. |
| `final DateTime updatedAt;` | وقت آخر تعديل. |
| `Note({...})` | مُنشئ مسمّى بالمعاملات. |
| `this.id` | يربط المعامل بالحقل مباشرة. |
| `required` | يمنع إنشاء الكائن دون هذه القيمة. |

**كيف يُستخدم؟**

```dart
await _service.insertNote(Note(
  title: title,
  content: content,
  createdAt: now,
  updatedAt: now,
));
```

هنا ينشئ `NotesController` كائن `Note` جديدًا ويمرره للخدمة.

**سؤال محتمل:** لماذا `id` اختياري؟
**الإجابة:** لأن SQLite هي التي تولّد `id` عبر `AUTOINCREMENT` بعد `INSERT`، فلا نعرف القيمة قبل الحفظ.

---

### 5.6 Null Safety

**التعريف:** نظام يمنع استخدام قيمة قد تكون `null` دون التحقق.

**أنواعه في المشروع:**

- `String?` تعني قد تكون `null`.
- `Rxn<T>` من GetX تعني قيمة تفاعلية قد تكون `null`.
- `RxnString()` تعني نصًا تفاعليًا قد يكون `null`.
- `late final` تعني تأجيل التهيئة مع ضمانها قبل الاستخدام.

**أين يوجد؟**

- `weather_controller.dart:10` `Rxn<Weather>()`.
- `weather_controller.dart:13` `RxnString()`.
- `weather_controller.dart:20` `Timer? _debounce`.
- `home_screen.dart:25` `late final PageController`.
- `note_form_screen.dart:21-22` `late final TextEditingController`.
- `note.dart:2` `int? id`.

**مقتطف حقيقي:**

```dart
final weather = Rxn<Weather>();
final currentCity = 'صنعاء'.obs;
final isLoading = false.obs;
final errorMessage = RxnString();
```

**شرح:**

- `Rxn<Weather>`: متغير تفاعلي (Rx) قيمته إما `Weather` أو `null`. قبل الجلب هو `null`.
- `.obs`: يحوّل القيمة إلى متغير تفاعلي يراقبه `Obx`.
- `RxnString`: نسخة جاهزة لنص قابل للـ`null`.

**أين نتحقق؟**

```dart
if (_weatherController.weather.value == null) {
  ...
}
final w = _weatherController.weather.value!;
```

- `== null` يتحقق قبل الاستخدام.
- `!` تعني «أنا متأكد أنها ليست null»؛ لا تُستخدم إلا بعد التحقق.

**ماذا لو حذفنا `!`؟** سيعطي Dart خطأ لأن النوع يبقى `Weather?`، ولن يسمح باستدعاء `w.cityName`.

**ماذا لو استخدمنا `!` دون تحقق؟** قد يحدث Crash عند التشغيل برسالة `Null check operator used on a null value`.

---

### 5.7 الجمل الشرطية (Conditional Statements)

**التعريف:** `if` و`else` و`switch` لتشغيل كود حسب شرط.

**أين يوجد؟**

- `weather_service.dart:20` التحقق من طول البحث.
- `weather_service.dart:34` التحقق من `statusCode`.
- `weather_controller.dart:74-82` التحقق من النص الفارغ/القصير.
- `weather_screen.dart:263` عرض درجة العظمى/الصغرى إذا توفرت.

**مقتطف حقيقي:**

```dart
if (trimmed.isEmpty) {
  _cancelAndClear();
  return;
}
if (trimmed.length < 2) {
  _cancelAndClear();
  searchError.value = 'اكتب حرفين على الأقل للبحث';
  return;
}
```

**شرح:**

- إذا كان النص فارغًا: إلغاء البحث وتنظيف النتائج والخروج.
- إذا كان حرفًا واحدًا: إلغاء + إظهار رسالة.
- `return` تمنع تنفيذ بقية الدالة (أي لا نرسل طلبًا للشبكة).

**فائدة عملية:** تقليل طلبات الشبكة غير المفيدة وتجربة مستخدم أفضل.

---

### 5.8 الحلقات (Loops)

**التعريف:** تكرار كود عدة مرات.

**الأنواع المستخدمة:**

- `for` تقليدي في `weather.dart:36`.
- `for (final tile in tiles)` في `weather_screen.dart:305`.
- `List.generate` في `floating_nav_bar.dart:67`.
- `.map` في `weather_service.dart:38`.

**مقتطف حقيقي:**

```dart
for (var i = 0; i < dates.length; i++) {
  dailyList.add(DailyForecast(
    date: DateTime.parse(dates[i]),
    tempMax: maxTemps[i].toDouble(),
    tempMin: minTemps[i].toDouble(),
    weatherCode: codes[i].toInt(),
  ));
}
```

**شرح:**

- `var i = 0`: بداية العد.
- `i < dates.length`: يستمر حتى آخر تاريخ.
- `i++`: يزيد العداد.
- `dates[i]`: العنصر المقابل في كل قائمة.

**لماذا آمنة؟** لأن جميع القوائم (dates, maxTemps, minTemps, codes) تأتي من نفس عدد الأيام في استجابة API.

---

### 5.9 الاستيراد (Import)

**التعريف:** جلب أكواد من ملف أو حزمة لاستخدامها.

**الأنواع في المشروع:**

```dart
import 'package:flutter/material.dart';       // حزمة Flutter
import 'package:get/get.dart';                 // حزمة GetX
import '../models/note.dart';                  // ملف محلي نسبي
import 'dart:convert';                         // مكتبة Dart أساسية
import 'package:http/http.dart' as http;       // حزمة مع بادئة
```

**شرح:**

- `package:` يعني حزمة خارجية أو حزمة المشروع.
- `../` تعني الرجوع مجلدًا واحدًا.
- `as http` تعطينا اسمًا مختصرًا؛ نستخدم `http.Client` و`http.get`.
- `dart:` مكتبات مدمجة في Dart.

**Export:** غير مستخدم في المشروع. لا يوجد ملف `export` يعيد تصدير ملفات أخرى.

---

### 5.10 `async` و`await` و`Future`

سيأتي تفصيلها الكبير في القسم 9. هنا التعريف السريع:

- `Future`: نتيجة عملية ستحدث لاحقًا.
- `async`: تجعل الدالة قادرة على إرجاع `Future`.
- `await`: تنتظر انتهاء `Future` دون تجميد الواجهة.

**مقتطف:**

```dart
final result = await _service.fetchWeatherForCity(cityName);
weather.value = result;
```

- `await` ينتظر وصول النتيجة.
- بعدها نضع النتيجة في `weather.value`.
- `Obx` يلاحظ التغيير ويعيد البناء.

---

## 6. مفاهيم Flutter والواجهات

### 6.1 `main()` و`runApp()`

**أين يوجد؟** `lib/main.dart:8-12`.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  runApp(const MyApp());
}
```

**شرح:**

| السطر | الشرح |
|---|---|
| `void main() async` | نقطة بداية تطبيق Dart. `async` لأننا سننتظر تهيئة اللغة. |
| `WidgetsFlutterBinding.ensureInitialized()` | يهيئ ربط Flutter قبل استخدام خدمات تحتاج ذلك. |
| `await initializeDateFormatting('ar', null)` | يحمّل بيانات اللغة العربية لتنسيق التواريخ عبر `intl`. |
| `runApp(const MyApp())` | يبدأ شجرة الواجهة. |

**لماذا نهيئ التاريخ؟** لأن `DateFormat('EEEE', 'ar')` في شاشة الطقس يحتاج بياناتLocale العربية؛ بدونها قد يظهر الخطأ أو الاسم الإنجليزي.

---

### 6.2 `GetMaterialApp`

**أين يوجد؟** `main.dart:19-34`.

```dart
return GetMaterialApp(
  title: 'Weather & Notes',
  debugShowCheckedModeBanner: false,
  theme: AppTheme.lightTheme,
  home: const HomeScreen(),
  locale: const Locale('ar'),
  fallbackLocale: const Locale('ar'),
  supportedLocales: const [Locale('ar'), Locale('en')],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  builder: (context, child) =>
      Directionality(textDirection: TextDirection.rtl, child: child!),
);
```

**شرح:**

- `GetMaterialApp`: نسخة من `MaterialApp` مدمجة مع GetX (تدعم `Get.to` و`Get.snackbar`...).
- `home`: أول شاشة.
- `locale`: اللغة العربية.
- `localizationsDelegates`: ترجمة عناصر Material إلى العربية.
- `builder`: يفرض اتجاه RTL على كل الشجرة.

**لماذا لم نستخدم `MaterialApp`؟** لأن التنقل والرسائل تعتمد على GetX؛ `GetMaterialApp` يوفر السياق المناسب لها.

---

### 6.3 `Scaffold`

**أين يوجد؟**

- `home_screen.dart:56`
- `weather_screen.dart:49`
- `notes_screen.dart:30`
- `note_form_screen.dart:74`
- `weather_search_screen.dart:42`

**وظيفته:** يوفر الهيكل الأساسي: `AppBar`، `body`، `floatingActionButton`، `bottomNavigationBar`.

**ملاحظة:** `HomeScreen` يستخدم `backgroundColor: Colors.transparent` و`extendBody: true` ليظهر خلفه `GlassBackground`.

---

### 6.4 `StatelessWidget` و`StatefulWidget`

**StatelessWidget:** واجهة لا تملك حالة داخلية متغيرة.

أمثلة:

- `MyApp` (`main.dart:14`)
- `_MainWeatherCard` (`weather_screen.dart:215`)
- `_InfoGrid` (`weather_screen.dart:277`)
- `GlassCard` (`glass_card.dart:16`)
- `FloatingNavBar` (`floating_nav_bar.dart:5`)

**StatefulWidget:** واجهة تملك حالة تتغير، وتستخدم `setState` أو `State`.

أمثلة:

- `HomeScreen` (`home_screen.dart:16`)
- `_HomeTab` (`home_screen.dart:88`)
- `WeatherScreen` (`weather_screen.dart:14`)
- `NotesScreen` (`notes_screen.dart:13`)
- `NoteFormScreen` (`note_form_screen.dart:11`)
- `WeatherSearchScreen` (`weather_search_screen.dart:11`)
- `FadeSlideIn` (`fade_slide_in.dart:4`)

**مقتطف حقيقي:**

```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  ...
}
```

**شرح:**

- `HomeScreen` هو الـWidget (الإعداد).
- `createState` ينشئ كائن الحالة.
- `_HomeScreenState` يحتفظ بـ`_currentIndex` و`PageController`.

**لماذا Stateful هنا؟** لأن التبويب الحالي يتغير، و`PageView` يحتاج Controller.

---

### 6.5 `build()` و`BuildContext`

**`build`:** دالة تصف الواجهة، وتُستدعى عند أول عرض وعند تغير الحالة.

**`BuildContext`:** موقع الـWidget في الشجرة؛ يُستخدم للوصول إلى `MediaQuery` و`Theme` والأب.

**مقتطف:**

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: SafeArea(
      child: Obx(() {
        final weather = controller.weather.value;
        ...
      }),
    ),
  );
}
```

**شرح:**

- `context` يمرره الإطار.
- `MediaQuery.viewPaddingOf(context)` في أماكن أخرى يقرأ الحواف الآمنة.
- `Obx` يعيد تنفيذ ما بداخله عند تغير Rx.

---

### 6.6 شجرة الواجهة (Widget Tree)

```text
MyApp
└── GetMaterialApp
    └── HomeScreen (Scaffold)
        ├── GlassBackground
        │   └── PageView
        │       ├── _HomeTab
        │       ├── WeatherScreen
        │       └── NotesScreen
        └── FloatingNavBar
```

كل عنصر في الشجرة Widget. التغيير في `Obx` يعيد بناء الجزء التابع فقط، لا الشجرة كلها.

---

### 6.7 `Column` و`Row`

**`Column`:** ترتيب عمودي.
**`Row`:** ترتيب أفقي.

**أين يوجد؟** في كل الشاشات تقريبًا.

**مقتطف من بطاقة الطقس السريعة (`home_screen.dart:185-245`):**

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Flexible(
      child: Text(
        w.cityName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        ...
      ),
    ),
    const SizedBox(width: 8),
    Text(w.icon, style: const TextStyle(fontSize: 34)),
  ],
),
```

**شرح:**

- `Row` يرتب المدينة والأيقونة أفقيًا.
- `spaceBetween` يضع مسافة بينهما.
- `Flexible` يسمح للنص بالانكماش بدل تجاوز العرض.
- `ellipsis` يضيف `...` عند الطول الزائد.
- `SizedBox(width: 8)` مسافة ثابتة.

**لماذا `Flexible` مهمة؟** لو كان اسم المدينة طويلًا، بدونها قد يحدث Overflow.

---

### 6.8 `Container` و`Padding`

**`Container`:** صندوق يمكن أن يحمل لونًا وحدودًا وظلًا وحشوًا وأبعادًا.

**`Padding`:** يضيف مسافة داخلية حول الطفل.

**أين يوجد؟**

- `home_screen.dart:260` حاوية أيقونة الملاحظات.
- `floating_nav_bar.dart:47` حاوية شريط التنقل.
- `glass_card.dart:191` `Padding` حول المحتوى.

**مقتطف:**

```dart
Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primaryLight, Color(0xFFD6E4FF)],
    ),
    borderRadius: BorderRadius.circular(14),
  ),
  child: const Icon(Icons.sticky_note_2_outlined, color: AppColors.primary),
)
```

**شرح:**

- `padding`: مسافة داخلية 14.
- `decoration`: تدرج أزرق فاتح.
- `borderRadius`: زوايا دائرية.
- `child`: الأيقونة.

**ملاحظة:** التطبيق لا يستخدم `Margin` widget مباشرة؛ يستخدم `EdgeInsets` داخل `Padding` و`SizedBox` للمسافات.

---

### 6.9 `Expanded` و`Flexible`

**`Expanded`:** يأخذ كل المساحة المتبقية.
**`Flexible`:** يأخذ مساحة مرنة لكن يمكنه أن يكون أصغر.

**أين يوجد؟**

- `home_screen.dart:188` `Flexible` لاسم المدينة.
- `weather_screen.dart:378` `Expanded(flex: 2)` لاسم اليوم.
- `notes_screen.dart:235` `Expanded` لعنوان الملاحظة.

**مقتطف:**

```dart
Expanded(
  child: Text(
    note.title,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
),
```

**لماذا؟** لأن بجانب العنوان زرّي تعديل وحذف؛ `Expanded` يعطي العنوان ما تبقى من العرض ويمنع التصادم.

---

### 6.10 `ListView` و`ListView.builder`

**أين يوجد؟** `notes_screen.dart:72-92`.

```dart
return ListView.builder(
  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
  padding: EdgeInsets.fromLTRB(
      16, 8, 16, MediaQuery.viewPaddingOf(context).bottom + 100),
  itemCount: notes.length,
  itemBuilder: (context, i) {
    final note = notes[i];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FadeSlideIn(
        key: ValueKey('note_${note.id}'),
        child: _NoteCard(...),
      ),
    );
  },
);
```

**شرح:**

- `itemCount`: عدد العناصر.
- `itemBuilder`: يبني عنصرًا واحدًا حسب الفهرس.
- `ListView.builder` يبني العناصر الظاهرة فقط = أداء أفضل.
- `padding` سفلي 100 لعدم تغطية شريط التنقل.
- `ValueKey` يساعد Flutter على تمييز العناصر عند التحديث.

**لماذا `ListView.builder` وليس `ListView` عادية؟** لأن عدد الملاحظات قد يزيد، والباني الكسول أكثر كفاءة.

---

### 6.11 `SingleChildScrollView`

**أين يوجد؟**

- `home_screen.dart:109`
- `weather_screen.dart:123`
- `note_form_screen.dart:80`

**وظيفته:** يجعل المحتوى الطويل قابلًا للتمرير عندما يكون في `Column`.

**مثال:** صفحة الطقس فيها بطاقة رئيسية + شبكة معلومات + توقعات + صف تحديث؛ لذلك تحتاج تمريرًا.

---

### 6.12 `TextField` و`TextFormField`

**`TextField`:** حقل إدخال بسيط.
**`TextFormField`:** حقل داخل `Form` يدعم `validator`.

**أين يوجد؟**

- `weather_search_screen.dart:55` `TextField` للبحث عن مدينة.
- `notes_screen.dart:45` `TextField` لبحث الملاحظات.
- `note_form_screen.dart:93` و`104` `TextFormField` للعنوان والمحتوى.

**مقتطف:**

```dart
TextFormField(
  controller: _titleController,
  decoration: const InputDecoration(
    labelText: AppStrings.noteTitle,
    prefixIcon: Icon(Icons.title),
  ),
  validator: (v) => (v == null || v.trim().isEmpty)
      ? AppStrings.titleRequired
      : null,
)
```

**شرح:**

- `controller`: يقرأ ويكتب النص.
- `labelText`: التسمية.
- `validator`: يرجع رسالة خطأ أو `null` إذا صحيح.
- `trim()`: يحذف المسافات الطرفية، فالمسافة وحدها لا تُعد عنوانًا.

---

### 6.13 الأزرار

**الأنواع المستخدمة:**

- `ElevatedButton` داخل `AppButton`.
- `TextButton` في الحوارات وإعادة المحاولة.
- `OutlinedButton` في زر الإلغاء.
- `FloatingActionButton.extended` لإضافة ملاحظة.
- `IconButton` للتعديل والحذف والبحث.

**أين يوجد؟**

- `app_button.dart:21`
- `note_form_screen.dart:125`
- `notes_screen.dart:101`
- `notes_screen.dart:244` و`254`

---

### 6.14 التنقل: `Navigator` أم GetX؟

**المشروع لا يستخدم `Navigator.push` مباشرة.** يستخدم:

- `Get.to(() => const WeatherSearchScreen())` في `weather_screen.dart:43`.
- `Get.to<bool>(() => NoteFormScreen(note: note), ...)` في `notes_screen.dart:111`.
- `Get.back()` في `weather_search_screen.dart:35` و`note_form_screen.dart:57` و`126`.

**لماذا GetX؟** لأن المشروع يعتمد GetX أصلًا للحالة، و`Get.to` يسمح بإرجاع نتيجة (`bool`) بسهولة، و`Get.back(result: true)`.

**الفرق:**

| Navigator | GetX |
|---|---|
| `Navigator.push(context, MaterialPageRoute(...))` | `Get.to(() => Screen())` |
| `Navigator.pop(context, result)` | `Get.back(result: result)` |
| يحتاج `context` | لا يحتاج `context` غالبًا |
| لا يحتاج حزمة | يحتاج `get` |

---

### 6.15 `setState`

**أين يوجد؟**

- `home_screen.dart:46` لتغيير التبويب.
- `note_form_screen.dart:44` و`67` لحالة الحفظ.

**مقتطف:**

```dart
void _onTabTap(int i) {
  if (i == _currentIndex) return;
  setState(() => _currentIndex = i);
  _pageController.animateToPage(
    i,
    duration: const Duration(milliseconds: 320),
    curve: Curves.easeOutCubic,
  );
}
```

**شرح:**

- إذا ضغط المستخدم نفس التبويب، لا شيء يحدث.
- `setState` يخبر Flutter أن `_currentIndex` تغير، فيعيد بناء الواجهة.
- `animateToPage` يحرك `PageView`.

**لماذا لا نستخدم GetX هنا؟** لأن التبويب حالة محلية خاصة بهذه الشاشة، و`setState` أبسط وأخف. GetX مخصص للحالة المشتركة بين الشاشات (الطقس والملاحظات).

---

### 6.16 مكونات إضافية مهمة

| المكوّن | الملف | وظيفته |
|---|---|---|
| `PageView` | `home_screen.dart:60` | تمرير بين 3 صفحات |
| `RefreshIndicator` | `home_screen.dart:107`, `weather_screen.dart:121` | سحب للتحديث |
| `SafeArea` | عدة شاشات | تجنب النوتش والحواف |
| `MediaQuery` | عدة شاشات | قراءة أبعاد الشاشة والحواف |
| `LayoutBuilder` | `weather_screen.dart:293` | التكيف مع العرض |
| `Wrap` | `weather_screen.dart:300` | التفاف البطاقات عند ضيق العرض |
| `Form` + `GlobalKey<FormState>` | `note_form_screen.dart:88` | التحقق من الحقول |
| `AlertDialog` | `notes_screen.dart:133` | تأكيد الحذف |
| `AnimatedContainer` | `floating_nav_bar.dart:99` | تحريك شكل التبويب النشط |
| `AnimatedSwitcher` | `floating_nav_bar.dart:129` | تبديل الأيقونة بسلاسة |
| `FadeTransition` + `SlideTransition` | `fade_slide_in.dart:51-54` | حركة دخول البطاقات |
| `BackdropFilter` + `ImageFilter.blur` | `glass_card.dart:202-203` | ضباب الزجاج الحقيقي |

---

## 7. GetX: إدارة الحالة والتنقل

### 7.1 ما هو GetX؟

GetX حزمة Flutter تجمع:

- إدارة الحالة (State Management).
- التنقل (Navigation).
- حقن التبعيات (Dependency Injection).
- الرسائل والحوارات (Snackbar/Dialog).

**الفكرة الأساسية:** بدل `setState` في كل مكان، نضع القيم في `GetxController`، والواجهة تراقبها عبر `Obx`.

### 7.2 `GetxController`

**أين يوجد؟**

- `WeatherController extends GetxController` (`weather_controller.dart:7`).
- `NotesController extends GetxController` (`notes_controller.dart:5`).

**مقتطف:**

```dart
class WeatherController extends GetxController {
  final WeatherService _service = WeatherService();

  final weather = Rxn<Weather>();
  final currentCity = 'صنعاء'.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  ...
}
```

**شرح:**

- `extends GetxController`: يمنح الكلاس دورة حياة (`onInit`, `onClose`) وقدرة على الاستخدام مع GetX.
- `_service`: كائن خدمة خاص.
- `weather`: نتيجة الطقس.
- `currentCity`: المدينة الحالية، تبدأ بـ«صنعاء».
- `isLoading`: هل هناك طلب جارٍ؟
- `errorMessage`: آخر خطأ.

### 7.3 `Rx` Variables و`.obs`

**التعريف:** متغير تفاعلي يبلغ الواجهة عند تغييره.

**الأنواع:**

- `.obs` على قيمة عادية → `Rx<T>`.
- `Rxn<T>` → قيمة قد تكون `null`.
- `RxnString` → نص قد يكون `null`.
- `<Location>[].obs` → قائمة تفاعلية.

**مثال:**

```dart
final notes = <Note>[].obs;
final isLoading = false.obs;
final searchQuery = ''.obs;
```

**كيف نقرأ ونكتب؟**

```dart
notes.assignAll(list);       // استبدال القائمة
isLoading.value = true;      // كتابة قيمة
final q = searchQuery.value; // قراءة
```

**لماذا `.value`؟** لأن المتغير التفاعلي كائن يغلف القيمة.

**ماذا لو كتبنا `isLoading = true`؟** خطأ، لأن `isLoading` من نوع `RxBool` وليس `bool`.

### 7.4 `Obx`

**التعريف:** Widget يعيد بناء محتواه تلقائيًا عند تغير أي Rx يُقرأ داخله.

**أين يوجد؟**

- `home_screen.dart:159` بطاقة الطقس.
- `home_screen.dart:254` بطاقة عدد الملاحظات.
- `weather_screen.dart:60` محتوى الطقس.
- `notes_screen.dart:63` قائمة الملاحظات.
- `weather_search_screen.dart:69` زر مسح البحث.
- `weather_search_screen.dart:94` نتائج البحث.

**مقتطف:**

```dart
return Obx(() {
  final weather = controller.weather.value;
  if (weather != null) {
    return _WeatherContent(...);
  }
  final error = controller.errorMessage.value;
  if (error != null) {
    return _ScrollableError(...);
  }
  return const WeatherSkeleton();
});
```

**شرح:**

- يقرأ `weather.value` و`errorMessage.value` → يسجل اعتمادًا عليهما.
- عند تغير أي منهما، يعيد تنفيذ الدالة.
- إذا وُجد طقس: يعرض المحتوى.
- إذا وُجد خطأ: يعرض الخطأ.
- وإلا: Skeleton.

**مهم:** يجب أن تكون القيم التفاعلية مقروءة **داخل** `Obx`، وليس خارجه، وإلا لن تتم المراقبة.

### 7.5 `Get.put`

**التعريف:** يسجّل كائنًا في نظام GetX ليُستخدم لاحقًا.

**أين يوجد؟** `home_screen.dart:30-35`.

```dart
if (!Get.isRegistered<WeatherController>()) {
  Get.put(WeatherController(), permanent: true);
}
if (!Get.isRegistered<NotesController>()) {
  Get.put(NotesController(), permanent: true);
}
```

**شرح:**

- `isRegistered`: هل الكائن موجود مسبقًا؟
- `Get.put`: ينشئه ويسجله.
- `permanent: true`: لا يحذفه GetX عند إغلاق الشاشة.

**لماذا؟** لأن الطقس والملاحظات يحتاجان البقاء طوال عمر التطبيق، ومشاركتهما بين الصفحات.

**ماذا لو استدعينا `Get.put` مرتين دون فحص؟** قد تُنشأ نسختان، وتختلف الحالة بين الشاشات.

### 7.6 `Get.find`

**التعريف:** يعيد الكائن المسجل مسبقًا.

**أين يوجد؟**

- `home_screen.dart:96-97`
- `weather_screen.dart:23`
- `notes_screen.dart:22`
- `note_form_screen.dart:23`
- `weather_search_screen.dart:19`

```dart
final WeatherController controller = Get.find<WeatherController>();
```

**شرح:**

- يبحث عن `WeatherController` في السجل.
- إذا لم يكن مسجلًا، يرمي خطأ.
- يضمن أن كل الشاشات تستخدم نفس الكائن ونفس البيانات.

**ترتيب مهم:** يجب أن يحدث `Get.put` قبل `Get.find`. هنا `Get.put` في `HomeScreen.initState`، وكل الشاشات الفرعية تُبنى بعده.

### 7.7 `onInit` و`onClose`

**`onInit`:** تُستدعى عند إنشاء المتحكم.

```dart
@override
void onInit() {
  super.onInit();
  loadWeather(currentCity.value);
}
```

- يبدأ جلب الطقس تلقائيًا عند أول تسجيل.

**`onClose`:** تُستدعى عند إزالة المتحكم.

```dart
@override
void onClose() {
  _debounce?.cancel();
  super.onClose();
}
```

- يلغي مؤقت البحث لتجنب تنفيذ عملية بعد التدمير.

### 7.8 `Get.to` و`Get.back`

**أمثلة:**

```dart
await Get.to(() => const WeatherSearchScreen());
```

- يفتح شاشة البحث.

```dart
final saved = await Get.to<bool>(
  () => NoteFormScreen(note: note),
  transition: Transition.downToUp,
  duration: const Duration(milliseconds: 320),
);
```

- يفتح نموذج الملاحظة وينتظر نتيجة من نوع `bool`.
- إذا حفظ المستخدم، يرجع النموذج `true`.

```dart
Get.back<bool>(result: true);
```

- يغلق النموذج ويعيد `true`.

```dart
Get.back();
```

- إغلاق عادي.

**لماذا `await Get.to`؟** لأن الشاشة قد تعيد قيمة، ونحتاج انتظارها لإظهار رسالة نجاح.

### 7.9 `Get.dialog` و`Get.snackbar`

**`Get.dialog`:** `notes_screen.dart:132` يعرض تأكيد الحذف.

**`Get.snackbar`:**

- `notes_screen.dart:117` رسالة نجاح الحفظ.
- `notes_screen.dart:145` خطأ الحذف.
- `note_form_screen.dart:59` خطأ الحفظ.

**ميزة:** لا تحتاج `ScaffoldMessenger` أو `context`.

### 7.10 الفرق بين إدارة الحالة والتنقل

| الجانب | إدارة الحالة | التنقل |
|---|---|---|
| الهدف | حفظ البيانات وتحديث الواجهة | الانتقال بين الشاشات |
| الأدوات هنا | `GetxController`, `Rx`, `Obx`, `Get.put/find` | `Get.to`, `Get.back`, `PageView` |
| مثال | `weather.value = result` | `Get.to(() => WeatherSearchScreen())` |

**ملاحظة:** كلاهما من GetX، لكنهما وظيفتان مختلفتان. لا تخلط بين `Obx` (حالة) و`Get.to` (تنقل).

### 7.11 ما هو غير مستخدم من GetX؟

- `GetBuilder`: غير مستخدم.
- `GetX<Controller>` widget: غير مستخدم.
- `Get.lazyPut`: غير مستخدم.
- `Get.off` / `Get.offAll`: غير مستخدم.
- `Get.arguments`: غير مستخدم.
- `Bindings`: غير مستخدمة.

لا تذكرها كتطبيق فعلي؛ يمكن ذكرها كمقارنة فقط.

---

## 8. الإنترنت وAPI وJSON

### 8.1 ما هو API؟

API واجهة برمجية تسمح لتطبيقك بطلب بيانات من خدمة خارجية. هنا:

- **Open-Meteo Forecast API**: بيانات الطقس.
- **Open-Meteo Geocoding API**: تحويل اسم المدينة إلى إحداثيات.

### 8.2 HTTP Request وGET

**HTTP Request:** رسالة يرسلها التطبيق إلى سيرفر.

**GET:** نوع الطلب المستخدم لقراءة بيانات دون تعديلها.

**مثال من الكود:**

```dart
final uri = Uri.parse(_weatherUrl).replace(queryParameters: {
  'latitude': lat.toString(),
  'longitude': lon.toString(),
  'current':
      'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
  'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
  'timezone': 'auto',
  'forecast_days': '5',
});

final response = await _client.get(uri).timeout(const Duration(seconds: 15));
```

**شرح:**

- `Uri.parse`: يحوّل النص إلى URI.
- `replace(queryParameters: ...)`: يضيف معاملات الاستعلام.
- `latitude` و`longitude`: الموقع.
- `current`: الحقول الحالية المطلوبة.
- `daily`: حقول التوقعات.
- `timezone=auto`: توقيت المدينة.
- `forecast_days=5`: خمسة أيام.
- `.get(uri)`: يرسل طلب GET.
- `.timeout(15s)`: يمنع الانتظار اللانهائي.

### 8.3 Response وStatusCode

```dart
if (response.statusCode == 200) {
  return Weather.fromJson(jsonDecode(response.body), cityName);
} else {
  throw Exception('فشل جلب الطقس (رمز: ${response.statusCode})');
}
```

- `200` = نجاح.
- أي رمز آخر = خطأ.
- `response.body` نص JSON.

### 8.4 JSON

**JSON** صيغة نصية لتبادل البيانات. مثال مبسّط:

```json
{
  "current": {
    "temperature_2m": 23.4,
    "relative_humidity_2m": 40,
    "apparent_temperature": 22.1,
    "weather_code": 1,
    "wind_speed_10m": 12.5
  },
  "daily": {
    "time": ["2026-11-20"],
    "temperature_2m_max": [26.0],
    "temperature_2m_min": [14.2],
    "weather_code": [1]
  }
}
```

**ملاحظة:** هذا مثال توضيحي للشكل، وليس استجابة محفوظة من المشروع.

### 8.5 `dart:convert` و`jsonDecode`

```dart
import 'dart:convert';
...
final data = jsonDecode(response.body) as Map<String, dynamic>;
```

- `jsonDecode`: يحوّل النص إلى `Map`/`List` في Dart.
- `as Map<String, dynamic>`: يخبر Dart بالشكل المتوقع.

**ماذا لو كان JSON غير صالح؟** يرمي `FormatException`، وهو معالج في `weather_service.dart:48-49`.

### 8.6 دور `Model`

`Weather.fromJson` يأخذ `Map` ويعيد كائن `Weather`:

```dart
factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
  final current = json['current'] as Map<String, dynamic>;
  ...
  return Weather(
    cityName: cityName,
    temperature: (current['temperature_2m'] as num).toDouble(),
    ...
  );
}
```

**الفائدة:** بقية التطبيق يتعامل مع `weather.temperature` بدل `json['current']['temperature_2m']`، وهذا أوضح وأأمن.

### 8.7 دور `Service`

`WeatherService` مسؤول عن:

- بناء الرابط.
- إرسال الطلب.
- التحقق من الحالة.
- تحويل JSON.
- تحويل الأخطاء إلى رسائل عربية.

**لا تعرف الواجهة شيئًا عن HTTP.** الواجهة تتعامل مع `WeatherController` فقط.

### 8.8 معالجة أخطاء الاتصال

```dart
} on SocketException {
  throw Exception('لا يوجد اتصال بالإنترنت');
} on TimeoutException {
  throw Exception('انتهت مهلة الاتصال');
} on FormatException {
  throw Exception('استجابة غير صالحة من الخادم');
}
```

- `SocketException`: لا إنترنت أو DNS.
- `TimeoutException`: تجاوز 15 ثانية.
- `FormatException`: JSON غير صالح.

ثم في المتحكم:

```dart
} catch (e) {
  errorMessage.value = e.toString().replaceFirst('Exception: ', '');
}
```

- يزيل كلمة `Exception: ` من الرسالة لعرض نص نظيف.
- `Obx` يعرض الخطأ.

### 8.9 عدم وجود نتائج للبحث

في `searchLocations`:

```dart
final results = data['results'] as List?;
if (results == null || results.isEmpty) return [];
```

- يعيد قائمة فارغة بدل خطأ.

في `_performSearch`:

```dart
searchResults.assignAll(results);
if (results.isEmpty) {
  searchError.value = 'لم يتم العثور على نتائج مطابقة.';
}
```

- يظهر للمستخدم «لم يتم العثور على نتائج مطابقة».

### 8.10 مسار البيانات الكامل: من اختيار المدينة إلى درجة الحرارة

```text
1. WeatherSearchScreen: يكتب المستخدم "Sana"
2. TextField.onChanged → WeatherController.onSearchChanged
3. Debounce 400ms
4. _performSearch → WeatherService.searchLocations
5. GET geocoding-api.open-meteo.com
6. JSON → List<Location> → searchResults (Rx)
7. Obx يبني _SuggestionTile لكل نتيجة
8. المستخدم يضغط نتيجة
9. _selectLocation → Get.back() ثم controller.selectLocation
10. WeatherService.fetchWeatherForCoords(lat, lon, name)
11. GET api.open-meteo.com
12. JSON → Weather.fromJson
13. weather.value = Weather
14. Obx في WeatherScreen يعيد البناء
15. تظهر درجة الحرارة والرطوبة والرياح والتوقعات
```

### 8.11 لماذا نستخدم `Debounce`؟

بدون Debounce، كل حرف يكتبه المستخدم يرسل طلبًا:

```text
S → طلب
Sa → طلب
San → طلب
Sana → طلب
```

مع Debounce 400ms، ينتظر حتى يتوقف المستخدم قليلًا ثم يرسل طلبًا واحدًا. هذا:

- يقلل استهلاك الشبكة.
- يقلل احتمال الوصول لترتيب خاطئ.
- يحسّن الاستجابة.

**إضافة مهمة:** `_searchRequestId` يمنع نتيجة قديمة من استبدال نتيجة أحدث:

```dart
final requestId = ++_searchRequestId;
...
if (requestId != _searchRequestId) return;
```

---

## 9. Future وasync/await وFutureBuilder

> **هذا القسم مهم جدًا، وفيه توضيح صريح: المشروع لا يستخدم `FutureBuilder`.**

### 9.1 ما هي `Future`؟

`Future` كائن يمثل نتيجة عملية ستكتمل لاحقًا. مثال:

```dart
Future<Weather> fetchWeatherForCoords(...)
```

معناه: «أعطني وقتًا؛ سأعيد `Weather` عند الانتهاء».

**الحالات:**

- غير مكتمل (pending).
- مكتمل بنجاح (completed with value).
- مكتمل بخطأ (completed with error).

### 9.2 لماذا نحتاجها؟

لأن الشبكة وقاعدة البيانات تستغرق وقتًا. لو انتظرناها بشكل متزامن (synchronous)، ستتجمد الواجهة ولا يستجيب التطبيق.

### 9.3 الفرق بين متزامن وغير متزامن

| متزامن | غير متزامن |
|---|---|
| ينفذ سطرًا بعد سطر وينتظر | يبدأ العملية ويكمل، ثم يعود عند الانتهاء |
| قد يجمد الواجهة | يحافظ على استجابة الواجهة |
| مثال: `1 + 1` | مثال: `await http.get(...)` |

### 9.4 `async` و`await`

```dart
Future<void> loadWeather(String cityName) async {
  isLoading.value = true;
  try {
    final result = await _service.fetchWeatherForCity(cityName);
    weather.value = result;
  } catch (e) {
    ...
  } finally {
    isLoading.value = false;
  }
}
```

**سطر بسطر:**

| السطر | الشرح |
|---|---|
| `Future<void>` | الدالة ستنتهي لاحقًا، ولا تعيد قيمة. |
| `async` | تسمح باستخدام `await` وتحوّل الإرجاع إلى `Future`. |
| `isLoading.value = true` | تعرض مؤشر تحميل فورًا. |
| `await ...` | تنتظر نتيجة الشبكة؛ الواجهة تبقى حية. |
| `weather.value = result` | تخزين النتيجة في Rx. |
| `catch` | التعامل مع أي خطأ. |
| `finally` | إخفاء التحميل في كل الحالات. |

**مهم:** `await` لا تجمّد التطبيق؛ إنها تعلّق تنفيذ هذه الدالة فقط، ويعود حدث Flutter للعمل.

### 9.5 أين تُنشأ `Future` في المشروع؟

| المكان | الدالة | النوع |
|---|---|---|
| `weather_service.dart:18` | `searchLocations` | `Future<List<Location>>` |
| `weather_service.dart:53` | `fetchWeatherForCoords` | `Future<Weather>` |
| `weather_service.dart:84` | `fetchWeatherForCity` | `Future<Weather>` |
| `weather_controller.dart:35` | `loadWeather` | `Future<void>` |
| `weather_controller.dart:49` | `selectLocation` | `Future<void>` |
| `weather_controller.dart:65` | `refreshWeather` | `Future<void>` |
| `database_service.dart:11` | `database` | `Future<Database>` |
| `database_service.dart:36` | `insertNote` | `Future<int>` |
| `database_service.dart:42` | `fetchNotes` | `Future<List<Note>>` |
| `database_service.dart:48` | `updateNote` | `Future<int>` |
| `database_service.dart:54` | `deleteNote` | `Future<int>` |
| `notes_controller.dart:28` | `loadNotes` | `Future<void>` |
| `notes_controller.dart:40` | `addNote` | `Future<void>` |
| `notes_controller.dart:51` | `updateNote` | `Future<void>` |
| `notes_controller.dart:60` | `deleteNote` | `Future<void>` |

### 9.6 أين يتم استدعاؤها وانتظارها؟

- `WeatherController.onInit` يستدعي `loadWeather` دون `await` (لأنها بداية غير محجوبة).
- `WeatherScreen.initState` يستدعي `controller.loadWeather(...)`.
- `_refresh` يستخدم `await controller.refreshWeather()`.
- `HomeScreen._handleRefresh` يستخدم `await` للطقس والملاحظات.
- `NoteFormScreen._save` يستخدم `await _notesController.addNote/updateNote`.
- `NotesScreen._confirmDelete` يستخدم `await controller.deleteNote`.
- `WeatherSearchScreen._selectLocation` يستخدم `await controller.selectLocation`.
- `RefreshIndicator.onRefresh` يتوقع `Future<void>`، ولهذا تعيد دوال التحديث `Future<void>`.

### 9.7 هل يوجد `FutureBuilder`؟

**لا.** تم البحث في كل `lib` ولم يُعثر على `FutureBuilder`.

**كيف تعرض الواجهة النتائج إذن؟**

- عبر `Obx` مع Rx Variables.
- `controller.weather.value` تحدد: Skeleton أو محتوى أو خطأ.
- `controller.isLoading.value` تحدد مؤشر التحميل.

**مقارنة:**

| FutureBuilder (في `api_ex`) | النمط المستخدم هنا |
|---|---|
| `FutureBuilder<List<Post>>(future: _postsFuture, ...)` | `Obx(() { final w = controller.weather.value; ... })` |
| `snapshot.connectionState == waiting` | `controller.isLoading.value` |
| `snapshot.hasError` | `controller.errorMessage.value != null` |
| `snapshot.data` | `controller.weather.value` |
| يحتاج تخزين `Future` وإعادة إنشائه عند التحديث | المتحكم يحتفظ بالبيانات ويعيد الجلب |

**لماذا اختير هذا النمط؟** لأن GetX يدير الحالة أصلًا، والبيانات تُشارك بين الرئيسية وشاشة الطقس وشاشة البحث. لو استخدمنا `FutureBuilder` في كل شاشة، لربما أعدنا الطلب أو عرضنا حالات مختلفة.

### 9.8 ما هو `snapshot`؟

في `FutureBuilder` (غير المستخدم هنا):

- `snapshot.connectionState`: حالة الاتصال (`waiting`, `done`, `active`...).
- `snapshot.hasData`: هل وصلت بيانات؟
- `snapshot.hasError`: هل حدث خطأ؟
- `snapshot.data`: البيانات.
- `snapshot.error`: الخطأ.

**مثال من المادة المتاحة (`api_ex`):**

```dart
FutureBuilder<List<Post>>(
  future: _postsFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return ...;
    }
    final posts = snapshot.data ?? [];
    return ListView...;
  },
)
```

**لكنه ليس في مشروع Weather & Notes.** لا تنسبه للمشروع.

### 9.9 `ConnectionState.waiting` و`done`

- `waiting`: العملية لم تكتمل بعد.
- `done`: اكتملت (نجاح أو خطأ).
- `active`: في بعض الحالات، وخصوصًا مع `Stream`.

في مشروعنا لا نستخدم هذه الحالات؛ نستخدم `isLoading` و`errorMessage`.

### 9.10 التعامل مع الخطأ في `Future`

```dart
try {
  final result = await ...;
  ...
} catch (e) {
  errorMessage.value = ...;
} finally {
  isLoading.value = false;
}
```

**لماذا `finally`؟** لضمان إخفاء التحميل حتى لو فشل الطلب، وإلا سيبقى المؤشر ظاهرًا للأبد.

### 9.11 العلاقة بين `Future` و`FutureBuilder`

- `Future` = الوعد بالنتيجة.
- `FutureBuilder` = Widget يراقب الوعد ويعرض حالاته.

**لكن المشروع يفصل بينهما:** الخدمة ترجع `Future`، والمتحكم ينتظرها بـ`await`، والواجهة تراقب الحالة عبر `Obx`. هذا نمط بديل صحيح، وليس خطأً.

---

## 10. SQLite وsqflite وعمليات CRUD

### 10.1 ما هي قاعدة البيانات؟

قاعدة البيانات مكان منظم لتخزين البيانات واسترجاعها. هنا نحتاج حفظ الملاحظات حتى بعد إغلاق التطبيق.

### 10.2 SQLite وsqflite

- **SQLite:** محرك قاعدة بيانات صغير يعمل داخل التطبيق، ويحفظ البيانات في ملف.
- **sqflite:** حزمة Flutter تسمح لـDart بالتعامل مع SQLite.

**لماذا قاعدة محلية؟**

- لا تحتاج إنترنت.
- سريعة.
- مناسبة لبيانات المستخدم الخاصة.
- لا تحتاج سيرفر.

**الفرق عن قاعدة على السيرفر:**

| محلية | على السيرفر |
|---|---|
| داخل الجهاز | على جهاز بعيد |
| لا تحتاج شبكة | تحتاج شبكة |
| بيانات جهاز واحد | يمكن مشاركتها بين أجهزة |
| SQLite | MySQL/PostgreSQL... |

### 10.3 المفاهيم الأساسية

- **Database:** الملف الذي يحتوي الجداول.
- **Table:** جدول مثل `notes`.
- **Row:** صف = ملاحظة واحدة.
- **Column:** عمود = خاصية مثل `title`.
- **Primary Key:** عمود يميز كل صف؛ هنا `id`.

### 10.4 جدول `notes`

الكود الفعلي في `database_service.dart:23-31` يكتب اسم الجدول عبر متغير `_tableName`، وليس كلمة `notes` حرفيًا:

```dart
await db.execute('''
  CREATE TABLE $_tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  )
''');
```

وبما أن `_tableName = 'notes'`، فإن **SQL المكافئ** هو:

```sql
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
```

**لماذا `$_tableName`؟** لأن Dart يستبدل قيمة المتغير داخل النص (String Interpolation)، فيصبح اسم الجدول `notes` وقت التنفيذ. هذا يسهّل تغيير الاسم من مكان واحد.

**شرح:**

| العمود | النوع | معناه |
|---|---|---|
| `id` | `INTEGER` | معرف فريد. |
| `PRIMARY KEY` | قيد | لا يتكرر. |
| `AUTOINCREMENT` | قيد | يزيد تلقائيًا. |
| `title` | `TEXT` | عنوان الملاحظة. |
| `content` | `TEXT` | المحتوى. |
| `created_at` | `TEXT` | تاريخ الإنشاء بصيغة ISO. |
| `updated_at` | `TEXT` | تاريخ آخر تعديل. |
| `NOT NULL` | قيد | لا يقبل `null`. |

**لماذا النوع `TEXT` للتاريخ؟** لأن sqflite لا يدعم `DateTime` مباشرة؛ نخزنه كنص ISO 8601 عبر `toIso8601String()`، ونعيده بـ`DateTime.parse`.

### 10.5 إنشاء قاعدة البيانات وفتحها

**الملف:** `lib/services/database_service.dart:11-34`.

```dart
Future<Database> get database async {
  if (_database != null) return _database!;
  _database = await _initDatabase();
  return _database!;
}

Future<Database> _initDatabase() async {
  final path = join(await getDatabasesPath(), _dbName);
  return openDatabase(
    path,
    version: _dbVersion,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $_tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
    },
  );
}
```

**شرح سطر بسطر:**

| السطر | الشرح |
|---|---|
| `static Database? _database;` | مرجع واحد مشترك؛ `null` قبل الفتح. |
| `_dbName = 'weather_notes.db'` | اسم الملف. |
| `_dbVersion = 1` | إصدار المخطط. |
| `get database` | getter غير متزامن. |
| `if (_database != null) return _database!;` | إن كانت مفتوحة، أعدها فورًا (Singleton). |
| `_database = await _initDatabase();` | وإلا افتحها. |
| `getDatabasesPath()` | مسار قواعد البيانات على الجهاز. |
| `join(...)` | يدمج المسار واسم الملف بشكل صحيح. |
| `openDatabase(...)` | يفتح/ينشئ. |
| `onCreate` | يُنفّذ مرة واحدة عند أول إنشاء. |
| `db.execute(...)` | ينفذ SQL. |

**لماذا `static`؟** لأن `DatabaseService` يُنشأ في `NotesController` مرة واحدة هنا، لكن `static` يضمن أن أي نسخة أخرى تشارك نفس الاتصال إن وُجدت.

**ملاحظة:** لا يوجد `onUpgrade` هنا. لو تغير المخطط لاحقًا، يجب زيادة `_dbVersion` وإضافة ترحيل.

### 10.6 CRUD

#### CREATE: إضافة ملاحظة

```dart
Future<int> insertNote(Note note) async {
  final db = await database;
  final map = note.toMap()..remove('id');
  return db.insert(_tableName, map);
}
```

**شرح:**

- `await database`: تأكد أن القاعدة مفتوحة.
- `note.toMap()`: يحوّل الكائن إلى `Map`.
- `..remove('id')`: يحذف `id` لأن SQLite سينشئه.
- `db.insert`: ينفذ `INSERT`.
- يعيد `int`: رقم الصف الجديد.

**SQL المكافئ:**

```sql
INSERT INTO notes (title, content, created_at, updated_at)
VALUES (?, ?, ?, ?);
```

#### READ: قراءة الملاحظات

```dart
Future<List<Note>> fetchNotes() async {
  final db = await database;
  final maps = await db.query(_tableName, orderBy: 'updated_at DESC');
  return maps.map((m) => Note.fromMap(m)).toList();
}
```

**شرح:**

- `query`: `SELECT * FROM notes`.
- `orderBy: 'updated_at DESC'`: الأحدث تعديلًا أولًا.
- `maps.map(...)`: يحوّل كل صف إلى `Note`.
- `toList()`: يعيد قائمة.

#### UPDATE: تعديل ملاحظة

```dart
Future<int> updateNote(Note note) async {
  final db = await database;
  final map = note.toMap()..remove('id');
  return db.update(_tableName, map, where: 'id = ?', whereArgs: [note.id]);
}
```

**شرح:**

- `where: 'id = ?'`: شرط التحديث.
- `whereArgs: [note.id]`: القيمة التي تُوضع مكان `?` (حماية من SQL Injection).
- يعيد عدد الصفوف المتأثرة.

#### DELETE: حذف ملاحظة

```dart
Future<int> deleteNote(int id) async {
  final db = await database;
  return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
}
```

**شرح:**

- يحذف الصف المطابق.
- يعيد عدد الصفوف المحذوفة.

### 10.7 كيف تبقى الملاحظات محفوظة؟

- SQLite يخزن البيانات في ملف دائم داخل التطبيق.
- عند إغلاق التطبيق، الملف يبقى.
- عند إعادة الفتح، `getDatabasesPath()` يعيد نفس المسار.
- `NotesController.onInit` يستدعي `loadNotes` فيقرأها من الملف.

**دورة الحفظ:**

```text
NoteFormScreen._save
  → NotesController.addNote
    → DatabaseService.insertNote
      → SQLite INSERT
  → NotesController.loadNotes
    → SELECT
  → notes.assignAll
    → Obx يعيد بناء ListView
  → Get.back(true)
  → NotesScreen تعرض Snackbar
```

### 10.8 لماذا نعيد `loadNotes` بعد كل عملية؟

```dart
await _service.insertNote(...);
await loadNotes();
```

- لضمان أن الواجهة تعرض ما هو موجود فعليًا في قاعدة البيانات (source of truth).
- بديل كان ممكنًا: تعديل قائمة `notes` محليًا. لكن إعادة القراءة أبسط وأكثر أمانًا.

### 10.9 ما غير المستخدم في قاعدة البيانات؟

- `onUpgrade`: غير مستخدم.
- `transaction`: غير مستخدم في المشروع (ظهر في `my_expenses`).
- `batch`: غير مستخدم.
- `rawQuery`: غير مستخدم في المشروع.
- `path_provider`: غير مستخدم؛ نعتمد `getDatabasesPath()` من sqflite.
- `foreign keys`: غير مستخدمة.

---

## 11. Models وتحويل البيانات

### 11.1 لماذا ننشئ Model؟

بدل تمرير `Map<String, dynamic>` في كل التطبيق:

- نحصل على نوع واضح (`Weather`, `Note`).
- يمنع أخطاء الأسماء المطبعية.
- يجمع التحويل في مكان واحد.
- يسهّل الاختبار والصيانة.

### 11.2 `Weather` و`DailyForecast`

**الملف:** `lib/models/weather.dart`.

- `Weather` يمثل الطقس الحالي + قائمة التوقعات.
- `DailyForecast` يمثل يومًا واحدًا.

**منشئ `Weather`:**

```dart
Weather({
  required this.cityName,
  required this.temperature,
  required this.feelsLike,
  required this.humidity,
  required this.windSpeed,
  required this.weatherCode,
  required this.lastUpdated,
  this.tempMax,
  this.tempMin,
  this.forecast = const [],
});
```

**ملاحظة:** `lastUpdated` لم يأتِ من API؛ يُضبط بـ`DateTime.now()` عند التحويل (السطر 55).

**`fromJson`:**

```dart
factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
  final current = json['current'] as Map<String, dynamic>;
  final daily = json['daily'] as Map<String, dynamic>?;

  final dailyList = <DailyForecast>[];
  if (daily != null) {
    ...
  }

  return Weather(
    cityName: cityName,
    temperature: (current['temperature_2m'] as num).toDouble(),
    ...
  );
}
```

**شرح:**

- `factory`: مُنشئ خاص يعيد كائنًا، وليس بالضرورة `new`.
- `current`: الجزء الحالي من JSON.
- `daily`: قد يكون `null`.
- `dailyList`: تجميع التوقعات.
- `cityName` يُمرَّر يدويًا لأن API لا يعيد اسمًا عربيًا بالضرورة؛ نستخدم الاسم المختار.
- `lastUpdated`: وقت الجهاز.

**لماذا `as num`؟** JSON قد يعيد `23` (int) أو `23.5` (double)؛ `num` يستوعب الاثنين ثم `.toDouble()`.

**الدوال المساعدة:**

```dart
String get description => weatherDescription(weatherCode);
String get icon => weatherIcon(weatherCode);
```

- `get` خصائص محسوبة؛ لا تُخزَّن، بل تُحسب عند القراءة.
- `weatherDescription` يحوّل كود Open-Meteo إلى نص عربي.
- `weatherIcon` يحوّله إلى إيموجي.

### 11.3 `Location`

**الملف:** `lib/models/location.dart`.

**`fromJson`:**

```dart
factory Location.fromJson(Map<String, dynamic> json) {
  return Location(
    id: (json['id'] as num).toInt(),
    name: json['name'] as String,
    admin1: json['admin1'] as String?,
    admin2: json['admin2'] as String?,
    country: json['country'] as String?,
    countryCode: json['country_code'] as String?,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
}
```

- `admin1` و`admin2` و`country` قد تكون `null`.
- `country_code` يُستخدم لتوليد علم الدولة.

**خصائص محسوبة:**

- `region`: يعيد `admin1` أو `admin2` أو `null`.
- `subtitle`: يدمج المنطقة والدولة بفاصلة عربية.
- `flag`: يحوّل رمز الدولة إلى إيموجي علم.

**كيف يعمل `flag`؟**

```dart
final first = code.codeUnitAt(0) - 0x41 + 0x1F1E6;
```

يحوّل حرف الدولة (مثل `S`) إلى رمز إيموجي إقليمي؛ هذه طريقة يونيكود لبناء الأعلام.

### 11.4 `Note`

**الملف:** `lib/models/note.dart`.

- لا يوجد `fromJson`؛ لأن الملاحظات لا تأتي من API.
- يوجد `fromMap` و`toMap` للتعامل مع SQLite.
- يوجد `copyWith` لإنشاء نسخة معدلة.

**`toMap`:**

```dart
Map<String, dynamic> toMap() => {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
```

- يحوّل الحقول إلى أسماء الأعمدة.
- `DateTime` → `String`.

**`fromMap`:**

```dart
factory Note.fromMap(Map<String, dynamic> map) => Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
```

- `String` → `DateTime`.

**`copyWith`:**

```dart
Note copyWith({...}) {
  return Note(
    id: id ?? this.id,
    title: title ?? this.title,
    ...
  );
}
```

- إذا مررت قيمة، استخدمها؛ وإلا احتفظ بالقديمة.
- `??` تعني «إن كانت `null` استخدم اليمين».

**ملاحظة مهمة:** `id: id ?? this.id` لا يسمح بجعل `id` فارغًا عمدًا، لكن هذا لا نحتاجه هنا.

### 11.5 هل يوجد `toJson`؟

**لا** داخل `lib`. يوجد `toMap` فقط لـSQLite.

**الفرق:**

| `toJson` | `toMap` |
|---|---|
| عادة للـAPI | هنا لقاعدة البيانات |
| أسماء JSON | أسماء أعمدة SQL |
| غير موجود في المشروع | موجود في `Note` |

المادة `api_ex` تحتوي `Post.toJson`، لكن المشروع لا يستخدمه لأن التطبيق لا يرسل ملاحظات إلى سيرفر.

---

## 12. الحزم والمكتبات المستخدمة

**الملف:** `pubspec.yaml:30-55`.

| الحزمة | الإصدار | الوظيفة | أين تظهر؟ | نوعها |
|---|---|---|---|---|
| `flutter` | SDK | إطار العمل | كل الملفات | أساسية |
| `cupertino_icons` | `^1.0.8` | أيقونات iOS | **معلنة لكن غير مستوردة مباشرة** | مساعدة |
| `get` | `^4.7.3` | حالة + تنقل + رسائل | `main`, controllers, screens | أساسية |
| `http` | `^1.6.0` | طلبات HTTP | `weather_service.dart` | أساسية |
| `sqflite` | `^2.4.6` | SQLite | `database_service.dart` | أساسية |
| `path` | `^1.9.1` | دمج المسارات | `database_service.dart:18` | مساعدة |
| `intl` | `^0.20.3` | تنسيق التواريخ | `main`, `weather_screen`, `notes_screen` | مساعدة |
| `flutter_localizations` | SDK | ترجمة Material | `main.dart` | أساسية للعربية |
| `shimmer` | `^4.0.0` | تأثير لمعان Skeleton | `skeleton_widgets.dart` | مساعدة |
| `flutter_test` | SDK | اختبارات | `test/` | تطوير |
| `flutter_lints` | `^6.0.0` | قواعد تحليل | `analysis_options.yaml` | تطوير |

**حزم غير موجودة:**

- `path_provider` (غير مستخدمة؛ المسار من `getDatabasesPath`)
- `provider` (ظهرت في مثال `statesmang` فقط)
- `dio` (نستخدم `http`)
- `shared_preferences` (لا)
- `hive` (لا)

**`cupertino_icons`:** لا يوجد `import 'package:cupertino_icons/...'` في `lib`؛ الحزمة تأتي مع قالب Flutter لكن المشروع لا يستخدم `CupertinoIcons` فعليًا.

---

## 13. مسارات التنفيذ الكاملة الثمانية

### المسار الأول: تشغيل التطبيق

```text
main()
  ├─ WidgetsFlutterBinding.ensureInitialized()
  ├─ await initializeDateFormatting('ar', null)
  └─ runApp(MyApp())
       └─ MyApp.build
            └─ GetMaterialApp(home: HomeScreen)
                 └─ HomeScreen.initState
                      ├─ Get.put(WeatherController, permanent: true)
                      │    └─ WeatherController.onInit
                      │         └─ loadWeather('صنعاء')
                      └─ Get.put(NotesController, permanent: true)
                           └─ NotesController.onInit
                                └─ loadNotes()
                 └─ HomeScreen.build
                      ├─ GlassBackground
                      ├─ PageView(children: [_HomeTab, WeatherScreen, NotesScreen])
                      └─ FloatingNavBar
```

**بالتفصيل:**

1. `main.dart:8` يبدأ التنفيذ.
2. `main.dart:9` يهيئ Flutter.
3. `main.dart:10` يحمّل بيانات التاريخ العربي.
4. `main.dart:11` يستدعي `runApp`.
5. `main.dart:19` ينشئ `GetMaterialApp`.
6. `main.dart:23` يحدد `HomeScreen`.
7. `home_screen.dart:28` `initState` يسجل المتحكمين.
8. `weather_controller.dart:24` `onInit` يبدأ جلب الطقس.
9. `notes_controller.dart:23` `onInit` يبدأ قراءة الملاحظات.
10. `home_screen.dart:56` يبني `Scaffold` والخلفية والـ`PageView`.
11. `home_screen.dart:158` بطاقة الطقس تعرض Skeleton ثم البيانات.
12. `home_screen.dart:253` بطاقة الملاحظات تعرض العدد.

**ملاحظة:** الجلب والقراءة غير متزامنين؛ لذلك تظهر الواجهة أولًا ثم تُحدَّث.

---

### المسار الثاني: جلب بيانات الطقس

**نقطة البداية:** `WeatherController.onInit` أو `WeatherScreen.initState` أو زر التحديث.

```text
loadWeather(cityName)
  ├─ isLoading = true
  ├─ errorMessage = null
  ├─ await WeatherService.fetchWeatherForCity(cityName)
  │    ├─ searchLocations(cityName)
  │    │    ├─ GET geocoding API
  │    │    ├─ JSON → List<Location>
  │    │    └─ return list (or [])
  │    ├─ if empty → throw Exception
  │    └─ fetchWeatherForCoords(first.lat, first.lon, first.name)
  │         ├─ GET forecast API
  │         ├─ JSON → Weather.fromJson
  │         └─ return Weather
  ├─ weather.value = result
  ├─ currentCity.value = result.cityName
  ├─ catch → errorMessage.value
  └─ finally → isLoading = false
```

**ماذا يرى المستخدم؟**

- `isLoading = true` → قد يظهر شريط تقدم/مؤشر.
- عند النجاح → البطاقة الرئيسية ودرجة الحرارة.
- عند الفشل → `AppErrorWidget` أو `_ErrorBanner`.

**الملفات:**

- `weather_controller.dart:35-47`
- `weather_service.dart:84-91` ثم `18-51` و`53-82`
- `weather.dart:26-58`
- `weather_screen.dart:60-78`
- `home_screen.dart:158-251`

---

### المسار الثالث: البحث عن المدن

```text
WeatherScreen: زر البحث
  → Get.to(WeatherSearchScreen)
    → initState: controller.clearSearch()
    → المستخدم يكتب
    → TextField.onChanged = controller.onSearchChanged
      ├─ إذا فارغ → _cancelAndClear
      ├─ إذا < 2 → رسالة
      └─ Debounce 400ms
           → _performSearch(query)
             ├─ requestId++
             ├─ isSearching = true
             ├─ await WeatherService.searchLocations
             │    ├─ GET geocoding API
             │    └─ JSON → List<Location>
             ├─ تجاهل نتيجة قديمة
             ├─ searchResults.assignAll
             └─ isSearching = false
    → Obx يعرض LoadingWidget / رسالة / ListView
    → المستخدم يضغط _SuggestionTile
      → Get.back()
      → await controller.selectLocation(loc)
        → fetchWeatherForCoords(lat, lon, name)
        → weather.value = result
    → العودة إلى WeatherScreen مع البيانات الجديدة
```

**ملفات:**

- `weather_search_screen.dart:34-37`, `93-156`, `175-233`
- `weather_controller.dart:69-130`
- `weather_service.dart:18-51`

---

### المسار الرابع: إضافة ملاحظة

```text
NotesScreen: FloatingActionButton
  → _openForm() [note = null]
    → Get.to<bool>(NoteFormScreen(note: null))
      → initState: حقول فارغة
      → المستخدم يكتب
      → يضغط حفظ
        → _save()
          ├─ _formKey.currentState!.validate()
          ├─ setState(_isSaving = true)
          ├─ _isEditing == false
          ├─ await NotesController.addNote(title, content)
          │    ├─ DateTime.now()
          │    ├─ Note(...)
          │    ├─ DatabaseService.insertNote
          │    │    ├─ database
          │    │    ├─ toMap + remove id
          │    │    └─ db.insert
          │    └─ loadNotes
          │         └─ fetchNotes → notes.assignAll
          ├─ Get.back<bool>(result: true)
          └─ finally _isSaving = false
    → NotesScreen تستقبل true
      → Get.snackbar('تم الحفظ', ...)
```

**قاعدة البيانات:**

```sql
INSERT INTO notes (title, content, created_at, updated_at) VALUES (?, ?, ?, ?);
```

**ملفات:**

- `notes_screen.dart:98-128`
- `note_form_screen.dart:42-69`
- `notes_controller.dart:40-49`
- `database_service.dart:36-40`

---

### المسار الخامس: قراءة الملاحظات

```text
NotesController.onInit
  → loadNotes()
    ├─ isLoading = true
    ├─ await DatabaseService.fetchNotes()
    │    ├─ await database
    │    ├─ db.query('notes', orderBy: 'updated_at DESC')
    │    └─ maps.map(Note.fromMap).toList()
    ├─ notes.assignAll(list)
    └─ isLoading = false
  → NotesScreen Obx
    ├─ إذا loading والقائمة فارغة → NotesSkeleton
    ├─ إذا فارغة → _EmptyState
    └─ وإلا → ListView.builder(_NoteCard)
```

**الاستعلام:**

```sql
SELECT * FROM notes ORDER BY updated_at DESC;
```

**ماذا لو أعدنا فتح التطبيق؟**

- نفس ملف SQLite موجود.
- `loadNotes` يقرأ نفس الصفوف.
- تظهر الملاحظات السابقة.

**ملفات:**

- `notes_controller.dart:22-38`
- `database_service.dart:42-46`
- `notes_screen.dart:62-94`
- `note.dart:24-30`

---

### المسار السادس: تعديل ملاحظة

```text
NotesScreen: زر التعديل
  → _openForm(note)
    → Get.to<bool>(NoteFormScreen(note: note))
      → initState: تعبئة الحقول من note
      → المستخدم يعدل
      → يضغط حفظ
        → _save()
          ├─ validate
          ├─ _isEditing == true
          ├─ await NotesController.updateNote(note, title, content)
          │    ├─ note.copyWith(title, content, updatedAt: now)
          │    ├─ DatabaseService.updateNote
          │    │    └─ db.update(... where id = ?)
          │    └─ loadNotes
          ├─ Get.back<bool>(result: true)
          └─ NotesScreen تعرض Snackbar
```

**الاستعلام:**

```sql
UPDATE notes
SET title = ?, content = ?, created_at = ?, updated_at = ?
WHERE id = ?;
```

**ملاحظة:** `createdAt` يبقى كما هو لأن `copyWith` لا يغيّره، و`updatedAt` يتغير.

**ملفات:**

- `notes_screen.dart:86`, `110-128`
- `note_form_screen.dart:47-49`
- `notes_controller.dart:51-58`
- `note.dart:32-46`
- `database_service.dart:48-52`

---

### المسار السابع: حذف ملاحظة

```text
NotesScreen: زر الحذف
  → _confirmDelete(note)
    → Get.dialog(AlertDialog)
      ├─ "لا" → Get.back() (إغلاق فقط)
      └─ "نعم"
           ├─ Get.back()
           ├─ if note.id == null return
           ├─ await NotesController.deleteNote(note.id!)
           │    ├─ DatabaseService.deleteNote
           │    │    └─ db.delete(where id = ?)
           │    └─ loadNotes
           └─ عند الخطأ → Snackbar
```

**الاستعلام:**

```sql
DELETE FROM notes WHERE id = ?;
```

**لماذا نتحقق من `note.id == null`؟** لأن الملاحظة غير المحفوظة لا `id` لها، ولا يمكن حذفها من القاعدة.

**ملفات:**

- `notes_screen.dart:130-162`
- `notes_controller.dart:60-63`
- `database_service.dart:54-57`

---

### المسار الثامن: التنقل بين الصفحات

#### التنقل الرئيسي (التبويبات)

```text
FloatingNavBar.onTap(i)
  → HomeScreen._onTabTap(i)
    ├─ if i == current → return
    ├─ setState(_currentIndex = i)
    └─ PageController.animateToPage(i)
         → PageView يعرض الصفحة i
```

**الصفحات:** `_HomeTab` (0)، `WeatherScreen` (1)، `NotesScreen` (2).

**لماذا `NeverScrollableScrollPhysics`؟** `home_screen.dart:62` يمنع السحب اليدوي بين الصفحات، ويجعل التنقل عبر الشريط فقط.

#### التنقل الفرعي (GetX)

- `WeatherScreen` → `Get.to(WeatherSearchScreen)`.
- `NotesScreen` → `Get.to<bool>(NoteFormScreen)`.
- العودة: `Get.back()`.
- العودة بنتيجة: `Get.back<bool>(result: true)`.

#### زر الرجوع في AppBar

`AppBar` يعرض سهم رجوع تلقائيًا عندما تكون الشاشة مفتوحة عبر `Get.to`، ويعمل مع GetX.

#### لماذا طريقتان؟

- `PageView` للتنقل الدائم بين الأقسام الثلاثة (بدون بناء مسار جديد).
- `Get.to` للشاشات الفرعية المؤقتة (بحث/نموذج).

---

## 14. جدول متطلبات المنهج مقابل المشروع

> **قراءة الجدول:** عمود «ما تعلمناه» يشير إلى ما ظهر في الأمثلة المتاحة، وليس إلى نص صريح من الأستاذة. عمود «الحالة» يصف المشروع الحالي.

| المفهوم المطلوب | ما تعلمناه عنه؟ | أين استخدمناه في المشروع؟ | الملف والدالة | حالة التطبيق |
|---|---|---|---|---|
| Variables | `var/final/const` في أمثلة Flutter | حقول وألوان وثوابت | `app_colors.dart`, `note.dart` | مطبق بالكامل |
| Data Types | `String/int/double/bool` | حقول النماذج | `weather.dart`, `note.dart` | مطبق بالكامل |
| List | قوائم في أمثلة API/Flutter | التوقعات، الملاحظات، نتائج البحث | `weather.dart`, `notes_controller.dart` | مطبق بالكامل |
| Map | `toMap` في `my_expenses` | JSON وSQLite | `note.dart`, `weather.dart` | مطبق بالكامل |
| Functions | دوال في كل الأمثلة | الخدمات والمتحكمات | `weather_service.dart` | مطبق بالكامل |
| Parameters/Return | دوال بمعاملات وقيم إرجاع | `loadWeather`, `insertNote` | المتحكمات والخدمات | مطبق بالكامل |
| Classes/Objects | النماذج في `api_ex` | `Weather`, `Note`, `Location` | `models/` | مطبق بالكامل |
| Constructors | `Post(...)` في `api_ex` | منشئات النماذج | `weather.dart:13` | مطبق بالكامل |
| Null Safety | `?` في أمثلة API | `Rxn`, `String?`, `int?` | `weather_controller.dart`, `note.dart` | مطبق بالكامل |
| Conditionals | `if` في كل الأمثلة | التحقق من الحالة والأخطاء | `weather_service.dart` | مطبق بالكامل |
| Loops | `for` في أمثلة SQL/Flutter | بناء التوقعات | `weather.dart:36` | مطبق بالكامل |
| Import/Export | `import` في كل الأمثلة | كل الملفات | كل الملفات | Import مطبق، Export غير مستخدم |
| async/await | في `api_ex` | كل عمليات الشبكة وSQLite | المتحكمات والخدمات | مطبق بالكامل |
| Future | `Future<Post>` في `api_ex` | خدمات ومتحكمات | `weather_service.dart` | مطبق بالكامل |
| main/runApp | القالب الافتراضي | بداية التطبيق | `main.dart:8-12` | مطبق بالكامل |
| MaterialApp | القالب الافتراضي | استُبدل بـ`GetMaterialApp` | `main.dart:19` | مطبق جزئيًا (نسخة GetX) |
| Scaffold | كل الأمثلة | كل الشاشات | الشاشات | مطبق بالكامل |
| StatelessWidget | `MyApp` في القالب | بطاقات ومكونات | `glass_card.dart` | مطبق بالكامل |
| StatefulWidget | القالب الافتراضي | الشاشات والنماذج | `home_screen.dart` | مطبق بالكامل |
| build() | كل الأمثلة | كل الـWidgets | كل الملفات | مطبق بالكامل |
| BuildContext | `build(context)` | MediaQuery/Theme | الشاشات | مطبق بالكامل |
| Widget Tree | ضمني في كل مثال | كل الواجهة | `main.dart` | مطبق بالكامل |
| Column/Row | القالب الافتراضي | تخطيط البطاقات | `home_screen.dart` | مطبق بالكامل |
| Container | أمثلة Flutter | أيقونة الملاحظات | `home_screen.dart:260` | مطبق بالكامل |
| Padding | أمثلة Flutter | كل البطاقات | `glass_card.dart:191` | مطبق بالكامل |
| Margin | غير بارز كمكوّن مستقل | المسافات عبر `SizedBox`/`EdgeInsets` | عدة ملفات | غير مستخدم كمكوّن مستقل |
| Expanded/Flexible | أمثلة التخطيط | البطاقات والنصوص | `notes_screen.dart:235` | مطبق بالكامل |
| ListView | أمثلة القوائم | قائمة الملاحظات | `notes_screen.dart:72` | مطبق بالكامل |
| SingleChildScrollView | أمثلة النماذج | صفحات طويلة | `weather_screen.dart:123` | مطبق بالكامل |
| TextField | أمثلة النماذج | البحث والنموذج | `weather_search_screen.dart:55` | مطبق بالكامل |
| Buttons | القالب الافتراضي | كل الإجراءات | `app_button.dart` | مطبق بالكامل |
| Navigator | القالب الافتراضي | لم يُستخدم مباشرة | — | غير مستخدم (GetX بديل) |
| GetX Navigation | `ex_getx` | `Get.to/back` | `weather_screen.dart:43` | مطبق بالكامل |
| setState | القالب الافتراضي | التبويب وحالة الحفظ | `home_screen.dart:46` | مطبق بالكامل |
| GetMaterialApp | `ex_getx` | جذر التطبيق | `main.dart:19` | مطبق بالكامل |
| GetxController | `ex_getx` | متحكما الطقس والملاحظات | `controllers/` | مطبق بالكامل |
| Get.put | `ex_getx` | تسجيل المتحكمين | `home_screen.dart:31` | مطبق بالكامل |
| Get.find | `ex_getx` | الوصول للمتحكمين | الشاشات | مطبق بالكامل |
| Obx | `ex_getx` | كل عرض تفاعلي | الشاشات | مطبق بالكامل |
| Rx Variables | `RxInt` في `ex_getx` | `Rxn`, `.obs`, `RxnString` | `controllers/` | مطبق بالكامل |
| Get.to/Get.back | `ex_getx` | البحث والنموذج | `notes_screen.dart` | مطبق بالكامل |
| Get.dialog/snackbar | لم يظهر بنفس الشكل | تأكيد الحذف والرسائل | `notes_screen.dart` | مطبق بالكامل |
| GetBuilder/GetX widget | `ex_getx` (تعليقات) | غير مستخدم | — | غير مستخدم |
| Provider/ChangeNotifier | `statesmang` | غير مستخدم | — | غير مستخدم في المشروع |
| API/HTTP GET | `api_ex` | Open-Meteo | `weather_service.dart` | مطبق بالكامل |
| JSON | `api_ex` | `jsonDecode` | `weather_service.dart` | مطبق بالكامل |
| Model.fromJson | `Post.fromJson` | `Weather.fromJson`, `Location.fromJson` | `models/` | مطبق بالكامل (Note يستخدم fromMap) |
| Model.toJson | `Post.toJson` | غير موجود | — | غير مستخدم |
| Error Handling | `try/catch` في `api_ex` | الشبكة والحفظ | `weather_service.dart` | مطبق بالكامل |
| FutureBuilder | `api_ex` | غير مستخدم | — | غير مستخدم |
| snapshot/ConnectionState | `api_ex` | غير مستخدم | — | غير مستخدم |
| SQLite | `my_expenses` | قاعدة الملاحظات | `database_service.dart` | مطبق بالكامل |
| sqflite | `my_expenses` | فتح/CRUD | `database_service.dart` | مطبق بالكامل |
| onCreate | `my_expenses` | إنشاء الجدول | `database_service.dart:22` | مطبق بالكامل |
| onUpgrade | `my_expenses` | غير مستخدم | — | غير مستخدم |
| CRUD Insert | `my_expenses` | إضافة ملاحظة | `database_service.dart:36` | مطبق بالكامل |
| CRUD Select | `my_expenses` | قراءة الملاحظات | `database_service.dart:42` | مطبق بالكامل |
| CRUD Update | `my_expenses` | تعديل ملاحظة | `database_service.dart:48` | مطبق بالكامل |
| CRUD Delete | `my_expenses` | حذف ملاحظة | `database_service.dart:54` | مطبق بالكامل |
| Transactions | `my_expenses` | غير مستخدم | — | غير مستخدم |
| Batch | `my_expenses` | غير مستخدم | — | غير مستخدم |
| Path | `my_expenses` | دمج مسار القاعدة | `database_service.dart:18` | مطبق بالكامل |
| path_provider | لم يظهر في المشروع | غير مستخدم | — | غير موجود في الحزم |
| intl/DateFormat | غير بارز في الأمثلة | تنسيق التواريخ | `weather_screen.dart:161` | مطبق بالكامل |
| shimmer | غير بارز | Skeleton | `skeleton_widgets.dart` | مطبق بالكامل |

**ملاحظة عن الحالة:** «مطبق جزئيًا» تعني أن الفكرة موجودة بصيغة بديلة، مثل `GetMaterialApp` بدل `MaterialApp`. «غير مستخدم» تعني أن الكود غير موجود، وليس عيبًا بالضرورة.

---

## 15. ملخص سريع للمناقشة

إذا كان لديك دقيقتان فقط قبل المناقشة، تذكّر:

1. **نقطة البداية:** `main.dart` → `GetMaterialApp` → `HomeScreen`.
2. **الحالة:** GetX (`Get.put` → `Get.find` → `Obx`).
3. **الطقس:** `WeatherService` → HTTP GET → JSON → `Weather.fromJson` → `weather.value`.
4. **الملاحظات:** `NotesController` → `DatabaseService` → SQLite CRUD → `notes.assignAll`.
5. **الواجهة:** بطاقات زجاجية `GlassCard`، تنقل `PageView` + `FloatingNavBar`، شاشات فرعية `Get.to`.
6. **المهم:** `FutureBuilder` و`Provider` و`toJson` و`path_provider` **غير مستخدمة** في المشروع الحالي.
7. **المنهج:** لا توجد ملفات منهج رسمية داخل المشروع؛ الأمثلة الخارجية هي الدليل المتاح.

---

### انتهى الدليل الرئيسي

> راجع `Project_Files_Reference.md` لشرح كل ملف، و`Teacher_Questions_and_Answers.md` للأسئلة التفصيلية.
