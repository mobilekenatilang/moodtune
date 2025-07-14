import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtune/core/themes/_themes.dart';
import 'package:moodtune/core/widgets/navbar_item.dart';
import 'package:moodtune/features/home/presentation/pages/homepage.dart';
import 'package:moodtune/services/logger_service.dart';
import 'dart:ui';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: const NavigationMenu(),
    );
  }
}

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  // List of pages to navigate between
  static const List<Widget> _pages = [
    HomePage(),
    ExamplePage(title: "Status"),
    ExamplePage(title: "Playlist"),
    ExamplePage(title: "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.alabaster,
      body: Stack(
        children: [
          SafeArea(
            child: BlocBuilder<NavigationCubit, int>(
              builder: (context, selectedIndex) {
                return IndexedStack(index: selectedIndex, children: _pages);
              },
            ),
          ),

          // Non-clickable overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: IgnorePointer(
              ignoring: false,
              child: Container(color: Colors.transparent),
            ),
          ),

          // Blur effect
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    BaseColors.neutral100.withValues(alpha: 0.05),
                    BaseColors.neutral100.withValues(alpha: 0.1),
                    BaseColors.neutral100.withValues(alpha: 0.2),
                    BaseColors.neutral100.withValues(alpha: 0.4),
                  ],
                  stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                ),
              ),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.75, sigmaY: 0.75),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ),

          // Navbarnya
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: BlocBuilder<NavigationCubit, int>(
              builder: (context, selectedIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 280,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: BaseColors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(48),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: navbarItems
                            .map(
                              (item) => NavItem(
                                item: item,
                                isSelected:
                                    navbarItems.indexOf(item) == selectedIndex,
                                onTap: () {
                                  context.read<NavigationCubit>().changeTab(
                                    navbarItems.indexOf(item),
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: BaseColors.gold3,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // TODO: Handle add button press
                          LoggerService.i('Add button pressed');
                        },
                        icon: const Icon(
                          Icons.add,
                          color: BaseColors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void changeTab(int index) {
    emit(index);
  }
}

// NOTE: Placeholder pages - replace this ASAP
class ExamplePage extends StatelessWidget {
  final String title;
  const ExamplePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.alabaster,
      body: Center(child: Text(title, style: FontTheme.poppins24w700black())),
    );
  }
}
