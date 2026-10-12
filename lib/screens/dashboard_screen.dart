
import 'package:flutter/material.dart';
import '../widgets/navigation_shell.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationShell(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        if (index == 0) return;

        final sectionNames = [
          'Dashboard',
          'Inventory',
          'Sales',
          'Analytics',
        ];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${sectionNames[index]} screen coming soon.',
            ),
          ),
        );
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Here is an overview of your sari-sari store.',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 28),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns =
                        constraints.maxWidth >= 900
                            ? 4
                            : constraints.maxWidth >= 550
                                ? 2
                                : 1;

                    const spacing = 16.0;
                    final cardWidth =
                        (constraints.maxWidth -
                            spacing * (columns - 1)) /
                        columns;

                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: const SummaryCard(
                            title: 'Total Products',
                            value: '0',
                            icon: Icons.inventory_2_outlined,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: const SummaryCard(
                            title: "Today's Sales",
                            value: '₱0.00',
                            icon: Icons.payments_outlined,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: const SummaryCard(
                            title: 'Low Stock Items',
                            value: '0',
                            icon: Icons.warning_amber_rounded,
                            color: Color(0xFFEA580C),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: const SummaryCard(
                            title: 'Restock Suggestions',
                            value: '0',
                            icon: Icons.auto_awesome_outlined,
                            color: Color(0xFF9333EA),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to TindaSmart!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Your store overview will appear here. '
                        'Once the backend is connected, this dashboard '
                        'can display actual inventory, sales, and '
                        'AI-powered restocking recommendations.',
                        style: TextStyle(
                          height: 1.6,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 20),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
