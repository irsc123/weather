# 03 — أسئلة الأستاذة المتوقعة وإجاباتها المرتبطة بالمشروع

> **المشروع:** Weather & Notes — `C:\flutter_app\weather_notes`
>
> **طريقة الإجابة:** كل إجابة مرتبطة بملف ودالة وسطر فعلي. لا إجابات نظرية منفصلة عن الكود.

---

## 1. أسئلة اختيار API وSQLite

### س1: لماذا اخترت API في هذا المشروع؟

**الإجابة:**

لأن بيانات الطقس خارجية ومتغيرة، ولا يمكن معرفتها مسبقًا داخل التطبيق. استخدمت **Open-Meteo API** لجلب:

- حالة الطقس الحالية.
- توقعات 5 أيام.
- إحداثيات المدينة عند البحث عنها.

**الدليل:**

- `lib/services/weather_service.dart:13-16` يحتوي رابطي الخدمة.
- `weather_service.dart:30-32` يرسل طلب `GET` للبحث.
- `weather_service.dart:66-68` يرسل طلب `GET` للطقس.

**لو لم أستخدم API:** سأحتاج إلى إدخال بيانات الطقس يدويًا أو تخزينها مسبقًا، وستكون قديمة وغير واقعية.

---

### س2: لماذا اخترت SQLite؟

**الإجابة:**

لأن الملاحظات بيانات شخصية يجب أن تبقى بعد إغلاق التطبيق، ولا تحتاج إلى سيرفر أو إنترنت. استخدمت `sqflite` لأنها:

- تعمل محليًا.
- سريعة.
- تحفظ البيانات في ملف دائم.
- مناسبة لعمليات CRUD البسيطة.

**الدليل:**

- `lib/services/database_service.dart:1-9` يستورد `sqflite` ويعرّف اسم القاعدة `weather_notes.db` والجدول `notes`.
- `database_service.dart:36-57` ينفذ `INSERT` و`SELECT` و`UPDATE` و`DELETE`.

---

### س3: ما الفرق بين API وقاعدة البيانات المحلية؟

**الإجابة:**

| API | SQLite |
|---|---|
| مصدر خارجي على الإنترنت | ملف داخل الجهاز |
| يحتاج اتصالًا بالشبكة | لا يحتاج إنترنت |
| البيانات قد تتغير على الخادم | البيانات تحت سيطرة التطبيق |
| مناسب للطقس والتوقعات | مناسب للملاحظات الشخصية |
| مثال: Open-Meteo | مثال: `weather_notes.db` |

**في مشروعي:** الطقس من API، والملاحظات من SQLite.

---

### س4: لماذا استخدمت الاثنين معًا؟ أليس واحدًا كافيًا؟

**الإجابة:**

لأن لكل نوع بيانات طبيعة مختلفة:

- **الطقس:** بيانات خارجية متغيرة، لا معنى لتخزينها محليًا دون تحديث؛ لذلك API.
- **الملاحظات:** بيانات المستخدم، يجب حفظها دائمًا؛ لذلك SQLite.

لو استخدمت API فقط: سأفقد الملاحظات عند إغلاق التطبيق.
لو استخدمت SQLite فقط: لن أحصل على بيانات طقس حقيقية ومحدثة.

**الدليل:** `weather_controller.dart` يستدعي `WeatherService`، و`notes_controller.dart` يستدعي `DatabaseService`. لا يوجد تداخل بينهما.

---

## 2. أسئلة State Management وGetX

### س5: ما المقصود بـ State Management؟

**الإجابة:**

هي إدارة البيانات التي تتغير أثناء استخدام التطبيق، وتحديث الواجهة عندما تتغير.

**مثال من المشروع:** عند جلب الطقس، تتغير حالة `weather` من `null` إلى كائن `Weather`، وتتغير `isLoading` من `true` إلى `false`، فتتحدث الواجهة.

**الدليل:** `weather_controller.dart:10-18` يعرّف متغيرات الحالة.

---

### س6: لماذا استخدمت GetX؟

**الإجابة:**

لأن GetX يوفر:

- إدارة حالة عبر `GetxController`.
- متغيرات تفاعلية عبر `.obs` و`Rxn`.
- إعادة بناء تلقائية عبر `Obx`.
- حقن تبعيات بسيط عبر `Get.put` و`Get.find`.
- تنقلًا ورسائل دون `BuildContext` غالبًا.

