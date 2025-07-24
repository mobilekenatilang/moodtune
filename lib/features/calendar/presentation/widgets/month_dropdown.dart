part of '_widgets.dart';

class MonthDropdown extends StatefulWidget {
  final DateTime currentMonth;
  final ValueChanged<DateTime> onChanged;

  const MonthDropdown({
    super.key,
    required this.currentMonth,
    required this.onChanged,
  });

  @override
  State<MonthDropdown> createState() => _MonthDropdownState();
}

class _MonthDropdownState extends State<MonthDropdown> {
  bool _showYearList = false;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.currentMonth.year;
  }

  void _openModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: BaseColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          setStateModal(() => _selectedYear--);
                        },
                        icon: const Icon(
                          Icons.chevron_left,
                          color: BaseColors.neutral100,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setStateModal(() => _showYearList = !_showYearList);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedYear.toString(),
                              style: FontTheme.poppins16w500black(),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: BaseColors.neutral100,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setStateModal(() => _selectedYear++);
                        },
                        icon: const Icon(
                          Icons.chevron_right,
                          color: BaseColors.neutral100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_showYearList)
                    _buildYearGrid(setStateModal)
                  else
                    _buildMonthGrid(context),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMonthGrid(BuildContext context) {
    final months = List.generate(12, (i) => i + 1);
    return GridView.builder(
      shrinkWrap: true,
      itemCount: months.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (ctx, index) {
        final m = months[index];
        final isSelected =
            m == widget.currentMonth.month &&
            _selectedYear == widget.currentMonth.year;
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
            widget.onChanged(DateTime(_selectedYear, m));
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? BaseColors.gold3 : BaseColors.neutral20,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              Constants.monthNames[m - 1],
              style: FontTheme.poppins14w600black().copyWith(
                color: isSelected ? BaseColors.white : BaseColors.neutral100,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearGrid(void Function(void Function()) setStateModal) {
    final years = List<int>.generate(9, (i) => _selectedYear - 6 + i);
    return GridView.builder(
      shrinkWrap: true,
      itemCount: years.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (ctx, index) {
        final y = years[index];
        final isSelected = y == _selectedYear;
        return GestureDetector(
          onTap: () {
            setStateModal(() {
              _selectedYear = y;
              _showYearList = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? BaseColors.gold3 : BaseColors.neutral20,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              y.toString(),
              style: FontTheme.poppins14w600black().copyWith(
                color: isSelected ? BaseColors.white : BaseColors.neutral100,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openModal(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: BaseColors.neutral20,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              "${Constants.monthNames[widget.currentMonth.month - 1]} ${widget.currentMonth.year}",
              style: FontTheme.poppins14w600black(),
            ),
            const Icon(Icons.arrow_drop_down, color: BaseColors.neutral90),
          ],
        ),
      ),
    );
  }
}

class Constants {
  static const List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
}
