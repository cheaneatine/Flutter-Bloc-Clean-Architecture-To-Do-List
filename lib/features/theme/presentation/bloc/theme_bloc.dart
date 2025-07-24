import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: ThemeData.light(), isDark: false)) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<LoadThemeEvent>(_onLoadTheme);
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    final isDark = !state.isDark;
    emit(
      ThemeState(
        themeData: isDark ? ThemeData.dark() : ThemeData.light(),
        isDark: isDark,
      ),
    );
  }

  void _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) {
    // Could load saved theme from storage in a real app
    emit(state);
  }
}