**الدليل:**

- `main.dart:19` يستخدم `GetMaterialApp`.
- `weather_controller.dart:7` و`notes_controller.dart:5` يرثان `GetxController`.
- `home_screen.dart:30-35` يسجل المتحكمين.
- `home_screen.dart:159` يستخدم `Obx`.

**لماذا ليس Riverpod؟** لأن GetX هو ما طبقته فعليًا، وRiverpod غير موجود في `pubspec.yaml` ولا في `lib`. الأستاذة تسمح بواحد منهما، والمشروع اختار GetX.

---

### س7: ما الفرق بين المتغير العادي والمتغير التفاعلي؟

**الإجابة:**

| عادي | تفاعلي |
|---|---|
| `final WeatherService _service = WeatherService();` | `final isLoading = false.obs;` |
| لا يعيد بناء الواجهة عند تغيره | يعيد بناء ما يعتمد عليه عند تغيير `.value` |
| نوعه `WeatherService` | نوعه `RxBool` |
| لا يحتاج `Obx` | يحتاج `Obx` أو `FutureBuilder`/`setState` حسب الاستخدام |

**مثال:**

```dart
isLoading.value = true;
```

لا نكتب `isLoading = true` لأن `isLoading` كائن `RxBool` وليس `bool`.

---

### س8: كيف يتم الوصول إلى Controller؟

**الإجابة:**

1. **التسجيل:** `Get.put(WeatherController(), permanent: true)` في `home_screen.dart:30-32`.
2. **الوصول:** `Get.find<WeatherController>()` في `weather_screen.dart:23`.
3. **الاستخدام:** `controller.weather.value` أو `controller.fetchWeather(...)`.

**لماذا `permanent: true`؟** حتى يبقى المتحكم طوال عمر التطبيق ولا يُحذف عند إغلاق الشاشة.

**ماذا لو استدعينا `Get.find` قبل `Get.put`؟** سيحدث خطأ لأن المتحكم غير مسجل. الترتيب في المشروع صحيح: التسجيل في `HomeScreen.initState` قبل بناء الشاشات الفرعية.

---

### س9: ما وظيفة `Obx`؟ وأين تستخدمه؟

**الإجابة:**

`Obx` Widget يعيد بناء محتواه عند تغير أي متغير تفاعلي يُقرأ داخله.

**أماكنه:**

- `home_screen.dart:159` بطاقة الطقس.
- `home_screen.dart:254` بطاقة عدد الملاحظات.
- `weather_search_screen.dart:69` زر مسح البحث.
- `weather_search_screen.dart:94` نتائج البحث.
- `notes_screen.dart:146` حول `FutureBuilder` للبحث.

**مهم:** يجب قراءة المتغير التفاعلي داخل `Obx`، وليس خارجه، وإلا لن تتم المراقبة.

---

### س10: هل يوجد تعارض بين GetX وFutureBuilder؟

**الإجابة:** لا.

- **GetX** يدير الحالة المشتركة (الطقس، الملاحظات، البحث).
- **FutureBuilder** يعرض حالة عملية غير متزامنة واحدة (تحميل/خطأ/بيانات).

في شاشة الطقس: المتحكم يجلب البيانات ويحفظها، و`FutureBuilder` يعرض `_weatherFuture`.
في شاشة الملاحظات: `Obx` يعيد البناء عند تغير البحث، و`FutureBuilder` يعرض `_notesFuture`.

**الدليل:** `weather_screen.dart:80` و`notes_screen.dart:148`.

---

## 3. أسئلة Future وasync/await وFutureBuilder

### س11: ما المقصود بـ Future؟

**الإجابة:**

`Future` كائن يمثل نتيجة عملية ستكتمل لاحقًا، مثل طلب شبكة أو قراءة SQLite.

**أمثلة:**

- `Future<Weather>` من `fetchWeatherForCity`.
- `Future<List<Note>>` من `fetchNotes`.
- `Future<Database>` من `DatabaseService.database`.

**الدليل:** `weather_service.dart:18` و`53` و`84`، `database_service.dart:11` و`42`.

---

### س12: لماذا نستخدم Future؟

