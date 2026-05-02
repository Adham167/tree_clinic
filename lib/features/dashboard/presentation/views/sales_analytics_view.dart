import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';
import 'package:tree_clinic/features/cart/data/model/merchant_order_request_model.dart';
import 'package:tree_clinic/features/dashboard/domain/entities/shop_entity.dart';

enum SalesPeriod { daily, weekly, monthly }

extension SalesPeriodLabel on SalesPeriod {
  String localizedLabel(BuildContext context) {
    return switch (this) {
      SalesPeriod.daily => context.tr('Daily'),
      SalesPeriod.weekly => context.tr('Weekly'),
      SalesPeriod.monthly => context.tr('Monthly'),
    };
  }
}

class SalesAnalyticsView extends StatefulWidget {
  const SalesAnalyticsView({super.key, required this.shop});

  final ShopEntity shop;

  @override
  State<SalesAnalyticsView> createState() => _SalesAnalyticsViewState();
}

class _SalesAnalyticsViewState extends State<SalesAnalyticsView> {
  SalesPeriod period = SalesPeriod.weekly;
  late Future<_SalesReport> reportFuture;

  @override
  void initState() {
    super.initState();
    reportFuture = _loadReport();
  }

  Future<_SalesReport> _loadReport() async {
    final requestsSnapshot =
        await FirebaseFirestore.instance
            .collection('merchant_order_requests')
            .where('shopId', isEqualTo: widget.shop.id)
            .get();

    final range = _rangeFor(period);
    final lines = <_SalesLine>[];

    for (final doc in requestsSnapshot.docs) {
      final request = MerchantOrderRequestModel.fromJson(doc.data(), doc.id);
      if (request.status != 'approved') continue;
      if (request.createdAt.isBefore(range.start) ||
          !request.createdAt.isBefore(range.end)) {
        continue;
      }

      lines.add(
        _SalesLine(
          requestId: request.id,
          orderId: request.orderId,
          productId: request.productId,
          productName: request.productName,
          quantity: request.quantity,
          revenue: request.totalPrice,
          createdAt: request.createdAt,
          buyerName: request.buyerName,
        ),
      );
    }

    return _SalesReport.fromLines(lines, period, range);
  }

