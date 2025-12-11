import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String profession;
  final String countryCode;
  final String phoneNumber;
  final String email;
  final String? avatarUrl;

  const ProfilePage({
    super.key,
    required this.name,
    required this.profession,
    required this.countryCode,
    required this.phoneNumber,
    required this.email,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: size.width * 0.88),
                child: Column(
                  children: [
                    // === Avatar ===
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF0EAE0),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: avatarUrl != null
                            ? NetworkImage(avatarUrl!)
                            : null,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        child: avatarUrl == null
                            ? Text(
                                _initialsFromName(name),
                                style: const TextStyle(
                                  fontSize: 34,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // === Name ===
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // === Profession ===
                    Text(
                      profession,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // === Info Rows (transparent, minimal) ===
                    _TransparentInfoRow(
                      icon: Icons.phone_outlined,
                      label: "Phone",
                      value: "$countryCode $phoneNumber",
                    ),
                    const SizedBox(height: 18),
                    _TransparentInfoRow(
                      icon: Icons.email_outlined,
                      label: "Email",
                      value: email,
                    ),

                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _initialsFromName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}

class _TransparentInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _TransparentInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon bubble
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 16),

        // Texts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 10,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),

              // Thin line (no card background)
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.white.withOpacity(0.18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