**الإجابة:**

لأن الشبكة وSQLite يستغرقان وقتًا. لو انتظرنا بشكل متزامن، ستتجمد الواجهة. `Future` يسمح للتطبيق بالاستمرار ثم استقبال النتيجة.

**مثال:** `WeatherScreen` يعرض `WeatherSkeleton` أثناء انتظار `_weatherFuture`، ثم يعرض البيانات عند اكتمالها.

---

### س13: ما الفرق بين Future وasync وawait؟

**الإجابة:**

| المصطلح | وظيفته |
|---|---|
| `Future` | نوع يمثل نتيجة مستقبلية |
| `async` | تسمح للدالة باستخدام `await` وإرجاع `Future` |
| `await` | ينتظر اكتمال `Future` دون تجميد الواجهة |
| `FutureBuilder` | Widget يعرض حالة `Future` |

**مثال:**

```dart
Future<Weather> fetchWeather(String cityName) async {
  final result = await _service.fetchWeatherForCity(cityName);
  return result;
}
```

- `Future<Weather>` نوع الإرجاع.
- `async` تسمح بـ`await`.
- `await` تنتظر نتيجة الخدمة.

---

### س14: هل يستخدم المشروع FutureBuilder فعلًا؟

**الإجابة:** **نعم، وليس مجرد Future.**

**الدليل الأول:** `weather_screen.dart:80`:

```dart
child: FutureBuilder<Weather>(
  future: _weatherFuture,
  builder: (context, snapshot) { ... },
),
```

**الدليل الثاني:** `notes_screen.dart:148`:

```dart
return FutureBuilder<List<Note>>(
  future: _notesFuture,
  builder: (context, snapshot) { ... },
);
```

**مهم:** المشروع يستخدم `FutureBuilder` في شاشتين فقط، وليس في كل مكان. شاشة البحث تستخدم `Obx` لأنها تعرض حالة بحث تفاعلية وليست Future واحدًا.

---

### س15: لماذا نستخدم FutureBuilder؟

**الإجابة:**

لأنه يعرض حالات العملية غير المتزامنة بشكل منظم:

1. **التحميل:** `ConnectionState.waiting`.
2. **الخطأ:** `snapshot.hasError`.
3. **النجاح:** `snapshot.hasData` أو `snapshot.data`.

بدون `FutureBuilder` سنحتاج إلى إدارة `setState` يدويًا لكل حالة، وقد ننسى حالة.

---

### س16: ما وظيفة snapshot؟

**الإجابة:**

`snapshot` كائن يعطينا حالة الـFuture ونتيجته:

| الخاصية | معناها |
|---|---|
| `connectionState` | waiting / done / active / none |
| `hasData` | هل وصلت بيانات؟ |
| `data` | البيانات نفسها |
| `hasError` | هل حدث خطأ؟ |
| `error` | كائن الخطأ |

**مثال من المشروع:** `weather_screen.dart:84-105`.

---

### س17: ما الفرق بين `hasData` و`hasError` و`connectionState`؟

**الإجابة:**

- `connectionState` تصف **الزمن**: هل العملية ما زالت جارية أم انتهت؟
- `hasData` تصف **النتيجة**: هل توجد بيانات ناجحة؟
- `hasError` تصف **النتيجة**: هل انتهت بخطأ؟

**مهم:** قد تكون `connectionState == done` ومع ذلك `hasError == true`. و`hasData` و`hasError` لا يكونان صحيحين معًا.

**في المشروع:** نتحقق من `waiting` أولًا، ثم `hasError`، ثم `hasData`.

---

### س18: كيف يعرض التطبيق البيانات أثناء التحميل وبعد اكتمالها؟

**الإجابة:**

**الطقس:**

- أثناء التحميل: `WeatherSkeleton` (`weather_screen.dart:84-86`).
- بعد النجاح: `_WeatherContent` (`weather_screen.dart:100-105`).
- عند الخطأ: `_ScrollableError` (`weather_screen.dart:89-97`).

**الملاحظات:**

- أثناء التحميل: `NotesSkeleton` (`notes_screen.dart:152-154`).
- بعد النجاح: `ListView` أو `_EmptyState` (`notes_screen.dart:168-208`).
- عند الخطأ: `_ScrollableError` (`notes_screen.dart:157-165`).

