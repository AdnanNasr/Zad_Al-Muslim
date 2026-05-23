import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';

class CustomLicensePage extends StatefulWidget {
  const CustomLicensePage({super.key});

  @override
  State<CustomLicensePage> createState() => _CustomLicensePageState();
}

class _CustomLicensePageState extends State<CustomLicensePage> {
  late final Future<Map<String, List<LicenseEntry>>> _licensesFuture;

  @override
  void initState() {
    super.initState();
    _licensesFuture = _getLicenses();
  }

  Future<Map<String, List<LicenseEntry>>> _getLicenses() async {
    final Map<String, List<LicenseEntry>> packages = {};
    final licenses = await LicenseRegistry.licenses.toList();
    for (final license in licenses) {
      for (final package in license.packages) {
        packages.putIfAbsent(package, () => []).add(license);
      }
    }
    return packages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "التراخيص",
        center: false,
        themeMode: false,
      ),
      body: FutureBuilder<Map<String, List<LicenseEntry>>>(
        future: _licensesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('خطأ في تحميل التراخيص'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لم يتم العثور على تراخيص'));
          }

          final packages = snapshot.data!;
          final packageNames = packages.keys.toList()..sort();

          return Scrollbar(
            trackVisibility: true,
            thumbVisibility: true,
            interactive: true,
            child: ListView.builder(
              itemCount: packageNames.length,
              itemBuilder: (context, index) {
                final packageName = packageNames[index];
                final packageLicenses = packages[packageName]!;

                return ListTile(
                  title: Text(packageName, style: TextStyle(fontSize: 16.sp)),
                  subtitle: Text(
                    '${packageLicenses.length} ${packageLicenses.length == 1 ? "ترخيص" : "تراخيص"}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PackageLicenseDetailPage(
                          packageName: packageName,
                          licenses: packageLicenses,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PackageLicenseDetailPage extends StatelessWidget {
  final String packageName;
  final List<LicenseEntry> licenses;

  const PackageLicenseDetailPage({
    super.key,
    required this.packageName,
    required this.licenses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: packageName, center: false, themeMode: false),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: licenses.length,
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: const Divider(),
        ),
        itemBuilder: (context, index) {
          final license = licenses[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: license.paragraphs.map((p) {
              if (p.indent == LicenseParagraph.centeredIndent) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Center(
                    child: Text(
                      p.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.only(top: 8.h, left: p.indent * 10.0),
                child: Text(
                  p.text,
                  style: const TextStyle(height: 1.5),
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.ltr,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
