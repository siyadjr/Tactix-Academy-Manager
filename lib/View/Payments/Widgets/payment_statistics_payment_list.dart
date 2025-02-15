import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/Controllers/payments_details_provider.dart';

class PaymentLists extends StatelessWidget {
  final PaymentsDetailsProvider provider;

  const PaymentLists({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlayersList(
          title: 'Paid Players',
          players: provider.thisMonthPaidPlayers,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        PlayersList(
          title: 'Unpaid Players',
          players: provider.thisMonthUnpaidPlayers,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class PlayersList extends StatelessWidget {
  final String title;
  final List players;
  final Color color;

  const PlayersList({
    super.key,
    required this.title,
    required this.players,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.black87,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  title.contains('Paid') ? Icons.check_circle : Icons.warning,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (players.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No Players',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: players.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final player = players[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    backgroundImage: player.userProfile != null &&
                            player.userProfile.isNotEmpty
                        ? NetworkImage(player.userProfile)
                        : null,
                    child:
                        player.userProfile == null || player.userProfile.isEmpty
                            ? Icon(Icons.person, color: color)
                            : null,
                  ),
                  title: Text(
                    player.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(
                    title.contains('Paid') ? Icons.check_circle : Icons.warning,
                    color: color,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
