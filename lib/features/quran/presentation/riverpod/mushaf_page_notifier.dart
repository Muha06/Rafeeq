import 'package:rafeeq/features/quran/domain/entities/mushaf_page.dart';
import 'package:rafeeq/features/quran/domain/useCases/fetch_mushaf_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:riverpod/legacy.dart';

enum MushafPageStatus { initial, loading, loaded, error }

class MushafPageState {
  final MushafPageStatus status;
  final MushafPage? page;
  final String? error;
  final int? highlightedAyah;

  MushafPageState({
    required this.status,
    this.page,
    this.error,
    this.highlightedAyah,
  });

  MushafPageState copyWith({
    MushafPageStatus? status,
    MushafPage? page,
    String? error,
    int? highlightedAyah,
  }) {
    return MushafPageState(
      status: status ?? this.status,
      page: page ?? this.page,
      error: error ?? this.error,
      highlightedAyah: highlightedAyah ?? this.highlightedAyah,
    );
  }
}

class MushafPageNotifier extends StateNotifier<MushafPageState> {
  final FetchMushafPageUseCase fetchPageUseCase;

  MushafPageNotifier({required this.fetchPageUseCase})
    : super(MushafPageState(status: MushafPageStatus.initial));

  // Load a page
  Future<void> loadPage(int pageNumber) async {
    try {
      state = state.copyWith(status: MushafPageStatus.loading);
      final page = await fetchPageUseCase(page: pageNumber);
      state = state.copyWith(status: MushafPageStatus.loaded, page: page);
    } catch (e) {
      state = state.copyWith(
        status: MushafPageStatus.error,
        error: e.toString(),
      );
    }
  }

  // Highlight a specific ayah
  void highlightAyah(int ayahNumber) {
    state = state.copyWith(highlightedAyah: ayahNumber);
  }

  // Optional: reset
  void reset() {
    state = MushafPageState(status: MushafPageStatus.initial);
  }
}

final mushafPageProvider =
    StateNotifierProvider.family<MushafPageNotifier, MushafPageState, int>((
      ref,
      pageNumber,
    ) {
      final fetchUseCase = ref.watch(mushafPageUsecaseProvider);
      return MushafPageNotifier(fetchPageUseCase: fetchUseCase);
    });
