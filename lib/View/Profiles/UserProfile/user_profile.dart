import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/user_profile_controller.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/manager_model.dart';
import 'package:tactix_academy_manager/View/Authentications/forgot_password.dart';
import 'package:tactix_academy_manager/View/Profiles/UserProfile/Widgets/license_viewer.dart';
import 'package:tactix_academy_manager/View/Profiles/UserProfile/Widgets/user_profile_account_actions.dart';
import 'package:tactix_academy_manager/View/Profiles/UserProfile/Widgets/user_profile_build_gradientcard.dart';
import 'package:tactix_academy_manager/View/Profiles/UserProfile/Widgets/user_profile_profile_card.dart';
import 'package:tactix_academy_manager/View/Profiles/UserProfile/Widgets/user_profile_setting_tile.dart';
import 'package:tactix_academy_manager/View/Profiles/UserProfile/about_page.dart';
import 'package:tactix_academy_manager/View/Profiles/UserProfile/contact_us.dart';
import 'package:tactix_academy_manager/View/Profiles/UserProfile/privacy_policy.dart';
import 'package:tactix_academy_manager/View/Profiles/UserProfile/terms_and_conditions.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileController>().getUserData();
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backGroundColor,
              blackColor,
            ],
          ),
        ),
        child: Consumer<UserProfileController>(
          builder: (context, userProvider, _) {
            return CustomScrollView(
              slivers: [
                buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: userProvider.isLoading
                      ? const Center(child: LoadingIndicator())
                      : Column(
                          children: [
                            UserProfileBuildProfileCard(
                                context: context, userProvider: userProvider),
                            const SizedBox(height: 24),
                            buildSettingsCard(context, userProvider.player!),
                            const SizedBox(height: 24),
                            UserProfileAccountActions(
                                context: context, userProvider: userProvider),
                            const SizedBox(height: 32),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildSliverAppBar() {
    return const SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      stretch: true,
      centerTitle: true,
      backgroundColor: backGroundColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildSettingsCard(BuildContext context, ManagerModel manager) {
    return Column(
      children: [
        BuildGradientCard(
            title: 'Account',
            icon: CupertinoIcons.settings,
            color: Colors.purple,
            child: Column(children: [
              buildSettingsTile(
                icon: CupertinoIcons.lock_fill,
                iconColor: Colors.blue,
                title: 'Change Password',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => ForgotPasswordScreen()),
                ),
              ),
              buildSettingsTile(
                icon: Icons.document_scanner_outlined,
                iconColor: Colors.red,
                title: 'Coaching License',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          LicenseViewerScreen(licenseUrl: manager.licenseUrl)),
                ),
              ),
            ])),
        const SizedBox(height: 16),
        BuildGradientCard(
            title: 'Help & Info',
            icon: CupertinoIcons.info_circle,
            color: Colors.teal,
            child: Column(
              children: [
                buildSettingsTile(
                  icon: CupertinoIcons.doc_text_fill,
                  iconColor: Colors.purple,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const PrivacyPolicy()));
                  },
                ),
                buildSettingsTile(
                  icon: CupertinoIcons.mail_solid,
                  iconColor: Colors.green,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => const ContactUs()));
                  },
                ),
                buildSettingsTile(
                  icon: CupertinoIcons.info_circle_fill,
                  iconColor: Colors.blue,
                  title: 'About',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => AboutPage()));
                  },
                ),
                buildSettingsTile(
                  icon: CupertinoIcons.doc_plaintext,
                  iconColor: Colors.indigo,
                  title: 'Terms & Conditions',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => TermsAndCondition()));
                  },
                  showBorder: false,
                ),
              ],
            )),
      ],
    );
  }
}
