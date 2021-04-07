/// Klasa PredictionApiResponse
///
/// Rezultat ML API-ja za predviđanje transakcija
/// se u aplikaciji sprema kao instanca ove klase.

class PredictionApiResponse {
  dynamic confidence;
  List<dynamic> prediction;
  int predictionShift;

  PredictionApiResponse(
    this.prediction,
    this.confidence,
    this.predictionShift,
  );
}
