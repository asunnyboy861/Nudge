# Nudge - iOS Development Guide

## Executive Summary

Nudge is a mobile-first client follow-up automation tool designed for freelancers, solopreneurs, and small business owners in the US market. Unlike complex CRMs like HubSpot ($50+/mo), Pipedrive ($14+/mo), and Close ($49+/mo), Nudge offers a zero-learning-curve experience with smart follow-up reminders, one-tap actions, and AI-powered suggestions at just $6.99/month.

**Product Vision**: Make follow-ups automatic so no lead is ever lost to forgetfulness. 80% of deals close after the 5th touchpoint, but most people quit after the 2nd. Nudge ensures you never quit.

**Key Differentiators**:
- 2-minute setup vs 30+ minutes for competitors
- 25 clients free forever (generous free tier for word-of-mouth growth)
- Smart cadence-based auto-reminders (not manual)
- One-tap Call/Email/Text with auto-logging
- AI follow-up suggestions and email drafts
- Complete offline functionality
- Mobile-first design (not a desktop app ported to mobile)

**Target Audience**: Freelancers, independent consultants, small business owners (1-5 people), real estate/insurance agents, service-based businesses (cleaning, repair, landscaping).

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Follow Up Boss | Deep real estate integrations, 200+ lead sources, team features | $69+/mo per user, complex setup, real-estate-only, poor iPad support | 10x cheaper, zero learning curve, works for any industry, not just real estate |
| Pipedrive | Visual pipeline, 500+ integrations, AI sales assistant | $14-79/mo per user, no free plan, desktop-first, steep learning curve | Free tier with 25 clients, mobile-first, auto-reminders vs manual tasks |
| Close | Built-in calling/SMS, AI call assistant, fast for outbound teams | $35-149/mo per user, no free plan, sales-team-focused, complex | Solo-friendly pricing, smart cadence system, no per-user pricing trap |

## Apple Design Guidelines Compliance

- **HIG Navigation**: TabView with 4 tabs (Today, Clients, Follow-Ups, Settings) following iOS standard patterns
- **HIG Modality**: Sheets for add/edit flows, full-screen for detail views
- **HIG Notifications**: UNUserNotificationCenter with interactive notification actions (Complete, Snooze, Call)
- **HIG Haptics**: UIImpactFeedbackGenerator for follow-up completion
- **HIG Dark Mode**: Full dark mode support with semantic colors
- **HIG Accessibility**: VoiceOver labels, Dynamic Type support, minimum touch target 44pt
- **HIG Data Entry**: Inline editing where possible, minimal form fields, smart defaults
- **HIG Gestures**: Swipe actions on list items (Complete, Snooze), pull-to-refresh

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), MessageUI (MailCompose), Contacts (CNContactStore)
- **Data**: SwiftData (@Model, @Query, ModelContainer)
- **Cloud**: CloudKit (optional sync, NSPersistentCloudKitContainer equivalent for SwiftData)
- **Notifications**: UNUserNotificationCenter + Background Tasks
- **Monetization**: StoreKit 2 (In-App Purchase)
- **Architecture**: MVVM + @Observable (iOS 17+)
- **Async**: async/await + Task (no Combine, no callbacks)
- **Testing**: Swift Testing framework
- **Design System**: Custom NudgeDesign module for unified colors/fonts/spacing

## Module Structure

```
Nudge/
├── NudgeApp.swift
├── Models/
│   ├── Client.swift
│   ├── FollowUp.swift
│   ├── Interaction.swift
│   ├── EmailTemplate.swift
│   └── Enums.swift
├── ViewModels/
│   ├── ClientListViewModel.swift
│   ├── ClientDetailViewModel.swift
│   ├── FollowUpListViewModel.swift
│   ├── DashboardViewModel.swift
│   ├── SettingsViewModel.swift
│   └── TemplateViewModel.swift
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Today/
│   │   ├── TodayView.swift
│   │   └── DashboardStatView.swift
│   ├── Clients/
│   │   ├── ClientListView.swift
│   │   ├── ClientDetailView.swift
│   │   ├── AddClientView.swift
│   │   └── ClientCardView.swift
│   ├── FollowUps/
│   │   ├── FollowUpListView.swift
│   │   ├── AddFollowUpView.swift
│   │   └── FollowUpRowView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── ContactSupportView.swift
│   │   └── PaywallView.swift
│   └── Shared/
│       └── DesignSystem.swift
├── Services/
│   ├── NotificationManager.swift
│   ├── ContactImporter.swift
│   └── PurchaseManager.swift
└── Assets.xcassets/
```

