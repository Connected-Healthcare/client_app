class CloudSchema {
  static const String AccelerometerTag = "Accelerometer";
  static const String GyroscopeTag = "Gyroscope";
  static const String MagnetometerTag = "Magnetometer";

  static const String HTS221SensorTag = "HTS221";
  static const String LPS22HBSensorTag = "LPS22HB";
  static const String SpecCoSensorTag = "Spec_CO";

  static const String TimeOfFlightSensorTag = "Time_Of_Flight";
  static const String GpsTag = "GPS";

  static const String HeartbeatSensorTag = "Heartbeat";

  static const String EpochTimeTag = "EpochTime";
  static const String TimestampTag = "Timestamp";
  final Map<dynamic, dynamic> data;
  CloudSchema(this.data);

  // TODO, Parse other information as needed
  // String identifier;
  // String hts221Temperature;
  // String hts221Humidity;
  // String lps22hbTemperature;
  // String lps22hbPressure;
  // List<String> magnetometer = List<String>.filled(3, "");
  // List<String> gyroscope = List<String>.filled(3, "");
  // String timeOfFlight;
  // String coGasConcentration;
  // String coTemperature;
  // String coRelativeHumidity;
  // List<String> gps = List<String>.filled(2, "");

  List<int> heartbeat;
  List<int> accelerometer;
  int epochTime;

  // TODO, Handle error cases
  bool parse() {
    String rawHeartbeat = data[HeartbeatSensorTag];
    heartbeat =
        rawHeartbeat.trim().split(",").map((e) => int.parse(e)).toList();

    String rawEpoch = data[EpochTimeTag];
    epochTime = double.parse(rawEpoch).toInt();

    String rawAccelerometer = data[AccelerometerTag];
    accelerometer =
        rawAccelerometer.trim().split(",").map((e) => int.parse(e)).toList();

    return true;
  }
}
