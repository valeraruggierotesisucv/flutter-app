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
                child: profileImage == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(events, 'Events', onEvents),
                    _buildStatItem(followers, 'Followers', onFollowers),
                    _buildStatItem(following, 'Following', onFollowed),
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
              if (onFollow != null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: disableFollowButton ? null : onFollow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFollowing ? Colors.white : const Color(0xFF050F71),
                      side: isFollowing
                          ? const BorderSide(color: Color(0xFF050F71))
                          : null,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isFollowing ? 'Unfollow' : 'Follow',
                      style: TextStyle(
                        color: isFollowing
                            ? const Color(0xFF050F71)
                            : Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
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
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
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
