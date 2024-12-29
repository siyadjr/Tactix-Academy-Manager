import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/home_screen_provider.dart';

class TeamBasicDetails extends StatelessWidget {
  const TeamBasicDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<TeamProvider>(
                  builder: (context, teamProvider, child) {
                    return CircleAvatar(
                      radius: 65,
                      backgroundImage: teamProvider.teamPhotoUrl.isNotEmpty
                          ? NetworkImage(teamProvider.teamPhotoUrl)
                          : const AssetImage('Assets/default_team.logo.png')
                              as ImageProvider,
                    );
                  },
                ),
                const VerticalDivider(),
                Consumer<TeamProvider>(
                  builder: (context, teamProvider, child) {
                    return CircleAvatar(
                      radius: 65,
                      backgroundImage: teamProvider.managerPhotoUrl.isNotEmpty
                          ? NetworkImage(teamProvider.managerPhotoUrl)
                          : const AssetImage('Assets/default_team.logo.png')
                              as ImageProvider,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
