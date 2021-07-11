<div align="center">
<img src="/doc_img/cover.jpg"/>
</div>

# 📢📢📢 Flutter Best Architecture Challenge 📢📢📢

**「此為參加 Flutter Best Architecture Challenge 活動的專案」**

**聯絡方式：clementlin321@gmail.com**

Hi, This is Clement

感謝Flutter Taipei舉辦這個活動解救WFH到快悶死的我XD

本次我採用的是經典Clean Architecture架構，雖然對這項目來說跟用光劍殺螞蟻沒兩樣，
但是專案規模越大，你越能感受Clean Architecture的優勢，畫面、業務邏輯、資料…職責明確的分層，
高複用性、以及高測試性，會節省你許多維護時間。

<div align="center">
<img src="/doc_img/clean_circle.png"/>
</div>

上圖是`Clean Architecture`的概念圖，架構中有四個角色，以及一條`Dependecy Rule`，線的方向代表依賴關係，外層依賴內層，每一層除了內層成員外，不知道外層發生的任何事，例如：`UseCases`能使用`Entities`提供的對外接口，本身也提供對外接口。

四個角色分別是：

* **Entities**：也能理解為Model。

* **UseCases**：usecase持有Entities，負責操作Entities資料存取以及管理商業邏輯，本身提供Presenter層使用。

* **Presenters**：提供接口給UI呼叫，使用UseCase操作商業邏輯。

* **UI**：UI、tools、framework都是屬於這塊。

## Project Structure

```yaml
- /lib
   - /core
   # Core包含usecase，repository、remote/local data，必要時可以獨立一個module
      - /domain # UseCase
      - /model # json bean
      - /provider
         - /post_api.dart  # api, db...etc
      - /repository
      - core_injection.dart # core的整體di
   - /res
   # 顏色、SizeBox、TextStyle…等列舉
      - /colors.dart
      - /gaps.dart
      - /styles.dart
   - /routes # 路由導航宣告
      - /app_pages.dart
      - /app_routes.dart
   - /screens
      - /components  # 共同custom widget
      - /home  # 主頁
         - /bindings
            - /home_bindins.dart
         - /controller
            - /home_controller.dart
         - /views
            - /home_view
   - main.dart

```

## Clean Architecture in Flutter

<div align="center">
<img src="/doc_img/clean_architecture_all.png"/>
</div>

Clean Architecture在Flutter實作上可以理解成MVVM + Repository pattern的組合(同Android主流架構)，有一點很重要Domain Layer及Data Layer內是純Dart Code不能有Widget元素在其中。

假設我們從上帝視角來看一個專案可以分成三個部份：

* Presentation Layer：View、Controller(ViewModel)

* Domain Layer：UseCase，封裝業務邏輯來提高複用性

* Data Layer：實作Repository pattern，處理資料(Remote、Local)

### Data Layer

<div align="center">
<img src="/doc_img/data_layer.png"/>
</div>