## Implementation Flow

1. Set up SwiftData models (Client, FollowUp, Interaction, EmailTemplate) with all enums
2. Create DesignSystem module (colors, fonts, spacing constants)
3. Build NudgeApp with TabView and NavigationStack
4. Implement OnboardingView (welcome + notification auth + contacts import)
5. Build ClientListView with search, filter, sort
6. Build AddClientView with form and validation
7. Build ClientDetailView with timeline and quick actions
8. Build FollowUpListView with overdue/today/upcoming sections
9. Build AddFollowUpView with date picker and type selection
10. Implement NotificationManager (schedule, cancel, interactive actions)
11. Implement ContactImporter (CNContactStore read-only access)
12. Build TodayView dashboard with stats and overdue alerts
13. Implement PurchaseManager with StoreKit 2
14. Build PaywallView and SettingsView
15. Build ContactSupportView with feedback backend
16. Add email template engine with variable substitution
17. Integrate all views and test on iPhone + iPad

## UI/UX Design Specifications

- **Color Scheme**:
  - Primary: #4A90D9 (Nudge Blue - trust, professional)
  - Overdue: #E74C3C (Red - urgent)
  - Due Today: #F39C12 (Orange - attention)
  - Completed: #27AE60 (Green - success)
  - Hot Priority: #E74C3C, Warm: #F39C12, Cold: #3498DB
  - Background: #F8F9FA (light), #1A1A2E (dark)
  - Card: #FFFFFF (light), #2D2D44 (dark)
  - Text Primary: #1A1A2E (light), #F8F9FA (dark)
  - Text Secondary: #6C757D

- **Typography**: SF Pro Rounded for headings (bold, semibold), SF Pro for body
  - Large Title: 34pt bold rounded
  - Title 1: 28pt bold rounded
  - Title 2: 22pt semibold rounded
  - Headline: 17pt semibold
  - Body: 17pt regular
  - Caption: 12pt regular

- **Layout**:
  - 4-tab TabView: Today, Clients, Follow-Ups, Settings
  - Card-based lists with 12pt padding, 12pt corner radius
  - 44pt minimum touch targets
  - iPad: max width 720pt for content, centered
  - NavigationStack for all navigation flows

- **Animations**:
  - Card tap: scaleEffect(0.97) with spring animation
  - Follow-up complete: checkmark + strikethrough, 0.3s easeOut
  - Delete: slide + fade, 0.25s easeIn
  - Overdue pulse: opacity 1.0->0.5->1.0, 2s repeat
  - Page transition: system default navigation transition

## Code Generation Rules

- MVVM + @Observable architecture (no Combine)
- SwiftData @Model for persistence (no Core Data)
- Pure SwiftUI (UIKit only for MailCompose/MFMessageCompose)
- NavigationStack + NavigationPath for navigation
- async/await + Task (no callbacks)
- UNUserNotificationCenter for notifications
- Local-first with optional CloudKit sync
- Swift Testing framework (no XCTest)
- No comments in code (self-documenting)
- iOS 17.0 minimum deployment target
- Custom DesignSystem module for all UI constants
- All SwiftData attributes must be optional or have default values
- All relationships must have inverse relationships
- iPad content: .frame(maxWidth: 720).frame(maxWidth: .infinity)

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.Nudge
2. Verify Deployment Target: iOS 17.0
3. Configure App Icon (all sizes)
4. Enable Push Notifications capability
5. Enable CloudKit capability (optional sync)
6. Configure StoreKit 2 subscription products
7. Create StoreKit Configuration file for testing
8. Test on iPhone XS Max simulator
9. Test on iPad Pro 13-inch (M4) simulator
10. Verify no API keys in source code
11. Push to GitHub repository
12. Deploy policy pages to GitHub Pages
13. Create App Store Connect listing
14. Submit for review
