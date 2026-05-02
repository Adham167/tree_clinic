import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/cart/data/model/merchant_order_request_model.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';

class MerchantOrderRequestsView extends StatefulWidget {
  const MerchantOrderRequestsView({super.key, required this.shop});

  final ShopEntity shop;

  @override
  State<MerchantOrderRequestsView> createState() =>
      _MerchantOrderRequestsViewState();
}

class _MerchantOrderRequestsViewState extends State<MerchantOrderRequestsView> {
  String selectedFilter = 'all';
  bool isUpdating = false;

  Future<void> _updateRequestStatus(
    MerchantOrderRequestModel request,
    String nextStatus,
  ) async {
    setState(() => isUpdating = true);
    try {
      await FirebaseFirestore.instance
          .collection('merchant_order_requests')
          .doc(request.id)
          .update({
            'status': nextStatus,
            'updatedAt': DateTime.now().toIso8601String(),
          });
      await _syncParentOrderStatus(request.orderId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr(
              nextStatus == 'approved'
                  ? 'Order request approved.'
                  : 'Order request rejected.',
            ),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => isUpdating = false);
      }
    }
  }

  Future<void> _syncParentOrderStatus(String orderId) async {
    final requestsSnapshot =
        await FirebaseFirestore.instance
            .collection('merchant_order_requests')
            .where('orderId', isEqualTo: orderId)
            .get();

    final statuses =
        requestsSnapshot.docs
            .map((doc) => doc.data()['status']?.toString() ?? 'pending')
            .toList();

    final orderStatus =
        statuses.any((status) => status == 'rejected')
            ? 'rejected'
            : statuses.isNotEmpty &&
                statuses.every((status) => status == 'approved')
            ? 'approved'
            : 'awaiting_merchant_approval';

    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': orderStatus,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Color _statusColor(String status) {
    return switch (status) {
      'approved' => Colors.green,
      'rejected' => Colors.red,
      _ => Colors.orange,
    };
  }

  String _statusLabel(BuildContext context, String status) {
    return switch (status) {
      'approved' => context.tr('Approved'),
      'rejected' => context.tr('Rejected'),
      _ => context.tr('Pending'),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(context.tr('Order Approvals')),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            FirebaseFirestore.instance
                .collection('merchant_order_requests')
                .where('shopId', isEqualTo: widget.shop.id)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests =
              snapshot.data!.docs
                  .map(
                    (doc) =>
                        MerchantOrderRequestModel.fromJson(doc.data(), doc.id),
                  )
                  .toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          final filteredRequests =
              selectedFilter == 'all'
                  ? requests
                  : requests
                      .where((request) => request.status == selectedFilter)
                      .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _ApprovalSummary(
                  totalCount: requests.length,
                  pendingCount:
                      requests
                          .where((request) => request.status == 'pending')
                          .length,
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _StatusFilterChip(
                      label: context.tr('All'),
                      selected: selectedFilter == 'all',
                      onTap: () => setState(() => selectedFilter = 'all'),
                    ),
                    _StatusFilterChip(
                      label: context.tr('Pending'),
                      selected: selectedFilter == 'pending',
                      onTap: () => setState(() => selectedFilter = 'pending'),
                    ),
                    _StatusFilterChip(
                      label: context.tr('Approved'),
                      selected: selectedFilter == 'approved',
                      onTap: () => setState(() => selectedFilter = 'approved'),
                    ),
                    _StatusFilterChip(
                      label: context.tr('Rejected'),
                      selected: selectedFilter == 'rejected',
                      onTap: () => setState(() => selectedFilter = 'rejected'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child:
                    filteredRequests.isEmpty
                        ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              context.tr('No approval requests found.'),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          itemCount: filteredRequests.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final request = filteredRequests[index];
                            return _ApprovalRequestCard(
                              request: request,
                              isUpdating: isUpdating,
                              statusColor: _statusColor(request.status),
                              statusLabel: _statusLabel(
                                context,
                                request.status,
                              ),
                              onApprove:
                                  request.status == 'pending'
                                      ? () => _updateRequestStatus(
                                        request,
                                        'approved',
                                      )
                                      : null,
                              onReject:
                                  request.status == 'pending'
                                      ? () => _updateRequestStatus(
                                        request,
                                        'rejected',
                                      )
                                      : null,
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ApprovalSummary extends StatelessWidget {
  const _ApprovalSummary({
    required this.totalCount,
    required this.pendingCount,
  });

  final int totalCount;
  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.assignment_turned_in_outlined, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Approval requests'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr(
                    '{pending} pending from {total} total requests',
                    params: {
                      'pending': pendingCount.toString(),
                      'total': totalCount.toString(),
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusFilterChip extends StatelessWidget {
  const _StatusFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: Colors.green.withValues(alpha: 0.18),
      ),
    );
  }
}

class _ApprovalRequestCard extends StatelessWidget {
  const _ApprovalRequestCard({
    required this.request,
    required this.isUpdating,
    required this.statusColor,
    required this.statusLabel,
    required this.onApprove,
    required this.onReject,
  });

  final MerchantOrderRequestModel request;
  final bool isUpdating;
  final Color statusColor;
  final String statusLabel;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final tree = request.productTree.trim();
    final disease = request.productDisease.trim();
    final deliveryDetails = request.deliveryDetails;
    final placeType = deliveryDetails.placeType.trim();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoTag(label: '${context.tr('Quantity')}: ${request.quantity}'),
              _InfoTag(
                label:
                    '${context.tr('Total')}: ${request.totalPrice.toStringAsFixed(0)} ${context.tr('EGP')}',
              ),
              if (tree.isNotEmpty)
                _InfoTag(label: '${context.tr('Tree')}: ${context.tr(tree)}'),
              if (disease.isNotEmpty)
                _InfoTag(
                  label: '${context.tr('Disease')}: ${context.tr(disease)}',
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('Buyer Details'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _DetailLine(label: context.tr('Name'), value: request.buyerName),
          _DetailLine(label: context.tr('Email'), value: request.buyerEmail),
          _DetailLine(label: context.tr('Phone'), value: request.buyerPhone),
          const SizedBox(height: 12),
          Text(
            context.tr('Delivery Details'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _DetailLine(
            label: context.tr('Governorate'),
            value: deliveryDetails.governorate,
          ),
          _DetailLine(
            label: context.tr('Address'),
            value: deliveryDetails.address,
          ),
          _DetailLine(
            label: context.tr('Place Type'),
            value: placeType.isEmpty ? '' : context.tr(placeType),
          ),
          _DetailLine(
            label: context.tr('Location availability'),
            value: deliveryDetails.placeAvailability,
          ),
          const SizedBox(height: 16),
          if (request.status == 'pending')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: isUpdating ? null : onApprove,
                    icon: const Icon(Icons.check),
                    label: Text(context.tr('Approve')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    onPressed: isUpdating ? null : onReject,
                    icon: const Icon(Icons.close),
                    label: Text(context.tr('Reject')),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InfoTag extends StatelessWidget {
  const _InfoTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.trim().isEmpty ? '-' : value.trim())),
        ],
      ),
    );
  }
}
