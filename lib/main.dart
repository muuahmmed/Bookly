import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:untitled5/features/home/domain_layer/use_cases/fetch_newest_books_use_cse.dart';
import 'package:untitled5/features/splash/presentation_layer/views/widgets/splash_view.dart';
import 'constants.dart';
import 'core/utils/api_services.dart';
import 'core/utils/bloc_observer.dart';
import 'features/home/data/data_sources/home_local_data_source.dart';
import 'features/home/data/data_sources/home_remote_data_source.dart';
import 'features/home/data/repos/home_repo_implementation.dart';
import 'features/home/domain_layer/entities/book_entity.dart';
import 'features/home/domain_layer/use_cases/fetch_featured_books_use_case.dart';
import 'features/home/presentation/manager/featured/featured_cubit.dart';
import 'features/home/presentation/manager/newest/newest_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const SimpleBlocObserver();
  await Hive.initFlutter();
  Hive.registerAdapter(BookEntityAdapter());

  final featuredBox = await Hive.openBox<BookEntity>('featured_box');
  final newestBox = await Hive.openBox<BookEntity>('newest_box');

  if (featuredBox.isEmpty) {
    await featuredBox.addAll([]);
  }

  if (newestBox.isEmpty) {
    await newestBox.addAll([]);
  }

  runApp(const BooklyApp());
}

class BooklyApp extends StatelessWidget {
  const BooklyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => FeaturedCubit(
                FetchFeaturedBooksUseCase(
                  HomeRepoImpl(
                    homeLocalDataSource: HomeLocalDataSourceImpl(),
                    homeRemoteDataSource: HomeRemoteDataSourceImpl(
                      apiServices: ApiServices(Dio()),
                    ),
                    apiServices: ApiServices(Dio()),
                  ),
                ),
              ),
        ),
        BlocProvider(
          create:
              (context) => NewestCubit(
                FetchNewestBooksUseCase(
                  HomeRepoImpl(
                    homeLocalDataSource: HomeLocalDataSourceImpl(),
                    homeRemoteDataSource: HomeRemoteDataSourceImpl(
                      apiServices: ApiServices(Dio()),
                    ),
                    apiServices: ApiServices(Dio()),
                  ),
                ),
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: kPrimaryColor,
          appBarTheme: AppBarTheme(
            backgroundColor: kPrimaryColor,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        home: SplashView(),
      ),
    );
  }
}
