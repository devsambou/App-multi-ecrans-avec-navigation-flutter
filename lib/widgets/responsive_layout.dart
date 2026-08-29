import 'package:flutter/material.dart';

import '../core/constants/breakpoints.dart';

/// Widget réutilisable n°1.
///
/// Ne connaît AUCUN modèle métier : il reçoit juste deux Widgets déjà
/// construits et choisit lequel afficher selon la largeur disponible.
/// Utilisable dans n'importe quel écran, pour n'importe quel contenu.
///
/// LayoutBuilder (plutôt que MediaQuery.of(context).size) est utilisé
/// volontairement : il réagit à la largeur du PARENT (utile si ce
/// widget est un jour placé dans un panneau latéral plus étroit que
/// l'écran), alors que MediaQuery donne toujours la largeur de
/// l'écran entier.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
  });

  final Widget mobile;
  final Widget tablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.tablet) {
          return tablet;
        }
        return mobile;
      },
    );
  }
}
