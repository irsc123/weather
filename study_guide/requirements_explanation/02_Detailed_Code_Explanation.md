# 02 — الشرح التفصيلي للأكواد ومسارات التنفيذ

> **المشروع:** Weather & Notes — `C:\flutter_app\weather_notes`
>
> **الهدف:** شرح المفاهيم المطلوبة من خلال الكود الفعلي فقط، مع بيان مكان كل مفهوم ووظيفته وطريقة عمله.
>
> **قاعدة مهمة:** كل مقتطف أدناه منسوخ من المشروع الحالي، وكل رقم سطر تم التحقق منه. إذا لم يكن المفهوم موجودًا، سيُقال ذلك صراحة.

---

## 1. خريطة المشروع والطبقات

```text
lib/
├── main.dart                         نقطة البداية + GetMaterialApp
├── theme.dart                        الثيم
├── constants/
│   ├── app_colors.dart               الألوان
│   └── app_strings.dart              النصوص
├── models/
│   ├── weather.dart                  Weather + DailyForecast + fromJson
│   ├── location.dart                 Location + fromJson
│   └── note.dart                     Note + toMap/fromMap/copyWith
├── services/
│   ├── weather_service.dart          HTTP + JSON + Open-Meteo
│   └── database_service.dart         SQLite + CRUD
├── controllers/
│   ├── weather_controller.dart       حالة الطقس + البحث + Future
│   └── notes_controller.dart         حالة الملاحظات + CRUD + Future
├── screen/
│   ├── home_screen.dart              التبويبات + بطاقات مختصرة
│   ├── weather_screen.dart           FutureBuilder للطقس
│   ├── weather_search_screen.dart    البحث + Obx
│   ├── notes_screen.dart             FutureBuilder + Obx + CRUD UI
│   └── note_form_screen.dart         إضافة/تعديل + Form
└── widgets/                          مكونات واجهة مشتركة
```

### 1.1 تدفق الطبقات

```text
الواجهة (Screen/Widget)
   │ تقرأ الحالة أو تعرض FutureBuilder
   ▼
المتحكم (GetxController)
   │ يطلب البيانات ويحفظ الحالة
   ▼
الخدمة (Service)
   ├── WeatherService  ──HTTP──► Open-Meteo
   └── DatabaseService ──SQL───► SQLite
   │
   ▼
النموذج (Model)
   └── JSON/Map → كائن Dart
```

**الفكرة:** الواجهة لا تعرف `http` ولا SQL، والخدمة لا تعرف `Obx` ولا `BuildContext`. هذا الفصل هو سبب وجود الطبقات.

---

## 2. فحص الحزم: ما هو مستخدم فعلًا؟

**الملف:** `pubspec.yaml:30-55`.

| الحزمة | مذكورة؟ | مستخدمة فعليًا؟ | الدليل |
|---|---|---|---|
| `get` | نعم | نعم | `main.dart:3`، `weather_controller.dart:2`، `notes_controller.dart:1` |
| `http` | نعم | نعم | `weather_service.dart:4` و`30` و`66` |
| `sqflite` | نعم | نعم | `database_service.dart:1` و`19` |
| `path` | نعم | نعم | `database_service.dart:2` و`18` (`join`) |
| `intl` | نعم | نعم | `main.dart:4`، `weather_screen.dart:3`، `notes_screen.dart:3` |
| `flutter_localizations` | نعم | نعم | `main.dart:2` و`27-31` |
| `shimmer` | نعم | نعم | `skeleton_widgets.dart:2` و`22` |
| `cupertino_icons` | نعم | **لا يوجد استيراد مباشر في `lib`** | لا يوجد `import 'package:cupertino_icons/...'` |
| `flutter_test` | نعم (dev) | الاختبار الحالي placeholder فقط | `test/widget_test.dart` |
| `flutter_lints` | نعم (dev) | نعم | `analysis_options.yaml` |

**مهم:** وجود `http` أو `sqflite` في `pubspec.yaml` وحده لا يثبت الاستخدام؛ لكن المشروع يحتوي استدعاءات فعلية كما هو موضح في الأقسام التالية.

**Riverpod / Provider:** غير موجودين في `pubspec.yaml` أصلًا.

---

## 3. المفهوم الأول: API والاتصال بالإنترنت

### 3.1 الاسم

**API** (واجهة برمجة التطبيقات) — **HTTP GET** — **JSON**.

### 3.2 التعريف

الـAPI وسيلة يطلب بها التطبيق بيانات من خدمة خارجية. يرسل التطبيق طلب HTTP إلى رابط، ويعيد الخادم استجابة غالبًا بصيغة JSON.

### 3.3 لماذا نستخدمه؟

لأن بيانات الطقس تتغير باستمرار، ولا يمكن تخزينها مسبقًا داخل التطبيق. نحتاج مصدرًا خارجيًا يعطينا:

- حالة الطقس الحالية.
- توقعات الأيام القادمة.
- إحداثيات المدينة عند البحث عنها.

### 3.4 مكانه في المشروع

**الملف:** `lib/services/weather_service.dart`

**الكلاس:** `WeatherService`

**الدوال:**

| الدالة | السطر | الوظيفة |
|---|---:|---|
| `WeatherService(...)` | 11 | إنشاء `http.Client` |
| `searchLocations` | 18 | البحث عن مدينة |
| `fetchWeatherForCoords` | 53 | جلب الطقس بالإحداثيات |
| `fetchWeatherForCity` | 84 | البحث عن مدينة ثم جلب طقسها |

### 3.5 الكود الحقيقي: البحث عن مدينة

```dart
Future<List<Location>> searchLocations(String query) async {
  final trimmed = query.trim();
  if (trimmed.length < 2) return [];

  final uri = Uri.parse(_geoUrl).replace(queryParameters: {
    'name': trimmed,
    'count': '10',
    'language': 'ar',
    'format': 'json',
  });

  try {
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List?;
      if (results == null || results.isEmpty) return [];
      return results
          .map((r) => Location.fromJson(r as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('فشل البحث (رمز: ${response.statusCode})');
    }
  } on SocketException {
    throw Exception('لا يوجد اتصال بالإنترنت');
  } on TimeoutException {
    throw Exception('انتهت مهلة الاتصال');
  } on FormatException {
    throw Exception('استجابة غير صالحة من الخادم');
  }
}
```

### 3.6 شرح الكود سطرًا بسطر

