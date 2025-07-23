import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtune/app.dart';
import 'package:moodtune/core/themes/_themes.dart';
import 'package:moodtune/core/widgets/navbar_item.dart';
import 'package:moodtune/features/home/presentation/pages/_pages.dart';
import 'package:moodtune/features/journal/presentation/pages/_pages.dart';
import 'package:moodtune/features/calendar/presentation/pages/_pages.dart';
import 'package:moodtune/features/playlist/presentation/pages/_pages.dart';
import 'package:moodtune/features/profile/presentation/pages/profile_page.dart';

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
    CalendarPage(),
    PlaylistDemoPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.alabaster,
      body: SafeArea(
        top: false,
        child: BlocBuilder<NavigationCubit, int>(
          builder: (context, selectedIndex) {
            return Stack(
              children: [
                _pages[selectedIndex],
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildNavbar(context, selectedIndex),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavbar(BuildContext context, int selectedIndex) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            BaseColors.neutral100.withValues(alpha: 0.025),
            BaseColors.neutral100.withValues(alpha: 0.05),
            BaseColors.neutral100.withValues(alpha: 0.1),
            BaseColors.neutral100.withValues(alpha: 0.2),
          ],
          stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: BaseColors.white,
                borderRadius: const BorderRadius.all(Radius.circular(48)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(navbarItems.length, (i) {
                  final item = navbarItems[i];
                  return NavItem(
                    item: item,
                    isSelected: i == selectedIndex,
                    onTap: () => context.read<NavigationCubit>().changeTab(i),
                  );
                }),
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
                onPressed: () => nav.push(AddJournal()),
                icon: const Icon(Icons.add, color: BaseColors.white, size: 28),
              ),
            ),
          ],
        ),
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
