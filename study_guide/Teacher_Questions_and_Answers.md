# أسئلة المناقشة وإجاباتها — مشروع Weather & Notes

> إجابات مبنية على الكود الفعلي في `C:\flutter_app\weather_notes\lib`.
>
> **تنبيه:** عند سؤال «هل درستم كذا؟» نوضح أن الدليل المتاح هو أمثلة خارجية، وليس نص متطلبات مكتوب من الأستاذة.

---

## 1. أسئلة عن Dart

### س1 (سهل): ما الفرق بين `final` و`const` في مشروعك؟

**الإجابة:**

- `final`: قيمة تُسند مرة واحدة وقت التشغيل، مثل `final _formKey = GlobalKey<FormState>();` في `note_form_screen.dart:20`.
- `const`: قيمة معروفة وقت الترجمة، مثل `static const primary = Color(0xFF2F6BFF);` في `app_colors.dart:4`.

`const` أكثر صرامة وأخف، لكنها تحتاج قيمة ثابتة معروفة مسبقًا. `final` تسمح بقيمة تُحسب عند التشغيل.

**مثال من المشروع:** `final DateTime now = DateTime.now();` لا يمكن أن تكون `const` لأن الوقت غير معروف وقت الترجمة.

---

### س2 (سهل): ما أنواع البيانات المستخدمة في `Weather`؟

**الإجابة:** في `lib/models/weather.dart:1-11`:

- `String cityName`
- `double temperature`, `double feelsLike`
- `int humidity`, `int weatherCode`
- `double? tempMax`, `double? tempMin`
- `DateTime lastUpdated`
- `List<DailyForecast> forecast`

استخدمنا `double` للحرارة لأن API قد يعيد كسورًا، و`int` للرطوبة لأنها نسبة صحيحة، و`?` للحقول الاختيارية.

---

### س3 (متوسط): لماذا نستخدم `as num` ثم `.toDouble()` في `fromJson`؟

**الإجابة:** لأن `jsonDecode` قد يعيد الرقم `23` كـ`int` أو `23.5` كـ`double`. النوع `num` يشمل الاثنين. لو حولنا مباشرة `as double` وفصلنا `int`، سيحدث خطأ وقت التشغيل.

**الكود:** `weather.dart:48-52`.

```dart
temperature: (current['temperature_2m'] as num).toDouble(),
```

هذا آمن في الحالتين.

---

### س4 (متوسط): أين تستخدم `List` و`Map`؟ وما الفرق بينهما؟

**الإجابة:**

- `List`: قائمة مرتبة. مثال: `weather.forecast` قائمة `DailyForecast`، و`notes` قائمة `Note`.
- `Map`: أزواج مفتاح/قيمة. مثال: `Note.toMap()` يعيد خريطة بأسماء أعمدة SQLite، و`jsonDecode` يعيد `Map<String, dynamic>`.

**لماذا لا نستخدم `Map` لكل شيء؟** لأن `Map` لا يضمن أنواع الحقول، ويصعب اكتشاف الأخطاء المطبعية. النماذج أوضح.

---

### س5 (متقدم): ماذا يحدث لو حذفنا `factory` من `Weather.fromJson`؟

**الإجابة:** `factory` تسمح للمُنشئ بإعادة كائن موجود أو كائن من نوع فرعي، ولا تُجبر على إنشاء نسخة جديدة دائمًا. في هذا المشروع لا نستفيد من هذه المرونة كثيرًا، لكن إزالة `factory` تجعلها مُنشئًا عاديًا، ويبقى الكود صالحًا طالما يعيد `Weather`. الأهم أن يبقى الاسم `fromJson` والنوع `Weather`.

**ملاحظة:** لا يوجد سبب وظيفي قوي لوجود `factory` هنا سوى اتباع النمط الشائع لتحويل JSON.

---

### س6 (عملي): أين يوجد `async/await`؟ وماذا لو حذفنا `await` من `loadWeather`؟

**الإجابة:** في `weather_controller.dart:35-47`.

لو حذفنا `await`:

```dart
final result = _service.fetchWeatherForCity(cityName);
weather.value = result;
```

سيصبح `result` من نوع `Future<Weather>` لا `Weather`، وسيحدث خطأ نوع. ولو خزّناه كما هو، ستعرض الواجهة `Future` لا البيانات.

**الخلاصة:** `await` ضرورية للحصول على القيمة الفعلية.

---

### س7 (متقدم): هل يوجد `export` في المشروع؟

**الإجابة:** لا. لا يوجد ملف يعيد تصدير ملفات أخرى. كل ملف يستورد ما يحتاجه مباشرة. هذا أبسط للمشروع الصغير، لكنه قد يكرر الاستيرادات في المشاريع الكبيرة.

---

### س8 (عملي): ما الفرق بين `==` و`=`؟

**الإجابة:**

