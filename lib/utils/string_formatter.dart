 String truncateString(String input) {
    if (input.length > 24) {
      return "${input.substring(0, 20)}...";
    }
    return input;
  }