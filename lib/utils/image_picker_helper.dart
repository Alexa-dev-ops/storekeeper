import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<String?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    return image?.path;
  }
}
