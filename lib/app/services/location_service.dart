

/*
import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';



class LocationService extends GetxService with WidgetsBindingObserver {
  bool enabled = true;
  int statusAuthorization = 0;
  bool statusGPS = false;
  int accuracyAuthorization = 10;
  RxDouble odometer = 0.0.obs;
  // RxString motionActivity = 'still'.obs;

  final auth = Get.find<AuthService>();

  StreamSubscription<Position>? _positionStream;
  StreamSubscription<ServiceStatus>? _serviceStatusStream;

  RxList<CircleMarker> currentPosition = <CircleMarker>[].obs;

  // late RxList<GeofenceMarker> geofences;
  // late RxList<GeofenceMarker> geofenceEvents;
  // late RxList<CircleMarker> geofenceEventEdges;
  // late RxList<CircleMarker> geofenceEventLocations;
  // late RxList<Polyline> geofenceEventPolylines;

  // late RxList<LatLng> polyline;
  // late RxList<CircleMarker> locations;

  // late Map<String, Placemark> placemarkGeofence;
  // late Map<String, dynamic> geofenceActionEvents;

  // RxList<bg.Geofence> listGeofencesDatabase = <bg.Geofence>[].obs;

  List<double> speedList = <double>[1.0, 3.0];

  bool isFirstNotification = true;

  Rx<Position?> position = Position(
    longitude: -46.673070,
    latitude: -23.577599,
    timestamp: DateTime.now(),
    accuracy: 5000.0,
    altitude: 0.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 5000.0,
  ).obs;

  bool isServiceEnabled = false;
  ServiceStatus serviceStatus = ServiceStatus.enabled;
  LocationPermission locationPermission = LocationPermission.denied;

  AppLifecycleState _appLifecycleState = AppLifecycleState.inactive;

  final GetStorage box = GetStorage();
  // late FlutterTts flutterTts;

  final trackingApi = TrackingApi();

  RxBool isAllRequiredPermissionsGranted = false.obs;
  RxBool isSdkEnabled = false.obs;
  RxBool isLoadingDialogLoginSdk = false.obs;

  @override
  void onInit() {
    super.onInit();

    ambiguate(WidgetsBinding.instance)?.addObserver(this);
  }

  @override
  void onReady() async {
    super.onReady();

    if (kIsWeb) {
      await isLocationServiceEnabled();
    } else {
      initStreamLocationStatus();
    }
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    _serviceStatusStream?.cancel();
    ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    debugPrint(state.name);
    trackingApi.isSdkEnabled().then((value) {
      if (isSdkEnabled.value || (value ?? false)) {
        if (box.hasData("active_telematics")) {
          final res = box.read("active_telematics") as bool;
          if (!res) {
            disableTelematicSdk();
            debugPrint("DISABLE_TELEMATICS_LIFECICLE");
          }
        }
      }
      isSdkEnabled.value = value ?? false;
      isSdkEnabled.refresh();
    });
    checkPermission();
  }

  RxDouble get speedAverage =>
      (speedList.reduce((curr, next) => curr + next) / speedList.length).obs;

  RxBool get isLocationOk => ((isServiceEnabled == true) &&
      (serviceStatus == ServiceStatus.enabled) &&
      (locationPermission == LocationPermission.always ||
          locationPermission == LocationPermission.whileInUse))
      .obs;

  RxBool get isBackgroundLocationOk =>
      (isAllRequiredPermissionsGranted.value || isLocationOk.value).obs;

  // RxList<bg.Geofence> get customGeofences {
  //   final newList = listGeofencesDatabase
  //       .where((e) => (e.extras != null &&
  //           e.extras!.containsKey("custom") &&
  //           e.extras!["custom"]))
  //       .toList()
  //     ..sort((a, b) => a.distance.value.compareTo(b.distance.value));

  //   return RxList.from(newList);
  // }

  Future<bool> onPermissionStatus() async {
    final permissionList = GetPlatform.isAndroid
        ? await Future.wait([
      permiss.Permission.notification.status,
      permiss.Permission.locationWhenInUse.status,
      permiss.Permission.locationAlways.status,
      permiss.Permission.activityRecognition.status,
      permiss.Permission.ignoreBatteryOptimizations.status,
    ])
        : await Future.wait([
      permiss.Permission.locationWhenInUse.status,
      permiss.Permission.notification.status,
      permiss.Permission.sensors.status,
      permiss.Permission.locationAlways.status,
    ]);

    return permissionList.every((e) => e.isGranted);
  }

  void initStreamLocationStatus() {
    _serviceStatusStream?.cancel();
    _serviceStatusStream = null;

    _serviceStatusStream =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
          debugPrint(status.toString());
          serviceStatus = status;
        });
  }

  void iniStreamPosition() async {
    _positionStream?.cancel();
    _positionStream = null;

    if (isBackgroundLocationOk.value) {
      _positionStream =
          Geolocator.getPositionStream().listen((Position? positionResult) {
            if (position.value != null &&
                positionResult != null &&
                positionResult.accuracy < 100 &&
                position.value!.latitude != 0.0) {
              odometer.value += distanceInMeters(
                  startLatitude: position.value!.latitude,
                  startLongitude: position.value!.longitude,
                  endLatitude: positionResult.latitude,
                  endLongitude: positionResult.longitude);
            }
            position.value = positionResult;

            LatLng ll = LatLng(
                positionResult?.latitude ?? 0.0, positionResult?.longitude ?? 0.0);
            updateCurrentPositionMarker(ll);

            final sp = (positionResult?.speed ?? 0.0) > 0
                ? ((positionResult?.speed ?? 0.0) * 3.6).toPrecision(1)
                : 0.0;

            speedList.add(sp);

            if (speedList.length > 100) {
              speedList.removeAt(0);
            }
            // speedList.refresh();
          });
    }
  }

  void cancelStreamPosition() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  Future<void> isLocationServiceEnabled() async {
    try {
      isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> openSettings() async {
    try {
      if (serviceStatus == ServiceStatus.disabled) {
        await Geolocator.openLocationSettings();
      } else {
        await Geolocator.openAppSettings();
      }
    } catch (_) {
      await Geolocator.openAppSettings();
    }
  }

  Future<void> getCurrentPosition() async {
    try {
      position.value = await Geolocator.getCurrentPosition();

      LatLng ll = LatLng(
          position.value?.latitude ?? 0.0, position.value?.longitude ?? 0.0);
      updateCurrentPositionMarker(ll);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> lastKnowPosition() async {
    try {
      position.value = await Geolocator.getLastKnownPosition();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  double distanceInMeters({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  Future<Placemark?> getPlacemarkFromCoordinates(
      {required double latitude, required double longitude}) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude,
          localeIdentifier: 'pt_BR');
      if (placemarks.isNotEmpty) {
        return placemarks.first;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // Future<Placemark?> getPlacemarkFromGeofence(bg.Geofence geo) async {
  //   try {
  //     if (placemarkGeofence.containsKey(geo.identifier)) {
  //       return placemarkGeofence[geo.identifier];
  //     }

  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         geo.latitude, geo.longitude,
  //         localeIdentifier: 'pt_BR');
  //     if (placemarks.isNotEmpty) {
  //       placemarkGeofence.addAll({geo.identifier: placemarks.first});
  //       return placemarkGeofence[geo.identifier];
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  //   return null;
  // }

  Future<void> checkPermission() async {
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    locationPermission = await Geolocator.checkPermission();
  }

  Future<void> initPermission() async {
    await Future.delayed(const Duration(milliseconds: 500));

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      //  debugPrint('Os serviços de localização estão desabilitados.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        //  debugPrint('As permissões de localização foram negadas');
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      // debugPrint(
      //     'As permissões de localização são negadas permanentemente, não podemos solicitar permissões.');
    }
  }

  Future<void> setDeviceTelematicsSdk() async {
    await auth.getTelematicsCredentials();

    if (!(auth.user.value.isTelematicAuth ?? false) &&
        (auth.user.value.telematicDeviceToken == null ||
            auth.user.value.telematicDeviceToken!.isEmpty)) {
      await _registerTelematicSdk();
    } else {
      final date = DateTime.now();
      DateTime expireToken =
          auth.user.value.expireTelematicToken ?? DateTime.now();
      expireToken = expireToken.subtract(const Duration(days: 1));

      if (expireToken.isBefore(date)) {
        await _refreshTokenTelematicSdk();
      }
    }

    isSdkEnabled.value = await trackingApi.isSdkEnabled() ?? false;

    isFirstNotification = true;

    if (!isSdkEnabled.value &&
        (auth.user.value.isTelematicAuth ?? false) &&
        (auth.user.value.telematicDeviceToken != null &&
            auth.user.value.telematicDeviceToken!.isNotEmpty)) {
      try {
        await trackingApi.setDeviceID(
            deviceId: auth.user.value.telematicDeviceToken ?? '');
        await trackingApi.setEnableSdk(enable: true);
        isSdkEnabled.value = true;
        auth.isTelematicServiceDisponible.value = true;
        auth.isTelematicServiceDisponible.refresh();

        await box.write("active_telematics", true);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> initPermissionService() async {
    await telematicIsDisponible();

    if (!auth.isTelematicServiceDisponible.value) {
      await disableTelematicSdk(disableOnFirebase: true);
      return;
    }
    // _isAllRequiredPermissionsGranted.value =
    //     await _trackingApi.isAllRequiredPermissionsAndSensorsGranted() ?? false;
    isAllRequiredPermissionsGranted.value = await onPermissionStatus();

    if (isAllRequiredPermissionsGranted.value) {
      await setDeviceTelematicsSdk();
      initGeofenceService();
      return;
    }
    // await trackingApi.showPermissionWizard(
    //   enableAggressivePermissionsWizard: false,
    //   enableAggressivePermissionsWizardPage: true,
    // );

    final permissionList = GetPlatform.isAndroid
        ? [
      permiss.Permission.notification,
      permiss.Permission.locationWhenInUse,
      permiss.Permission.locationAlways,
      permiss.Permission.activityRecognition,
      permiss.Permission.ignoreBatteryOptimizations,
    ]
        : [
      permiss.Permission.locationWhenInUse,
      permiss.Permission.notification,
      permiss.Permission.sensors,
      permiss.Permission.locationAlways,
    ];

    List<permiss.Permission> listRequestPermission = [];

    for (var p in permissionList) {
      final res = await p.status;

      if (res != permiss.PermissionStatus.granted) {
        listRequestPermission.add(p);
      }
    }

    final res = await Get.to(
            () => PermissionAssistantScreen(permissionList: listRequestPermission),
        fullscreenDialog: true);

    // final text = (res != null && res)
    //     ? 'Todas as permissões foram concedidas'
    //     : 'Há permissões que não foram concedidas';

    if (res != null && res) {
      Get.snackbar(
        'Permissões',
        'Todas as permissões foram concedidas',
        icon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            Icons.info_outlined,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey.shade900,
        shouldIconPulse: true,
        maxWidth: 450,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 50, left: 8, right: 8),
      );

      await setDeviceTelematicsSdk();
      await initGeofenceService();
    } else {
      // ignore: use_build_context_synchronously
      await deniedPermissionBottomSheet();
    }
  }

  Future<void> initGeofenceService() async {
    final auth = Get.find<AuthService>();

    // bg.TransistorAuthorizationToken token =
    //     await bg.TransistorAuthorizationToken.findOrCreate(
    //         'testenazildosouza', auth.user.value.name ?? '');

    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    bg.BackgroundGeolocation.onHttp(_onHttp);
    bg.BackgroundGeolocation.onGeofence(_onGeofence);
    bg.BackgroundGeolocation.onGeofencesChange(_onGeofenceChange);
    bg.BackgroundGeolocation.onSchedule(_onSchedule);
    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);

    bg.BackgroundGeolocation.ready(
      bg.Config(
        reset: true,
        // transistorAuthorizationToken: token,
        locationAuthorizationRequest: 'Always',
        backgroundPermissionRationale: bg.PermissionRationale(
          title:
          "Permitir que {applicationName} acesse a localização deste dispositivo em segundo plano?",
          message:
          "Para rastrear sua atividade em segundo plano, ative a permissão de localização {backgroundPermissionOptionLabel}",
          positiveAction: "Mude para {backgroundPermissionOptionLabel}",
          negativeAction: "Cancelar",
        ),
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        //  distanceFilter: 20.0,
        //  desiredOdometerAccuracy: 80,
        geofenceProximityRadius: 10000,
        geofenceModeHighAccuracy: true,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        debug: false,
        logLevel: bg.Config.LOG_LEVEL_OFF,
        autoSyncThreshold: 20,
        batchSync: true,
        maxBatchSize: 30,
        method: 'POST',
        url: baseUrlString("/routes/execute/"),
        headers: {'Authorization': 'Bearer ${auth.apiToken}'},
        notification: bg.Notification(
          title: 'Neo Seguradora',
          text: 'Serviço de Área de Risco Ativado',
          smallIcon: '@drawable/ic_tracking_sdk_status_bar',
          largeIcon: '@drawable/ic_tracking_sdk_notification',
        ),
      ),
    ).then((bg.State state) async {
      enabled = state.enabled;

      getCurrentPosition();
      await getGeofenceLocates();

      debugPrint('[ready] ${state.toMap()}');
      debugPrint('[didDeviceReboot] ${state.didDeviceReboot}');

      if (state.schedule != null && state.schedule!.isNotEmpty) {
        bg.BackgroundGeolocation.startSchedule();
      }
      if (!state.enabled) {
        bg.BackgroundGeolocation.startGeofences().then(
              (bg.State state) async {
            enabled = state.enabled;
          },
        );
      }

      // bg.BackgroundGeolocation.geofences.then((geofences) {
      //   for (var geo in geofences) {
      //     if (box.hasData('geofence_${geo.identifier}')) {
      //       final mapString = box.read('geofence_${geo.identifier}') as String;
      //       Map<String, dynamic> map =
      //           Map<String, dynamic>.from(json.decode(mapString));

      //       if (geofenceActionEvents
      //           .containsKey('geofence_${geo.identifier}')) {
      //         geofenceActionEvents['geofence_${geo.identifier}'] = map;
      //       } else {
      //         geofenceActionEvents.addAll({'geofence_${geo.identifier}': map});
      //       }
      //     }
      //   }
      // });
    });
  }

  // Configure BackgroundFetch (not required by BackgroundGeolocation).
  Future<void> initBackgroundFetch() async {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            startOnBoot: true,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresStorageNotLow: false,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      debugPrint("[BackgroundFetch] received event $taskId");

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // int count = 0;
      // if (prefs.get("fetch-count") != null) {
      //   count = prefs.getInt("fetch-count");
      // }
      // prefs.setInt("fetch-count", ++count);
      // print('[BackgroundFetch] count: $count');

      if (taskId == 'flutter_background_fetch') {
        try {
          // Fetch current position
          var location = await bg.BackgroundGeolocation.getCurrentPosition(
              samples: 1,
              extras: {"event": "background-fetch", "headless": false});
          debugPrint("[location] $location");
        } catch (error) {
          debugPrint("[location] ERROR: $error");
        }

        // Test scheduling a custom-task in fetch event.
        BackgroundFetch.scheduleTask(TaskConfig(
            taskId: "com.transistorsoft.customtask",
            delay: 5000,
            periodic: false,
            forceAlarmManager: true,
            stopOnTerminate: false,
            enableHeadless: true));
      }
      BackgroundFetch.finish(taskId);
    });
  }

  void _onGeofence(bg.GeofenceEvent event) async {
    debugPrint('[${bg.Event.GEOFENCE}] - $event');
    bg.Logger.info('[onGeofence] Flutter received onGeofence event $event');

    // if (event.extras != null &&
    //     event.extras!.containsKey("custom") &&
    //     event.extras!["custom"]) {
    //   if (box.hasData('geofence_${event.identifier}')) {
    //     final mapString = box.read('geofence_${event.identifier}') as String;
    //     Map<String, dynamic> map =
    //         Map<String, dynamic>.from(json.decode(mapString));

    //     if (geofenceActionEvents.containsKey('geofence_${event.identifier}')) {
    //       geofenceActionEvents['geofence_${event.identifier}'] = map;
    //     } else {
    //       geofenceActionEvents.addAll({'geofence_${event.identifier}': map});
    //     }
    //   } else {
    //     Map<String, dynamic> mapTemp = {
    //       "ENTER": null,
    //       "EXIT": null,
    //     };

    //     geofenceActionEvents.addAll({'geofence_${event.identifier}': mapTemp});
    //   }

    //   if (event.action.toUpperCase() == "ENTER" &&
    //       geofenceActionEvents['geofence_${event.identifier}']["ENTER"] ==
    //           null) {
    //     geofenceActionEvents['geofence_${event.identifier}']["ENTER"] =
    //         DateTime.now().toString();
    //     await _showNotificationGeofence(event);
    //     await box.write('geofence_${event.identifier}',
    //         json.encode(geofenceActionEvents['geofence_${event.identifier}']));
    //   } else if (event.action.toUpperCase() == "ENTER" &&
    //       geofenceActionEvents['geofence_${event.identifier}']["ENTER"] !=
    //           null &&
    //       geofenceActionEvents['geofence_${event.identifier}']["EXIT"] !=
    //           null) {
    //     geofenceActionEvents['geofence_${event.identifier}']["ENTER"] =
    //         DateTime.now().toString();
    //     geofenceActionEvents['geofence_${event.identifier}']["EXIT"] = null;

    //     await _showNotificationGeofence(event);
    //     await box.write('geofence_${event.identifier}',
    //         json.encode(geofenceActionEvents['geofence_${event.identifier}']));
    //   } else if (event.action.toUpperCase() == "EXIT") {
    //     geofenceActionEvents['geofence_${event.identifier}']["EXIT"] =
    //         DateTime.now().toString();

    //     await _showNotificationGeofence(event);
    //     await box.write('geofence_${event.identifier}',
    //         json.encode(geofenceActionEvents['geofence_${event.identifier}']));
    //   }

    //   GeofenceMarker? marker = geofences.firstWhereOrNull(
    //       (GeofenceMarker marker) =>
    //           marker.geofence.identifier == event.identifier);

    //   if (marker == null) {
    //     bool exists =
    //         await bg.BackgroundGeolocation.geofenceExists(event.identifier);
    //     if (exists) {
    //       // Maybe this is a boot from a geofence event and geofencechange hasn't yet fired
    //       bg.Geofence? geofence =
    //           await bg.BackgroundGeolocation.getGeofence(event.identifier);
    //       marker = GeofenceMarker(geofence: geofence!);
    //       if (!geofences
    //           .map((e) => e.geofence.identifier)
    //           .contains(marker.geofence.identifier)) {
    //         geofences.add(marker);
    //         geofences.refresh();
    //       }
    //     } else {
    //       debugPrint(
    //           "[_onGeofence] failed to find geofence marker: ${event.identifier}");
    //       return;
    //     }
    //   }

    //   bg.Geofence geofence = marker.geofence;

    //   // Render a new greyed-out geofence CircleMarker to show it's been fired but only if it hasn't been drawn yet.
    //   // since we can have multiple hits on the same geofence.  No point re-drawing the same hit circle twice.
    //   GeofenceMarker? eventMarker = geofenceEvents.firstWhereOrNull(
    //       (GeofenceMarker marker) =>
    //           marker.geofence.identifier == event.identifier);

    //   if (eventMarker == null) {
    //     final geoMark = GeofenceMarker(geofence: geofence, triggered: true);
    //     if (!geofenceEvents
    //         .map((e) => e.geofence.identifier)
    //         .contains(geoMark.geofence.identifier)) {
    //       geofenceEvents.add(geoMark);
    //     }
    //   }

    //   // Build geofence hit statistic markers:
    //   // 1.  A computed CircleMarker upon the edge of the geofence circle (red=exit, green=enter)
    //   // 2.  A CircleMarker for the actual location of the geofence event.
    //   // 3.  A black PolyLine joining the two above.
    //   bg.Location location = event.location;
    //   LatLng center = LatLng(geofence.latitude, geofence.longitude);
    //   LatLng hit = LatLng(location.coords.latitude, location.coords.longitude);

    //   // Determine bearing from center -> event location
    //   double bearing = Geospatial.getBearing(center, hit);
    //   // Compute a coordinate at the intersection of the line joining center point -> event location and the circle.
    //   LatLng edge =
    //       Geospatial.computeOffsetCoordinate(center, geofence.radius, bearing);
    //   // Green for ENTER, Red for EXIT.
    //   Color color = Colors.green;
    //   if (event.action == "EXIT") {
    //     color = Colors.red;
    //   } else if (event.action == "DWELL") {
    //     color = Colors.yellow;
    //   }

    //   // Edge CircleMarker (background: black, stroke doesn't work so stack 2 circles)
    //   geofenceEventEdges
    //       .add(CircleMarker(point: edge, color: Colors.black, radius: 5));
    //   // Edge CircleMarker (foreground)
    //   geofenceEventEdges
    //       .add(CircleMarker(point: edge, color: color, radius: 4));

    //   // Event location CircleMarker (background: black, stroke doesn't work so stack 2 circles)
    //   geofenceEventLocations
    //       .add(CircleMarker(point: hit, color: Colors.black, radius: 6));
    //   // Event location CircleMarker
    //   geofenceEventLocations
    //       .add(CircleMarker(point: hit, color: Colors.blue, radius: 4));
    //   // Polyline joining the two above.
    //   geofenceEventPolylines.add(
    //       Polyline(points: [edge, hit], strokeWidth: 1.0, color: Colors.black));
    // } else
    if (event.extras != null &&
        event.extras!.containsKey("safeArea") &&
        event.extras!["safeArea"]) {
      bg.Location location = event.location;
      LatLng hit = LatLng(location.coords.latitude, location.coords.longitude);

      bool isNotify = true;

      final list = (await bg.BackgroundGeolocation.geofences)
          .where((e) => e.identifier != event.identifier);

      for (var geo in list) {
        final distance = Geolocator.distanceBetween(
            hit.latitude, hit.longitude, geo.latitude, geo.longitude);

        if (distance <= geo.radius) {
          isNotify = false;
          break;
        }
      }

      if (isNotify) {
        if (isFirstNotification) {
          isFirstNotification = false;
          return;
        }

        final flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

        const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'channel_id',
          'Channel Name',
          channelDescription: 'Channel Description',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/ic_tracking_sdk_status_bar',
          largeIcon: DrawableResourceAndroidBitmap(
              '@drawable/ic_tracking_sdk_notification'),
        );
        const iOSNotificationDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
        const NotificationDetails notificationDetails = NotificationDetails(
            android: androidNotificationDetails, iOS: iOSNotificationDetails);

        String msg = '';

        final action = event.action.toUpperCase() == 'EXIT'
            ? 'entrou em'
            : event.action.toUpperCase() == 'ENTER'
            ? 'saiu de'
            : 'permanece em';

        msg = 'Você $action uma região de risco';

        flutterLocalNotificationsPlugin.show(
          2,
          "Região de Risco",
          msg,
          notificationDetails,
        );

        // if (_appLifecycleState == AppLifecycleState.resumed) {
        //   final flutterTts = FlutterTts();
        //   flutterTts.setLanguage("pt-BR").then((_) => flutterTts.speak(msg));
        // }
      }
    }
  }

  void _onGeofenceChange(bg.GeofencesChangeEvent event) async {
    debugPrint('[${bg.Event.GEOFENCE}] - $event');

    // for (var identifier in event.off) {
    //   geofences.removeWhere(
    //       (GeofenceMarker marker) => marker.geofence.identifier == identifier);
    // }

    // for (var geofence in event.on) {
    //   if (geofence.extras != null &&
    //       geofence.extras!.containsKey("custom") &&
    //       geofence.extras!["custom"]) {
    //     if (!geofences
    //         .map((e) => e.geofence.identifier)
    //         .contains(geofence.identifier)) {
    //       geofences.add(GeofenceMarker(geofence: geofence));
    //     }
    //   }
    // }

    // if (event.off.isEmpty && event.on.isEmpty) {
    //   geofences.clear();
    // }
    // geofences.refresh();

    // listGeofencesDatabase.value = await bg.BackgroundGeolocation.geofences;
    // listGeofencesDatabase.refresh();
  }

  void _onSchedule(bg.State state) {
    debugPrint('[${bg.Event.SCHEDULE}] - $state');
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    debugPrint('[activitychange] - $event');

    // motionActivity.value = event.activity;
  }

  void _onProviderChange(bg.ProviderChangeEvent event) async {
    debugPrint('$event');

    enabled = event.enabled;
    statusAuthorization = event.status;
    statusGPS = event.gps;
    accuracyAuthorization = event.accuracyAuthorization;

    if (statusAuthorization == 3 &&
        accuracyAuthorization ==
            bg.ProviderChangeEvent.ACCURACY_AUTHORIZATION_REDUCED) {
      if (_appLifecycleState == AppLifecycleState.paused) {
        await PushNotification().showNotification(
            title: 'Ative sua Localização Precisa',
            msg:
            'É necessário para a Neo Seguradora manter seu veículo assegurado');
      }
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.snackbar(
        'Ative sua Localização Precisa',
        'É necessário para a Neo Seguradora manter seu veículo assegurado',
        backgroundColor: Colors.grey.shade900,
        maxWidth: 450,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
        ),
        duration: const Duration(days: 1),
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 30, left: 8, right: 8),
        mainButton: TextButton(
            onPressed: () {
              Get.closeCurrentSnackbar();
              openSettings();
            },
            child: const Text('OK')),
        // onTap: (_) {
        //   Get.closeCurrentSnackbar();
        //   openSettings();
        // },
      );
    }

    if (statusAuthorization != 3) {
      if (_appLifecycleState == AppLifecycleState.paused) {
        await PushNotification().showNotification(
            title: 'Mantenha sua Localização sempre Ativa',
            msg:
            'É necessário para a Neo Seguradora manter seu veículo assegurado');
      }
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.snackbar(
        'Mantenha sua Localização sempre Ativa',
        'É necessário para a Neo Seguradora manter seu veículo assegurado',
        backgroundColor: Colors.grey.shade900,
        maxWidth: 450,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
        ),
        duration: const Duration(days: 1),
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 30, left: 8, right: 8),
        mainButton: TextButton(
            onPressed: () {
              Get.closeCurrentSnackbar();
              openSettings();
            },
            child: const Text('OK')),
        // onTap: (_) {
        //   Get.closeCurrentSnackbar();
        //   openSettings();
        // },
      );
    }

    if (!statusGPS) {
      if (_appLifecycleState == AppLifecycleState.paused) {
        await PushNotification().showNotification(
            title: 'Ative seu GPS',
            msg:
            'É necessário para a Neo Seguradora manter seu veículo assegurado');
      }
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.snackbar(
        'Ative seu GPS',
        'É necessário para a Neo Seguradora manter seu veículo assegurado',
        backgroundColor: Colors.grey.shade900,
        maxWidth: 450,
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
        ),
        duration: const Duration(days: 1),
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 30, left: 8, right: 8),
        mainButton: TextButton(
            onPressed: () {
              Get.closeCurrentSnackbar();
              openSettings();
            },
            child: const Text('OK')),
        // onTap: (_) {
        //   Get.closeCurrentSnackbar();
        //   openSettings();
        // },
      );
    }

    if (event.status == 3 &&
        event.gps &&
        event.enabled &&
        event.accuracyAuthorization ==
            bg.ProviderChangeEvent.ACCURACY_AUTHORIZATION_FULL) {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      await PushNotification().cancelNotification(0);
    }
  }

  void _onHttp(bg.HttpEvent response) {
    debugPrint(
        '[http] success? ${response.success}, status? ${response.status}');
  }

  /// Update Big Blue current position dot.
  void updateCurrentPositionMarker(LatLng ll) {
    currentPosition.clear();

    // White background
    currentPosition
        .add(CircleMarker(point: ll, color: Colors.white, radius: 10));
    // Blue foreground
    currentPosition.add(CircleMarker(point: ll, color: Colors.blue, radius: 7));

    currentPosition.refresh();
  }

  double distanceBetween(double endLat, double endLong) {
    if (position.value == null) return 0.0;
    return Geolocator.distanceBetween(
        position.value!.latitude, position.value!.longitude, endLat, endLong);
  }

  String distanceString(double distance) {
    if (distance <= 0) return '--';
    if (distance >= 1000.0) {
      return '${(distance / 1000.0).formattedKM()} Km';
    } else if (distance >= 100.0) {
      return '${distance.formattedMT()} m';
    } else {
      return '${distance.formattedmt()} m';
    }
  }

  Future<void> _registerTelematicSdk() async {
    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);

    const url = 'https://user.telematicssdk.com/v1/Registration/create';

    await disableTelematicSdk();

    final deviceID = await auth.uniqueDeviceId();

    try {
      final user = await FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(auth.apiToken)
          .get();

      final userDevices = await FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(auth.apiToken)
          .collection(FirebaseKeys.devices)
          .get();

      final device = userDevices.docs.firstWhereOrNull((e) =>
      ((e.data()['telematicSdkAtivated'] != null &&
          e.data()['telematicSdkAtivated'] == true) &&
          e.id == deviceID));

      if (user.exists &&
          user.data()?['telematicDeviceToken'] != null &&
          user.data()!['telematicDeviceToken'].toString().isNotEmpty) {
        final isNotAtivated = userDevices.docs.every((e) =>
        (e.data()['telematicSdkAtivated'] == null ||
            e.data()['telematicSdkAtivated'] == false));

        if (isNotAtivated || (device != null && device.exists)) {
          auth.user.value = auth.user.value.copyWith(
              telematicDeviceToken:
              user.data()!['telematicDeviceToken'].toString());
          await _loginTelematicSdk();
        } else {
          await Get.dialog(
            WillPopScope(
              onWillPop: () async => false,
              child: CustomDialog(
                title: 'Atenção',
                bodyText:
                'O serviço de pontuação já foi iniciado em outro dispositivo ou em uma instalação anterior do App Neo, ao prosseguir voçê irá habilitar o serviço de pontuação nesse dispositivo e desabilitará nos demais se houver.',
                buttons: [
                  Obx(
                        () => WillPopScope(
                      onWillPop: () async => false,
                      child: CustomElevatedButton(
                        onPressed: isLoadingDialogLoginSdk.value
                            ? null
                            : () async {
                          try {
                            isLoadingDialogLoginSdk.value = true;

                            String? tokenLocal;

                            try {
                              tokenLocal = await FirebaseMessaging
                                  .instance
                                  .getToken();
                            } catch (e) {
                              debugPrint(e.toString());
                            }

                            for (var doc in userDevices.docs) {
                              await FirebaseFirestore.instance
                                  .collection(FirebaseKeys.users)
                                  .doc(auth.apiToken)
                                  .collection(FirebaseKeys.devices)
                                  .doc(doc.id)
                                  .set({
                                "telematicSdkAtivated": false,
                              }, SetOptions(merge: true));

                              final tokenFB =
                              doc.data()["firebaseMessagingToken"];

                              if (tokenFB != null &&
                                  tokenFB.toString() !=
                                      tokenLocal.toString()) {
                                await PushNotification
                                    .sendNotificationToDisableTelemetry(
                                    doc.data()[
                                    "firebaseMessagingToken"]);
                              }
                            }

                            auth.user.value = auth.user.value.copyWith(
                                telematicDeviceToken: user
                                    .data()!['telematicDeviceToken']
                                    .toString());
                            await _loginTelematicSdk();

                            isLoadingDialogLoginSdk.value = false;

                            Get.back();
                          } catch (e) {
                            isLoadingDialogLoginSdk.value = false;
                            debugPrint(e.toString());
                          }
                        },
                        child: isLoadingDialogLoginSdk.value
                            ? const CircularProgressIndicator.adaptive()
                            : const Text("Prosseguir",
                            style: OneStyles.buttonStyle),
                      ),
                    ),
                  ),
                  OneSepators.medium,
                  Obx(
                        () => SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: OneColors.pink),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          foregroundColor: OneColors.pink,
                        ),
                        onPressed: isLoadingDialogLoginSdk.value
                            ? null
                            : () => Get.back(),
                        child: const Text(
                          'Agora Não',
                          style: TextStyle(
                              color: OneColors.pink,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
      return;
    }

    final payload = {
      "UserFields": {"ClientId": auth.apiToken},
      "FirstName": auth.user.value.name,
      "LastName": "",
      "Nickname": auth.user.value.name,
      "Phone": auth.user.value.phone,
      "Email": auth.user.value.email,
    };
    try {
      final response = await http
          .post(Uri.parse(url),
          headers: {
            "InstanceId": auth.telematicsInstanceId,
            "InstanceKey": auth.telematicsInstanceKey,
            "accept": "application/json",
            "content-type": "application/json",
          },
          body: json.encode(payload))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final date = DateTime.now();
        final expireToken = date.add(Duration(
            seconds: jsonResponse["Result"]?["AccessToken"]?["ExpiresIn"]));

        await auth.createFirestoreDevice(
            isTelematicsAtivated: true,
            telematicDeviceToken: jsonResponse["Result"]?["DeviceToken"]);

        await FirebaseFirestore.instance
            .collection(FirebaseKeys.users)
            .doc(auth.apiToken)
            .set({
          "telematicDeviceToken": jsonResponse["Result"]?["DeviceToken"],
        }, SetOptions(merge: true));

        auth.user.value = auth.user.value.copyWith(
          telematicDeviceToken: jsonResponse["Result"]?["DeviceToken"],
          telematicJwtToken: jsonResponse["Result"]?["AccessToken"]?["Token"],
          telematicJwtRefreshToken: jsonResponse["Result"]?["RefreshToken"],
          isTelematicAuth: true,
          expireTelematicToken: expireToken,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _loginTelematicSdk() async {
    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);

    const url = 'https://user.telematicssdk.com/v1/Auth/Login';

    final payload = {
      "LoginFields": {"Devicetoken": auth.user.value.telematicDeviceToken},
      "Password": auth.telematicsInstanceKey,
    };
    try {
      final response = await http
          .post(Uri.parse(url),
          headers: {
            "InstanceId": auth.telematicsInstanceId,
            "accept": "application/json",
            "content-type": "application/json",
          },
          body: json.encode(payload))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final date = DateTime.now();
        final expireToken = date.add(Duration(
            seconds: jsonResponse["Result"]?["AccessToken"]?["ExpiresIn"]));

        await auth.createFirestoreDevice(
            isTelematicsAtivated: true,
            telematicDeviceToken: jsonResponse["Result"]?["DeviceToken"]);

        auth.user.value = auth.user.value.copyWith(
          telematicDeviceToken: jsonResponse["Result"]?["DeviceToken"],
          telematicJwtToken: jsonResponse["Result"]?["AccessToken"]?["Token"],
          telematicJwtRefreshToken: jsonResponse["Result"]?["RefreshToken"],
          isTelematicAuth: true,
          expireTelematicToken: expireToken,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _refreshTokenTelematicSdk() async {
    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);

    const url = 'https://user.telematicssdk.com/v1/Auth/RefreshToken';

    final payload = {
      "AccessToken": auth.user.value.telematicJwtToken,
      "RefreshToken": auth.user.value.telematicJwtRefreshToken,
    };
    try {
      final response = await http
          .post(Uri.parse(url),
          headers: {
            "InstanceId": auth.telematicsInstanceId,
            "InstanceKey": auth.telematicsInstanceKey,
            "accept": "application/json",
            "content-type": "application/json",
          },
          body: json.encode(payload))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
        final date = DateTime.now();
        final expireToken = date.add(Duration(
            seconds: jsonResponse["Result"]?["AccessToken"]?["ExpiresIn"]));

        auth.user.value = auth.user.value.copyWith(
          telematicDeviceToken: jsonResponse["Result"]?["DeviceToken"],
          telematicJwtToken: jsonResponse["Result"]?["AccessToken"]?["Token"],
          telematicJwtRefreshToken: jsonResponse["Result"]?["RefreshToken"],
          expireTelematicToken: expireToken,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> disableTelematicSdk({bool disableOnFirebase = false}) async {
    try {
      auth.user.value = auth.user.value.copyWith(
          isTelematicAuth: false,
          telematicDeviceToken: '',
          telematicJwtToken: '',
          telematicJwtRefreshToken: '',
          expireTelematicToken: DateTime.now());

      if (await trackingApi.isSdkEnabled() ?? false) {
        await trackingApi.setEnableSdk(enable: false);
        await trackingApi.clearDeviceID();
      }

      await box.write("active_telematics", false);

      if (disableOnFirebase) {
        await auth.createFirestoreDevice(isTelematicsAtivated: false);
      }

      isSdkEnabled.value = false;
      isSdkEnabled.refresh();
    } catch (e) {
      debugPrint("Erro disable telematic sdk");
    }
  }

  Future<bool> telematicIsDisponible() async {
    if (auth.apiToken ==
        '69d59c380f0bce482493dd71f4c9bfc2bce128b4536f41737ef4e293f1367405') {
      auth.isTelematicServiceDisponible.value = true;
      auth.isTelematicServiceDisponible.refresh();
      return true;
    }
    final url = baseUrlString(
        "/telemetry/check", Get.find<AuthService>().getCredentials());

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": 'Bearer ${Get.find<AuthService>().apiToken}'
      }).timeout(const Duration(seconds: 20));

      var jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      if (jsonResponse.containsKey('response') &&
          jsonResponse['response'] is bool) {
        Get.log(jsonResponse['message'].toString());
        bool isActivated = jsonResponse['response'];
        auth.isTelematicServiceDisponible.value = isActivated;
        auth.isTelematicServiceDisponible.refresh();
        return isActivated;
      }

      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> getGeofenceLocates() async {
    final url = baseUrlString(
        "/telemetry/locates", Get.find<AuthService>().getCredentials());

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": 'Bearer ${Get.find<AuthService>().apiToken}'
      }).timeout(const Duration(seconds: 20));

      var jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      if (jsonResponse.containsKey('response') && jsonResponse['response']) {
        if (jsonResponse['message'] is List &&
            (jsonResponse['message'] as List).isNotEmpty) {
          await bg.BackgroundGeolocation.removeGeofences();
          List<bg.Geofence> list = (jsonResponse['message'] as List)
              .map(
                (e) => bg.Geofence(
              identifier: "safeArea_${e['id'].toString()}",
              radius: ((e['km'] as num) * 1000).toDouble(),
              latitude: (e['lat'] as num).toDouble(),
              longitude: (e['long'] as num).toDouble(),
              notifyOnEntry: true,
              notifyOnExit: true,
              notifyOnDwell: false,
              extras: {
                "safeArea": true,
              },
            ),
          )
              .toList();
          await bg.BackgroundGeolocation.addGeofences(list);
          debugPrint("ADD ${list.length} GEOFENCE SAFE AREA");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deniedPermissionBottomSheet() async {
    await showModalBottomSheet(
        context: Get.context!,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        builder: (context) {
          return Container(
            color: OneColors.whiteBg,
            height: MediaQuery.of(context).size.height * .9,
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Icon(
                    Icons.info_outline,
                    color: OneColors.accentMidle,
                    size: Get.height * 0.15,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Atenção',
                        textAlign: TextAlign.center,
                        style: OneStyles.titleStyle.copyWith(
                          color: OneColors.primaryDark,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Ao não conceder essas permissões, você deixa de pontuar suas viagens, perdendo descontos e benefícios que poderia receber. Mas fique tranquilo, você pode obte-los em outro momento indo em:',
                            textAlign: TextAlign.center,
                            style: OneStyles.subtitleStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '\n-> Perfil\n-> Permissões\n-> Serviço de Pontuação',
                            textAlign: TextAlign.start,
                            style: OneStyles.subtitleStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: responsiveMargin(Get.size),
                    child: CustomElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'Ok',
                        style: OneStyles.buttonStyle,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

extension DistanceOnGeofence on bg.Geofence {
  RxDouble get distance {
    return Get.find<LocationService>().distanceBetween(latitude, longitude).obs;
  }
}

extension CopyPosition on Position {
  Position copyWith({
    double? longitude,
    double? latitude,
    DateTime? timestamp,
    double? accuracy,
    double? altitude,
    double? heading,
    double? speed,
    double? speedAccuracy,
    int? floor,
    bool? isMocked,
  }) {
    return Position(
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      speedAccuracy: speedAccuracy ?? this.speedAccuracy,
      floor: floor ?? this.floor,
      isMocked: isMocked ?? this.isMocked,
    );
  }
}


 */