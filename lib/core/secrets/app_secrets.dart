class AppSecrets {
  // Never store secret in source code !!!
  // In production, this can either be injected via build pipeline environment varaibles,
  // or retrieved through cloud Key-Vault service and stored in encrypted secure storage on device.
  // e.g KeyChain on iOS
  static const String supabaseUrl = '***';
  static const String supabaseAnnoKey = '***';
}