- `=` إسناد: `isLoading.value = true;`
- `==` مقارنة: `if (i == _currentIndex) return;` في `home_screen.dart:45`.

الخلط بينهما في الشرط يؤدي إلى أخطاء منطقية أو ترجمة.

---

## 2. أسئلة عن Flutter

### س1 (سهل): ما وظيفة `main()` و`runApp()`؟

**الإجابة:** `main()` نقطة بداية Dart. `runApp()` يمرر الـWidget الجذري إلى Flutter ليبدأ بناء الشجرة.

في `main.dart:8-12`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar', null);
  runApp(const MyApp());
}
```

---

### س2 (سهل): لماذا `MyApp` من نوع `StatelessWidget`؟

**الإجابة:** لأنه لا يملك حالة داخلية تتغير. وظيفته بناء `GetMaterialApp` فقط. الثيم واللغة ثابتان في هذه النسخة.

---

### س3 (متوسط): ما الفرق بين `MaterialApp` و`GetMaterialApp`؟

**الإجابة:** `GetMaterialApp` نسخة من `MaterialApp` تضيف دعم GetX للتنقل والرسائل والحوارات. المشروع يستخدمها في `main.dart:19`.

لو استخدمنا `MaterialApp` فقط، فقد تعمل بعض وظائف GetX لكن دون التكامل الكامل، وقد نحتاج `Navigator` و`ScaffoldMessenger` بدلًا منها.

---

### س4 (متوسط): أين نستخدم `setState`؟ ولماذا لا نستخدمه لكل شيء؟

**الإجابة:** في:

- `home_screen.dart:46` لتغيير التبويب.
- `note_form_screen.dart:44` و`67` لحالة الحفظ.

لا نستخدمه لكل شيء لأن حالة الطقس والملاحظات مشتركة بين شاشات، وGetX يوفر مصدرًا واحدًا. `setState` مناسب للحالة المحلية البسيطة.

---

### س5 (متقدم): ما وظيفة `AutomaticKeepAliveClientMixin`؟

**الإجابة:** يحافظ على حالة الشاشة عند تبديل التبويبات. موجود في:

- `_HomeTabState` (`home_screen.dart:95`)
- `_WeatherScreenState` (`weather_screen.dart:21-22`)
- `_NotesScreenState` (`notes_screen.dart:20-21`)

بدونها قد يعيد `PageView` بناء الصفحة ويفقد موضع التمرير أو يعيد الطلبات.

**ملاحظة:** يجب استدعاء `super.build(context)` في `build`، وهو موجود.

---

### س6 (عملي): كيف يدعم التطبيق العربية وRTL؟

**الإجابة:**

- `locale: Locale('ar')` في `main.dart:24`.
- `localizationsDelegates` للترجمة.
- `builder` يفرض `Directionality(rtl)` في `main.dart:32-33`.
- `initializeDateFormatting('ar')` لتواريخ عربية.

---

### س7 (متقدم): ماذا يحدث لو حذفنا `extendBody: true` من `Scaffold` الرئيسي؟

**الإجابة:** سيتوقف جسم الصفحة قبل شريط التنقل السفلي، ولن تظهر الخلفية الزجاجية خلف الشريط بنفس الشكل. التصميم الحالي يعتمد على `extendBody` و`backgroundColor: Colors.transparent` ليظهر `GlassBackground` خلف كل شيء.

---

### س8 (عملي): كيف يتم تمرير البيانات بين الصفحات؟

**الإجابة:** عبر المتحكمات المشتركة، لا عبر معاملات التنقل:

- `WeatherController` مسجل بـ`Get.put`، ويُقرأ بـ`Get.find` في الشاشات.
- `NotesController` كذلك.

هذا يسمح لشاشة البحث بتحديث الطقس ثم رؤية النتيجة في شاشة الطقس دون تمرير كائنات.

---

## 3. أسئلة عن Widgets

### س1 (سهل): ما الفرق بين `StatelessWidget` و`StatefulWidget`؟ أعطِ مثالًا.

**الإجابة:**

- `StatelessWidget`: لا حالة متغيرة. مثال: `GlassCard` في `glass_card.dart:16`.
- `StatefulWidget`: له `State` ويمكن أن يتغير. مثال: `NotesScreen` في `notes_screen.dart:13`.

`GlassCard` تعرض شكلًا ثابتًا حسب معاملاتها، بينما `NotesScreen` تتغير قائمتها وحقل بحثها.

---

### س2 (سهل): ما وظيفة `build()`؟

**الإجابة:** تصف الواجهة عند كل إعادة بناء. يجب أن تكون خالية من الآثار الجانبية (لا إرسال طلبات أو تعديل حالة داخلها). الطلبات موجودة في `initState` أو المتحكمات.

---

### س3 (متوسط): لماذا نستخدم `Expanded` حول عنوان الملاحظة؟

**الإجابة:** لأن الصف يحتوي عنوانًا + زر تعديل + زر حذف. `Expanded` يعطي العنوان المساحة المتبقية ويمنع تجاوز الأزرار. مع `maxLines: 1` و`ellipsis` يظهر العنوان الطويل بثلاث نقاط.

**الكود:** `notes_screen.dart:233-243`.

---

### س4 (متوسط): ما الفرق بين `ListView` و`SingleChildScrollView`؟

**الإجابة:**

- `SingleChildScrollView` يمرر محتوى واحدًا كبيرًا، ويبني كل شيء دفعة واحدة. مناسب للصفحات القصيرة/المتوسطة مثل نموذج الملاحظة.
- `ListView.builder` يبني العناصر الظاهرة فقط. مناسب لقائمة ملاحظات قد تطول.

**أين؟** `notes_screen.dart:72` للقائمة، و`note_form_screen.dart:80` للنموذج.

---

### س5 (متقدم): كيف يعمل `GlassCard` لجعل الخلفية ضبابية؟

**الإجابة:**

```text
DecoratedBox (ظل)
└── ClipRRect (قص الزوايا)
    └── BackdropFilter (ImageFilter.blur)
        └── Stack (تعبئة + لمعات + محتوى)
