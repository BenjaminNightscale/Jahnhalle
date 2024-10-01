extension GetImageExtension on String {
  getExtension() {
    return split(".").last;
  }
}
