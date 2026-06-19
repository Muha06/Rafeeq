import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rafeeq/features/adhkar_02/data/datasources/dhikr_remote_datasource.dart';
import 'package:rafeeq/features/adhkar_02/data/repositories/dhikr_repo_impl.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_category.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_entity.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_subcategory.dart';
import 'package:rafeeq/features/adhkar_02/domain/usecases/fetch_all_adhkar.dart';
import 'package:rafeeq/features/adhkar_02/domain/usecases/fetch_all_categories.dart';
import 'package:rafeeq/features/adhkar_02/domain/usecases/fetch_all_subcategories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late SupabaseClient supabase;
  late FetchAllCategories fetchAllCategories;
  late FetchAllSubcategoriesUsecase fetchAllSubcategories;
  late FetchAllAdhkarUsecase fetchAllAdhkar;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Load Supabase credentials from the same .env file used by the app.
    await dotenv.load(fileName: '.env');

    // Initialize the real Supabase client for integration testing.
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    // Wire the data source, repository, and use cases exactly like app code.
    supabase = Supabase.instance.client;
    final remoteDataSource = AdhkarRemoteDatasourceImpl(client: supabase);
    final repo = DhikrRepoImpl(remoteDataSource: remoteDataSource);

    fetchAllCategories = FetchAllCategories(repository: repo);
    fetchAllSubcategories = FetchAllSubcategoriesUsecase(repo: repo);
    fetchAllAdhkar = FetchAllAdhkarUsecase(repo: repo);
  });

  group('Adhkar fetching usecases', () {
    test('should fetch all categories', () async {
      // ACT: fetch categories from Supabase through the use case.
      final result = await fetchAllCategories();

      // ASSERT: the use case returns typed domain entities with real data.
      expect(result, isA<List<DhikrCategory>>());
      expect(result, isNotEmpty);
      expect(result.first.id, isNotEmpty);
      expect(result.first.title, isNotEmpty);
      expect(result.first.slug, isNotEmpty);
    });

    test('should fetch all subcategories', () async {
      // ACT: fetch subcategories from Supabase through the use case.
      final result = await fetchAllSubcategories();

      // ASSERT: the use case returns typed domain entities with real data.
      expect(result, isA<List<DhikrSubcategory>>());
      expect(result, isNotEmpty);
      expect(result.first.id, isNotEmpty);
      expect(result.first.title, isNotEmpty);
      expect(result.first.slug, isNotEmpty);
      expect(result.first.categoryId, isNotEmpty);
    });

    test('should fetch all adhkar', () async {
      // ACT: fetch adhkar from Supabase through the use case.
      final result = await fetchAllAdhkar();

      // ASSERT: the use case returns typed domain entities with real data.
      expect(result, isA<List<Dhikr>>());
      expect(result, isNotEmpty);
      expect(result.first.id, isA<int>());
      expect(result.first.arabicText, isNotEmpty);
      expect(result.first.englishText, isNotEmpty);
      expect(result.first.repeat, greaterThan(0));
      expect(result.first.subcategoryId, isNotEmpty);
    });
  });
}
