# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: Nudge Premium
- **Group ID**: Auto-generated in App Store Connect

## Subscription Tiers

### 1. Monthly Subscription (Pro)
- **Reference Name**: Nudge Pro Monthly
- **Product ID**: `com.zzoutuo.Nudge.proMonthly`
- **Price**: $6.99 per month
- **Display Name**: Nudge Pro Monthly
- **Description**: Unlimited clients, AI follow-ups, and more
- **Localization**: English (US)

### 2. Yearly Subscription (Pro)
- **Reference Name**: Nudge Pro Yearly
- **Product ID**: `com.zzoutuo.Nudge.proYearly`
- **Price**: $59.99 per year (28% savings vs monthly)
- **Display Name**: Nudge Pro Yearly
- **Description**: Best value - unlimited clients and AI features
- **Localization**: English (US)

### 3. Monthly Subscription (Business)
- **Reference Name**: Nudge Business Monthly
- **Product ID**: `com.zzoutuo.Nudge.businessMonthly`
- **Price**: $14.99 per month
- **Display Name**: Nudge Business Monthly
- **Description**: Team features, priority support, and analytics
- **Localization**: English (US)

### 4. Yearly Subscription (Business)
- **Reference Name**: Nudge Business Yearly
- **Product ID**: `com.zzoutuo.Nudge.businessYearly`
- **Price**: $119.99 per year (33% savings vs monthly)
- **Display Name**: Nudge Business Yearly
- **Description**: Best value for teams with full analytics
- **Localization**: English (US)

## Free Tier (No IAP Required)
- Up to 25 clients
- Unlimited follow-up reminders
- Basic interaction logging (manual)
- One-time contact import
- 3 email templates
- Basic notifications
- No Widget / Live Activity
- No AI features
- No CloudKit sync

## Pro Tier Features
- Unlimited clients
- AI follow-up suggestions
- AI email drafts
- Widgets & Live Activities
- Cloud sync across devices
- Unlimited email templates
- Advanced notification actions

## Business Tier Features
- Everything in Pro
- Team collaboration
- Shared client pools
- Advanced analytics & conversion funnel
- Priority support
- Revenue tracking

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial (auto-converts to paid Pro Monthly)
- **Applies to**: Pro Monthly subscription only

## Policy Pages Required
- Support Page: ✅ (Must include subscription management info)
- Privacy Policy: ✅
- Terms of Use: ✅ (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included (7-day trial on Pro Monthly)
- [ ] Restore purchases functionality implemented

## Pricing Psychology Applied
| Strategy | Application |
|----------|-------------|
| Anchoring | Show Business $14.99 first, then Pro $6.99 feels cheaper |
| Loss Aversion | "You're missing 3 follow-ups this week" messaging |
| Annual Discount | $59.99/year vs $6.99/month = 28% savings |
| Free Trial | 7-day free trial lowers barrier to try |
| Freemium | 25 clients free forever enables word-of-mouth |
