import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _bgColor = Color(0xFF050816);
const _cardColor = Color(0xFF042A2B);
const _accentPurple = Color(0xFFF0EAE0);
const _accentGreen = Color(0xFF10B981);

class MentorDashboardPage extends StatefulWidget {
  const MentorDashboardPage({super.key});

  @override
  State<MentorDashboardPage> createState() => _MentorDashboardPageState();
}

class _MentorDashboardPageState extends State<MentorDashboardPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Fake loading – replace with your real data loading later
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final spots = [
      const FlSpot(0, 2),
      const FlSpot(1, 3.5),
      const FlSpot(2, 4),
      const FlSpot(3, 6),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Skeletonizer(
          enabled: _isLoading,
          ignorePointers: true,
          // customize how skeleton looks
          effect: const ShimmerEffect(
            baseColor: Color(0xFF032A2A),
            highlightColor: Color(0xFF064E4E),
          ),
          containersColor: const Color(0xFF032A2A),
          child: Column(
            children: [
              // ======== CARD 1: Mentoring hours + chart ========
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mentoring Hours (This Month)',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '26.5 h',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _accentGreen.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            '+3.2 h vs last month',
                            style: TextStyle(
                              color: _accentGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Across 9 startups',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        _PillChip(label: 'This month', selected: true),
                        SizedBox(width: 8),
                        _PillChip(label: '3M'),
                        SizedBox(width: 8),
                        _PillChip(label: 'YTD'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // chart: custom skeleton when loading
                    if (_isLoading)
                      // big rounded block instead of messy chart bones
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFF032A2A),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      )
                    else
                      _buildLineChart(spots: spots, color: _accentGreen),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ======== CARD 2: Mentor stats ========
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
                    _SectionTitle(title: 'Mentor Stats'),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatItem(
                          label: 'Active Startups',
                          value: '9',
                          sub: '3 new this month',
                        ),
                        _StatItem(
                          label: 'Avg. Rating',
                          value: '4.8 / 5',
                          sub: '32 reviews',
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatItem(
                          label: 'Sessions',
                          value: '41',
                          sub: 'Last 90 days',
                        ),
                        _StatItem(
                          label: 'Deals Closed',
                          value: '3',
                          sub: 'Mentored to funding',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ======== CARD 3: Sessions ========
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const _SectionTitle(
                      title: 'Today\'s Sessions',
                      actionText: 'View calendar',
                    ),
                    const SizedBox(height: 12),
                    _sessionRow(
                      title: 'EcoSolar',
                      subtitle: 'Fundraising narrative • 10:00–10:45',
                    ),
                    const Divider(color: Colors.white12),
                    _sessionRow(
                      title: 'MediConnect',
                      subtitle: 'Go-to-market review • 13:00–13:30',
                    ),
                    const Divider(color: Colors.white12),
                    _sessionRow(
                      title: 'AgriSense',
                      subtitle: 'Unit economics • 16:00–16:45',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // button: keep structure but Skeletonizer will bone the text only
              Skeleton.keep(
                // we keep the button shape so it doesn't turn into
                // a tiny grey box when loading
                child: _PrimaryButton(
                  label: _isLoading ? 'Loading...' : 'Open Deal Room',
                  onTap: _isLoading ? () {} : () {}, // hook your logic here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildLineChart({
    required List<FlSpot> spots,
    Color color = _accentGreen,
  }) {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.transparent,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
                  final index = value.toInt();
                  return Text(
                    index >= 0 && index < labels.length ? labels[index] : '',
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 2.5,
              color: color,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: color.withOpacity(0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sessionRow({required String title, required String subtitle}) {
    return Row(
      children: [
        const Icon(Icons.video_call, color: Colors.white70, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.white54),
      ],
    );
  }
}

/// local helpers

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;

  const _SectionTitle({required this.title, this.actionText});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        if (actionText != null)
          Text(
            actionText!,
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
          ),
      ],
    );
  }
}

class _PillChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _PillChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? _accentPurple : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? Colors.white : Colors.grey[300],
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;

  const _StatItem({required this.label, required this.value, this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        if (sub != null) ...[
          const SizedBox(height: 2),
          Text(sub!, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        ],
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: _accentPurple,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
