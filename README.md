# OfflineFirstInspection
This is flutter portfolio project designed for offline first mobiel app following clean architecture.

Flutter package choices:

State Management:

[Bloc](https://pub.dev/packages/flutter_bloc) is used for flutter state management. It enables unidirectional workflow and enforce clean architecture design.
```
User Action 
-> Bloc Event/or Cubit 
-> Bloc Event handler 
-> execute Use Case (Data source CRUD operations + Business logic) 
-> Bloc emit new State 
-> UI BlocBuilder listen to and refresh based on new State.
```

Dependency Injection (Service Locator):

[get_it](https://pub.dev/packages/get_it) is chosen for its easy setup and support for both lazy and factory dependency register.
```dart
getIt.registerLazySingleton<SupabaseClient>(() => supabase.client);
getIt.registerFactory<IAuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt<SupabaseClient>()),
    )
```

Offline Database:

[drift](https://pub.dev/packages/drift) is great for structured and relational database. It also support complex local db schema migration. 


Backend (Supabase):

I use supabase for user authentication and relation database. Firebase is another choice if you want nosql unsgtructured data.


App demo: User Login -> Initialial Data Fetech -> CRUD offline inspection form -> Sync with Server 

![login inspection demo](./readme/loginInspection.gif)

App demo: Responsive Tab View Layout Handles both Portrait and Lanscape screen size 

![Responsive Tab View Layout demo](./readme/ResponsiveLayout.gif)

App demo: Infinite Fast Scrolling Image List View

![FastScrollingImageList demo](./readme/FastScrollingImageList.gif)

App Performance demo: Use RepaintBoundary to isolate animation widget inside list cell to reduce unnecessary list cell repaint
Note: loading animation widget isolated with RepaintBoundary does not cause its parent list cell to repaint compare to the ones without RepaintBoundary

![RepaintBoundary demo](./readme/RepaintBoundary.gif)
