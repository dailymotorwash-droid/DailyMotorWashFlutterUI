import 'dart:io';

import 'package:dmw/Apis/RestServiceImp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/AppVersionPolicy.dart';

class ForceUpdateGate extends StatefulWidget {
  final Widget child;

  const ForceUpdateGate({
    super.key,
    required this.child,
  });

  @override
  State<ForceUpdateGate> createState() =>
      _ForceUpdateGateState();
}

class _ForceUpdateGateState extends State<ForceUpdateGate>
    with WidgetsBindingObserver {

  AppVersionPolicy? _policy;
  bool _checking = true;
  bool _required = false;
  bool _checkFailed = false;
  bool _updating = false;
  bool _checkingPolicy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPolicy();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed &&
  //       !_updating &&
  //       !_checkingPolicy) {
  //     _checkPolicySafely();
  //   }
  // }
  Future<void> _checkPolicySafely() async {
    if (_checkingPolicy) return;

    _checkingPolicy = true;

    try {
      await _checkPolicy();
    } catch (e) {
      debugPrint('App version policy check failed: $e');
    } finally {
      _checkingPolicy = false;
    }
  }

  Future<void> _checkPolicy() async {
    if (_checking && _policy != null) return;

    if (mounted) {
      setState(() {
        _checking = true;
        _checkFailed = false;
      });
    }
    debugPrint('🔵 About to call fetchPolicy()');
    try {
      final policy = await RestServiceImp.fetchPolicy();
      final installedCode =
      await RestServiceImp.getInstalledVersionCode();
      debugPrint('INSTALLED CODE: $installedCode');
      final required =
      RestServiceImp.requiresUpdate(installedCode, policy);
      debugPrint('UPDATE REQUIRED: $required');
      if (!mounted) return;

      setState(() {
        _policy = policy;
        _required = required;
        _checking = false;
        _checkFailed = false;
      });
      debugPrint('STATE UPDATED: required=$_required, checking=$_checking');
    } catch (_) {
      debugPrint('STATE UPDATED: exception=$_');
      if (!mounted) return;

      setState(() {
        _checking = false;
        _checkFailed = true;
      });
    }
  }

  Future<void> _openStore() async {
    final policy = _policy;
    if (policy == null) return;

    final uri = Uri.tryParse(policy.updateUrl);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host != 'play.google.com' ||
        uri.path != '/store/apps/details' ||
        uri.queryParameters['id'] !=
            'com.app.dailymotorwash') {
      _showMessage('Invalid Google Play update URL.');
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        _showMessage('Unable to open Google Play.');
      }
    } catch (_) {
      _showMessage('Unable to open Google Play.');
    }
  }

  Future<void> _startUpdate() async {
    if (_updating) return;

    setState(() => _updating = true);

    try {
      if (Platform.isIOS) {
        // iOS: redirect to the Apple App Store.
        await _openStore();
        return;
      }
      // Android: use Google Play immediate update.
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      } else {
        await _openStore();
      }
    } on PlatformException {
      await _openStore();
    } catch (_) {
      await _openStore();
    } finally {
      if (mounted) {
        setState(() => _updating = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_required) {
      final policy = _policy!;

      return PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.system_update,
                      size: 76,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Update Required',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      policy.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Latest version: ${policy.latestVersion}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                        _updating ? null : _startUpdate,
                        child: Text(
                          _updating
                              ? 'Opening update...'
                              : 'Update Now',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Fail-open policy: if the server is unavailable, allow
    // existing users to continue and retry on app resume.
    // The backend must still enforce API compatibility.
    return widget.child;
  }
}