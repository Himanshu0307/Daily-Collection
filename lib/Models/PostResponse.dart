class PostResponse {
  final bool success;
  final String msg;
  final String error;
  PostResponse(this.success,  {this.msg = "", this.error = ""});
}