  _DateRange _rangeFor(SalesPeriod period) {
    final now = DateTime.now();
    return switch (period) {
      SalesPeriod.daily => _DateRange(
        DateTime(now.year, now.month, now.day),
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      ),
      SalesPeriod.weekly => _DateRange(
        DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 6)),
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      ),
      SalesPeriod.monthly => _DateRange(
        DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1, 1),
      ),
    };
  }

  void _changePeriod(SalesPeriod value) {
    setState(() {
      period = value;
      reportFuture = _loadReport();
    });
  }

  Future<void> _exportCsv(_SalesReport report) async {
    final buffer =
        StringBuffer()
          ..writeln(
            'date,order_id,request_id,buyer_name,product_id,product_name,quantity,revenue',
          );
    for (final line in report.lines) {
      buffer.writeln(
        [
          line.createdAt.toIso8601String(),
          line.orderId,
          line.requestId,
          '"${line.buyerName.replaceAll('"', '""')}"',
          line.productId,
          '"${line.productName.replaceAll('"', '""')}"',
          line.quantity,
          line.revenue.toStringAsFixed(2),
        ].join(','),
      );
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('CSV report copied to clipboard.'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(context.tr('Sales Analytics')),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<_SalesReport>(
        future: reportFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final report = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() => reportFuture = _loadReport());
              await reportFuture;
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  context.tr('Approved sales only'),
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 12),
                _PeriodSelector(value: period, onChanged: _changePeriod),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    _KpiCard(
                      title: context.tr('Revenue'),
                      value:
                          '${report.totalRevenue.toStringAsFixed(0)} ${context.tr('EGP')}',
                      icon: Icons.payments_outlined,
                    ),
                    _KpiCard(
                      title: context.tr('Orders'),
                      value: report.orderCount.toString(),
                      icon: Icons.receipt_long_outlined,
                    ),
                    _KpiCard(
                      title: context.tr('Items Sold'),
                      value: report.itemsSold.toString(),
                      icon: Icons.inventory_2_outlined,
                    ),
                    _KpiCard(
                      title: context.tr('Average Order'),
                      value:
                          '${report.averageOrderValue.toStringAsFixed(0)} ${context.tr('EGP')}',
                      icon: Icons.trending_up,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SalesChart(
                  title: context.tr('Revenue Trend'),
                  buckets: report.buckets,
                ),
                const SizedBox(height: 16),
                _TopProducts(products: report.topProducts),
                const SizedBox(height: 16),
                _OrdersTable(lines: report.lines),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _exportCsv(report),
                    icon: const Icon(Icons.file_download_outlined),
                    label: Text(context.tr('Export CSV')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.value, required this.onChanged});

  final SalesPeriod value;
  final ValueChanged<SalesPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<SalesPeriod>(
      segments:
          SalesPeriod.values
              .map(
                (period) => ButtonSegment<SalesPeriod>(
                  value: period,
                  label: Text(period.localizedLabel(context)),
                ),
              )
              .toList(),
      selected: {value},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.green),
          Text(title, style: TextStyle(color: Colors.grey.shade700)),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _SalesChart extends StatelessWidget {
  const _SalesChart({required this.title, required this.buckets});

  final String title;
  final List<_SalesBucket> buckets;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _BarChartPainter(buckets),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopProducts extends StatelessWidget {
  const _TopProducts({required this.products});

  final List<_ProductSalesSummary> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Top Products'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (products.isEmpty)
            Text(context.tr('No product sales in this period.'))
          else
            ...products.take(5).map(
              (product) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(product.name),
                subtitle: Text(
                  context.tr(
                    '{count} items sold',
                    params: {'count': product.quantity.toString()},
                  ),
                ),
                trailing: Text(
                  '${product.revenue.toStringAsFixed(0)} ${context.tr('EGP')}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrdersTable extends StatelessWidget {
  const _OrdersTable({required this.lines});

  final List<_SalesLine> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Report Details'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (lines.isEmpty)
            Text(context.tr('No orders found for this period.'))
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text(context.tr('Date'))),
                  DataColumn(label: Text(context.tr('Buyer'))),
                  DataColumn(label: Text(context.tr('Product'))),
                  DataColumn(label: Text(context.tr('Qty'))),
                  DataColumn(label: Text(context.tr('Revenue'))),
                ],
                rows:
                    lines
                        .map(
                          (line) => DataRow(
                            cells: [
                              DataCell(Text(_dateLabel(line.createdAt))),
                              DataCell(Text(line.buyerName)),
                              DataCell(Text(line.productName)),
                              DataCell(Text(line.quantity.toString())),
                              DataCell(
                                Text(
                                  '${line.revenue.toStringAsFixed(0)} ${context.tr('EGP')}',
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
              ),
            ),
        ],
      ),
    );
  }

  static String _dateLabel(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter(this.buckets);

  final List<_SalesBucket> buckets;

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.12)
          ..strokeWidth = 1;
    final barPaint = Paint()..color = Colors.green;
    final labelPainter = TextPainter(textDirection: TextDirection.ltr);

    canvas.drawLine(
      Offset(0, size.height - 24),
      Offset(size.width, size.height - 24),
      axisPaint,
    );

    if (buckets.isEmpty) return;

    final maxRevenue = buckets
        .map((bucket) => bucket.revenue)
        .fold<double>(0, (max, value) => value > max ? value : max);
    final safeMax = maxRevenue <= 0 ? 1 : maxRevenue;
    final gap = 8.0;
    final barWidth =
        (size.width - (gap * (buckets.length - 1))) / buckets.length;

    for (var index = 0; index < buckets.length; index++) {
      final bucket = buckets[index];
      final barHeight = (bucket.revenue / safeMax) * (size.height - 52);
      final left = index * (barWidth + gap);
      final top = size.height - 24 - barHeight;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, barHeight),
        const Radius.circular(5),
      );
      canvas.drawRRect(rect, barPaint);

      labelPainter.text = TextSpan(
        text: bucket.label,
        style: const TextStyle(fontSize: 10, color: Colors.black54),
      );
      labelPainter.layout(maxWidth: barWidth + gap);
      labelPainter.paint(canvas, Offset(left, size.height - 18));
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.buckets != buckets;
  }
}

