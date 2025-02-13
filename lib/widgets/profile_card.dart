import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String? profileImage;
  final String username;
  final String biography;
  final int events;
  final int followers;
  final int following;
  final bool isFollowing;
  final VoidCallback? onFollow;
  final VoidCallback? onConfigureProfile;
  final VoidCallback? onEditProfile;
  final VoidCallback? onEvents;
  final VoidCallback? onFollowers;
  final VoidCallback? onFollowed;
  final bool disableFollowButton;
  final bool isOtherUser;
  final String eventsLabel;
  final String followersLabel;
  final String followingLabel;
  final String followButtonLabel;
  final String editButtonLabel;
  final String configButtonLabel;

  const ProfileCard({
    super.key,
    this.profileImage,
    required this.username,
    required this.biography,
    required this.events,
    required this.followers,
    required this.following,
    this.isFollowing = false,
    this.onFollow,
    this.onConfigureProfile,
    this.onEditProfile,
    this.onEvents,
    this.onFollowers,
    this.onFollowed,
    this.disableFollowButton = false,
    this.isOtherUser = false,
    required this.eventsLabel,
    required this.followersLabel,
    required this.followingLabel,
    required this.followButtonLabel,
    required this.editButtonLabel,
    required this.configButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          Row(
            children: [
              
              CircleAvatar(
                radius: 40,
                backgroundImage: profileImage != null
                    ? NetworkImage(profileImage!)
                    : null,
                child: profileImage == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(events, eventsLabel, onEvents),
                    _buildStatItem(followers, followersLabel, onFollowers),
                    _buildStatItem(following, followingLabel, onFollowed),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  biography,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (isOtherUser) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: onFollow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing ? Colors.white : const Color(0xFF050F71),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      side: BorderSide(
                        color: const Color(0xFF050F71),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isFollowing ? 'Following' : 'Follow',
                      style: TextStyle(
                        color: isFollowing ? const Color(0xFF050F71) : Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
              if (onEditProfile != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onEditProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF050F71),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      editButtonLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
              if (onConfigureProfile != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfigureProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF050F71),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      configButtonLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(int value, String label, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
