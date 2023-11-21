import 'package:flutter/material.dart';

class ProfilePageBox extends StatelessWidget {
  const ProfilePageBox({super.key, required this.icon, required this.label, required this.routeWidget});

  final IconData icon;
  final String label;
  final Widget routeWidget;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => routeWidget),
        );
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromARGB(100, 29, 36, 40),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: ListTile(
              leading: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              title: Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