| السطر/المجموعة | الشرح |
|---|---|
| `Future<List<Location>>` | الدالة ستنتهي لاحقًا وتعيد قائمة مدن. |
| `async` | تسمح باستخدام `await` داخل الدالة. |
| `query.trim()` | يحذف المسافات من البداية والنهاية. |
| `if (trimmed.length < 2) return [];` | يمنع إرسال طلب لحرف واحد ويعيد قائمة فارغة. |
| `Uri.parse(_geoUrl)` | يحوّل نص الرابط إلى كائن `Uri`. |
| `.replace(queryParameters: {...})` | يضيف معاملات البحث: الاسم، العدد 10، اللغة العربية، الصيغة JSON. |
| `_client.get(uri)` | يرسل طلب GET. |
| `.timeout(15s)` | يوقف الانتظار بعد 15 ثانية ويرمي `TimeoutException`. |
| `response.statusCode == 200` | 200 تعني أن الخادم نجح. |
| `jsonDecode(response.body)` | يحول نص JSON إلى `Map`. |
| `data['results'] as List?` | يقرأ قائمة النتائج، وقد تكون غير موجودة. |
| `results == null` أو `results.isEmpty` | يعيد قائمة فارغة بدل حدوث خطأ. |
| `.map((r) => Location.fromJson(...))` | يحول كل نتيجة JSON إلى كائن `Location`. |
| `.toList()` | يجمع النتائج في `List<Location>`. |
| `else throw Exception(...)` | أي رمز غير 200 يُعامل كخطأ. |
| `on SocketException` | لا يوجد اتصال أو تعذر الوصول للخادم. |
| `on TimeoutException` | انتهت المهلة. |
| `on FormatException` | JSON غير صالح. |

### 3.7 الكود الحقيقي: جلب الطقس بالإحداثيات

```dart
Future<Weather> fetchWeatherForCoords(
    double lat, double lon, String cityName) async {
  final uri = Uri.parse(_weatherUrl).replace(queryParameters: {
    'latitude': lat.toString(),
    'longitude': lon.toString(),
    'current':
        'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
    'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
    'timezone': 'auto',
    'forecast_days': '5',
  });

  try {
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body), cityName);
    } else {
      throw Exception('فشل جلب الطقس (رمز: ${response.statusCode})');
    }
  } on SocketException {
    throw Exception('لا يوجد اتصال بالإنترنت');
  } on TimeoutException {
    throw Exception('انتهت مهلة الاتصال');
  } on FormatException {
    throw Exception('استجابة غير صالحة من الخادم');
  }
}
```

### 3.8 شرح الكود

| الجزء | الشرح |
|---|---|
| `lat`, `lon` | إحداثيات المدينة القادمة من `Location`. |
| `cityName` | اسم المدينة لعرضه، لأن API لا يعيد الاسم العربي المطلوب دائمًا. |
| `'current': ...` | الحقول الحالية المطلوبة: الحرارة، الرطوبة، المحسوسة، كود الطقس، الرياح. |
| `'daily': ...` | حقول التوقعات اليومية. |
| `'timezone': 'auto'` | يستخدم توقيت المدينة. |
| `'forecast_days': '5'` | يطلب 5 أيام. |
| `Weather.fromJson(...)` | يحول JSON إلى كائن `Weather`. |

### 3.9 الكود الحقيقي: جلب الطقس باسم المدينة

```dart
Future<Weather> fetchWeatherForCity(String cityName) async {
  final results = await searchLocations(cityName);
  if (results.isEmpty) {
    throw Exception('لم يتم العثور على المدينة: $cityName');
  }
  final first = results.first;
  return fetchWeatherForCoords(first.latitude, first.longitude, first.name);
}
```

**ماذا يحدث؟**

1. يبحث عن المدينة.
2. إذا لم توجد نتيجة، يرمي استثناءً.
3. يأخذ أول نتيجة.
4. يجلب طقس إحداثياتها.
5. يعيد `Weather`.

### 3.10 تحويل JSON إلى Models

**الملف:** `lib/models/weather.dart:26-58`.

```dart
factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
  final current = json['current'] as Map<String, dynamic>;
  final daily = json['daily'] as Map<String, dynamic>?;

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

  return Weather(
    cityName: cityName,
    temperature: (current['temperature_2m'] as num).toDouble(),
    feelsLike: (current['apparent_temperature'] as num).toDouble(),
    humidity: (current['relative_humidity_2m'] as num).toInt(),
    windSpeed: (current['wind_speed_10m'] as num).toDouble(),
    weatherCode: (current['weather_code'] as num).toInt(),
    tempMax: dailyList.isNotEmpty ? dailyList.first.tempMax : null,
    tempMin: dailyList.isNotEmpty ? dailyList.first.tempMin : null,
    lastUpdated: DateTime.now(),
    forecast: dailyList,
  );
}
```

**شرح:**

- `json['current']` هو الجزء الحالي من الاستجابة.
- `json['daily']` قد يكون `null`، لذلك نوعه `Map?`.
- `dailyList` قائمة التوقعات.
- كل قائمة من API لها نفس عدد الأيام؛ لذلك الحلقة `for` آمنة.
- `as num` مهم لأن JSON قد يعيد `23` كـ`int` أو `23.5` كـ`double`.
- `DateTime.now()` وقت الجهاز، وليس من API.

**الملف:** `lib/models/location.dart:22-33` يحوّل نتيجة البحث إلى `Location`، ويستخدم `(json['latitude'] as num).toDouble()` للسبب نفسه.

### 3.11 معالجة الأخطاء

**في الخدمة:** استثناءات محددة كما في 3.6.

**في المتحكم:** `fetchWeather` يلتقط الخطأ ويضع رسالة نظيفة:

```dart
} catch (e) {
  _pendingFuture = null;
  errorMessage.value = e.toString().replaceFirst('Exception: ', '');
  rethrow;
}
```

**في الواجهة:** `FutureBuilder` يرى الخطأ عبر `snapshot.hasError`، ويعرض `_ScrollableError`.

**ملاحظة:** `rethrow` مهمة لأنها لا تبتلع الخطأ؛ فهي تسمح لـ`FutureBuilder` أن يعرف أن العملية فشلت، بينما `errorMessage` تسمح لبطاقة الرئيسية بعرض الخطأ أيضًا.

---

## 4. المفهوم الثاني: SQLite وsqflite

### 4.1 الاسم

**SQLite** — قاعدة بيانات محلية — **sqflite** — **CRUD**.

### 4.2 التعريف

