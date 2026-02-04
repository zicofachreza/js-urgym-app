import '../../data/models/home_model.dart';

class HomeRemoteDatasource {
  Future<HomeData> fetchHome() async {
    await Future.delayed(const Duration(seconds: 1));

    return HomeData(
      news: [
        {'title': 'New Class Available', 'subtitle': 'Try HIIT Extreme Today'},
        {'title': 'Promo Membership', 'subtitle': 'Up to 30% OFF'},
        {'title': 'Personal Trainer', 'subtitle': 'Book Your Session Now'},
      ],
      equipments: [
        {'icon': 'fitness', 'title': 'Dumbbell Set', 'subtitle': 'Up to 50kg'},
        {'icon': 'run', 'title': 'Treadmill', 'subtitle': 'Cardio Zone'},
        {'icon': 'strength', 'title': 'Smith Machine', 'subtitle': 'Strength'},
        {'icon': 'yoga', 'title': 'Yoga Mat', 'subtitle': 'Flexibility'},
      ],
      location: 'UrGym Fitness Center\nBandung, Indonesia',
    );
  }
}
