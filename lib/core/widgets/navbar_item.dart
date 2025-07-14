import 'package:flutter/material.dart';
import 'package:moodtune/core/themes/_themes.dart';

class NavItem extends StatelessWidget {
  final NavbarItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const NavItem({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? BaseColors.goldenrod.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                item.icon,
                color: isSelected ? BaseColors.gold3 : BaseColors.gray3,
                size: 27,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubicEmphasized,
              child: isSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          item.label,
                          style: FontTheme.poppins14w600black().copyWith(
                            color: BaseColors.gold3,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class NavbarItem {
  final IconData icon;
  final String label;

  NavbarItem({required this.icon, required this.label});
}

List<NavbarItem> navbarItems = [
  NavbarItem(icon: Icons.home_filled, label: 'Home'),
  NavbarItem(icon: Icons.calendar_month, label: 'Status'),
  NavbarItem(icon: Icons.headset, label: 'Playlist'),
  NavbarItem(icon: Icons.person, label: 'Profile'),
];
