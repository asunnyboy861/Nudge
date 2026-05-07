# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- "通知" / "提醒" / "alert" → Push Notifications required
- "同步" / "sync" / "iCloud" → iCloud (CloudKit) optional sync
- "购买" / "订阅" / "会员" / "premium" → In-App Purchase (Subscription)
- "联系人" / "导入" / "CNContactStore" → Contacts (read-only access)
- "邮件" / "MailCompose" → No special capability needed (MessageUI framework)
- "后台" / "刷新" → Background Modes (Background Fetch for notifications)

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| Push Notifications | ✅ Configured | Xcode project capability |
| In-App Purchase | ✅ Configured | StoreKit 2 framework |
| Background Modes | ✅ Configured | Xcode project capability |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| iCloud (CloudKit) | ⏳ Pending | 1. Open Xcode → Signing & Capabilities → + Capability → iCloud 2. Check CloudKit checkbox 3. Create CloudKit container: iCloud.com.zzoutuo.Nudge 4. Enable in App Store Connect |
| Contacts | ⏳ Pending | 1. Add NSContactsUsageDescription to Info.plist: "Nudge needs access to your contacts to import client information." 2. No capability needed - just Info.plist key |

## No Configuration Needed
- Camera / Photo Library: Not required
- Location Services: Not required
- HealthKit: Not required
- Apple Watch: Not required
- Siri: Not required
- Sign in with Apple: Not required

## Verification
- Build succeeded after configuration: ⏳ Pending (will verify after code generation)
- All entitlements correct: ⏳ Pending
