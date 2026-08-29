/// Point de vérité unique pour les seuils responsive.
///
/// Toute la logique "mobile vs tablette" de l'app passe par cette
/// constante : si on veut déplacer le seuil, on le change ici et
/// nulle part ailleurs (pas de "600" dispersé dans chaque écran).
class Breakpoints {
  Breakpoints._();

  static const double tablet = 600;
  static const double desktop = 1024;
}
