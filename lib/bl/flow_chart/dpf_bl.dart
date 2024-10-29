List<Map<String, dynamic>> calculateFixedDeposit(int years, double interestRate, double initialCapital) {
  List<Map<String, dynamic>> yearlyData = [];
  double capital = initialCapital;

  for (int year = 1; year <= years; year++) {
    double interest = capital * (interestRate / 100);
    capital += interest;

    yearlyData.add({
      'year': year,
      'interest': interest,
      'capital': capital,
    });
  }

  return yearlyData;
}
