import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'site_analysis_window.freezed.dart';

@freezed
abstract class SiteAnalysisWindow with _$SiteAnalysisWindow {
  const factory SiteAnalysisWindow(String name, int startTime, int endTime) = _SiteAnalysisWindow;
}
