import 'package:client/features/payment/domain/usecases/get_my_payment_usecase.dart';
import 'package:client/features/payment/presentation/bloc/payment_history/payment_history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/dio_client.dart';

// ===== CORE =====
import 'core/storage/token_storage.dart';

// ===== AUTH FEATURE =====
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

// ===== HOME FEATURE =====
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/usecases/get_home_data_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

// ===== GYM CLASS FEATURE =====
import 'features/gym_class/data/datasources/gym_class_remote_datasource.dart';
import 'features/gym_class/data/repositories/gym_class_repository_impl.dart';
import 'features/gym_class/domain/usecases/get_gym_class_list_usecase.dart';
import 'features/gym_class/presentation/bloc/gym_class/gym_class_bloc.dart';

// ===== MEMBERSHIP PLAN FEATURE =====
import 'features/membership_plan/data/datasources/membership_plan_remote_datasource.dart';
import 'features/membership_plan/data/repositories/membership_plan_repository_impl.dart';
import 'features/membership_plan/domain/usecases/get_membership_plans_usecase.dart';
import 'features/membership_plan/presentation/bloc/membership_plan_bloc.dart';

// ===== PAYMENT FEATURE =====
import 'features/payment/data/datasources/payment_remote_datasource.dart';
import 'features/payment/data/repositories/payment_repository_impl.dart';
import 'features/payment/domain/usecases/create_payment_usecase.dart';
import 'features/payment/presentation/bloc/payment/payment_bloc.dart';

// ===== BOOKING HISTORY FEATURE =====
import 'features/booking/data/datasources/booking_remote_datasource.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/domain/usecases/get_my_booking_usecase.dart';
import 'features/booking/presentation/bloc/booking_history/booking_history_bloc.dart';

// ===== PROFILE DATA FEATURE =====
import 'features/profile/domain/usecases/get_my_profile_usecase.dart';
import 'features/profile/presentation/bloc/profile_data/profile_data_bloc.dart';

// ===== PROFILE (LOGOUT) FEATURE =====
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/usecases/logout_usecase.dart';
import 'features/profile/presentation/bloc/profile/profile_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 🔐 AUTH
        BlocProvider<AuthBloc>(
          create: (_) {
            final dio = DioClient.create();

            return AuthBloc(
              LoginUseCase(AuthRepositoryImpl(AuthRemoteDatasource(dio))),
              RegisterUseCase(AuthRepositoryImpl(AuthRemoteDatasource(dio))),
              TokenStorage(),
            );
          },
        ),

        // 🏠 HOME
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            GetHomeDataUseCase(HomeRepositoryImpl(HomeRemoteDatasource())),
          ),
        ),

        // GYM CLASS
        BlocProvider<GymClassBloc>(
          create: (_) {
            final dio = DioClient.create();

            return GymClassBloc(
              GetGymClassesUseCase(
                GymClassRepositoryImpl(GymClassRemoteDatasource(dio)),
              ),
            );
          },
        ),

        // MEMBERSHIP PLAN
        BlocProvider<MembershipPlanBloc>(
          create: (_) {
            final dio = DioClient.create();

            return MembershipPlanBloc(
              GetMembershipPlansUseCase(
                MembershipPlanRepositoryImpl(
                  MembershipPlanRemoteDatasource(dio),
                ),
              ),
            );
          },
        ),

        // 💳 PAYMENT
        BlocProvider<PaymentBloc>(
          create: (_) {
            final dio = DioClient.create();

            return PaymentBloc(
              CreatePaymentUseCase(
                PaymentRepositoryImpl(PaymentRemoteDatasource(dio)),
              ),
            );
          },
        ),

        // 📜 PAYMENT HISTORY
        BlocProvider<PaymentHistoryBloc>(
          create: (_) {
            final dio = DioClient.create();

            return PaymentHistoryBloc(
              GetMyPaymentUsecase(
                PaymentRepositoryImpl(PaymentRemoteDatasource(dio)),
              ),
            );
          },
        ),

        // BOOKING HISTORY
        BlocProvider<BookingHistoryBloc>(
          create: (_) {
            final dio = DioClient.create();
            return BookingHistoryBloc(
              GetMyBookingsUseCase(
                BookingRepositoryImpl(BookingRemoteDatasource(dio)),
              ),
            );
          },
        ),

        // 👤 PROFILE DATA
        BlocProvider<ProfileDataBloc>(
          create: (_) {
            final dio = DioClient.create();

            return ProfileDataBloc(
              GetMyProfileUsecase(
                ProfileRepositoryImpl(ProfileRemoteDatasource(dio)),
              ),
            );
          },
        ),

        // 👤 PROFILE (LOGOUT)
        BlocProvider<ProfileBloc>(
          create: (_) {
            final dio = DioClient.create();
            final tokenStorage = TokenStorage();
            return ProfileBloc(
              LogoutUseCase(
                ProfileRepositoryImpl(ProfileRemoteDatasource(dio)),
              ),
              tokenStorage,
            );
          },
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
