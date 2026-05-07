# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | Nudge |
| **Git URL** | git@github.com:asunnyboy861/Nudge.git |
| **Repo URL** | https://github.com/asunnyboy861/Nudge |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/Nudge/ | ⏳ Pending |
| Support | https://asunnyboy861.github.io/Nudge/support.html | ⏳ Pending |
| Privacy Policy | https://asunnyboy861.github.io/Nudge/privacy.html | ⏳ Pending |
| Terms of Use | https://asunnyboy861.github.io/Nudge/terms.html | ⏳ Pending (required for subscription) |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

```
Nudge/
├── Nudge/                           # iOS App Source Code
│   ├── Nudge.xcodeproj/             # Xcode Project
│   └── Nudge/                       # Swift Source Files
│       ├── Models/
│       ├── ViewModels/
│       ├── Views/
│       ├── Services/
│       └── Assets.xcassets/
├── docs/                            # Policy Pages (GitHub Pages source)
│   ├── index.html                   # Landing Page
│   ├── support.html                 # Support Page
│   ├── privacy.html                 # Privacy Policy
│   └── terms.html                   # Terms of Use
├── .github/workflows/
│   └── deploy.yml                   # GitHub Pages deployment
├── us.md                            # English Development Guide
├── keytext.md                       # App Store Metadata
├── capabilities.md                  # Capabilities Configuration
├── icon.md                          # App Icon Details
├── price.md                         # Pricing Configuration
└── nowgit.md                        # This File
```