我們用[Dio](https://pub.dev/packages/dio)來處理http request取得Remote Data，接著為了方便我們建立api，使用[retrofit](https://pub.dev/packages/retrofit)來快速産生api class(Android的同學對retrofit應該很熟悉)。

```dart
part 'post_api.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class PostApi {
  factory PostApi(Dio dio, {String baseUrl}) = _PostApi;

  @GET("/posts")
  @NoBody()
  Future<List<Post>> getPosts();
}
```

Dio建立搭配[dio_log](https://pub.dev/packages/dio_log)方便debug，視覺化的log紀錄，對request, response一目了指。

Model層實作Repository Pattern只專注於資料存取，Repository是倉庫的意思，它掌管所有資料的入口，UseCase一律透過Repository來存取資料。Call Api和存取本地儲存(資料庫/Shared Preferences)都在Repository內執行。

```dart
abstract class PostRepository {

  Future<List<Post>> fetchPosts();
}
```

```dart
class PostRepositoryImpl implements PostRepository {

  final PostApi _postApi;

  PostRepositoryImpl(this._postApi);

  @override
  Future<List<Post>> fetchPosts() {
    return _postApi.getPosts();
  }
}
```
### Domain Layer

<div align="center">
<img src="/doc_img/domain_layer.png"/>
</div>

`UseCase` 封裝商業邏輯，目的是提高其複用性。

UseCase跟其它class命名不同，因為`UseCase`使用上跟function相同，所以要用`動詞+名詞`組成如`GetUserInfoUseCase`。

```dart
class FetchPostUseCase extends UseCase<PostRepository, FetchPostUseCaseParams> {
  FetchPostUseCase(PostRepository repository) : super(repository);

  @override
  void dispose() {}

  @override
  Future<List<Post>> execute(FetchPostUseCaseParams param) {
    return repository.fetchPosts();
  }
}

class FetchPostUseCaseParams {
  FetchPostUseCaseParams();
}
```

### Presentation Layer

View、ViewModel(or Controller)都是Presentation Layer的一員，同MVVM架構的精神，View與ViewModel兩者間屬綁定關係，View顯示的資料由ViewModel提供，View並不會主動更新而是根據資料改變才刷新。使用者互動由ViewModel還提供function處理，ViewModel擁有Domain Layer的UseCase來處理商業邏輯。

實作上使用[GetX](https://pub.dev/packages/get)建構整個App，GetX是Flutter目前最具野心的lib，除了三大主要功能：State Manager、Navigation Manager、Dependencies Manager之外，你也可以透過GetX管理Theme、多國語系、No-SQL storage。

<div align="center">
<img src="/doc_img/get_page.png"/>
</div>

一個base GetX的UI結構有三個角色，View、Bindings、Controller(ViewModel)，View毫無反應就是個Widget，Controller繼承GetxController並提供UI需要的資料或事件，再來透過Bindings綁定View與Controller，你就能在Controller中得到View生命周期的callback

#### Controller

在GetX你可以簡單用`.obs`宣告一個同`Stream`的效果，而不需要建立許多StreamContoller

```dart
class HomeController extends GetxController {
  ...
  //提供UI綁定的資料
  final postList = <Post>[].obs;
  final _isSortByTitle = false.obs;
  ...
}
```

View生命周期的callback

```dart
class HomeController extends GetxController {
  ...
  @override
  void onReady() {
    _fetchPosts();
    ever<bool>(_isSortByTitle, (value) => doSortBy(value));
    super.onReady();
  }

  @override
  void onClose() {
    postList.close();
    _isSortByTitle.close();
    super.onClose();
  }

  ...
}
```

這段用到GetX的[Worker](https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md#workers)，意思是每當`_isSortByTitle`的值有變化，都是進後方callback。

```dart
ever<bool>(_isSortByTitle, (value) => doSortBy(value));
```

View上互動經由Controller提供的func呼叫usecase

```dart
class HomeController extends GetxController {
  final FetchPostUseCase _fetchPostUseCase;

  HomeController(this._fetchPostUseCase);

  ...

  void _fetchPosts() {
    _fetchPostUseCase.execute(FetchPostUseCaseParams()).then((value) {
      postList.clear();
      postList.addAll(value);
      update();
    }).catchError((ex) {
      print(ex);
    });
  }

  doSortBy(bool isSortByTitle) {
    if (postList.isEmpty) return;

    postList.sort((a, b) {
      if (isSortByTitle)
        return a.title.compareTo(b.title);
      else
        return a.id.compareTo(b.id);
    });
    update();
  }
}
```

Controller的[完整Code](https://github.com/clementlinnn/BestArchitectureChallenge/blob/main/lib/screens/home/controllers/home_controller.dart)

Bindings綁定View與Controller，不僅做Dependency Injection也綁定二者，讓Controller能觀察View的生命周期。

```dart
class HomeBindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
```

GetX DI可參考[這裡](https://github.com/jonataslaw/getx/blob/master/documentation/en_US/dependency_management.md)

#### View

View 建議用`GetView<T>`，內建一個Controller方便使用

```dart
class HomeView extends GetView<HomeController> {}
```

畫面更新對應Controller提供的`.obs`事件

```dart
Obx(() => Text('Posts: ${controller.postList.length}', style: TextStyles.textBold22,))
```

當controller.postList有所變化`Obx`內的Widget便會刷新，對於ListView可以用GetBuilder建構

```dart
GetBuilder<HomeController>(
   builder: (_controller) {
   return ListView.separated(
      itemCount: _controller.postList.length,
      itemBuilder: (context, index) {
         return PostTile(
            item: _controller.postList[index]);
      },
      separatorBuilder: (context, index) {
         return Divider();
      },
   );
   },
),
```


### GetMaterialApp

要使用GetX，首先要把MaterialApp換成GetMaterialApp即可。你可以設定路由、語系…等功能。

```dart
GetMaterialApp(
   theme: ThemeData(
      primarySwatch: Colors.deepPurple,
   ),
   translations: Messages(), //你的翻譯
   locale: Locale('en', 'US'), //當前語系
   fallbackLocale: Locale('en', 'UK'), //預設語系，如當前語系無資料
   initialRoute: AppPages.INITIAL, //首頁
   getPages: AppPages.routes, //路由宣告
);
```

```dart
class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: '/', page: () => HomeView(), binding: HomeBindings()),
  ];
}

abstract class Routes {
  static const HOME ='/';
}
```

更多多國語系看[這裡](https://github.com/jonataslaw/getx#internationalization)

更多路由導航看[這裡](https://github.com/jonataslaw/getx/blob/master/documentation/en_US/route_management.md)

## Testing

Clean Architecture由於職責分層在測試上很有優勢，基本上針對每層寫測試即可，比較有難度大概就是UI上的測試。Flutter的測試我還在學習當中，如果有觀念有誤或有更好的寫法歡迎指教！！

### Testing http request

使用[http_mock_adapter](https://pub.dev/packages/http_mock_adapter)mock server提供資料回傳

```dart
late PostApi postApi;

setUp(() {
   Dio dio = Dio();
   postApi = PostApi(dio, baseUrl: BaseUrl);
   DioAdapter dioAdapter = DioAdapter();

   dio.httpClientAdapter = dioAdapter;
   dioAdapter.onGet('/posts', (request) => request.reply(200, testPosts));
});

test('request posts', () async {
   final response = await postApi.getPosts();

   expect(testPosts.length, response.length);
   expect(testPosts[0].userId, response[0].userId);
   expect(testPosts[0].id, response[0].id);
   expect(testPosts[0].title, response[0].title);
   expect(testPosts[0].body, response[0].body);
});
```

### Testing Repository/UseCase

repository及usecase皆有di，所以用[mockito](https://pub.dev/packages/mockito) mock注入。

並用`when`設定相對應回傳。

```dart
//Repository Test
//設定要mock的類別，再跑build_runner建立
@GenerateMocks([PostApi])
void main() async {
  late PostRepository postRepository;

  group('repository test', () {

    PostApi postApi = MockPostApi();
    setUp(() {
      postRepository = PostRepositoryImpl(postApi);
      when(postApi.getPosts()).thenAnswer((_) async => Future.value(testPosts));
    });
    ...
  });
}
```

```dart
// UseCase Test
//mock PostRepositoryImpl
@GenerateMocks([PostRepositoryImpl])
void main() async {

  group('repository test', () {
    late FetchPostUseCase fetchPostUseCase;

    setUp(() {
      final mockRepo = MockPostRepositoryImpl();
      fetchPostUseCase = FetchPostUseCase(mockRepo);
      when(mockRepo.fetchPosts()).thenAnswer((_) async => Future.value(testPosts));
    });
    ...
  });
}
```

### Testing View/Controller

由於View與Controller資料是綁定關係，所以我們一起測試。

在`setUp()`先準備好Mock的UseCase的行為及Controller的DI。

```dart
setUp(() {
   final fetchPostUseCase = MockFetchPostUseCase();
   Get.put<FetchPostUseCase>(fetchPostUseCase);
   controller =
         Get.put<HomeController>(HomeController(fetchPostUseCase));

   when(fetchPostUseCase.execute(any))
         .thenAnswer((_) => Future.value(testPosts));
});
```

接著pump一個GetMaterialApp環境，對`HomeView`進行測試，分別驗證post count，與兩種排序是否正確。

```dart
testWidgets('Home test', (tester) async {
   await tester.pumpWidget(GetMaterialApp(
      theme: ThemeData(
         primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      getPages: [GetPage(name: '/', page: () => HomeView())],
   ));

   expect(find.text('Posts: 2'), findsOneWidget);

   //找出widget
   await tester.tap(find.byIcon(Icons.sort));
   await tester.pump();

   //delay 1秒讓畫面反應
   await tester.pump(const Duration(seconds: 1));

   //點擊title排序
   await tester.tap(find.text('使用title排序'));
   await tester.pump();

   //delay 2秒
   await tester.pump(const Duration(seconds: 2));

   //驗證是否正確依title排序
   expect(testPosts[1].title, controller.postList[0].title);

   //同樣步驟驗證id排序
   await tester.tap(find.byIcon(Icons.sort));
   await tester.pump();
   await tester.pump(const Duration(seconds: 1));
   await tester.tap(find.text('使用id排序'));
   await tester.pump();
   await tester.pump(const Duration(seconds: 2));
   expect(testPosts[0].title, controller.postList[0].title);
});
```

### Ref.

https://medium.com/stepstone-tech/clean-architecture-with-reactive-use-cases-c943d7a8f69c