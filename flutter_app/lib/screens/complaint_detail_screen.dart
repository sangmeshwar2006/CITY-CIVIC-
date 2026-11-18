import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/complaint_service.dart';
import '../widgets/status_chip.dart';
import '../widgets/timeline_tile.dart';

class ComplaintDetailScreen extends StatefulWidget {
  const ComplaintDetailScreen({super.key, required this.complaintId});

  static const routeName = '/complaint-detail';
  final String complaintId;

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadComplaint());
  }

  Future<void> _loadComplaint() async {
    final token = context.read<AuthService>().token!;
    await context.read<ComplaintService>().fetchComplaintById(
          token: token,
          id: widget.complaintId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final complaint = context.watch<ComplaintService>().selectedComplaint;

    return Scaffold(
      appBar: AppBar(title: const Text('Complaint Details')),
      body: complaint == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (complaint.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      complaint.imageUrl.startsWith('http')
                          ? complaint.imageUrl
                          : 'http://10.0.2.2:5000${complaint.imageUrl}',
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  complaint.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    StatusChip(status: complaint.status),
                    Chip(label: Text(complaint.category)),
                  ],
                ),
                const SizedBox(height: 20),
                Text(complaint.description),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(complaint.address),
                  subtitle: Text(
                    'Lat ${complaint.latitude}, Lng ${complaint.longitude}',
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Status timeline',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...complaint.history.asMap().entries.map(
                      (entry) => TimelineTile(
                        history: entry.value,
                        isLast: entry.key == complaint.history.length - 1,
                      ),
                    ),
              ],
            ),
    );
  }
}