---

### س19: أين يتم إنشاء Future للطقس؟ ولماذا ليس داخل build؟

**الإجابة:**

يُنشأ في `WeatherScreen.initState`:

```dart
_weatherFuture = controller.ensureWeatherLoaded();
```

وفي `_reload` و`_refresh` عند التحديث.

**لماذا ليس داخل `build`؟** لأن `build` قد تُستدعى عدة مرات، وإنشاء Future داخلها يسبب طلبات متكررة. تخزينه في حقل `late Future<Weather>` يضمن استخدام نفس العملية.

**الدليل:** `weather_screen.dart:24` و`30-33` و`36-53`.

---

### س20: ماذا يحدث عند فشل الاتصال بالإنترنت؟

**الإجابة:**

1. `http` يرمي `SocketException`.
2. `WeatherService` يلتقطه ويحوّله إلى `Exception('لا يوجد اتصال بالإنترنت')`.
3. `WeatherController.fetchWeather` يضع الرسالة في `errorMessage.value` ثم `rethrow`.
4. `FutureBuilder` يرى `snapshot.hasError` ويعرض `_ScrollableError`.
5. في الرئيسية، `Obx` يرى `errorMessage.value` ويعرض `AppErrorWidget`.

**الدليل:** `weather_service.dart:44-45`، `weather_controller.dart:53-56`، `weather_screen.dart:88-97`، `home_screen.dart:160-167`.

**لا يحدث Crash** لأن الخطأ معالج.

---

### س21: ماذا يحدث عند فشل عملية SQLite؟

**الإجابة:**

- **القراءة:** `NotesController.loadNotes` يعيد رمي الخطأ، و`FutureBuilder` يعرضه.
- **الحفظ/التعديل:** `NoteFormScreen._save` يلتقط الخطأ ويعرض `SnackBar`.
- **الحذف:** `NotesScreen._confirmDelete` يلتقط الخطأ ويعرض `SnackBar`.

**الدليل:** `notes_controller.dart:37-49`، `note_form_screen.dart:58-65`، `notes_screen.dart:96-106`.

**ملاحظة:** الرسائل عامة، ولا توجد ترجمة دقيقة لكل نوع خطأ SQLite.

---

## 4. أسئلة قاعدة البيانات والملاحظات

### س22: كيف يتم حفظ الملاحظات؟

**الإجابة:**

1. المستخدم يفتح `NoteFormScreen`.
2. يتحقق `Form` من العنوان والمحتوى.
3. `NotesController.addNote` ينشئ `Note` بـ`DateTime.now()`.
4. `DatabaseService.insertNote` يحول `Note` إلى `Map` ويحذف `id`.
5. `db.insert` يكتب في جدول `notes`.
6. `loadNotes` تعيد قراءة القائمة.
7. `notes.assignAll` تحدّث الحالة.
8. `Get.back(result: true)` يعيد للملاحظات.
9. `NotesScreen` يعرض `SnackBar`.

**الدليل:** `note_form_screen.dart:42-57`، `notes_controller.dart:52-61`، `database_service.dart:36-40`.

---

### س23: كيف تتم قراءة الملاحظات وعرضها؟

**الإجابة:**

- `DatabaseService.fetchNotes` ينفذ `db.query('notes', orderBy: 'updated_at DESC')`.
- كل صف يتحول إلى `Note` عبر `Note.fromMap`.
- `NotesController.loadNotes` يضعها في `notes` عبر `assignAll`.
- `FutureBuilder` في `NotesScreen` يعرض `snapshot.data`.
- `ListView.builder` يبني البطاقات.

**الدليل:** `database_service.dart:42-46`، `note.dart:24-30`، `notes_controller.dart:37-50`، `notes_screen.dart:168-208`.

---

### س24: كيف يتم تعديل ملاحظة؟

**الإجابة:**

- `NoteFormScreen` يُفتح مع `note` موجود.
- `_isEditing` يصبح `true`.
- `NotesController.updateNote` يستخدم `note.copyWith` لتحديث العنوان والمحتوى و`updatedAt`.
- `DatabaseService.updateNote` ينفذ `db.update` مع `where: 'id = ?'`.
- `loadNotes` تعيد القراءة.