```

`BackdropFilter` يضبب ما هو **خلف** البطاقة، وليس محتواها. لذلك يجب أن تكون طبقة التعبئة شبه شفافة، وإلا لن يظهر الضباب.

**الكود:** `glass_card.dart:199-215`.

---

### س6 (عملي): ماذا يحدث لو أزلنا `ClipRRect` من `GlassCard`؟

**الإجابة:** قد يتسرب تأثير الـBlur خارج الزوايا الدائرية، وتظهر حواف غير نظيفة. `ClipRRect` يضمن أن الضباب والتعبئة محصوران في شكل البطاقة.

---

### س7 (متقدم): كيف يتكيف `_InfoGrid` مع الشاشات الصغيرة؟

**الإجابة:** يستخدم `LayoutBuilder` و`MediaQuery.textScalerOf`:

```dart
final columns = (constraints.maxWidth < 300 || textScale > 1.25) ? 2 : 3;
```

إذا كان العرض أقل من 300 أو الخط مكبّرًا، يستخدم عمودين بدل ثلاثة. هذا يمنع Overflow.

**الكود:** `weather_screen.dart:292-310`.

---

### س8 (عملي): كيف يعمل شريط التنقل؟

**الإجابة:**

- `HomeScreen` يحتفظ بـ`_currentIndex`.
- `FloatingNavBar` يعرض الأيقونات ويستدعي `onTap(i)`.
- `_onTabTap` يحدث الحالة ويحرك `PageController`.
- `PageView` يعرض الصفحة المناسبة.

**ملاحظة:** `NeverScrollableScrollPhysics` يمنع السحب اليدوي، فالتنقل فقط عبر الشريط.

---

## 4. أسئلة عن API

### س1 (سهل): ما هو API؟ وما نوع الطلب المستخدم؟

**الإجابة:** API واجهة تسمح للتطبيق بطلب بيانات من خدمة خارجية. نستخدم **GET** لأننا نقرأ بيانات فقط.

**المصدر:** Open-Meteo:

- `https://geocoding-api.open-meteo.com/v1/search`
- `https://api.open-meteo.com/v1/forecast`

**الملف:** `weather_service.dart:13-16`.

---

### س2 (سهل): ما هو JSON؟ وكيف نحوله؟

**الإجابة:** JSON صيغة نصية لتبادل البيانات. نستخدم `jsonDecode(response.body)` من `dart:convert` لتحويله إلى `Map`/`List`.

**الكود:** `weather_service.dart:35` و`71`.

---

### س3 (متوسط): كيف نتعامل مع رمز الحالة `statusCode`؟

**الإجابة:**

```dart
if (response.statusCode == 200) {
  ...
} else {
  throw Exception('فشل جلب الطقس (رمز: ${response.statusCode})');
}
```

`200` تعني نجاح. أي رمز آخر (400, 404, 500...) يُحوَّل إلى استثناء يصل للمتحكم ثم للواجهة.

---

### س4 (متوسط): ماذا يحدث عند انقطاع الإنترنت؟

**الإجابة:** يرمي `http` استثناء `SocketException`. الخدمة تلتقطه:

```dart
} on SocketException {
  throw Exception('لا يوجد اتصال بالإنترنت');
}
```

ثم المتحكم يضع الرسالة في `errorMessage.value`، و`Obx` يعرضها مع زر إعادة المحاولة.

---

### س5 (متقدم): لماذا نستخدم `timeout`؟

**الإجابة:** لمنع الانتظار اللانهائي إذا لم يستجب السيرفر. في `weather_service.dart:32` و`68`:

