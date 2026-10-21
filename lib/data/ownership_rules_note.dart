/// Kandidat Security Rules RTDB — BELUM DI-DEPLOY.
///
/// Scope Step 08 hanya ownership `/users/{uid}` milik user login.
/// JANGAN copy-paste ke Console tanpa verifikasi struktur RTDB aktual.
/// Finalisasi device-level rules menunggu keputusan device identity.
///
/// ```json
/// {
///   "rules": {
///     "users": {
///       "$uid": {
///         ".read": "auth != null && auth.uid == $uid",
///         ".write": "auth != null && auth.uid == $uid"
///       }
///     }
///   }
/// }
/// ```
///
/// Status: PROPOSED — NOT DEPLOYED, NOT VERIFIED.
const String proposedOwnershipRulesNote = 'users/{uid} owned by auth.uid';