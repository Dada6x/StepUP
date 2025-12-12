import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _bgColor = Color(0xFF050816);
const _cardColor = Color(0xFF042A2B);
const _accentPurple = Color(0xFFF0EAE0);
const _accentGreen = Color(0xFF10B981);
const _accentRed = Color(0xFFEF4444);

class InvestorDashboardPage extends StatefulWidget {
  const InvestorDashboardPage({super.key});

  @override
  State<InvestorDashboardPage> createState() => _InvestorDashboardPageState();
}

class _InvestorDashboardPageState extends State<InvestorDashboardPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Fake loading – plug in your real async logic instead
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
      const FlSpot(0, 4),
      const FlSpot(1, 5.5),
      const FlSpot(2, 5),
      const FlSpot(3, 7.5),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Skeletonizer(
          enabled: _isLoading,
          ignorePointers: true,
          effect: const ShimmerEffect(
            baseColor: Color(0xFF032A2A),
            highlightColor: Color(0xFF064E4E),
          ),
          containersColor: const Color(0xFF032A2A),
          child: Column(
            children: [
              // Portfolio card + chart
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
                      'Total Portfolio Value',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$256,840.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
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
                            '+4.23% (24h)',
                            style: TextStyle(
                              color: _accentGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Updated just now',
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
                        _PillChip(label: '24H', selected: true),
                        SizedBox(width: 8),
                        _PillChip(label: '1W'),
                        SizedBox(width: 8),
                        _PillChip(label: '1M'),
                        SizedBox(width: 8),
                        _PillChip(label: '1Y'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // chart skeleton when loading
                    if (_isLoading)
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

              // Portfolio stats
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
                    _SectionTitle(title: 'Portfolio Stats'),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatItem(label: 'Invested', value: '\$180,000'),
                        _StatItem(
                          label: 'Unrealized P/L',
                          value: '+\$26,300',
                          valueColor: _accentGreen,
                          sub: '+14.6%',
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatItem(
                          label: 'Startups',
                          value: '12',
                          sub: 'Active deals',
                        ),
                        _StatItem(label: 'Avg. Ticket', value: '\$15,000'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Active investments
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const _SectionTitle(
                      title: 'Active Investments',
                      actionText: 'View all',
                    ),
                    const SizedBox(height: 12),
                    _investmentRow(
                      name: 'EcoSolar',
                      stage: 'Seed • Energy',
                      value: '\$40,000',
                      change: '+8.3%',
                    ),
                    const Divider(color: Colors.white12),
                    _investmentRow(
                      name: 'MediConnect',
                      stage: 'Pre-Series A • HealthTech',
                      value: '\$65,000',
                      change: '+3.1%',
                    ),
                    const Divider(color: Colors.white12),
                    _investmentRow(
                      name: 'AgriSense',
                      stage: 'MVP • AgriTech',
                      value: '\$22,000',
                      change: '-1.4%',
                      isDown: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Button – keep shape predictable while loading
              Skeleton.keep(
                child: _PrimaryButton(
                  label: _isLoading ? 'Loading...' : 'Browse New Startups',
                  onTap: () {
                    if (_isLoading) return;
                    // TODO: navigate to search / deal room
                  },
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
                  final labels = ['Oct 10', 'Oct 11', 'Oct 12', 'Oct 13'];
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
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                  radius: 3.5,
                  color: _bgColor,
                  strokeWidth: 2,
                  strokeColor: color,
                ),
              ),
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

  static Widget _investmentRow({
    required String name,
    required String stage,
    required String value,
    required String change,
    bool isDown = false,
  }) {
    final changeColor = isDown ? _accentRed : _accentGreen;
    final icon = isDown ? Icons.arrow_downward : Icons.arrow_upward;

    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white.withOpacity(0.08),
          child: Text(
            name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                stage,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(icon, size: 12, color: changeColor),
                const SizedBox(width: 2),
                Text(
                  change,
                  style: TextStyle(
                    color: changeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Small shared widgets for this file only

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
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
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
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