```dart
.timeout(const Duration(seconds: 15))
```

بعد 15 ثانية يرمي `TimeoutException`، وتظهر رسالة «انتهت مهلة الاتصال».

---

### س6 (متقدم): كيف نمنع نتيجة بحث قديمة من استبدال نتيجة جديدة؟

**الإجابة:** عبر `_searchRequestId` في `weather_controller.dart:21` و`99` و`107`:

```dart
final requestId = ++_searchRequestId;
...
if (requestId != _searchRequestId) return;
```

كل طلب جديد يزيد الرقم. عند وصول نتيجة قديمة، يكون رقمها أقل من الحالي، فتُتجاهل.

**لماذا نحتاجها؟** لأن الشبكة قد تعيد نتيجة «San» بعد نتيجة «Sana»؛ بدون الحماية ستظهر نتائج خاطئة.

---

### س7 (عملي): كيف يتم البحث عن مدينة؟

**الإجابة:**

1. `onSearchChanged` يتحقق من الطول.
2. debounce 400ms.
3. `searchLocations` يبني رابط Geocoding.
4. يحول النتائج إلى `Location`.
5. `searchResults.assignAll`.
6. `Obx` يعرض القائمة.
7. عند اختيار مدينة: `selectLocation` يجلب الطقس بالإحداثيات.

**الملفات:** `weather_controller.dart:69-120`, `weather_service.dart:18-51`.

---

### س8 (متقدم): ماذا لو أرادت الأستاذة إضافة مدينة افتراضية أخرى؟

**الإجابة:** نغيّر القيمة الأولية في `weather_controller.dart:11`:

```dart
final currentCity = 'صنعاء'.obs;
```

إلى اسم آخر. لكن يجب أن يكون الاسم قابلًا للبحث في Geocoding. لا نغيّر `WeatherService`.

---

## 5. أسئلة عن Future وFutureBuilder

### س1 (سهل): ما هي `Future`؟

**الإجابة:** كائن يمثل نتيجة عملية ستكتمل لاحقًا، مثل طلب شبكة أو قراءة قاعدة بيانات.

**مثال:** `Future<Weather> fetchWeatherForCoords(...)`.

---

### س2 (سهل): ما وظيفة `async` و`await`؟

**الإجابة:**

- `async` تجعل الدالة قادرة على إرجاع `Future` واستخدام `await`.
- `await` تنتظر النتيجة دون تجميد الواجهة.

**مثال:** `weather_controller.dart:35-47`.

---

### س3 (متوسط): هل يستخدم المشروع `FutureBuilder`؟

**الإجابة:** **لا.** لا يوجد `FutureBuilder` في أي ملف داخل `lib`.

المشروع يستخدم:

- `Future` + `async/await` في الخدمات والمتحكمات.
- `Obx` لعرض الحالات.

هذا نمط بديل، وليس خطأً.

---

### س4 (متوسط): ما الفرق بين `FutureBuilder` والنمط المستخدم؟

**الإجابة:**

| FutureBuilder | النمط هنا |
|---|---|
| Widget يراقب Future مباشرة | المتحكم ينتظر Future ويخزن النتيجة |
| `snapshot.connectionState` | `isLoading.value` |
| `snapshot.hasError` | `errorMessage.value != null` |
| `snapshot.data` | `weather.value` |
| يحتاج إدارة Future في الشاشة | الحالة مشتركة بين الشاشات |

**لماذا النمط هنا؟** لأن الطقس مشترك بين 3 شاشات، وGetX يوفر حالة واحدة.

---

### س5 (متقدم): ما هو `snapshot`؟ وما `ConnectionState`؟

**الإجابة (نظريًا، لأنه غير مستخدم هنا):**

- `snapshot`: كائن يحتوي حالة العملية وبياناتها وخطأها.
- `ConnectionState.waiting`: لم تكتمل.
- `ConnectionState.done`: اكتملت.
- `snapshot.hasData`: وصلت بيانات.
- `snapshot.hasError`: حدث خطأ.

**مثال من `api_ex` وليس من المشروع:**

```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  return const CircularProgressIndicator();
}
if (snapshot.hasError) return ...;
final posts = snapshot.data ?? [];
```

---

### س6 (عملي): أين نعرض حالة التحميل في المشروع؟

**الإجابة:**

- `isLoading.value` في `WeatherController` و`NotesController`.
- `WeatherSkeleton` / `NotesSkeleton` / `HomeSkeleton`.
- `LinearProgressIndicator` أثناء تحديث الطقس في `_WeatherContent`.

**الكود:** `weather_screen.dart:133-140`, `home_screen.dart:169`, `notes_screen.dart:64-66`.

---

### س7 (متقدم): ماذا يحدث لو نسي المبرمج `finally { isLoading.value = false; }`؟