SQLite قاعدة بيانات صغيرة تعمل داخل التطبيق وتحفظ البيانات في ملف. `sqflite` حزمة Flutter تسمح لـDart بفتح القاعدة وتنفيذ الاستعلامات.

### 4.3 لماذا نستخدمها؟

لأن الملاحظات بيانات المستخدم، ويجب أن تبقى بعد إغلاق التطبيق، ولا تحتاج سيرفرًا أو إنترنت.

### 4.4 مكانها

**الملف:** `lib/services/database_service.dart`

**الكلاس:** `DatabaseService`

**الثوابت:**

```dart
static Database? _database;
static const String _dbName = 'weather_notes.db';
static const int _dbVersion = 1;
static const String _tableName = 'notes';
```

| الثابت | المعنى |
|---|---|
| `_database` | اتصال واحد مشترك، `null` قبل الفتح. |
| `_dbName` | اسم ملف القاعدة. |
| `_dbVersion` | إصدار المخطط؛ حاليًا 1. |
| `_tableName` | اسم الجدول؛ `notes`. |

### 4.5 فتح القاعدة وإنشاء الجدول

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

**شرح:**

| الجزء | الشرح |
|---|---|
| `get database` | Getter غير متزامن يعيد القاعدة. |
| `if (_database != null)` | إذا كانت مفتوحة، لا تعد فتحها. |
| `getDatabasesPath()` | مسار قواعد البيانات على الجهاز. |
| `join(...)` | يدمج المسار والاسم بطريقة صحيحة. |
| `openDatabase(...)` | يفتح الملف أو ينشئه. |
| `version: 1` | إصدار المخطط. |
| `onCreate` | يُنفذ مرة واحدة عند أول إنشاء. |
| `CREATE TABLE $_tableName` | ينشئ جدول `notes` لأن المتغير قيمته `notes`. |
| `id INTEGER PRIMARY KEY AUTOINCREMENT` | معرف فريد يزيد تلقائيًا. |
| `TEXT NOT NULL` | يمنع القيم الفارغة. |

### 4.6 INSERT

```dart
Future<int> insertNote(Note note) async {
  final db = await database;
  final map = note.toMap()..remove('id');
  return db.insert(_tableName, map);
}
```

**شرح:**

1. `await database` يضمن فتح القاعدة.
2. `note.toMap()` يحول الكائن إلى `Map`.
3. `..remove('id')` يحذف `id` لأن SQLite سينشئه.
4. `db.insert` ينفذ الإدراج.
5. يعيد رقم الصف الجديد.

**لماذا نحذف `id`؟** لأن `id` في `Note` قد يكون `null` قبل الحفظ. إرساله قد يسبب سلوكًا غير مرغوب، لذلك نترك SQLite يولده.

### 4.7 SELECT

```dart
Future<List<Note>> fetchNotes() async {
  final db = await database;
  final maps = await db.query(_tableName, orderBy: 'updated_at DESC');
  return maps.map((m) => Note.fromMap(m)).toList();
}
```

**شرح:**

- `query` تقرأ كل الصفوف.
- `orderBy: 'updated_at DESC'` الأحدث تعديلًا أولًا.
- `map` تحول كل صف إلى `Note`.
- `toList` تجمع النتائج.

### 4.8 UPDATE

```dart
Future<int> updateNote(Note note) async {
  final db = await database;
  final map = note.toMap()..remove('id');
  return db.update(_tableName, map, where: 'id = ?', whereArgs: [note.id]);
}
```

**شرح:**

- `where: 'id = ?'` شرط التحديث.
- `whereArgs: [note.id]` تمرر القيمة بشكل آمن بدل دمجها في النص.
- يعيد عدد الصفوف المتأثرة.

### 4.9 DELETE

```dart
Future<int> deleteNote(int id) async {
  final db = await database;
  return db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
}
```

**شرح:** يحذف الصف المطابق فقط، ويعيد عدد الصفوف المحذوفة.

### 4.10 تحويل Note إلى Map والعكس

**الملف:** `lib/models/note.dart`.

```dart
Map<String, dynamic> toMap() => {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

factory Note.fromMap(Map<String, dynamic> map) => Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
```

**شرح:**

- `DateTime` لا يُخزَّن مباشرة في SQLite، لذلك يُحوَّل إلى نص ISO 8601.
- عند القراءة، `DateTime.parse` يعيده إلى `DateTime`.
- `id` قد يكون `null` عند الإنشاء، لذلك `int?`.

**ملاحظة:** `Note` لا يحتوي `toJson`؛ لأنه لا يُرسل إلى API. هذا ليس نقصًا في المتطلب.

---

## 5. المفهوم الثالث: State Management باستخدام GetX

### 5.1 الاسم

**State Management** — إدارة الحالة — **GetX**.

### 5.2 التعريف

إدارة الحالة هي طريقة حفظ البيانات التي تتغير مع استخدام التطبيق، وتحديث الواجهة عندما تتغير هذه البيانات.

### 5.3 لماذا نحتاجها؟

بدون إدارة حالة مركزية:

- قد تختلف بيانات الطقس بين الصفحات.
- قد تحتاج كل شاشة إلى إعادة جلب البيانات.
- يصعب تحديث الواجهة عند تغير القيمة.

GetX يجعل المتحكم مصدرًا واحدًا للحالة، و`Obx` يعيد بناء الجزء المعتمد على القيمة عند تغيرها.

### 5.4 أين توجد Controllers؟

**الملف:** `lib/controllers/weather_controller.dart`

```dart
class WeatherController extends GetxController {
  final WeatherService _service = WeatherService();

  final weather = Rxn<Weather>();
  final currentCity = 'صنعاء'.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  final searchResults = <Location>[].obs;
  final isSearching = false.obs;
  final searchError = RxnString();
  final searchQuery = ''.obs;
```

**الملف:** `lib/controllers/notes_controller.dart`

```dart
class NotesController extends GetxController {
  final DatabaseService _service = DatabaseService();

  final notes = <Note>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
```

### 5.5 المتغير العادي مقابل المتغير التفاعلي

| النوع | مثال | السلوك |
|---|---|---|
| عادي | `final WeatherService _service = WeatherService();` | لا يعيد بناء الواجهة عند تغيره. |
| تفاعلي | `final isLoading = false.obs;` | كائن `RxBool`؛ عند تغيير `.value` تُبلَّغ الواجهة. |
| nullable تفاعلي | `final weather = Rxn<Weather>();` | قيمة قد تكون `null`. |
| قائمة تفاعلية | `final notes = <Note>[].obs;` | قائمة يمكن مراقبتها وتحديثها. |

