


class ProfileSetupController {

  // TODO: set to default paths
  static String _profilePhotoPath = 'assets/profile_photos/default_pfp.jpeg';
  static String _profileBannerPath = 'assets/profile_photos/default_banner.png';

  ProfileSetupController();

  String get profilePhotoPath => _profilePhotoPath;
  String get profileBannerPath => _profileBannerPath;

  set profilePhotoPath(String profilePhotoPath) => _profilePhotoPath = profilePhotoPath.trim();
  set profileBannerPath(String profileBannerPath) => _profileBannerPath = profileBannerPath.trim();
}