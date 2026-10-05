class WeatherDayForecast {
  final String dayName;
  final String date;
  final double tempMax;
  final double tempMin;
  final int rainProbability;
  final String condition;
  final String iconName;

  WeatherDayForecast({
    required this.dayName,
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.rainProbability,
    required this.condition,
    required this.iconName,
  });
}

class WeatherModel {
  final double temperature;
  final double feelsLike;
  final double humidity;
  final int rainProbability;
  final double windSpeedKmh;
  final double rainfallMm;
  final double uvIndex;
  final String conditionText;
  final String smartAdvisory;
  final List<WeatherDayForecast> forecast7Days;

  WeatherModel({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.rainProbability,
    required this.windSpeedKmh,
    required this.rainfallMm,
    required this.uvIndex,
    required this.conditionText,
    required this.smartAdvisory,
    required this.forecast7Days,
  });

  factory WeatherModel.defaultNagpur() {
    return WeatherModel(
      temperature: 29.0,
      feelsLike: 31.0,
      humidity: 64.0,
      rainProbability: 20,
      windSpeedKmh: 14.5,
      rainfallMm: 0.0,
      uvIndex: 7.2,
      conditionText: 'Partly Cloudy',
      smartAdvisory: 'Optimal weather for orange grove foliar spray. Low rain probability today.',
      forecast7Days: [
        WeatherDayForecast(dayName: 'Today', date: '05 Oct', tempMax: 31, tempMin: 21, rainProbability: 20, condition: 'Partly Cloudy', iconName: 'cloud'),
        WeatherDayForecast(dayName: 'Tue', date: '06 Oct', tempMax: 32, tempMin: 22, rainProbability: 15, condition: 'Sunny', iconName: 'sunny'),
        WeatherDayForecast(dayName: 'Wed', date: '07 Oct', tempMax: 30, tempMin: 21, rainProbability: 35, condition: 'Scattered Clouds', iconName: 'cloud'),
        WeatherDayForecast(dayName: 'Thu', date: '08 Oct', tempMax: 28, tempMin: 20, rainProbability: 70, condition: 'Showers Likely', iconName: 'rain'),
        WeatherDayForecast(dayName: 'Fri', date: '09 Oct', tempMax: 27, tempMin: 19, rainProbability: 80, condition: 'Rain Expected', iconName: 'rain'),
        WeatherDayForecast(dayName: 'Sat', date: '10 Oct', tempMax: 29, tempMin: 20, rainProbability: 25, condition: 'Clearing', iconName: 'sunny'),
        WeatherDayForecast(dayName: 'Sun', date: '11 Oct', tempMax: 31, tempMin: 22, rainProbability: 10, condition: 'Sunny & Clear', iconName: 'sunny'),
      ],
    );
  }
}