class _SalesReport {
  _SalesReport({
    required this.lines,
    required this.buckets,
    required this.topProducts,
    required this.totalRevenue,
    required this.orderCount,
    required this.itemsSold,
    required this.averageOrderValue,
  });

  final List<_SalesLine> lines;
  final List<_SalesBucket> buckets;
  final List<_ProductSalesSummary> topProducts;
  final double totalRevenue;
  final int orderCount;
  final int itemsSold;
  final double averageOrderValue;

  factory _SalesReport.fromLines(
    List<_SalesLine> lines,
    SalesPeriod period,
    _DateRange range,
  ) {
    final sortedLines = List<_SalesLine>.from(lines)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final totalRevenue = sortedLines.fold<double>(
      0,
      (total, line) => total + line.revenue,
    );
    final orderIds = sortedLines.map((line) => line.orderId).toSet();
    final itemsSold = sortedLines.fold<int>(
      0,
      (total, line) => total + line.quantity,
    );
    final productMap = <String, _ProductSalesSummary>{};
    for (final line in sortedLines) {
      final current =
          productMap[line.productId] ??
          _ProductSalesSummary(name: line.productName, quantity: 0, revenue: 0);
      productMap[line.productId] = current.copyWith(
        quantity: current.quantity + line.quantity,
        revenue: current.revenue + line.revenue,
      );
    }

    final topProducts =
        productMap.values.toList()
          ..sort((a, b) => b.revenue.compareTo(a.revenue));

    return _SalesReport(
      lines: sortedLines,
      buckets: _buildBuckets(sortedLines, period, range),
      topProducts: topProducts,
      totalRevenue: totalRevenue,
      orderCount: orderIds.length,
      itemsSold: itemsSold,
      averageOrderValue: orderIds.isEmpty ? 0 : totalRevenue / orderIds.length,
    );
  }

  static List<_SalesBucket> _buildBuckets(
    List<_SalesLine> lines,
    SalesPeriod period,
    _DateRange range,
  ) {
    if (period == SalesPeriod.daily) {
      return List.generate(6, (index) {
        final startHour = index * 4;
        final endHour = startHour + 4;
        final revenue = lines
            .where(
              (line) =>
                  line.createdAt.hour >= startHour &&
                  line.createdAt.hour < endHour,
            )
            .fold<double>(0, (total, line) => total + line.revenue);
        return _SalesBucket(label: '$startHour', revenue: revenue);
      });
    }

    if (period == SalesPeriod.weekly) {
      return List.generate(7, (index) {
        final day = range.start.add(Duration(days: index));
        final revenue = lines
            .where(
              (line) =>
                  line.createdAt.year == day.year &&
                  line.createdAt.month == day.month &&
                  line.createdAt.day == day.day,
            )
            .fold<double>(0, (total, line) => total + line.revenue);
        return _SalesBucket(label: '${day.month}/${day.day}', revenue: revenue);
      });
    }

    return List.generate(4, (index) {
      final start = range.start.add(Duration(days: index * 7));
      final end = index == 3 ? range.end : start.add(const Duration(days: 7));
      final revenue = lines
          .where(
            (line) =>
                !line.createdAt.isBefore(start) && line.createdAt.isBefore(end),
          )
          .fold<double>(0, (total, line) => total + line.revenue);
      return _SalesBucket(label: 'W${index + 1}', revenue: revenue);
    });
  }
}

class _SalesLine {
  _SalesLine({
    required this.requestId,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.revenue,
    required this.createdAt,
    required this.buyerName,
  });

  final String requestId;
  final String orderId;
  final String productId;
  final String productName;
  final int quantity;
  final double revenue;
  final DateTime createdAt;
  final String buyerName;
}

class _SalesBucket {
  _SalesBucket({required this.label, required this.revenue});

  final String label;
  final double revenue;
}

class _ProductSalesSummary {
  _ProductSalesSummary({
    required this.name,
    required this.quantity,
    required this.revenue,
  });

  final String name;
  final int quantity;
  final double revenue;

  _ProductSalesSummary copyWith({int? quantity, double? revenue}) {
    return _ProductSalesSummary(
      name: name,
      quantity: quantity ?? this.quantity,
      revenue: revenue ?? this.revenue,
    );
  }
}

class _DateRange {
  _DateRange(this.start, this.end);

  final DateTime start;
  final DateTime end;
}
