import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/home/presentation/pages/home_page.dart';
import '../features/gym_class/presentation/pages/gym_class_page.dart';
import '../features/membership_plan/presentation/pages/membership_plan_page.dart';
import '../features/booking/presentation/pages/booking_history_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import 'cubit/bottom_nav_cubit.dart';
import 'cubit/bottom_nav_state.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static final List<Widget> _pages = [
    const HomePage(),
    const GymClassPage(),
    const MembershipPlanPage(),
    const BookingHistoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            body: _pages[state.index],

            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(splashColor: Colors.transparent),
              child: BottomNavigationBar(
                currentIndex: state.index,
                onTap: (index) {
                  context.read<BottomNavCubit>().changeTab(index);
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.black,
                selectedItemColor: const Color.fromARGB(255, 172, 14, 3),
                unselectedItemColor: Colors.white70,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.sports_gymnastics),
                    label: 'Class',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.card_membership),
                    label: 'Member',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