**الدليل:** `note_form_screen.dart:26` و`47-49`، `notes_controller.dart:63-70`، `database_service.dart:48-52`، `note.dart:32-46`.

---

### س25: كيف يتم حذف ملاحظة؟

**الإجابة:**

- زر الحذف يستدعي `_confirmDelete`.
- `Get.dialog` يعرض تأكيدًا.
- إذا وافق المستخدم، يتحقق الكود من `note.id`.
- `DatabaseService.deleteNote` ينفذ `db.delete` مع `where: 'id = ?'`.
- `loadNotes` تحدّث القائمة.
- `_notesFuture` يُحدَّث بقيمة جاهزة.

**الدليل:** `notes_screen.dart:72-107`، `notes_controller.dart:72-75`، `database_service.dart:54-57`.

**لماذا نتحقق من `note.id == null`؟** لأن الملاحظة غير المحفوظة لا `id` لها، ولا يمكن حذفها من القاعدة.

---

### س26: كيف تبقى الملاحظات بعد إغلاق التطبيق؟

**الإجابة:**

لأن SQLite يحفظها في ملف `weather_notes.db` داخل مسار التطبيق. عند إعادة الفتح:

- `getDatabasesPath()` يعيد نفس المسار.
- `openDatabase` يفتح نفس الملف.
- `loadNotes` تقرأ نفس الصفوف.

**الدليل:** `database_service.dart:7` و`18-19`.

**لا نستخدم** `shared_preferences` أو الذاكرة فقط.

---

### س27: هل تستخدم Transactions؟ ولماذا؟

**الإجابة:** **لا.** كل عملية في `DatabaseService` منفردة: `insert`، `query`، `update`، `delete`.

**متى نحتاجها؟** عند تنفيذ أكثر من عملية يجب أن تنجح كلها أو تفشل كلها، مثل خصم رصيد وإضافة مصروف في نفس الوقت. المشروع الحالي لا يحتاجها لأن كل عملية ملاحظة مستقلة.

---

## 5. أسئلة مقارنة وتقييم

### س28: ما الفرق بين API وSQLite في مشروعك من حيث الأخطاء؟

**الإجابة:**

| API | SQLite |
|---|---|
| أخطاء شبكة، مهلة، JSON غير صالح | أخطاء قراءة/كتابة/قاعدة |
| معالجة مفصلة في `WeatherService` | معالجة موزعة بين `NotesController` والشاشات |
| تظهر في `FutureBuilder` أو بطاقة الخطأ | تظهر في `FutureBuilder` أو `SnackBar` |

**API** أكثر نضجًا في معالجة الأخطاء من SQLite.

---

### س29: هل استخدام API وSQLite منطقي؟

**الإجابة:** نعم.

- الطقس بيانات خارجية متغيرة → API.
- الملاحظات بيانات محلية دائمة → SQLite.
- لا حاجة لمزامنة أو سيرفر.
- الفصل يقلل التعقيد ويطابق المتطلبات.

---

### س30: هل توجد مفاهيم متقدمة أكثر من مستوى المادة؟

**الإجابة:** نعم، لكنها ليست أخطاء:

1. **`_pendingFuture`** لمنع طلبين متوازيين.
2. **`_searchRequestId`** لمنع نتيجة بحث قديمة من استبدال الأحدث.
3. **`Future.value`** لتحديث `FutureBuilder` بعد الحفظ أو الحذف.
4. **`Obx` حول `FutureBuilder`** للبحث المحلي.
5. **`AutomaticKeepAliveClientMixin`** للحفاظ على حالة الصفحات.
6. **`BackdropFilter`** للتصميم الزجاجي.

يمكن شرحها كمزايا إضافية، وليست مطلوبة حرفيًا.

---

### س31: هل توجد نقاط ضعف أو تطبيق جزئي؟

**الإجابة:** نعم، بصراحة:

