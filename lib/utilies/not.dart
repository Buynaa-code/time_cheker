String formatDate(String dateString) {
  try {
    // Ирсэн огнооны форматыг "05/01 - ЛХ" гэж үзэж байна
    final dateParts = dateString.split(' - ')[0].split('/');
    if (dateParts.length == 2) {
      final formattedDate =
          '2025-${dateParts[0].padLeft(2, '0')}-${dateParts[1].padLeft(2, '0')}';
      return formattedDate; // Жишээ: "2025-05-01"
    }
  } catch (e) {
    print('Огноог хөрвүүлэхэд алдаа гарлаа: $e');
  }
  return dateString; // Хэрэв хөрвүүлж чадахгүй бол эхний утгаа буцаана
}
//bachka0425@gmail.com
//cbdilb0425