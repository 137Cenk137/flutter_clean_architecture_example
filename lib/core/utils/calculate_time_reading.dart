int calculateReadingTime(String content) {
  final words = content.split(' ');
  return (words.length / 200).round();
}