**مهم:** `isLoading` ليس `bool`، بل `RxBool`. لذلك نكتب:

```dart
isLoading.value = true;
```

ولا نكتب:

```dart
isLoading = true; // خطأ
```

### 5.6 كيف يتم تحديث الحالة؟

**مثال الطقس:**

```dart
Future<Weather> fetchWeather(String cityName) async {
  isLoading.value = true;
  errorMessage.value = null;
  try {
    final result = await _service.fetchWeatherForCity(cityName);
    weather.value = result;
    currentCity.value = result.cityName;
    _pendingFuture = null;
    return result;
  } catch (e) {
    _pendingFuture = null;
    errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    rethrow;
  } finally {
    isLoading.value = false;
  }
}
```

**خطوات:**

1. `isLoading.value = true` يشير إلى بدء التحميل.
2. `errorMessage.value = null` يمسح الخطأ القديم.
3. `await` ينتظر نتيجة الخدمة.
4. `weather.value = result` يحدّث الحالة.
5. `currentCity.value` يحدّث اسم المدينة.
6. عند الخطأ: يضع الرسالة ويعيد رمي الخطأ.
7. `finally` يوقف التحميل في كل الحالات.

**مثال الملاحظات:**

```dart
Future<void> addNote(String title, String content) async {
  final now = DateTime.now();
  await _service.insertNote(Note(
    title: title,
    content: content,
    createdAt: now,
    updatedAt: now,
  ));
  await loadNotes();
}
```

بعد `insertNote`، تُستدعى `loadNotes` لتقرأ القائمة من SQLite وتحدّث `notes` عبر `assignAll`.

### 5.7 كيف تنعكس التغييرات على الواجهة؟

**في الرئيسية:** `Obx` يقرأ `weather.value` و`errorMessage.value`:

```dart
Widget _buildWeatherCard() {
  return Obx(() {
    if (_weatherController.weather.value == null) {
      if (_weatherController.errorMessage.value != null) {
        return GlassCard(
          child: AppErrorWidget(
            message: _weatherController.errorMessage.value!,
            onRetry: () => _handleRefresh(),
          ),
        );
      }
      return const HomeSkeleton();
    }
    final w = _weatherController.weather.value!;
    ...
  });
}
```

**ماذا يحدث؟**

- `Obx` يسجل اعتمادًا على `weather.value` و`errorMessage.value`.
- عند تغير أي منهما، يعيد تنفيذ الدالة.
- إذا لا توجد بيانات ولا خطأ → Skeleton.
- إذا يوجد خطأ → `AppErrorWidget`.
- إذا توجد بيانات → البطاقة.

**في شاشة الطقس:** `FutureBuilder` يعرض نتيجة `_weatherFuture`. عند اكتمال الـFuture، يعيد البناء ويعرض بياناته. و`WeatherScreen` يحدّث `_weatherFuture` عبر `setState` عند التحديث.

**في شاشة الملاحظات:** `Obx` يقرأ `searchQuery` فقط، ويعيد بناء `FutureBuilder` عندما يتغير نص البحث. `FutureBuilder` نفسه يحتفظ بنفس `_notesFuture`، لذلك لا يعيد قراءة SQLite عند كل حرف.

### 5.8 `Get.put` و`Get.find`

**التسجيل:** `home_screen.dart:30-35`.

```dart
if (!Get.isRegistered<WeatherController>()) {
  Get.put(WeatherController(), permanent: true);
}
if (!Get.isRegistered<NotesController>()) {
  Get.put(NotesController(), permanent: true);
}
```

**الوصول:** `weather_screen.dart:23`.

```dart
final WeatherController controller = Get.find<WeatherController>();
```

**الشرح:**

- `Get.put` ينشئ المتحكم ويسجله.
- `permanent: true` يمنع حذفه عند إغلاق الشاشة.
- `Get.find` يعيد نفس الكائن المسجل.
- `isRegistered` يمنع تسجيل نسختين.

**ترتيب مهم:** `Get.put` يحدث في `HomeScreen.initState`، وكل الشاشات الفرعية تُبنى بعده.

### 5.9 `onInit` و`onClose`

**في `WeatherController`:**

```dart
@override
void onInit() {
  super.onInit();
  ensureWeatherLoaded().ignore();
}
```

- `onInit` تعمل عند إنشاء المتحكم.
- `ensureWeatherLoaded()` تبدأ الجلب أو تعيد Future مشتركًا.
- `.ignore()` تمنع الخطأ غير المعالج إن فشل الطلب في الخلفية.

**في `NotesController`:**

```dart
@override
void onInit() {
  super.onInit();
  ensureNotesLoaded().ignore();
}
```

**`onClose`:** يلغي `Timer` الخاص بالبحث في `weather_controller.dart:31-35`، حتى لا ينفذ بحث بعد تدمير المتحكم.

### 5.10 ما غير المستخدم من GetX؟

- `GetBuilder`: غير مستخدم.
- `GetX<Controller>`: غير مستخدم.
- `Get.lazyPut`: غير مستخدم.
- `Get.off` / `Get.offAll`: غير مستخدم.
- `Bindings`: غير مستخدمة.

لا تنسب هذه الأشياء للمشروع في المناقشة.

---

## 6. المفهوم الرابع: Future وasync/await وFutureBuilder

### 6.1 الفروق الأساسية

| المصطلح | معناه |
|---|---|
| `Future` | كائن يمثل نتيجة عملية ستكتمل لاحقًا. |
| `async` | كلمة تجعل الدالة قادرة على إرجاع `Future` واستخدام `await`. |
| `await` | ينتظر اكتمال `Future` دون تجميد الواجهة. |
| `FutureBuilder` | Widget يراقب `Future` ويعرض حالته: تحميل، خطأ، بيانات. |

**مهم:** `Future` ليس بديلًا عن `FutureBuilder`، و`async/await` ليسا نوع بيانات. الثلاثة تعمل معًا.

### 6.2 أين توجد Future في المشروع؟

