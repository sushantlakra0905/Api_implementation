import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:neww/services/user_api.dart';
import '../model/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
  bool isLoading = true;
  final CardSwiperController controller = CardSwiperController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tinder-Style User Profiles'),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(
            child: CircularProgressIndicator(color: Colors.white))
            : users.isEmpty
            ? const Center(
          child: Text(
            'No users available',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        )
            : CardSwiper(
          controller: controller,
          cardsCount: users.length,
          onSwipe: _onSwipe,
          onUndo: _onUndo,
          numberOfCardsDisplayed: 3,
          backCardOffset: const Offset(40, 40),
          padding: const EdgeInsets.all(24.0),
          cardBuilder: (context, index,
              horizontalThresholdPercentage,
              verticalThresholdPercentage) {
            final user = users[index];
            final isMale = user.gender == 'male';

            return Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      user.picture.large,
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                            child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.email,
                                  size: 18, color: Colors.white70),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  user.email,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.phone,
                                  size: 18, color: Colors.white70),
                              const SizedBox(width: 8),
                              Text(
                                user.phone,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${user.gender.toUpperCase()} | ${user.nat} | Age: ${user.dob.age}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 18, color: Colors.white70),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${user.location.city}, ${user.location.state}, ${user.location.country}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // UPDATED: must return bool
  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.right) {
      print('Liked: ${users[previousIndex].fullName}');
    } else if (direction == CardSwiperDirection.left) {
      print('Disliked: ${users[previousIndex].fullName}');
    }
    return true;
  }

  // UPDATED: must return bool
  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    print('Undo swipe');
    return true;
  }

  Future<void> fetchUsers() async {
    try {
      final response = await UserApi.fetchUsers();
      setState(() {
        users = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    }
  }
}