**الإجابة:** إذا فشل الطلب، سيبقى `isLoading` مساويًا `true`، وقد يظل مؤشر التحميل ظاهرًا إلى الأبد، وتمنع بعض الواجهات التفاعل. `finally` تضمن التنظيف في كل الحالات.

---

### س8 (عملي): أين يتم إنشاء Future للطقس؟

**الإجابة:** داخل `WeatherService`:

- `searchLocations` تعيد `Future<List<Location>>`.
- `fetchWeatherForCoords` تعيد `Future<Weather>`.
- `fetchWeatherForCity` تعيد `Future<Weather>` (وتستدعي الاثنتين).

المتحكم لا ينشئ Future بنفسه؛ بل ينتظر ما تعيده الخدمة.

---

## 6. أسئلة عن SQLite وCRUD

### س1 (سهل): ما SQLite؟ وما sqflite؟

**الإجابة:**

- SQLite: محرك قاعدة بيانات محلي داخل التطبيق.
- sqflite: حزمة Flutter للتعامل مع SQLite.

**لماذا محلية؟** لأن الملاحظات خاصة، ولا تحتاج إنترنت أو سيرفر.

---

### س2 (سهل): ما الجدول والصف والعمود والمفتاح الأساسي؟

**الإجابة:**

- الجدول: `notes`.
- الصف: ملاحظة واحدة.
- العمود: `title`, `content`, `created_at`...
- المفتاح الأساسي: `id`، فريد لكل ملاحظة.

---

### س3 (متوسط): كيف يتم إنشاء قاعدة البيانات والجدول؟

**الإجابة:** في `database_service.dart:17-34`:

- `getDatabasesPath()` يعيد مسار التطبيق.
- `join` يدمج الاسم.
- `openDatabase` يفتح/ينشئ.
- `onCreate` ينفذ `CREATE TABLE`.

**مهم:** `onCreate` يعمل مرة واحدة فقط عند أول إنشاء.

---

### س4 (متوسط): اشرح عملية إضافة ملاحظة.

**الإجابة:**

1. `NoteFormScreen._save` تتحقق من الحقول.
2. `NotesController.addNote` تنشئ `Note` بـ`DateTime.now()`.
3. `DatabaseService.insertNote` تحول `toMap` وتحذف `id`.
4. `db.insert` ينفذ `INSERT`.
5. `loadNotes` تعيد القراءة.
6. `notes.assignAll` تحدث القائمة.
7. `Get.back(true)` يعيد للملاحظات ويعرض Snackbar.

---

### س5 (متوسط): كيف يتم التعديل؟

**الإجابة:**

- `note.copyWith(title: ..., content: ..., updatedAt: now)`.
- `updateNote` ينفذ `UPDATE notes SET ... WHERE id = ?`.
- `whereArgs` تحمي من SQL Injection.
- ثم `loadNotes`.

**الكود:** `notes_controller.dart:51-58`, `database_service.dart:48-52`.

---

### س6 (متقدم): لماذا نستخدم `whereArgs` بدل دمج النص؟

**الإجابة:** لتجنب SQL Injection. لو دمجنا:

```dart
where: 'id = $id'
```

وكان `id` نصًا خبيثًا، فقد يغير الاستعلام. `whereArgs` يرسل القيمة منفصلة ويضمن معاملتها كبيانات.

---

### س7 (متقدم): ماذا يحدث لو حذفنا `..remove('id')` قبل `INSERT`؟

**الإجابة:** سيُرسل `id: null` إلى SQLite. مع `AUTOINCREMENT` قد يعمل الإدراج ويعطي رقمًا جديدًا، لكن في بعض الحالات قد يسبب خطأ أو سلوكًا غير متوقع. الأفضل حذفه كما هو موجود.

---

### س8 (عملي): كيف تبقى الملاحظات بعد إغلاق التطبيق؟

**الإجابة:** لأن SQLite يخزنها في ملف دائم في مسار التطبيق. عند إعادة الفتح، نفس `weather_notes.db` موجود، و`loadNotes` تقرأه.

**لا نستخدم** `shared_preferences` أو الذاكرة فقط.

---

### س9 (متقدم): هل يستخدم المشروع Transactions؟

**الإجابة:** **لا.** `DatabaseService` ينفذ عمليات فردية. ظهرت Transactions في مثال `my_expenses`، لكنها غير مستخدمة هنا.

**متى نحتاجها؟** عند تنفيذ أكثر من عملية يجب أن تنجح كلها أو تفشل كلها (مثل خصم رصيد وإضافة مصروف).

---

## 7. أسئلة عن GetX وإدارة الحالة

### س1 (سهل): ما هو GetX؟ وما مكوناته المستخدمة هنا؟

**الإجابة:** حزمة تجمع الحالة والتنقل والرسائل. المستخدم هنا:

