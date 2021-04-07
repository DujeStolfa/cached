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