| الملف | الدالة/الخاصية | النوع |
|---|---|---|
| `weather_service.dart` | `searchLocations` | `Future<List<Location>>` |
| `weather_service.dart` | `fetchWeatherForCoords` | `Future<Weather>` |
| `weather_service.dart` | `fetchWeatherForCity` | `Future<Weather>` |
| `database_service.dart` | `database` | `Future<Database>` |
| `database_service.dart` | `_initDatabase` | `Future<Database>` |
| `database_service.dart` | `insertNote` | `Future<int>` |
| `database_service.dart` | `fetchNotes` | `Future<List<Note>>` |
| `database_service.dart` | `updateNote` | `Future<int>` |
| `database_service.dart` | `deleteNote` | `Future<int>` |
| `weather_controller.dart` | `ensureWeatherLoaded` | `Future<Weather>` |
| `weather_controller.dart` | `fetchWeather` | `Future<Weather>` |
| `weather_controller.dart` | `selectLocation` | `Future<void>` |
| `weather_controller.dart` | `refreshWeather` | `Future<void>` |
| `weather_controller.dart` | `_performSearch` | `Future<void>` |
| `notes_controller.dart` | `ensureNotesLoaded` | `Future<List<Note>>` |
| `notes_controller.dart` | `loadNotes` | `Future<List<Note>>` |
| `notes_controller.dart` | `addNote` | `Future<void>` |
| `notes_controller.dart` | `updateNote` | `Future<void>` |
| `notes_controller.dart` | `deleteNote` | `Future<void>` |
| `weather_screen.dart` | `_refresh` / `_openSearch` | `Future<void>` |
| `notes_screen.dart` | `_refresh` / `_openForm` / `_confirmDelete` | `Future<void>` |
| `note_form_screen.dart` | `_save` | `Future<void>` |
| `home_screen.dart` | `_handleRefresh` | `Future<void>` |
| `main.dart` | `main` | `async` (Future ضمني) |

### 6.3 لماذا نستخدم Future؟

لأن الشبكة وSQLite لا تنتهيان فورًا. لو انتظرنا بشكل متزامن، ستتجمد الواجهة. `Future` يسمح للواجهة بالاستمرار في العمل ثم استقبال النتيجة.

### 6.4 FutureBuilder في شاشة الطقس

**الملف:** `lib/screen/weather_screen.dart:80-113`.

```dart
child: FutureBuilder<Weather>(
  future: _weatherFuture,
  builder: (context, snapshot) {
    // 1) Waiting: عملية جلب جارية
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const WeatherSkeleton();
    }

    // 2) Error: فشل الطلب
    if (snapshot.hasError) {
      return _ScrollableError(
        message: snapshot.error
                ?.toString()
                .replaceFirst('Exception: ', '') ??
            'تعذر جلب بيانات الطقس.',
        onRetry: _reload,
      );
    }

    // 3) Has Data: وصلت البيانات
    if (snapshot.hasData) {
      return _WeatherContent(
        weather: snapshot.data!,
        onRefresh: _refresh,
      );
    }

    // 4) Empty: لا بيانات ولا خطأ (نادر)
    return _ScrollableError(
      message: 'لا توجد بيانات طقس متاحة.',
      onRetry: _reload,
    );
  },
),
```

### 6.5 شرح FutureBuilder سطرًا بسطر

| الجزء | الشرح |
|---|---|
| `FutureBuilder<Weather>` | Widget يراقب Future يعيد `Weather`. |
| `future: _weatherFuture` | الـFuture المُنشأ في `initState` أو عند التحديث. |
| `builder: (context, snapshot)` | دالة تُستدعى كلما تغيرت حالة الـFuture. |
| `snapshot.connectionState == ConnectionState.waiting` | العملية لم تكتمل بعد. |
| `WeatherSkeleton()` | هيكل تحميل بدل شاشة فارغة. |
| `snapshot.hasError` | حدث خطأ. |
| `snapshot.error?.toString()` | نص الخطأ. |
| `.replaceFirst('Exception: ', '')` | يزيل بادئة Dart لعرض رسالة نظيفة. |
| `snapshot.hasData` | وصلت بيانات بنجاح. |
| `snapshot.data!` | البيانات، و`!` آمنة بعد التحقق. |
| الحالة الأخيرة | احتياط إذا لم تتحقق الشروط السابقة. |

### 6.6 من أين يأتي `_weatherFuture`؟

**الملف:** `weather_screen.dart`.

```dart
final WeatherController controller = Get.find<WeatherController>();
late Future<Weather> _weatherFuture;

@override
void initState() {
  super.initState();
  _weatherFuture = controller.ensureWeatherLoaded();
}

void _reload() {
  setState(() {
    _weatherFuture = controller.fetchWeather(controller.currentCity.value);
  });
}

Future<void> _refresh() async {
  final future = controller.fetchWeather(controller.currentCity.value);
  setState(() {
    _weatherFuture = future;
  });
  try {
    await future;
  } catch (_) {
    // الخطأ يُعرض عبر FutureBuilder
  }
}
```

**لماذا لا ننشئ Future داخل `build`؟**

لو كتبنا `FutureBuilder(future: controller.fetchWeather(...))` داخل `build`، فسيتم إنشاء طلب جديد كل مرة يعيد Flutter البناء. هذا يسبب طلبات متكررة. لذلك يُنشأ الـFuture في `initState` أو في دوال صريحة مثل `_reload` و`_refresh`.

### 6.7 `ensureWeatherLoaded` ومنع الطلب المكرر

**الملف:** `weather_controller.dart:37-41`.

```dart
Future<Weather> ensureWeatherLoaded() {
  if (weather.value != null) return Future.value(weather.value!);
  return _pendingFuture ??= fetchWeather(currentCity.value);
}
```

**الشرح:**

- إذا كانت البيانات موجودة، يعيد Future جاهزًا فورًا.
- إذا لم تكن موجودة، ينشئ Future ويحفظه في `_pendingFuture`.
- `??=` تعني: إن كان `_pendingFuture` فارغًا، أنشئه؛ وإلا أعد الموجود.
- `onInit` والشاشة يستدعيان نفس الدالة، فلا يحدث طلبان متوازيان.

### 6.8 FutureBuilder في شاشة الملاحظات

**الملف:** `notes_screen.dart:146-210`.

```dart
child: Obx(() {
  final query = controller.searchQuery.value.trim();
  return FutureBuilder<List<Note>>(
    future: _notesFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const NotesSkeleton();
      }

      if (snapshot.hasError) {
        return _ScrollableError(
          message: snapshot.error
                  ?.toString()
                  .replaceFirst('Exception: ', '') ??
              'تعذر تحميل الملاحظات.',
          onRetry: _reload,
        );
      }

      final allNotes = snapshot.data ?? <Note>[];
      final notes = query.isEmpty
          ? allNotes
          : allNotes
              .where((n) =>
                  n.title.toLowerCase().contains(query.toLowerCase()) ||
                  n.content.toLowerCase().contains(query.toLowerCase()))
              .toList();

      if (notes.isEmpty) {
        return _EmptyState(hasSearch: query.isNotEmpty);
      }

      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(...),
      );
    },
  );
}),
```