- `GetMaterialApp`
- `GetxController`
- `Get.put` / `Get.find`
- `Rx` / `.obs` / `Rxn`
- `Obx`
- `Get.to` / `Get.back`
- `Get.dialog` / `Get.snackbar`
- `Get.isRegistered`

---

### س2 (سهل): ما وظيفة `Get.put` و`Get.find`؟

**الإجابة:**

- `Get.put`: يسجل المتحكم.
- `Get.find`: يعيده من السجل.

**الكود:** `home_screen.dart:30-35` للتسجيل، و`weather_screen.dart:23` للوصول.

**لماذا؟** لمشاركة نفس الحالة بين الشاشات.

---

### س3 (متوسط): ما وظيفة `Obx`؟

**الإجابة:** يعيد بناء محتواه عند تغير أي متغير Rx يُقرأ داخله.

**مثال:** `home_screen.dart:159` يقرأ `weather.value` و`errorMessage.value`.

**تحذير:** يجب قراءة Rx داخل `Obx`، وإلا لن تتم المراقبة.

---

### س4 (متوسط): ما الفرق بين `Rx<T>` و`Rxn<T>`؟

**الإجابة:**

- `Rx<T>`: قيمة غير قابلة للـ`null` (نظريًا)، مثل `false.obs` → `RxBool`.
- `Rxn<T>`: قيمة قد تكون `null`، مثل `Rxn<Weather>()`.

`RxnString()` تعني نصًا قد يكون `null`، وتُستخدم لرسالة الخطأ.

---

### س5 (متقدم): لماذا نستخدم `permanent: true`؟

**الإجابة:** حتى لا يحذف GetX المتحكم عند إغلاق الشاشة. الطقس والملاحظات يجب أن يبقيا طوال عمر التطبيق.

**بدونها:** قد يُحذف المتحكم عند إغلاق الشاشة، وتفقد البيانات، أو يُعاد إنشاؤه من جديد.

---

### س6 (متقدم): ما الفرق بين `Get.to` و`Navigator.push`؟

**الإجابة:**

| GetX | Navigator |
|---|---|
| `Get.to(() => Screen())` | `Navigator.push(context, MaterialPageRoute(...))` |
| `Get.back(result: true)` | `Navigator.pop(context, true)` |
| لا يحتاج `context` غالبًا | يحتاج `context` |
| جزء من GetX | مدمج في Flutter |

المشروع يستخدم GetX لأنه يعتمد عليه أصلًا.

---

### س7 (عملي): كيف تعرض رسالة نجاح الحفظ؟

**الإجابة:** في `notes_screen.dart:110-128`:

1. `Get.to<bool>` ينتظر النموذج.
2. النموذج يعيد `true` بعد الحفظ.
3. إذا `saved == true`، يعرض `Get.snackbar`.

**لماذا لا يعرض النموذج الرسالة بنفسه؟** لأن النموذج سيُغلق مباشرة، وقد تختفي الرسالة معه. عرضها في الشاشة المستقبلة أضمن.

---

### س8 (متقدم): هل يمكن الاستغناء عن `setState` واستخدام GetX فقط؟

**الإجابة:** نظريًا نعم، لكنه ليس ضروريًا. `_currentIndex` حالة محلية بسيطة، و`setState` أخف وأوضح. GetX مناسب للحالة المشتركة. الخلط المدروس بينهما مقبول.

---

### س9 (عملي): أين يتم التخلص من الموارد؟

**الإجابة:**

- `HomeScreen.dispose` يتخلص من `PageController` (`home_screen.dart:39-42`).
- `NoteFormScreen.dispose` يتخلص من `TextEditingController`.
- `WeatherSearchScreen.dispose` كذلك.
- `WeatherController.onClose` يلغي `_debounce`.
- `FadeSlideIn.dispose` يتخلص من `AnimationController`.
- `AppButton` لا يحتاج؛ لا يملك Controller.

---

## 8. أسئلة عن Models

### س1 (سهل): لماذا نستخدم Models بدل `Map`؟

**الإجابة:** لأنها:

- تحدد الأنواع.
- تمنع أخطاء أسماء المفاتيح.
- تجمع التحويل في مكان واحد.
- تجعل الكود أوضح: `weather.temperature` بدل `json['current']['temperature_2m']`.

---

### س2 (سهل): ما وظيفة المُنشئ (Constructor)؟

**الإجابة:** ينشئ الكائن ويضع قيمه. `required` تفرض وجود الحقول الإلزامية.

**مثال:** `Weather(...)` في `weather.dart:13-24`.

---

### س3 (متوسط): ما وظيفة `fromJson`؟

**الإجابة:** تحويل `Map` قادم من JSON إلى كائن Dart.

**مثال:** `Weather.fromJson` و`Location.fromJson`.

