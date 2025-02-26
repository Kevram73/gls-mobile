class Urls {
  // static const baseUrl = "http://192.168.1.68:8000/api";
  static const baseUrl = "https://api.galorelotoservices.com/api";

  // 🔐 Authentification
  static const registerUrl = "$baseUrl/register";
  static const loginUrl = "$baseUrl/login";
  static const logoutUrl = "$baseUrl/logout";
  static const forgotPasswordUrl = "$baseUrl/forgot-password";
  static const resetPasswordUrl = "$baseUrl/reset-password";
  static const otpVerifyUrl = "$baseUrl/otp-verify";

  // 👤 Utilisateurs
  static const userProfileUrl = "$baseUrl/user/profile";
  static const updateUserUrl = "$baseUrl/user/update";
  static const deleteUserUrl = "$baseUrl/user/delete";
  static const usersListUrl = "$baseUrl/users";
  static const usersListWithTypeUrl = "$baseUrl/users/type";

  // 📩 Messages (Chat)
  static const String sendMessageUrl = "$baseUrl/messages/send";
static String conversationMessagesUrl(int otherUserId) =>
    "$baseUrl/messages/conversation/$otherUserId";
static String deleteMessageUrl(int messageId) =>
    "$baseUrl/messages/$messageId";
static const String contactedUsersUrl = "$baseUrl/messages/contacted-users";

  // 🛒 Ventes
  static const ventesListUrl = "$baseUrl/ventes";
  static const createVenteUrl = "$baseUrl/ventes";
  static const venteByIdUrl = "$baseUrl/ventes/{id}";
  static const updateVenteUrl = "$baseUrl/ventes/{id}";
  static const deleteVenteUrl = "$baseUrl/ventes/{id}";
  static const ventesBySellerUrl = "$baseUrl/ventes/seller/{sellerId}";
  static const ventesByPointOfSaleUrl =
      "$baseUrl/ventes/point-of-sale/{pointOfSaleId}";
  static const unpaidVentesUrl = "$baseUrl/ventes/unpaid";

  // 📍 Points de Vente
  static const pointOfSalesListUrl = "$baseUrl/point-of-sales";
  static const createPointOfSaleUrl = "$baseUrl/point-of-sales";
  static const pointOfSaleByIdUrl = "$baseUrl/point-of-sales/{id}";
  static const updatePointOfSaleUrl = "$baseUrl/point-of-sales/{id}";
  static const deletePointOfSaleUrl = "$baseUrl/point-of-sales/{id}";
  static const activePointsUrl = "$baseUrl/point-of-sales/active";
  static const pointOfSaleUsersUrl = "$baseUrl/users/no-pos";

  // 📰 Journaux
  static const journalsListUrl = "$baseUrl/journals";
  static const createJournalUrl = "$baseUrl/journals";
  static const journalByIdUrl = "$baseUrl/journals/{id}";
  static const updateJournalUrl = "$baseUrl/journals/{id}";
  static const deleteJournalUrl = "$baseUrl/journals/{id}";
  static const activeJournalsUrl = "$baseUrl/journals/active";

  // 🔔 Notifications
  static const notificationsListUrl = "$baseUrl/notifications";
  static const createNotificationUrl = "$baseUrl/notifications";
  static const notificationByIdUrl = "$baseUrl/notifications/{id}";
  static const markNotificationReadUrl = "$baseUrl/notifications/{id}/read";
  static const unreadNotificationsUrl = "$baseUrl/notifications/unread";
  static const deleteNotificationUrl = "$baseUrl/notifications/{id}";

  // 📊 Dashboard
  static const dashboardOverviewUrl = "$baseUrl/dashboard/overview";

  // 👥 Type Utilisateur
  static const typeUsersListUrl = "$baseUrl/type-users";
  static const typeUsersOthersUrl = "$baseUrl/type-users/others";
  static const createTypeUserUrl = "$baseUrl/type-users";
  static const typeUserByIdUrl = "$baseUrl/type-users/{id}";

  static const dashboardUrl = "$baseUrl/dashboard";
  static const changePasswordUrl = "$baseUrl/change-password";
  static const changeUserImageUrl = "$baseUrl/change-user-image";
}
