import 'package:fluid_caht_app/modules/call/view/call_view.dart';
import 'package:fluid_caht_app/modules/chat/view/chat_list_view.dart';
import 'package:fluid_caht_app/modules/contact/view/contact_view.dart';
import 'package:fluid_caht_app/modules/setting/seeting_view.dart';
import 'package:fluid_caht_app/modules/status/view/status_view.dart';
import 'package:flutter/material.dart';

import '../chat/view/chat_view.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ChatsPage(),
    const ContactsView(),
    StatusPage(),
    CallsPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: _pages[_selectedIndex],
      // Bottom Navigation Bar using AppTheme colors
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat, fill: 1.0),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radar_outlined),
            activeIcon: Icon(Icons.radar),
            label: 'Status',
          ), BottomNavigationBarItem(
            icon: Icon(Icons.call),
            activeIcon: Icon(Icons.call),
            label: 'Call',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