**شرح:**

- `Obx` يعيد البناء عند تغير `searchQuery`.
- `FutureBuilder` يستخدم `_notesFuture` الثابت.
- عند التحميل: `NotesSkeleton`.
- عند الخطأ: `_ScrollableError`.
- عند النجاح: `snapshot.data` أو قائمة فارغة.
- الفلترة محلية، لا تعيد قراءة SQLite.
- إن كانت النتيجة فارغة: `_EmptyState` وتفرق بين «لا ملاحظات» و«لا نتائج بحث».

### 6.9 `snapshot.hasData` و`snapshot.hasError` و`connectionState`

| الخاصية | معناها | أين استخدمت؟ |
|---|---|---|
| `connectionState` | حالة العملية: waiting / done / active / none | الشاشتان |
| `hasError` | هل انتهت العملية بخطأ؟ | الشاشتان |
| `hasData` | هل توجد بيانات ناجحة؟ | شاشة الطقس |
| `data` | البيانات نفسها | الشاشتان |
| `error` | كائن الخطأ | الشاشتان |

**مهم:** `hasData` و`hasError` لا يكونان صحيحين معًا. `connectionState` تصف الحالة الزمنية، بينما `hasData/hasError` تصفان النتيجة.

### 6.10 حالات التحميل والنجاح والفشل

**التحميل:**

- الطقس: `WeatherSkeleton`.
- الملاحظات: `NotesSkeleton`.
- البحث: `LoadingWidget`.

**النجاح:**

- الطقس: `_WeatherContent`.
- الملاحظات: `ListView.builder`.

**الفشل:**

- الطقس: `_ScrollableError` مع زر إعادة المحاولة.
- الملاحظات: `_ScrollableError` مع زر إعادة المحاولة.
- الحفظ/التعديل: `SnackBar` في `NoteFormScreen._save`.
- الحذف: `SnackBar` في `NotesScreen._confirmDelete`.
- البحث: رسالة داخل `_buildResults` مع زر إعادة المحاولة إذا كان النص حرفين أو أكثر.

### 6.11 معالجة أخطاء SQLite

**قراءة:**

```dart
Future<List<Note>> loadNotes() async {
  isLoading.value = true;
  try {
    final list = await _service.fetchNotes();
    notes.assignAll(list);
    _pendingNotesFuture = null;
    return list;
  } catch (e) {
    _pendingNotesFuture = null;
    rethrow;
  } finally {
    isLoading.value = false;
  }
}
```

- إذا فشلت القراءة، يعيد رمي الخطأ.
- `FutureBuilder` في شاشة الملاحظات يعرض `snapshot.hasError`.

**حفظ/تعديل:** `NoteFormScreen._save` يلتقط الخطأ ويعرض `SnackBar`.

**حذف:** `NotesScreen._confirmDelete` يلتقط الخطأ ويعرض `SnackBar`.

**النقص:** لا توجد رسائل مخصصة لأخطاء SQLite (مثل قاعدة مقفلة أو مساحة ممتلئة)، والرسالة العامة «حدث خطأ أثناء الحفظ» هي السائدة.

---

## 7. مسارات التنفيذ الفعلية

### 7.1 مسار تشغيل التطبيق

```text
main()
  ├─ WidgetsFlutterBinding.ensureInitialized()
  ├─ await initializeDateFormatting('ar', null)
  └─ runApp(MyApp())
       └─ GetMaterialApp(home: HomeScreen)
            └─ HomeScreen.initState
                 ├─ Get.put(WeatherController)
                 │    └─ onInit → ensureWeatherLoaded().ignore()
                 │         └─ fetchWeather('صنعاء')
                 └─ Get.put(NotesController)
                      └─ onInit → ensureNotesLoaded().ignore()
                           └─ loadNotes()
```

**الملفات:** `main.dart:8-12`، `home_screen.dart:28-36`، `weather_controller.dart:24-29`، `notes_controller.dart:24-28`.

### 7.2 مسار الطقس

```text
WeatherScreen.initState
  └─ _weatherFuture = controller.ensureWeatherLoaded()
       └─ _pendingFuture ??= fetchWeather('صنعاء')
            ├─ isLoading = true
            ├─ WeatherService.fetchWeatherForCity('صنعاء')
            │    ├─ searchLocations('صنعاء')
            │    │    ├─ GET geocoding API
            │    │    └─ JSON → List<Location>
            │    └─ fetchWeatherForCoords(lat, lon, name)
            │         ├─ GET forecast API
            │         └─ JSON → Weather.fromJson
            ├─ weather.value = result
            ├─ currentCity.value = result.cityName
            └─ return result
  └─ FutureBuilder
       ├─ waiting → WeatherSkeleton
       ├─ error → _ScrollableError
       └─ data → _WeatherContent
```

**التحديث:**

- `_reload()` ينشئ Future جديدة عبر `fetchWeather`.
- `_refresh()` ينشئ Future جديدة، ويحدّث `_weatherFuture`، وينتظرها لإخفاء `RefreshIndicator`.
- `WeatherScreen._openSearch()` بعد العودة من البحث يزامن `_weatherFuture` مع `controller.weather.value` إن كانت موجودة.

### 7.3 مسار البحث عن المدن

```text
WeatherScreen: زر البحث
  └─ Get.to(WeatherSearchScreen)
       ├─ initState: controller.clearSearch()
       ├─ TextField.onChanged → controller.onSearchChanged
       │    ├─ trim
       │    ├─ إذا فارغ → clear
       │    ├─ إذا أقل من حرفين → رسالة
       │    └─ Timer(400ms) → _performSearch
       │         ├─ requestId = ++_searchRequestId
       │         ├─ isSearching = true
       │         ├─ fetch searchLocations
       │         ├─ إذا requestId قديم → تجاهل
       │         ├─ searchResults.assignAll
       │         └─ إذا فارغة → searchError
       └─ Obx يعرض:
            ├─ LoadingWidget أثناء isSearching
            ├─ رسالة خطأ + إعادة المحاولة
            ├─ نص إرشادي إذا الحقل فارغ
            └─ ListView من _SuggestionTile
```

**عند اختيار مدينة:**

```text
_SuggestionTile.onTap
  └─ _selectLocation(location)
       ├─ Get.back()
       └─ await controller.selectLocation(location)
            ├─ weather.value = null
            ├─ fetchWeatherForCoords(...)
            ├─ weather.value = result
            └─ currentCity.value = result.cityName
```

