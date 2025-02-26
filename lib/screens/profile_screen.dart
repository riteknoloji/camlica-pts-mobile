import 'dart:io';

import 'package:camlica_pts/components/confirm_dialog.dart';
import 'package:camlica_pts/main.dart';
import 'package:camlica_pts/models/enums.dart';
import 'package:camlica_pts/models/user_model.dart';
import 'package:camlica_pts/providers.dart';
import 'package:camlica_pts/services/http_service.dart';
import 'package:camlica_pts/services/toast_service.dart';
import 'package:camlica_pts/services/token_storage.dart';
import 'package:camlica_pts/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:url_launcher/url_launcher.dart';

User? profile;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ProfileCard(),
              Divider(),
              Links(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  void logout() async {
    await TokenStorage.deleteToken();
    ToastService.success(message: "Çıkış yapıldı");
    Get.offAllNamed("/login");
  }

  void openWhatsapp(User? profile) async {
    if (profile == null) {
      ToastService.error(message: "Kullanıcı bilgileri yüklenemedi");
      return;
    }

    final message = [
      "Merhaba, Yardıma ihtiyacım var.",
      "Ad: ${profile.firstName} ${profile.lastName}",
      "Telefon: ${profile.phone}",
      "Platform: ${Platform.operatingSystem}",
      "Uygulama Sürümü: ${packageInfo?.version ?? "Bilinmiyor"}",
    ].join("\n");

    const number = "905434989203";

    final url =
        Uri.parse("https://wa.me/$number?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void testNotifications() async {
    try {
      await HttpService.dio.post("/notifications/test");
    } on DioException catch (e) {
      HttpService.handleError(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      data: (user) {
        final bool isAdmin = user.roles.contains(UserRole.ADMIN);

        return Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.person,
              ),
              title: Text("${user.firstName} ${user.lastName}"),
              subtitle: Text(user.phone ?? 'Telefon numarası yok'),
              trailing: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  ref.invalidate(profileProvider);
                },
              ),
            ),
            isAdmin
                ? ListTile(
                    leading: Icon(
                      Icons.admin_panel_settings,
                    ),
                    title: Text("Yönetici"),
                    subtitle: Text("Bu kullanıcı yönetici"),
                    onTap: () => Get.toNamed("/admin"),
                    trailing: IconButton(
                      onPressed: () async {
                        final confirmed = await showConfirmationDialog(context);
                        if (confirmed) {
                          logout();
                        }
                      },
                      icon: Icon(Icons.logout),
                      color: Colors.red,
                    ),
                  )
                : Container(),
            ListTile(
              leading: Icon(Icons.notifications),
              title: user.firebaseToken == null
                  ? Text(
                      "Lütfen uygulamayı yeniden başlatın",
                      style: TextStyle(color: Colors.red),
                    )
                  : Text("Bildirimleri test et  "),
              onTap: testNotifications,
            ),
            ListTile(
              leading: Icon(Icons.support_agent),
              title: Text("Destek"),
              onTap: () => openWhatsapp(user),
            ),
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

class Links extends StatefulWidget {
  const Links({super.key});

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {
  String? deviceId;

  @override
  void initState() {
    super.initState();

    getDeviceId().then(setDeviceId);
  }

  setDeviceId(String id) {
    setState(() {
      deviceId = id;
    });
  }

  void openWeb(String path) async {
    final url = Uri.parse("https://camlica-pts.riteknoloji.com$path");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text("Gizlilik Politikası"),
          trailing: Icon(Icons.open_in_browser),
          onTap: () => openWeb("/privacy"),
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text("KVKK"),
          trailing: Icon(Icons.open_in_browser),
          onTap: () => openWeb("/kvkk"),
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text("Kullanım Koşulları"),
          trailing: Icon(Icons.open_in_browser),
          onTap: () => openWeb("/tos"),
        ),
        ListTile(
          leading: Icon(Icons.app_settings_alt),
          title: Text("Uygulama Sürümü"),
          subtitle: Text(packageInfo?.version ?? "Bilinmiyor"),
          onLongPress: () async {
            // write to clipboard
            final textToCopy = packageInfo?.version ?? "Bilinmiyor";
            await Clipboard.setData(ClipboardData(text: textToCopy));
            ToastService.success(message: "Kopyalandı: $textToCopy");
          },
        ),
        ListTile(
          leading: Icon(Icons.app_settings_alt),
          title: Text("Cihaz ID"),
          subtitle: Text(deviceId ?? "Bilinmiyor"),
        ),
      ],
    );
  }
}