1. `isLoading` في المتحكمين يُحدَّث لكن الواجهة تستخدم `FutureBuilder`، فهو غير مستهلك.
2. `NotesController.filteredNotes` موجود لكنه غير مستخدم؛ الفلترة مكررة في الشاشة.
3. معالجة أخطاء SQLite عامة وموزعة.
4. **سباق زمني محتمل بعد اختيار مدينة:** `_selectLocation` تنفذ `Get.back()` ثم تنتظر جلب الطقس، بينما `_openSearch` تستأنف فورًا وتتحقق من `controller.weather.value`. لأن `selectLocation` تبدأ بتصفير `weather.value = null`، فقد تسبق `_openSearch` انتهاء الجلب، فلا يُحدَّث `_weatherFuture` وتبقى بيانات المدينة القديمة معروضة. وإذا فشل الجلب فلا يظهر خطأ في شاشة الطقس لأن `selectLocation` تلتقطه دون `rethrow`.
5. **خطأان يمنعان البناء حاليًا** في `weather_screen.dart:95` و`:110` بسبب تعارض نوع `onRetry` (تفصيله في س38).
6. لا توجد اختبارات فعلية.
7. لا توجد Transactions أو `onUpgrade`.

هذه نقاط تحسين، ولا تلغي تحقق المفاهيم المطلوبة في الكود المصدري، لكن النقطتين 4 و5 يجب ذكرهما بصراحة.

---

### س32: لو طلبت الأستاذة إضافة ميزة، كيف تعدل؟

**أمثلة:**

- **تغيير المدينة الافتراضية:** `weather_controller.dart:11` → `final currentCity = 'صنعاء'.obs;`.
- **ترتيب الملاحظات حسب الإنشاء:** `database_service.dart:44` → `orderBy: 'created_at DESC'`.
- **إضافة حقل إلى الملاحظة:** تعديل جدول `notes` في `database_service.dart`، و`Note`، و`Note.fromMap/toMap`، ثم رفع `_dbVersion` وإضافة `onUpgrade`.
- **عرض الطقس دون إنترنت:** إضافة تخزين محلي لآخر استجابة، وهذا يحتاج قرار تصميم جديد.

---

## 6. إجابات سريعة للمناقشة

### س33: اشرح المشروع في 30 ثانية.

**الإجابة:**

«Weather & Notes تطبيق Flutter عربي فيه قسمان: الطقس والملاحظات. الطقس يُجلب من Open-Meteo API عبر `http`، ويُحوَّل JSON إلى Models، ويُعرض عبر `FutureBuilder`. الملاحظات تُحفظ محليًا في SQLite عبر `sqflite` مع عمليات CRUD. أستخدم GetX لإدارة الحالة عبر `GetxController` و`Obx`، و`FutureBuilder` لعرض حالات التحميل والخطأ والنجاح.»

---

### س34: ما أهم ملف في المشروع؟

**الإجابة:** لا يوجد ملف واحد؛ التقسيم هو الأهم:

- `weather_service.dart` و`database_service.dart` للخارج.
- `weather_controller.dart` و`notes_controller.dart` للحالة.
- `weather_screen.dart` و`notes_screen.dart` للعرض.
- `weather.dart` و`note.dart` و`location.dart` للبيانات.

---

### س35: ما الذي لم تستخدمه من GetX؟

**الإجابة:** `GetBuilder`، `GetX<Controller>`، `Get.lazyPut`، `Get.off/offAll`، `Bindings`. المشروع يستخدم `Obx` و`Get.put/find` فقط، وهذا كافٍ.

---

### س36: هل `toJson` مطلوب؟

**الإجابة:** لا، لأن المشروع لا يرسل بيانات إلى API. `Note` يستخدم `toMap` و`fromMap` لSQLite، و`Weather`/`Location` يستخدمان `fromJson` للقراءة فقط.

---

### س37: هل المشروع كامل أكاديميًا؟

**الإجابة:** يحقق المفاهيم المطلوبة في الكود المصدري، لكنه ليس مشروعًا إنتاجيًا كاملًا: لا اختبارات، ولا معاملات، ولا مزامنة، ولا معالجة أخطاء SQLite مفصلة. والأهم أن النسخة الحالية بها خطأان يمنعان البناء (انظر س38). هذا طبيعي لمشروع مادة، لكن يجب الإصلاح قبل التسليم.

---

### س38: هل المشروع يعمل الآن؟ وماذا عن خطأ `flutter analyze`؟

**الإجابة بصراحة:** لا، النسخة الحالية لا تُبنى. `flutter analyze` يعطي:

```text
error - The argument type 'void Function()' can't be assigned to the
        parameter type 'Future<void> Function()'.
        lib\screen\weather_screen.dart:95:26
error - The argument type 'void Function()' can't be assigned to the
        parameter type 'Future<void> Function()'.
        lib\screen\weather_screen.dart:110:24
```

**السبب:** في `weather_screen.dart:119-123` عُرِّفت `_ScrollableError.onRetry` بنوع `Future<void> Function()`، لكن الدالة الممرَّرة `_reload` نوعها `void _reload()`. السطران 95 و110 يمرران `_reload` إلى `onRetry`، فيرفض المحلل الإسناد.

**هذا لا يعني أن مفاهيم `FutureBuilder` خاطئة:** الخطأ في توقيع دالة واجهة، وليس في استخدام `Future` أو `FutureBuilder`.

**الإصلاح:** إما تحويل `_reload` إلى `Future<void> _reload() async { ... }`، أو تغيير `onRetry` إلى `VoidCallback`. لم أُجرِ التعديل لأن المهمة توثيقية فقط.

**كيف أقولها للأستاذة؟** «الكود يطبق المتطلبات، لكن يوجد تعارض بسيط في نوع دالة إعادة المحاولة سأصلحه، وهو لا يؤثر على فهم `FutureBuilder` ولا على بقية المشروع.»

---

### س39: هل يوجد سباق زمني في مسار اختيار المدينة؟

**الإجابة:** نعم، احتمال وارد. بعد اختيار المدينة:

1. `_selectLocation` في `weather_search_screen.dart:34-36` تنفذ `Get.back()` ثم `await controller.selectLocation(location)`.
2. `Get.back()` يعيد التنفيذ فورًا إلى `_openSearch` في `weather_screen.dart:56-64`.
3. `_openSearch` تتحقق من `controller.weather.value != null` وتحدّث `_weatherFuture`.
4. لكن `selectLocation` بدأت بـ`weather.value = null` (`weather_controller.dart:65`) قبل انتهاء الجلب.

**النتيجة:** إذا كانت الشبكة بطيئة، تسبق `_openSearch` انتهاء الجلب فلا يُحدَّث `_weatherFuture`، وتبقى بيانات المدينة القديمة معروضة. وإذا فشل الجلب، لا يظهر الخطأ في شاشة الطقس لأن `selectLocation` تلتقطه دون `rethrow` (`weather_controller.dart:72-73`).

**الحل المقترح:** بعد `await selectLocation`، مزامنة `_weatherFuture` من الشاشة مباشرة، أو إعادة بناء الشاشة عند تغير `weather.value`، أو استخدام `Obx` حول المحتوى بدل الاعتماد على Future منفصل.

**هل هذا يبطل المتطلب؟** لا، لكنه مثال جيد على أن إدارة `Future` في الشاشة يجب أن تُزامَن مع حالة المتحكم.

---

## 7. خلاصة الإجابات

| السؤال | الجواب المختصر |
|---|---|
| لماذا API؟ | بيانات طقس خارجية متغيرة |
| لماذا SQLite؟ | ملاحظات محلية دائمة |
| لماذا الاثنان؟ | كل بيانات لها مصدرها المناسب |
| ما State Management؟ | إدارة البيانات المتغيرة وتحديث الواجهة |
| لماذا GetX؟ | حالة مشتركة + Obx + تنقل + حقن تبعيات |
| هل Riverpod مستخدم؟ | لا |
| ما Future؟ | نتيجة عملية مستقبلية |
| ما FutureBuilder؟ | Widget يعرض تحميل/خطأ/بيانات |
| هل مستخدم؟ | نعم في شاشتي الطقس والملاحظات |
| كيف تُحفظ الملاحظات؟ | `insertNote` ثم `loadNotes` |
| كيف تتحدث الواجهة؟ | `Obx` للحالة، `FutureBuilder` للنتيجة |
| هل المشروع يُبنى حاليًا؟ | لا، خطأ نوع `onRetry` في `weather_screen.dart:95` و`:110` |
| ما سباق اختيار المدينة؟ | `_openSearch` قد تسبق انتهاء `selectLocation` فتعرض بيانات قديمة |
| ماذا عند انقطاع الإنترنت؟ | `SocketException` → رسالة خطأ + إعادة محاولة |
