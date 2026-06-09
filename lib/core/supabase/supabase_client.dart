import 'package:supabase_flutter/supabase_flutter.dart';

/// Point d'accès global au client Supabase.
/// Import ce fichier partout où tu as besoin du client,
/// plutôt que de le redéfinir dans main.dart.
final supabase = Supabase.instance.client;