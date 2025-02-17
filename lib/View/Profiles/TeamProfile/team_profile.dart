import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tactix_academy_manager/Controller/Controllers/team_profile_controller.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Model/Models/team_full_model.dart';
import 'package:tactix_academy_manager/View/Profiles/TeamProfile/Widgets/team_profil_name_card.dart';
import 'package:tactix_academy_manager/View/Profiles/TeamProfile/Widgets/team_profile_appbar.dart';
import 'package:tactix_academy_manager/View/Profiles/TeamProfile/Widgets/team_profile_build_location_card.dart';
import 'package:tactix_academy_manager/View/Profiles/TeamProfile/Widgets/team_profile_copy_team_id.dart';
import 'package:tactix_academy_manager/View/Profiles/TeamProfile/Widgets/team_profile_empty_state.dart';
import 'package:tactix_academy_manager/View/Profiles/TeamProfile/Widgets/team_profile_stat_card.dart';

class TeamProfile extends StatelessWidget {
  const TeamProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeamProfileController>(context, listen: false);
    final size = MediaQuery.of(context).size;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getTeamDetails();
    });

    return Scaffold(
      body: Consumer<TeamProfileController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: LoadingIndicator());
          }

          if (controller.team == null) {
            return TeamProfileEmptyState(size: size);
          }

          return buildContent(context, controller.team!, provider, size);
        },
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget buildContent(BuildContext context, TeamFullModel team,
      TeamProfileController provider, Size size) {
    return CustomScrollView(
      slivers: [
        TeamProfileAppBar(team: team, provider: provider),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TeamNameCardWidget(team: team, provider: provider),
                const SizedBox(height: 24),
                TeamProfileStatCard(team: team),
                const SizedBox(height: 24),
                LocationCardWidget(
                  provider: provider,
                  team: team,
                ),
                TeamProfileCopyTeamId(
                  id: team.id,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
