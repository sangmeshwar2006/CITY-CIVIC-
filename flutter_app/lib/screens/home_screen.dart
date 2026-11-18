import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/complaint_service.dart';
import '../widgets/complaint_card.dart';
import 'complaint_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadComplaints());
  }

  Future<void> _loadComplaints() async {
    final token = context.read<AuthService>().token;
    if (token == null) return;
    await context.read<ComplaintService>().fetchComplaints(
          token: token,
          status: _selectedStatus,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final complaintService = context.watch<ComplaintService>();
    const statuses = ['', 'Pending', 'In Progress', 'Resolved'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
        actions: [
          IconButton(
            onPressed: () async {
              await authService.logout();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-complaint');
          await _loadComplaints();
        },
        icon: const Icon(Icons.add),
        label: const Text('Report issue'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadComplaints,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Hello ${authService.user?['name'] ?? 'Citizen'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Track open civic complaints and submit new ones quickly.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Filter by status'),
              items: statuses
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.isEmpty ? 'All statuses' : status),
                    ),
                  )
                  .toList(),
              onChanged: (value) async {
                setState(() => _selectedStatus = value ?? '');
                await _loadComplaints();
              },
            ),
            const SizedBox(height: 20),
            if (complaintService.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (complaintService.complaints.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: Text('No complaints yet')),
              )
            else
              ...complaintService.complaints.map(
                (complaint) => ComplaintCard(
                  complaint: complaint,
                  onTap: () => Navigator.pushNamed(
                    context,
                    ComplaintDetailScreen.routeName,
                    arguments: complaint.id,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
