import 'package:fitflow/core/network/network_info.dart';
import 'package:fitflow/core/services/api/api_service.dart';
import 'package:fitflow/core/services/storage/cache_helper.dart';
import 'package:fitflow/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fitflow/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fitflow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fitflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:fitflow/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/login_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fitflow/features/auth/domain/usecases/register_usecase.dart';
import 'package:fitflow/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:fitflow/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:fitflow/features/cart/domain/repositories/cart_repository.dart';
import 'package:fitflow/features/cart/domain/usecases/cart_usecases.dart';
import 'package:fitflow/features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:fitflow/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:fitflow/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:fitflow/features/wishlist/domain/usecases/wishlist_usecases.dart';
import 'package:fitflow/features/categories/data/datasources/category_remote_data_source.dart';
import 'package:fitflow/features/categories/data/repositories/category_repository_impl.dart';
import 'package:fitflow/features/categories/domain/repositories/category_repository.dart';
import 'package:fitflow/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:fitflow/features/products/data/datasources/product_remote_data_source.dart';
import 'package:fitflow/features/products/data/repositories/product_repository_impl.dart';
import 'package:fitflow/features/products/domain/repositories/product_repository.dart';
import 'package:fitflow/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:fitflow/features/products/domain/usecases/get_products_usecase.dart';
import 'package:fitflow/features/products/domain/usecases/search_products_usecase.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Core ──────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<CacheHelper>(() => CacheHelper());

  // ── Auth — Data Sources ───────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(cacheHelper: sl()),
  );

  // ── Auth — Repository ─────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ── Auth — Use Cases ──────────────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUsecase(sl()));

  // ── Products — Data Sources ───────────────────────────────────────────────
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiService: sl()),
  );

  // ── Products — Repository ─────────────────────────────────────────────────
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // ── Products — Use Cases ──────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetProductsUsecase(sl()));
  sl.registerLazySingleton(() => SearchProductsUsecase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUsecase(sl()));

  // ── Categories — Data Sources ─────────────────────────────────────────────
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(apiService: sl()),
  );

  // ── Categories — Repository ───────────────────────────────────────────────
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // ── Categories — Use Cases ────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl()));

  // ── Cart — Data Sources ───────────────────────────────────────────────────
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(apiService: sl()),
  );

  // ── Cart — Repository ─────────────────────────────────────────────────────
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // ── Cart — Use Cases ──────────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetCartUsecase(sl()));
  sl.registerLazySingleton(() => GetCartCountUsecase(sl()));
  sl.registerLazySingleton(() => GetCartItemByIdUsecase(sl()));
  sl.registerLazySingleton(() => AddToCartUsecase(sl()));
  sl.registerLazySingleton(() => RemoveCartItemUsecase(sl()));
  sl.registerLazySingleton(() => ClearCartUsecase(sl()));
  sl.registerLazySingleton(() => UpdateCartQuantityUsecase(sl()));
  sl.registerLazySingleton(() => SetCartQuantityUsecase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUsecase(sl()));

  // ── Wishlist — Data Sources ───────────────────────────────────────────────
  sl.registerLazySingleton<WishlistRemoteDataSource>(
    () => WishlistRemoteDataSourceImpl(apiService: sl()),
  );

  // ── Wishlist — Repository ─────────────────────────────────────────────────
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // ── Wishlist — Use Cases ──────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetWishlistUsecase(sl()));
  sl.registerLazySingleton(() => AddToWishlistUsecase(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlistUsecase(sl()));
}
