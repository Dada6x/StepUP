import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

const _cardColor = Color(0xFF042A2B);
const _accentPurple = Color(0xFFAE8B4D);
const _accentGreen = Color(0xFF10B981);
const _accentRed = Color(0xFFEF4444);

class StartupDashboardPage extends StatelessWidget {
  const StartupDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔻 Downward / losing trend
    final spots = [
      const FlSpot(0, 7),
      const FlSpot(1, 6),
      const FlSpot(2, 4.5),
      const FlSpot(3, 3),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ========= OVERVIEW CARD (different layout) =========
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Startup Overview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _accentRed.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline,
                                color: _accentRed, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'At risk',
                              style: TextStyle(
                                color: _accentRed,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _StatItem(
                        label: 'MRR',
                        value: '\$32,450',
                        sub: '-4.2% vs last month',
                        valueColor: _accentRed,
                      ),
                      _StatItem(
                        label: 'Burn Rate',
                        value: '\$24,800 / mo',
                      ),
                      _StatItem(
                        label: 'Runway',
                        value: '9 months',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Focus on extending runway and improving retention over the next quarter.',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ========= MRR TREND (red, going down) =========
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
                    'MRR Trend (Last 4 Months)',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      _PillChip(label: '1M'),
                      SizedBox(width: 8),
                      _PillChip(label: '3M'),
                      SizedBox(width: 8),
                      _PillChip(label: '6M', selected: true),
                      SizedBox(width: 8),
                      _PillChip(label: '1Y'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLineChart(spots: spots, color: _accentRed),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.trending_down,
                          size: 16, color: _accentRed),
                      const SizedBox(width: 4),
                      Text(
                        'MRR down ~\$4.8k over the last 4 months',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ========= Health stats (kept but slightly different place) =========
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
                  _SectionTitle(title: 'Company Health'),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(label: 'Cash in Bank', value: '\$220,000'),
                      _StatItem(label: 'Monthly Burn', value: '\$24,800'),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(
                        label: 'Active Users',
                        value: '3,980',
                        sub: '-3.1% this month',
                        valueColor: _accentRed,
                      ),
                      _StatItem(
                        label: 'Churn',
                        value: '3.8%',
                        valueColor: _accentRed,
                        sub: 'Last 30 days',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ========= Fundraising card =========
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const _SectionTitle(
                    title: 'Fundraising',
                    actionText: 'Pitch deck',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Target Round',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '\$500,000 Seed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Soft-circled: \$120k from 3 investors',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _PrimaryButton(
                    label: 'View Interested Investors',
                    onTap: _noop,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ========= Meetings with investors =========
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const _SectionTitle(
                    title: 'Upcoming Meetings',
                    actionText: 'See all',
                  ),
                  const SizedBox(height: 12),
                  _meetingRow(
                    title: 'Green Capital',
                    subtitle: 'Bridge round options • Tomorrow 3:00 PM',
                  ),
                  const Divider(color: Colors.white12),
                  _meetingRow(
                    title: 'Syrian Angels',
                    subtitle: 'Retention strategy • Fri 11:00 AM',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _noop() {}

  static Widget _buildLineChart({
    required List<FlSpot> spots,
    Color color = _accentRed,
  }) {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.transparent,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final labels = ['Jun', 'Jul', 'Aug', 'Sep'];
                  final index = value.toInt();
                  return Text(
                    index >= 0 && index < labels.length ? labels[index] : '',
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 10),
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
                color: color.withOpacity(0.18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _meetingRow({
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        const Icon(Icons.event, color: Colors.white70, size: 20),
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
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
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
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
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
  final Color? valueColor;

  const _StatItem({
    required this.label,
    required this.value,
    this.sub,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        if (sub != null) ...[
          const SizedBox(height: 2),
          Text(
            sub!,
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
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
          style:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
