import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/player_details_controller.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/players_database.dart';
import 'package:tactix_academy_manager/Model/Models/player_model.dart';
import 'package:tactix_academy_manager/View/Players/PlayerInitialDatas/Widgets/editable_intial_details.dart';
import 'package:tactix_academy_manager/View/Players/Widgets/player_position_dropdown.dart';

class AddPlayerInitialDetails extends StatefulWidget {
  final PlayerModel player;
  final bool? pop;
  const AddPlayerInitialDetails(
      {super.key, required this.player, this.pop = false});

  @override
  State<AddPlayerInitialDetails> createState() =>
      _AddPlayerInitialDetailsState();
}

class _AddPlayerInitialDetailsState extends State<AddPlayerInitialDetails> {
  late TextEditingController _goalsController;
  late TextEditingController _assistsController;
  late TextEditingController _jerseyNumber;
  late TextEditingController _matches;
  String? _selectedPosition;
  bool _changesSaved = false; // Track if changes are saved

  @override
  void initState() {
    super.initState();
    _matches = TextEditingController(text: widget.player.matches);
    _jerseyNumber = TextEditingController(text: widget.player.number);
    _goalsController = TextEditingController(text: widget.player.goals);
    _assistsController = TextEditingController(text: widget.player.assists);
    _selectedPosition = FootballPositions.positions
        .firstWhere(
            (position) => position.abbreviation == widget.player.position,
            orElse: () => FootballPositions.positions.first)
        .abbreviation;
  }

  @override
  void dispose() {
    _goalsController.dispose();
    _assistsController.dispose();
    _jerseyNumber.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedPlayer = PlayerModel(
        id: widget.player.id,
        name: widget.player.name,
        email: widget.player.email,
        fit: widget.player.fit,
        achivements: widget.player.achivements,
        matches: _matches.text,
        goals: _goalsController.text,
        assists: _assistsController.text,
        number: _jerseyNumber.text,
        position: _selectedPosition!,
        rank: widget.player.rank,
        teamId: widget.player.teamId,
        userProfile: widget.player.userProfile);

    PlayerDatabase().addPlayerDetails(updatedPlayer);
    Provider.of<PlayerDetailsController>(context, listen: false)
        .fetchData(widget.player.id);
    setState(() {
      _changesSaved = true;
    });
    Navigator.pop(context, widget.player); 
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.pop ?? false, // Prevent navigation unless confirmed
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            '${widget.player.name} Details',
            style: const TextStyle(
              color: secondTextColour,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: backGroundColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: backGroundColor),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(widget.player.userProfile),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.player.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: secondTextColour,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.player.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: secondTextColour.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    EditablePlayerIntialData(
                      label: 'Matches',
                      controller: _matches,
                      icon: Icons.sports_soccer,
                    ),
                    EditablePlayerIntialData(
                      label: 'Goals',
                      controller: _goalsController,
                      icon: Icons.sports_soccer,
                    ),
                    EditablePlayerIntialData(
                      label: 'Assists',
                      controller: _assistsController,
                      icon: Icons.assistant,
                    ),
                    EditablePlayerIntialData(
                      label: 'Jersey Number',
                      controller: _jerseyNumber,
                      icon: Icons.assistant,
                    ),
                    PositionSelectorField(
                      label: 'Position',
                      value: _selectedPosition,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedPosition = newValue;
                        });
                      },
                      textColor: secondTextColour,
                      backgroundColor: backGroundColor,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _saveChanges,
                        child: const Text('Save Changes'),
                      ),
                    ),
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
