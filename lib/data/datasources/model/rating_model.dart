
class RatingModel {
  late String? accountId;
  late String? preview;
  late double? rate;
  late DateTime? createTime;

  RatingModel(String? accountId, String? preview, double? rate, DateTime? createTime) {
    this.accountId = accountId ??= "";
    this.preview = preview ??= "";
    this.rate = rate ??= -1;
    this.createTime = createTime ??= null;
  }
  @override
  String toString() {
    return '{\"accountId\": \"$accountId\", \"preview\": \"$preview\", rate: $rate, createTime: $createTime}';
  }
}