**ملاحظة:** `Note` لا يستخدم `fromJson` لأن مصدره SQLite، ويستخدم `fromMap`.

---

### س4 (متوسط): هل يوجد `toJson`؟

**الإجابة:** **لا** داخل `lib`. يوجد `toMap` في `Note` للقاعدة، و`Post.toJson` في مثال `api_ex` لكنه ليس جزءًا من المشروع.

**لماذا لا نحتاجه؟** لأن الملاحظات لا تُرسل إلى API.

---

### س5 (متقدم): ما وظيفة `copyWith`؟

**الإجابة:** إنشاء نسخة جديدة مع تعديل بعض الحقول والحفاظ على الباقي.

**مثال:** `note.copyWith(title: ..., updatedAt: now)`.

**لماذا لا نعدل الحقول مباشرة؟** لأنها `final`؛ النماذج غير قابلة للتغيير (immutable)، وهذا safer.

---

### س6 (متقدم): لماذا `lastUpdated` لا يأتي من API؟

**الإجابة:** لأن Open-Meteo لا يعيد وقت التحديث بالشكل الذي نريده، ولأننا نريد وقت الجهاز عند الجلب. يُضبط في `weather.dart:55` بـ`DateTime.now()`.

**نتيجة:** كل جلب جديد يحدث الوقت.

---

### س7 (عملي): كيف يتحول كود الطقس إلى وصف وأيقونة؟

**الإجابة:** عبر `weatherDescription(code)` و`weatherIcon(code)` في `weather.dart:81-105`.

**مثال:** `code == 0` → «سماء صافية» + ☀️.

هذا يفصل منطق العرض عن منطق البيانات.

---

### س8 (متقدم): ماذا لو كان `daily` غير موجود في JSON؟

**الإجابة:** `weather.dart:28` يقرأه كـ`Map?`، ثم `if (daily != null)` يمنع الحلقة. تبقى `dailyList` فارغة، وتصبح `tempMax` و`tempMin` مساوية `null`.

**النتيجة:** لا تظهر درجة العظمى/الصغرى، ولا تظهر بطاقة التوقعات (`if (forecast.isEmpty) return SizedBox.shrink()`).

---

## 9. أسئلة عن تنظيم الملفات والمجلدات

### س1 (سهل): لماذا قسمنا المشروع إلى مجلدات؟

**الإجابة:** لفصل المسؤوليات:

- `models`: شكل البيانات.
- `services`: الخارج (HTTP/SQLite).
- `controllers`: الحالة والمنطق.
- `screen`: الصفحات.
- `widgets`: مكونات مشتركة.
- `constants`: قيم ثابتة.

هذا يجعل العثور على الكود أسهل ويقلل التكرار.

---

### س2 (سهل): ما الفرق بين `service` و`controller`؟

**الإجابة:**

- `Service`: يتحدث مع العالم الخارجي (API/DB)، ولا يعرف الواجهة.
- `Controller`: يحتفظ بالحالة، يستدعي الخدمة، ويوفر البيانات للواجهة.

**مثال:** `WeatherService.fetchWeatherForCity` لا يعرف `Obx`، و`WeatherController` لا يعرف `http`.

---

### س3 (متوسط): أين توضع Widgets المشتركة؟ ولماذا؟

**الإجابة:** في `lib/widgets`. مثل `GlassCard` المستخدمة في 5 شاشات. لو تركت داخل شاشة، لتكرر الكود أو لاستوردنا شاشة من شاشة.

---

### س4 (متوسط): لماذا `constants` منفصلة؟

**الإجابة:** لتجميع الألوان والنصوص. تغيير نص أو لون يتم في مكان واحد، وتقل الأخطاء.

---

### س5 (متقدم): هل تنظيم المشروع يطابق المنهج؟

**الإجابة:** المنهج المكتوب غير متاح. الأمثلة المتاحة تستخدم تنظيمًا أبسط (ملفات قليلة في `lib`)، بينما المشروع الحالي منظم إلى طبقات. هذا **اختلاف في الأسلوب وليس مخالفة**؛ التنظيم الطبقي أوضح للمشاريع المتوسطة.

---

### س6 (عملي): أين أبحث عن كود جلب الطقس؟

**الإجابة:** `lib/services/weather_service.dart`، ثم `lib/controllers/weather_controller.dart`، ثم `lib/screen/weather_screen.dart`.

---

### س7 (عملي): أين أبحث عن كود الملاحظات؟

**الإجابة:** `lib/screen/notes_screen.dart` و`note_form_screen.dart`، ثم `lib/controllers/notes_controller.dart`، ثم `lib/services/database_service.dart`.

---

## 10. أسئلة عن طريقة عمل المشروع بالكامل

### س1 (سهل): اشرح رحلة تشغيل التطبيق.

**الإجابة:**

