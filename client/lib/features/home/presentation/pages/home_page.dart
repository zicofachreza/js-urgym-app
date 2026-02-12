import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHome());
  }

  IconData _mapIcon(String icon) {
    switch (icon) {
      case 'fitness':
        return Icons.fitness_center;
      case 'run':
        return Icons.directions_run;
      case 'strength':
        return Icons.accessibility_new;
      case 'yoga':
        return Icons.self_improvement;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Welcome Home',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 172, 14, 3),
                  strokeWidth: 3,
                ),
              );
            }

            if (state is HomeError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 172, 14, 3),
                  ),
                ),
              );
            }

            if (state is HomeLoaded) {
              final data = state.data;

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // ================= NEWS SLIDER =================
                        SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              Expanded(
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: data.news.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    final item = data.news[index];
                                    return _NewsCard(
                                      title: item['title']!,
                                      subtitle: item['subtitle']!,
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 14),

                              // ===== MODERN DOT INDICATOR =====
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  data.news.length,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    height: 8,
                                    width: _currentPage == index ? 22 : 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: _currentPage == index
                                          ? const Color.fromARGB(
                                              255,
                                              172,
                                              14,
                                              3,
                                            )
                                          : Colors.white24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ================= OUR EQUIPMENT =================
                        const Text(
                          'Our Equipment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.equipments.length,
                            itemBuilder: (context, index) {
                              final item = data.equipments[index];
                              return _EquipmentCard(
                                icon: _mapIcon(item['icon']),
                                title: item['title'],
                                subtitle: item['subtitle'],
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ================= OUR LOCATION =================
                        const Text(
                          'Our Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _LocationMapCard(location: data.location),

                        const SizedBox(height: 24),
                      ]),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ===================== NEWS CARD =====================
class _NewsCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _NewsCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 172, 14, 3), Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

// ===================== EQUIPMENT CARD =====================
class _EquipmentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EquipmentCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade900,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(
                255,
                172,
                14,
                3,
              ).withValues(alpha: 0.15),
            ),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 172, 14, 3),
              size: 24,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ===================== LOCATION MAP CARD =====================
class _LocationMapCard extends StatelessWidget {
  final String location;

  const _LocationMapCard({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade900,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.grey.shade800, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const Center(
            child: Icon(
              Icons.location_pin,
              color: Color.fromARGB(255, 172, 14, 3),
              size: 48,
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.place,
                    color: Color.fromARGB(255, 172, 14, 3),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
