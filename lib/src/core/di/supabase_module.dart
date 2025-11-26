import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class SupabaseModule {
  @preResolve
  @lazySingleton
  Future<SupabaseClient> get supabaseClient async {
    await Supabase.initialize(
      url: 'https://ozdqvtymlavnzmpniaiw.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96ZHF2dHltbGF2bnptcG5pYWl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5NTc5NzUsImV4cCI6MjA3OTUzMzk3NX0.KkUEZ4czOpRsYkfxhSzKCh9ElczF7D7Dw0_uzd9pCMs',
    );

    return Supabase.instance.client;
  }
}