**ملاحظة واقعية — سباق زمني محتمل (Race Condition):**

الترتيب الفعلي هو:

```dart
// weather_search_screen.dart:34-36
Future<void> _selectLocation(Location location) async {
  Get.back();
  await controller.selectLocation(location);
```

بعد `Get.back()` يعود التنفيذ فورًا إلى `_openSearch` التي تنتظر `Get.to(...)`:

```dart
// weather_screen.dart:56-64
await Get.to(() => const WeatherSearchScreen());
if (!mounted) return;
if (controller.weather.value != null) {
  setState(() {
    _weatherFuture = Future<Weather>.value(controller.weather.value!);
  });
}
```

بينما `selectLocation` ما زالت تعمل، وقد بدأت بتصفير القيمة:

```dart
// weather_controller.dart:62-77
Future<void> selectLocation(Location location) async {
  isLoading.value = true;
  errorMessage.value = null;
  weather.value = null;      // ← القيمة تصبح null قبل انتهاء الجلب
  try {
    final result = await _service.fetchWeatherForCoords(...);
    weather.value = result;
    ...
  } catch (e) {
    errorMessage.value = ...; // ← لا يوجد rethrow هنا
  }
```

فيصبح هناك احتمالان حسب سرعة الشبكة:

1. **إذا انتهى الجلب قبل أن يكمل `_openSearch`:** تكون `weather.value` قد امتلأت، فيُستبدل `_weatherFuture` بالبيانات الجديدة، وتُعرض المدينة الجديدة بشكل صحيح.
2. **إذا كان `_openSearch` أسرع (وهو الأرجح عند شبكة بطيئة):** تكون `weather.value` ما زالت `null`، فلا يُستبدل `_weatherFuture`، فتبقى الشاشة تعرض **بيانات المدينة القديمة** من الـFuture السابق. وفي حالة فشل الجلب لا يظهر الخطأ في شاشة الطقس أصلًا، لأن `selectLocation` تلتقط الخطأ دون `rethrow` ودون تحديث `_weatherFuture`.

**الأثر:** واجهة الطقس قد تعرض بيانات قديمة أو لا تعرض خطأ الفشل حتى يتم سحب الشاشة للتحديث (`_refresh`) أو إعادة فتحها. بطاقة الرئيسية (`Obx`) تتأثر بشكل مختلف لأنها تقرأ `weather.value` مباشرة.

**سبب المشكلة:** فصل `_weatherFuture` في الشاشة عن `weather.value` في المتحكم، دون إعادة مزامنة صريحة بعد `selectLocation`. هذا خلل منطقي طرفي وليس نقصًا في مفهوم `FutureBuilder` نفسه.

### 7.4 مسار إضافة ملاحظة

```text
NotesScreen: FloatingActionButton
  └─ _openForm() [note = null]
       └─ Get.to<bool>(NoteFormScreen(note: null))
            └─ _save()
                 ├─ _formKey.currentState!.validate()
                 ├─ setState(_isSaving = true)
                 ├─ NotesController.addNote(title, content)
                 │    ├─ DateTime.now()
                 │    ├─ Note(...)
                 │    ├─ DatabaseService.insertNote
                 │    │    ├─ database
                 │    │    ├─ toMap + remove id
                 │    │    └─ db.insert
                 │    └─ loadNotes()
                 │         ├─ fetchNotes
                 │         └─ notes.assignAll
                 ├─ Get.back<bool>(result: true)
                 └─ finally _isSaving = false
       └─ NotesScreen:
            ├─ _notesFuture = Future.value(controller.notes.toList())
            └─ Get.snackbar('تم الحفظ')
```

### 7.5 مسار قراءة الملاحظات

```text
NotesController.onInit
  └─ ensureNotesLoaded().ignore()
       └─ loadNotes()
            ├─ isLoading = true
            ├─ DatabaseService.fetchNotes()
            │    ├─ database
            │    ├─ db.query('notes', orderBy: 'updated_at DESC')
            │    └─ Note.fromMap لكل صف
            ├─ notes.assignAll(list)
            └─ isLoading = false
  └─ NotesScreen FutureBuilder
       ├─ waiting → NotesSkeleton
       ├─ error → _ScrollableError
       └─ data → ListView / _EmptyState
```

### 7.6 مسار تعديل ملاحظة

```text
NotesScreen: زر التعديل
  └─ _openForm(note)
       └─ Get.to<bool>(NoteFormScreen(note: note))
            ├─ initState يعبئ الحقول
            └─ _save()
                 ├─ validate
                 ├─ NotesController.updateNote(note, title, content)
                 │    ├─ note.copyWith(title, content, updatedAt: now)
                 │    ├─ DatabaseService.updateNote
                 │    │    └─ db.update(where id = ?)
                 │    └─ loadNotes()
                 └─ Get.back<bool>(result: true)
```

**SQL المكافئ:**

```sql
UPDATE notes
SET title = ?, content = ?, created_at = ?, updated_at = ?
WHERE id = ?;
```

**ملاحظة:** `createdAt` يبقى كما هو لأن `copyWith` لا يغيّره، و`updatedAt` يتغير.

### 7.7 مسار حذف ملاحظة

```text
NotesScreen: زر الحذف
  └─ _confirmDelete(note)
       ├─ Get.dialog<bool>(AlertDialog)
       │    ├─ "لا" → Get.back(result: false)
       │    └─ "نعم" → Get.back(result: true)
       ├─ if confirmed != true || note.id == null → return
       └─ await controller.deleteNote(note.id!)
            ├─ DatabaseService.deleteNote
            │    └─ db.delete(where id = ?)
            └─ loadNotes()
       └─ _notesFuture = Future.value(controller.notes.toList())
```

**SQL المكافئ:**

```sql
DELETE FROM notes WHERE id = ?;
```

### 7.8 مسار إدارة الحالة

```text
Get.put(WeatherController)
  └─ onInit → fetchWeather
       └─ weather.value = result
            ├─ Obx في HomeScreen يعيد بناء بطاقة الطقس
            └─ FutureBuilder في WeatherScreen يعرض البيانات

Get.put(NotesController)
  └─ onInit → loadNotes
       └─ notes.assignAll(list)
            ├─ Obx في HomeScreen يعيد بناء عدد الملاحظات
            └─ FutureBuilder في NotesScreen يعرض القائمة

NotesScreen.setText
  └─ controller.searchQuery.value = q
       └─ Obx حول FutureBuilder يعيد البناء
            └─ الفلترة المحلية تعرض النتائج
```

