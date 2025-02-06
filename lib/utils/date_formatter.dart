String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  
  if (difference.inSeconds < 60) {
    return 'just now';
  }
  
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  }
  
  if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  }
  
  if (difference.inDays < 30) {
    return '${difference.inDays}d ago';
  }
  
  final months = (difference.inDays / 30).floor();
  if (months < 12) {
    return '${months}mo ago';
  }
  
  final years = (difference.inDays / 365).floor();
  return '${years}y ago';
}

DateTime parseDate(String date) {
  final parts = date.split("/").reversed.toList();
  return DateTime.parse("${parts.join("-")}T16:00:00.000Z");
} 

String formatDateToLocalString(DateTime dateTime){
  String formattedDate = "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
  
  return formattedDate;
}