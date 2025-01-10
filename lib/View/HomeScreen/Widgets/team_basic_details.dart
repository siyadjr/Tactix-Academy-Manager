import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tactix_academy_manager/Controller/home_screen_provider.dart';

class TeamBasicDetails extends StatelessWidget {
  const TeamBasicDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FadeInUp(
        child: Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF000620),
                const Color(0xFF000620).withOpacity(0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _ProfileSection(
                  title: 'Team Profile',
                  imageSelector: (provider) => provider.teamPhotoUrl,
                  icon: Icons.groups_rounded,
                  gradientColors: [
                    const Color(0xFF6426AC),
                    const Color.fromARGB(255, 147, 30, 30),
                  ],
                ),
              ),
              Container(
                height: 160,
                width: 1.5,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _ProfileSection(
                  title: 'Manager Profile',
                  imageSelector: (provider) => provider.managerPhotoUrl,
                  icon: Icons.person_rounded,
                  gradientColors: [
                    const Color(0xFF6426AC),
                    Colors.blue,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final String Function(TeamProvider) imageSelector;
  final IconData icon;
  final List<Color> gradientColors;

  const _ProfileSection({
    required this.title,
    required this.imageSelector,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 20),
        Consumer<TeamProvider>(
          builder: (context, teamProvider, child) {
            final imageUrl = imageSelector(teamProvider);
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3), // Border width
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFF000620),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    gradientColors.first,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF000620),
                              child: Icon(
                                icon,
                                size: 40,
                                color: gradientColors.first.withOpacity(0.5),
                              ),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF000620),
                            child: Icon(
                              icon,
                              size: 40,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
