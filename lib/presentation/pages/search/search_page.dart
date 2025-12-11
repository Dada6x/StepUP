import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

enum SearchCategory { all, projects, startups, investors }

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  SearchCategory _selectedCategory = SearchCategory.all;

  bool _isLoading = true;

  // ------- DUMMY DATA WITH IMAGES -------

  final List<Project> _projects = [
    Project(
      id: 'p1',
      name: 'EcoSolar',
      idea: 'Affordable modular solar systems for off-grid communities.',
      team:
          '3 founders (Electrical engineer, Product designer, Community manager)',
      stage: 'Seed',
      sector: 'Energy',
      market: 'Remote villages / off-grid households',
      commercialRecord: 'Pilot installed in 2 villages, 120+ households served',
      mentoringStatus: 'In Mentoring',
      dealRoomStatus: 'Not yet in Deal Room',
      startupName: 'EcoSolar Team',
      imageUrl:
          'https://images.pexels.com/photos/987544/pexels-photo-987544.jpeg?auto=compress&cs=tinysrgb&w=800', // solar panels
    ),
    Project(
      id: 'p2',
      name: 'MediConnect',
      idea:
          'Telehealth platform connecting patients with verified doctors online.',
      team: '2 doctors + 1 full-stack developer',
      stage: 'Pre-Series A',
      sector: 'HealthTech',
      market: 'Urban clinics & patients in underserved areas',
      commercialRecord:
          '5 paying clinics, 2k+ consultations processed through platform',
      mentoringStatus: 'Ready for Deal Room',
      dealRoomStatus: 'Visible in Investor Deal Room',
      startupName: 'MediConnect',
      imageUrl:
          'https://images.pexels.com/photos/7578800/pexels-photo-7578800.jpeg?auto=compress&cs=tinysrgb&w=800', // telehealth
    ),
    Project(
      id: 'p3',
      name: 'AgriSense',
      idea: 'Smart sensor kit for precision irrigation and soil monitoring.',
      team: 'Hardware engineer, Agronomist, Data scientist',
      stage: 'MVP',
      sector: 'AgriTech',
      market: 'Mid-size farms (50–200 hectares)',
      commercialRecord: '3 PoC farms, 15–20% water usage reduction',
      mentoringStatus: 'In Mentoring',
      dealRoomStatus: 'Screening for Deal Room',
      startupName: 'AgriSense',
      imageUrl:
          'https://images.pexels.com/photos/2886937/pexels-photo-2886937.jpeg?auto=compress&cs=tinysrgb&w=800', // farm
    ),
    Project(
      id: 'p4',
      name: 'StepUp Learning',
      idea: 'Micro-mentoring platform for student founders & early teams.',
      team: 'Student team of 4 with tech & business background',
      stage: 'Idea',
      sector: 'EdTech',
      market: 'Student & early-stage founders',
      commercialRecord: 'Pre-MVP, 50+ users on waitlist',
      mentoringStatus: 'Onboarding',
      dealRoomStatus: 'Not eligible yet',
      startupName: 'StepUp Edu',
      imageUrl:
          'https://images.pexels.com/photos/4144222/pexels-photo-4144222.jpeg?auto=compress&cs=tinysrgb&w=800', // learning
    ),
  ];

  final List<Startup> _startups = [
    Startup(
      id: 's1',
      name: 'EcoSolar Team',
      focusArea: 'Clean Energy',
      sector: 'Energy',
      stage: 'Seed',
      location: 'Syria / Rural areas',
      teamSize: '3–5',
      shortBio:
          'Building affordable solar kits and pay-as-you-go energy access for remote communities.',
      logoUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    Startup(
      id: 's2',
      name: 'MediConnect',
      focusArea: 'Digital Health',
      sector: 'HealthTech',
      stage: 'Pre-Series A',
      location: 'Syria / Urban centers',
      teamSize: '5–10',
      shortBio:
          'Connecting patients with verified doctors via secure video consultations & clinic tools.',
      logoUrl: 'https://i.pravatar.cc/150?img=6',
    ),
    Startup(
      id: 's3',
      name: 'AgriSense',
      focusArea: 'Smart Farming',
      sector: 'AgriTech',
      stage: 'MVP',
      location: 'Syria / Agricultural regions',
      teamSize: '3–5',
      shortBio:
          'IoT sensors and analytics helping farmers save water and increase yield.',
      logoUrl: 'https://i.pravatar.cc/150?img=7',
    ),
  ];

  final List<Investor> _investors = [
    Investor(
      id: 'i1',
      name: 'Green Capital',
      thesis: 'Climate & Energy, long-term impact plays.',
      ticketSize: '\$50k–\$200k',
      preferredStages: 'Seed, Series A',
      preferredSectors: 'Clean energy, sustainability, climate tech',
      isLead: true,
      dealsCount: 8,
      logoUrl: 'https://i.pravatar.cc/150?img=8',
    ),
    Investor(
      id: 'i2',
      name: 'Syrian Angels',
      thesis: 'Early-stage tech founders in Syria and the region.',
      ticketSize: '\$10k–\$50k',
      preferredStages: 'Pre-seed, Seed',
      preferredSectors: 'SaaS, marketplaces, fintech, edtech',
      isLead: false,
      dealsCount: 15,
      logoUrl: 'https://i.pravatar.cc/150?img=9',
    ),
    Investor(
      id: 'i3',
      name: 'Impact Bridge',
      thesis: 'Social impact ventures in health, education, and jobs.',
      ticketSize: '\$30k–\$150k',
      preferredStages: 'Seed, Growth',
      preferredSectors: 'EdTech, HealthTech, Future of work',
      isLead: false,
      dealsCount: 5,
      logoUrl: 'https://i.pravatar.cc/150?img=10',
    ),
  ];

  String get _searchQuery => _searchController.text.trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    // Fake loading to show skeletons.
    // Replace this with your real async load.
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ------- FILTERS -------

  List<Project> get _filteredProjects {
    if (_selectedCategory == SearchCategory.startups ||
        _selectedCategory == SearchCategory.investors) {
      return [];
    }
    if (_searchQuery.isEmpty) return _projects;
    return _projects
        .where(
          (p) =>
              p.name.toLowerCase().contains(_searchQuery) ||
              p.sector.toLowerCase().contains(_searchQuery) ||
              p.stage.toLowerCase().contains(_searchQuery) ||
              p.market.toLowerCase().contains(_searchQuery) ||
              p.idea.toLowerCase().contains(_searchQuery) ||
              p.startupName.toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  List<Startup> get _filteredStartups {
    if (_selectedCategory == SearchCategory.projects ||
        _selectedCategory == SearchCategory.investors) {
      return [];
    }
    if (_searchQuery.isEmpty) return _startups;
    return _startups
        .where(
          (s) =>
              s.name.toLowerCase().contains(_searchQuery) ||
              s.sector.toLowerCase().contains(_searchQuery) ||
              s.stage.toLowerCase().contains(_searchQuery) ||
              s.location.toLowerCase().contains(_searchQuery) ||
              s.focusArea.toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  List<Investor> get _filteredInvestors {
    if (_selectedCategory == SearchCategory.projects ||
        _selectedCategory == SearchCategory.startups) {
      return [];
    }
    if (_searchQuery.isEmpty) return _investors;
    return _investors
        .where(
          (i) =>
              i.name.toLowerCase().contains(_searchQuery) ||
              i.thesis.toLowerCase().contains(_searchQuery) ||
              i.preferredSectors.toLowerCase().contains(_searchQuery) ||
              i.preferredStages.toLowerCase().contains(_searchQuery),
        )
        .toList();
  }

  // ------- UI -------

  @override
  Widget build(BuildContext context) {
    final projects = _filteredProjects;
    final startups = _filteredStartups;
    final investors = _filteredInvestors;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Skeletonizer(
          enabled: _isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(context),
                const SizedBox(height: 16),
                _buildCategoriesRow(context),
                const SizedBox(height: 24),

                // Projects
                if (projects.isNotEmpty &&
                    (_selectedCategory == SearchCategory.all ||
                        _selectedCategory == SearchCategory.projects))
                  _buildProjectsSection(context, projects),

                // People (Investors & Startups)
                if ((startups.isNotEmpty || investors.isNotEmpty) &&
                    (_selectedCategory == SearchCategory.all ||
                        _selectedCategory == SearchCategory.startups ||
                        _selectedCategory == SearchCategory.investors)) ...[
                  const SizedBox(height: 24),
                  _buildPeopleSection(context, startups, investors),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      controller: _searchController,
      enabled: !_isLoading, // optional: lock while loading
      onChanged: (_) {
        if (!_isLoading) {
          setState(() {});
        }
      },
      decoration: InputDecoration(
        hintText: 'Search projects, startups, investors...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoriesRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget buildChip(String label, SearchCategory value, IconData icon) {
      final bool selected = _selectedCategory == value;
      return ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: selected,
        onSelected: _isLoading
            ? null
            : (_) {
                setState(() {
                  _selectedCategory = value;
                });
              },
        selectedColor: colorScheme.primary.withOpacity(0.15),
        labelStyle: TextStyle(
          color: selected ? colorScheme.primary : colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.3),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildChip('All', SearchCategory.all, Icons.all_inclusive),
          const SizedBox(width: 8),
          buildChip('Projects', SearchCategory.projects, Icons.work_outline),
          const SizedBox(width: 8),
          buildChip('Startups', SearchCategory.startups, Icons.rocket_launch),
          const SizedBox(width: 8),
          buildChip(
            'Investors',
            SearchCategory.investors,
            Icons.attach_money_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection(BuildContext context, List<Project> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Projects', icon: Icons.workspaces_outline),
        const SizedBox(height: 8),
        GridView.builder(
          itemCount: projects.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 per row
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 4 / 3,
          ),
          itemBuilder: (context, index) {
            final project = projects[index];
            return GestureDetector(
              onTap: _isLoading
                  ? null
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailsPage(project: project),
                        ),
                      );
                    },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (project.imageUrl != null)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          project.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${project.sector} • ${project.stage}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              project.market,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                _statusChip(
                                  project.mentoringStatus,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 4),
                                _statusChip(
                                  project.dealRoomStatus,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _statusChip(String text, {required Color color}) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPeopleSection(
    BuildContext context,
    List<Startup> startups,
    List<Investor> investors,
  ) {
    final List<_PersonItem> people = [
      ...startups.map(
        (s) => _PersonItem(
          id: s.id,
          name: s.name,
          subtitle: '${s.sector} • ${s.stage}',
          type: _PersonType.startup,
          imageUrl: s.logoUrl,
        ),
      ),
      ...investors.map(
        (i) => _PersonItem(
          id: i.id,
          name: i.name,
          subtitle: i.preferredSectors,
          type: _PersonType.investor,
          isLeadInvestor: i.isLead,
          imageUrl: i.logoUrl,
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Investors & Startups', icon: Icons.group_outlined),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: people.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final person = people[index];
              final bool isInvestor = person.type == _PersonType.investor;
              final Color badgeColor = isInvestor
                  ? Colors.green
                  : Colors.blueAccent;
              final String badgeText = isInvestor ? 'Investor' : 'Startup';
              final IconData badgeIcon = isInvestor
                  ? Icons.attach_money
                  : Icons.rocket_launch;

              return GestureDetector(
                onTap: _isLoading
                    ? null
                    : () {
                        if (isInvestor) {
                          final investor = _investors.firstWhere(
                            (inv) => inv.id == person.id,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  InvestorDetailsPage(investor: investor),
                            ),
                          );
                        } else {
                          final startup = _startups.firstWhere(
                            (st) => st.id == person.id,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  StartupDetailsPage(startup: startup),
                            ),
                          );
                        }
                      },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: person.imageUrl != null
                              ? NetworkImage(person.imageUrl!)
                              : null,
                          child: person.imageUrl == null
                              ? Text(
                                  person.name.isNotEmpty
                                      ? person.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(fontSize: 22),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              badgeIcon,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 100,
                      child: Text(
                        person.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        badgeText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: badgeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 6)],
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

// ------- MODELS -------

class Project {
  final String id;
  final String name;
  final String idea;
  final String team;
  final String stage;
  final String sector;
  final String market;
  final String commercialRecord;
  final String mentoringStatus;
  final String dealRoomStatus;
  final String startupName;
  final String? imageUrl;

  Project({
    required this.id,
    required this.name,
    required this.idea,
    required this.team,
    required this.stage,
    required this.sector,
    required this.market,
    required this.commercialRecord,
    required this.mentoringStatus,
    required this.dealRoomStatus,
    required this.startupName,
    this.imageUrl,
  });
}

class Startup {
  final String id;
  final String name;
  final String focusArea;
  final String sector;
  final String stage;
  final String location;
  final String teamSize;
  final String shortBio;
  final String? logoUrl;

  Startup({
    required this.id,
    required this.name,
    required this.focusArea,
    required this.sector,
    required this.stage,
    required this.location,
    required this.teamSize,
    required this.shortBio,
    this.logoUrl,
  });
}

class Investor {
  final String id;
  final String name;
  final String thesis;
  final String ticketSize;
  final String preferredStages;
  final String preferredSectors;
  final bool isLead;
  final int dealsCount;
  final String? logoUrl;

  Investor({
    required this.id,
    required this.name,
    required this.thesis,
    required this.ticketSize,
    required this.preferredStages,
    required this.preferredSectors,
    this.isLead = false,
    this.dealsCount = 0,
    this.logoUrl,
  });
}

enum _PersonType { startup, investor }

class _PersonItem {
  final String id;
  final String name;
  final String subtitle;
  final _PersonType type;
  final bool isLeadInvestor;
  final String? imageUrl;

  _PersonItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.type,
    this.isLeadInvestor = false,
    this.imageUrl,
  });
}

// ------- DETAILS PAGES -------

class ProjectDetailsPage extends StatelessWidget {
  final Project project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (project.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                project.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            project.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${project.sector} • ${project.stage}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),

          // Status chips
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Chip(
                label: Text(project.mentoringStatus),
                backgroundColor: Colors.blueAccent.withOpacity(0.12),
                labelStyle: const TextStyle(color: Colors.blueAccent),
              ),
              Chip(
                label: Text(project.dealRoomStatus),
                backgroundColor: Colors.deepPurple.withOpacity(0.12),
                labelStyle: const TextStyle(color: Colors.deepPurple),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _detailSectionTitle(context, 'Idea'),
          Text(project.idea, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),

          _detailSectionTitle(context, 'Team'),
          Text(project.team, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),

          _detailSectionTitle(context, 'Market & Sector'),
          Text(
            'Market: ${project.market}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Sector: ${project.sector}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          _detailSectionTitle(context, 'Commercial Record'),
          Text(
            project.commercialRecord,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          _detailSectionTitle(context, 'Startup'),
          Text(
            project.startupName,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 24),
          _detailSectionTitle(context, 'Project QR'),
          const SizedBox(height: 8),
          Center(
            child: QrImageView(
              data: 'stepup://project/${project.id}',
              version: QrVersions.auto,
              size: 160,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailSectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class StartupDetailsPage extends StatelessWidget {
  final Startup startup;

  const StartupDetailsPage({super.key, required this.startup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(startup.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: startup.logoUrl != null
                    ? NetworkImage(startup.logoUrl!)
                    : null,
                child: startup.logoUrl == null
                    ? Text(
                        startup.name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 24),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      startup.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Startup • ${startup.stage}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${startup.sector} • ${startup.location}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _detailTitle(context, 'Focus Area'),
          Text(
            startup.focusArea,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 16),
          _detailTitle(context, 'Team Size'),
          Text(
            '${startup.teamSize} people',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 16),
          _detailTitle(context, 'About'),
          Text(startup.shortBio, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _detailTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class InvestorDetailsPage extends StatelessWidget {
  final Investor investor;

  const InvestorDetailsPage({super.key, required this.investor});

  @override
  Widget build(BuildContext context) {
    final badgeColor = investor.isLead ? Colors.green : Colors.teal;

    return Scaffold(
      appBar: AppBar(title: Text(investor.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: investor.logoUrl != null
                    ? NetworkImage(investor.logoUrl!)
                    : null,
                child: investor.logoUrl == null
                    ? Text(
                        investor.name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 24),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      investor.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        investor.isLead ? 'Lead Investor' : 'Investor',
                        style: TextStyle(
                          color: badgeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${investor.dealsCount} deals backed',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          _detailTitle(context, 'Investment Thesis'),
          Text(investor.thesis, style: Theme.of(context).textTheme.bodyMedium),

          const SizedBox(height: 16),
          _detailTitle(context, 'Ticket Size'),
          Text(
            investor.ticketSize,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 16),
          _detailTitle(context, 'Preferred Stages'),
          Text(
            investor.preferredStages,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 16),
          _detailTitle(context, 'Preferred Sectors'),
          Text(
            investor.preferredSectors,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _detailTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