```text
main → GetMaterialApp → HomeScreen
  → Get.put(WeatherController) → onInit → loadWeather
  → Get.put(NotesController) → onInit → loadNotes
  → PageView + FloatingNavBar
```

---

### س2 (سهل): كيف ينتقل المستخدم بين الأقسام؟

**الإجابة:** عبر `FloatingNavBar`:

- الضغط يستدعي `_onTabTap`.
- `setState` يغير `_currentIndex`.
- `PageController.animateToPage` يحرك `PageView`.

الشاشات الفرعية عبر `Get.to`.

---

### س3 (متوسط): اشرح مسار جلب الطقس من البداية للنهاية.

**الإجابة:**

1. `WeatherController.loadWeather`.
2. `WeatherService.fetchWeatherForCity`.
3. `searchLocations` → Geocoding API.
4. `fetchWeatherForCoords` → Forecast API.
5. `Weather.fromJson`.
6. `weather.value = result`.
7. `Obx` يعيد البناء.
8. تظهر البطاقة.

---

### س4 (متوسط): اشرح مسار إضافة ملاحظة.

**الإجابة:**

1. زر الإضافة → `_openForm`.
2. `Get.to(NoteFormScreen)`.
3. التحقق من `Form`.
4. `addNote` → `insertNote` → `INSERT`.
5. `loadNotes` → `SELECT`.
6. `notes.assignAll`.
7. `Get.back(true)`.
8. Snackbar.

---

### س5 (متقدم): ماذا يحدث إذا أغلقت الإنترنت وفتحت شاشة الطقس؟

**الإجابة:**

- `loadWeather` يبدأ.
- `SocketException`.
- `errorMessage.value` تصبح «لا يوجد اتصال بالإنترنت».
- `isLoading` تصبح `false`.
- `Obx` يعرض `AppErrorWidget` أو `_ErrorBanner` مع زر إعادة المحاولة.

**لا يحدث Crash** لأن هناك `try/catch`.

---

### س6 (متقدم): ماذا يحدث إذا كانت قاعدة البيانات فارغة؟

**الإجابة:**

- `loadNotes` تعيد قائمة فارغة.
- `notes` تبقى فارغة.
- `NotesScreen` تعرض `_EmptyState` مع رسالة «لا توجد ملاحظات بعد».
- لا خطأ.

---

### س7 (متقدم): أين يمكن أن يحدث Crash؟ وكيف نتجنبه؟

**الإجابة:** أخطر المواضع:

1. `weather.value!` دون التحقق → نتجنب بـ`if (value == null)`.
2. `note.id!` دون التحقق → نتجنب بـ`if (note.id == null) return`.
3. `_formKey.currentState!` → نتجنب لأن `Form` موجود دائمًا وقت الاستدعاء.
4. `Get.find` دون `Get.put` → نتجنب بترتيب التسجيل في `HomeScreen.initState`.
5. `DateTime.parse` على نص غير صالح → نفترض أن SQLite يخزن ISO صحيحًا لأننا نكتبه بأنفسنا.

---

### س8 (عملي): ما الذي يتغير في الواجهة عند تحديث الطقس؟

**الإجابة:** `isLoading` تصبح `true`، فيظهر شريط تقدم صغير في `_WeatherContent`. عند الانتهاء، `weather.value` تتغير أو `errorMessage`، و`Obx` يعيد البناء.

**ملاحظة:** البيانات القديمة تبقى ظاهرة أثناء التحديث (لا تختفي)، وهذا مقصود لتجربة أفضل.

---

### س9 (متقدم): لو طُلب منك إضافة ميزة «ترتيب الملاحظات حسب التاريخ»، أين تعدل؟

**الإجابة:** في `DatabaseService.fetchNotes`:

```dart
orderBy: 'updated_at DESC'
```

يمكن تغييره إلى `created_at DESC` أو `title ASC`. لا حاجة لتعديل الواجهة لأنها تعرض ترتيب القائمة كما تأتي.

---

### س10 (ختامي): ما أكبر فرق بين المشروع والأمثلة المتاحة؟

**الإجابة:**

| الجانب | الأمثلة | المشروع |
|---|---|---|
| الحالة | `setState`/Provider/GetX بسيط | GetX كامل مع متحكمين |
| API | `FutureBuilder` في `api_ex` | `Future` + `await` + `Obx` |
| SQLite | `my_expenses` مع Transactions | CRUD أساسي بدون Transactions |
| التنظيم | ملفات قليلة | طبقات `models/services/controllers/screens/widgets` |
| الواجهة | Material بسيط | تصميم زجاجي مخصص |

**الخلاصة:** المشروع يطبّق المفاهيم الأساسية نفسها، لكن بأسلوب تنظيمي وحالة أكثر تقدمًا.

---

### انتهى ملف الأسئلة

> راجع الدليل الرئيسي ومرجع الملفات للتفاصيل الكاملة.
