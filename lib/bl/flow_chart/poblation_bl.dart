List<Map<String, dynamic>> calculatePopulationProjection(
    int projectionYear,
    int startYear,
    int population,
    double birthRate,
    double deathRate) {
  
  List<Map<String, dynamic>> yearlyData = [];

  for (int year = startYear; year <= projectionYear; year++) {
    int currentBirths = (population * birthRate / 100).round();
    int currentDeaths = (population * deathRate / 100).round();
    population = population + currentBirths - currentDeaths;

    yearlyData.add({
      'year': year,
      'births': currentBirths,
      'deaths': currentDeaths,
      'population': population,
    });
  }

  return yearlyData;
}
