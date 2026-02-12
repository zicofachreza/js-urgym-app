import 'package:client/features/payment/presentation/pages/payment_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';

import '../bloc/profile_data/profile_data_bloc.dart';
import '../bloc/profile_data/profile_data_event.dart';
import '../bloc/profile_data/profile_data_state.dart';

import '../../../auth/presentation/pages/login_page.dart';
import 'membership_barcode_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileDataBloc>().add(LoadProfileData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is LogoutSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              }

              if (state is ProfileError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ===== AVATAR =====
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 172, 14, 3), Colors.black],
                  ),
                ),
                child: const CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.person, color: Colors.white, size: 48),
                ),
              ),

              const SizedBox(height: 16),

              // ===== PROFILE INFO =====
              BlocBuilder<ProfileDataBloc, ProfileDataState>(
                builder: (context, state) {
                  if (state is ProfileDataLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 172, 14, 3),
                      ),
                    );
                  }

                  if (state is ProfileDataLoaded) {
                    final profile = state.profile;

                    return Column(
                      children: [
                        Text(
                          profile.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          profile.isMember
                              ? 'MEMBER • UrGym'
                              : 'NOT MEMBER • UrGym',
                          style: TextStyle(
                            color: profile.isMember
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }

                  if (state is ProfileDataError) {
                    return Text(
                      state.message,
                      style: TextStyle(color: Color.fromARGB(255, 172, 14, 3)),
                    );
                  }

                  return const SizedBox();
                },
              ),

              const SizedBox(height: 32),

              // ===== MENU =====
              BlocBuilder<ProfileDataBloc, ProfileDataState>(
                builder: (context, state) {
                  final isMember = state is ProfileDataLoaded
                      ? state.profile.isMember
                      : false;

                  return Column(
                    children: [
                      _ProfileMenu(
                        icon: Icons.qr_code,
                        title: 'Membership Barcode',
                        onTap: isMember
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MembershipBarcodePage(
                                      username: state.profile.username,
                                      barcodeToken:
                                          state.profile.membershipBarcodeToken!,
                                      expiredAt:
                                          state.profile.membershipExpiresAt,
                                    ),
                                  ),
                                );
                              }
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('You are not a member yet.'),
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      33,
                                      33,
                                      33,
                                    ),
                                  ),
                                );
                              },
                      ),

                      _ProfileMenu(
                        icon: Icons.receipt_long,
                        title: 'Transaction History',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaymentHistoryPage(),
                            ),
                          );
                        },
                      ),

                      _ProfileMenu(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {},
                      ),

                      _ProfileMenu(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        onTap: () {},
                      ),
                    ],
                  );
                },
              ),

              const Spacer(),

              // ===== LOGOUT =====
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  final isLoading = state is ProfileLoading;

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 172, 14, 3),
                        disabledBackgroundColor: Color.fromARGB(
                          255,
                          172,
                          14,
                          3,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<ProfileBloc>().add(
                                LogoutRequested(),
                              );
                            },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isLoading
                            ? const SizedBox(
                                key: ValueKey('loading'),
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Logout',
                                key: ValueKey('text'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenu({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          leading: Icon(icon, color: const Color.fromARGB(255, 172, 14, 3)),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
          onTap: onTap,
        ),
      ),
    );
  }
}