**الخلاصة:** GetX يدير الحالة المشتركة، و`FutureBuilder` يدير عرض نتيجة عملية غير متزامنة. كلاهما مستخدم، لكن لكل منهما دور مختلف.

---

## 8. العلاقة بين API وSQLite داخل المشروع

```text
┌─────────────────────────────┐
│        Weather & Notes      │
├──────────────┬──────────────┤
│    الطقس     │   الملاحظات  │
├──────────────┼──────────────┤
│ Open-Meteo   │   SQLite     │
│ HTTP/JSON    │   sqflite    │
│ لا تخزين محلي│ تخزين دائم   │
└──────────────┴──────────────┘
```

**لا يوجد تداخل بين البيانات:** لا تُحفظ نتائج الطقس في SQLite، ولا تُرسل الملاحظات إلى API. هذا ليس نقصًا، بل تصميم مقصود: كل نوع بيانات يستخدم المصدر المناسب له.

**نقطة تحسين اختيارية:** تخزين آخر استجابة طقس محليًا لعرضها عند انقطاع الإنترنت، لكن هذا ليس مطلوبًا في المتطلبات الحالية.

---

## 9. ملاحظات تقنية يجب معرفتها قبل المناقشة

### 9.1 حالة البناء الحالية: يوجد خطأان يمنعان التشغيل

هذه أهم ملاحظة يجب ذكرها بصراحة قبل المناقشة. عند تشغيل `flutter analyze` على النسخة الحالية ظهر:

```text
error - The argument type 'void Function()' can't be assigned to the
        parameter type 'Future<void> Function()'.
        lib\screen\weather_screen.dart:95:26
error - The argument type 'void Function()' can't be assigned to the
        parameter type 'Future<void> Function()'.
        lib\screen\weather_screen.dart:110:24
```

**السبب الدقيق:**

`_ScrollableError` يعرّف خاصية إعادة المحاولة بنوع يعيد `Future`:

```dart
// weather_screen.dart:119-123
class _ScrollableError extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ScrollableError({required this.message, required this.onRetry});
```

لكن الدالة الممرَّرة `_reload` نوعها `void`:

```dart
// weather_screen.dart
void _reload() {
  setState(() {
    _weatherFuture = controller.fetchWeather(controller.currentCity.value);
  });
}
```

في السطرين 95 و110 يُمرَّر `_reload` إلى `onRetry`، فيرفض المحلل (analyzer) الإسناد لأن `void Function()` ليس `Future<void> Function()`.

**الأثر:** المشروع لا يُبنى حاليًا (`flutter run` / `flutter build` سيفشل حتى يُصلح التعارض). المفاهيم المطلوبة موجودة في الكود، لكن هذا الخطأ البرمجي مستقل عنها.

**إصلاحان ممكنان (لم يُنفَّذ أي منهما لأن المهمة توثيقية فقط):**

1. جعل `_reload` تعيد `Future<void>`:

```dart
Future<void> _reload() async {
  final future = controller.fetchWeather(controller.currentCity.value);
  setState(() {
    _weatherFuture = future;
  });
  try {
    await future;
  } catch (_) {
    // الخطأ يُعرض عبر FutureBuilder
  }
}
```

2. أو تغيير نوع `onRetry` إلى `VoidCallback` في `_ScrollableError`، لأن الزر لا ينتظر قيمة إرجاع.

**أي إصلاح تختار؟** الخيار الأول أقرب لنية الكود (زر إعادة المحاولة قد يريد الانتظار)، والثاني أبسط. المهم ألا يُقال إن المشروع يعمل دون إصلاح.

### 9.2 ملاحظات أخرى

1. **`isLoading` غير مستخدم في الواجهة:** `FutureBuilder` يعتمد على `connectionState`، وليس على `isLoading`. وجوده لا يضر، لكن لا تقل إن الواجهة تعتمد عليه.
2. **`filteredNotes` غير مستخدم:** الفلترة موجودة داخل `NotesScreen`. يمكن ذكر أنها دالة جاهزة لكن الشاشة تفلتر مباشرة.
3. **`_pendingFuture` و`_pendingNotesFuture`:** يمنعان طلبين متوازيين عند تشغيل `onInit` و`initState` معًا.
4. **`rethrow`:** مهمة ليصل الخطأ إلى `FutureBuilder`.
5. **`Future.value`:** تستخدم بعد الحفظ/الحذف/البحث لتحديث `FutureBuilder` بقيمة جاهزة دون إعادة طلب.
6. **`Obx` حول `FutureBuilder`:** موجود في الملاحظات فقط لإعادة البناء عند تغير نص البحث، وليس لإعادة قراءة SQLite.
7. **لا توجد Transactions:** كل عملية SQLite منفردة. هذا كافٍ لعمليات الملاحظات الحالية.
8. **لا يوجد `toJson`:** لأن التطبيق لا يرسل بيانات إلى API.
9. **لا يوجد `onUpgrade`:** لأن إصدار القاعدة 1 ولم تتغير بنيتها بعد.
10. **لا يوجد اختبار فعلي:** `test/widget_test.dart` مجرد اختبار حسابي بسيط، وليس اختبارًا للتطبيق.

---

## 10. خلاصة الشرح

- **API:** `WeatherService` يبني الطلب، يرسله، يتحقق من الحالة، ويحوّل JSON إلى `Location` و`Weather`.
- **SQLite:** `DatabaseService` يفتح القاعدة، ينشئ الجدول، وينفذ CRUD، و`Note` يحول بين الكائن و`Map`.
- **GetX:** `WeatherController` و`NotesController` يحفظان الحالة، و`Obx` يعرض التغييرات.
- **Future/async/await:** مستخدمة في كل عملية شبكة أو قاعدة بيانات.
- **FutureBuilder:** موجود فعليًا في `WeatherScreen` و`NotesScreen`، ويعرض التحميل والخطأ والبيانات.
- **المسارات:** الطقس، البحث، الإضافة، القراءة، التعديل، الحذف، وإدارة الحالة كلها موجودة وموثقة أعلاه.

**تنبيه أخير:** الشرح أعلاه يصف الكود المصدري كما هو. النسخة الحالية لا تُبنى بسبب خطأ نوع `onRetry` في `weather_screen.dart:95` و`:110` (انظر 9.1). بعد إصلاحه فقط يصبح من الصحيح قول «التطبيق يعمل ويطبق المتطلبات».
