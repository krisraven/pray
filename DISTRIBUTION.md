# Distribution Guide

This guide explains how to package, distribute, and sell the Pray CLI tool across different platforms.

## Quick Start

### 1. Build All Platforms
```bash
./build.sh all
# or
make build-all
```

Binaries are created in the `build/` directory organized by platform.

### 2. Automated Releases via GitHub Actions

Create a version tag to automatically build and release:
```bash
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actions will:
- Build for all 9 platforms
- Create archives (.zip for Windows, .tar.gz for Unix)
- Publish a GitHub Release with all binaries

Users can download from: https://github.com/krisraven/pray/releases

## Distribution Methods

### Method 1: Direct Downloads (Recommended for Starting)

**Advantages:**
- Simplest to set up
- No middleman
- Keep 100% of revenue

**Platforms:**
- **Gumroad**: Easy payment processing, ~95% payout
- **Itch.io**: Developer-focused, variable pricing
- **Your Website**: Maximum control (requires Stripe/PayPal)

**Setup:**
1. Build binaries: `./build.sh all`
2. Create platform-specific archives
3. Upload to your chosen platform
4. Add download links to README

**Example Gumroad Setup:**
1. Create account at gumroad.com
2. Upload your binaries to a "product"
3. Set pricing (free, fixed, or pay-what-you-want)
4. Share link: `gumroad.com/[username]/pray`

### Method 2: Package Managers

**Homebrew (macOS):**
```bash
# Create a tap or contribute to official Homebrew
brew install krisraven/pray/pray
```

**Chocolatey (Windows):**
```bash
choco install pray
```

**Snap (Linux):**
```bash
snap install pray
```

**AUR (Arch Linux):**
```bash
yay -S pray
```

**Setup:**
- Each requires account setup and approval process
- Usually 1-2 weeks for approval
- Good for reach, but less control over pricing

### Method 3: Installer Scripts

**Unix/Linux/macOS:**
```bash
curl -fsSL https://your-domain.com/install.sh | bash
```

**Windows:**
```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://your-domain.com/install.bat'))
```

Use the provided `install.sh` and `install.bat` scripts as templates.

### Method 4: Bundled Installers

Create self-contained installers for different platforms:

**macOS (.dmg):**
```bash
# Create disk image
hdiutil create -volname "Pray" -srcfolder build/pray-darwin-amd64 -ov -format UDZO pray.dmg
```

**Windows (.msi or .exe):**
- Use WiX Toolset or NSIS
- Creates professional installer experience

**Linux (.deb or .rpm):**
```bash
# Debian package
fakeroot dpkg-deb --build build/pray-linux-amd64 pray-amd64.deb
```

## Packaging Strategy

### Individual Binaries
Most lightweight option:
- Just the executable + quotes.json
- Users manage paths themselves
- ~2-3 MB per binary

### Bundled Archives
Include everything needed:
```
pray-windows-amd64/
├── pray.exe
├── quotes.json
├── README.txt
└── INSTALL.txt
```

### Installer Bundles
Professional installation:
- Automated PATH setup
- Desktop shortcuts
- Uninstaller
- ~5-10 MB installer

## Pricing Strategy

### Tiered Model
```
Free Trial ($0)
└─ 7-day access to all features

Personal ($9.99)
└─ Personal use only
└─ Single platform

Professional ($24.99)
└─ All platforms
└─ Commercial use
└─ 1 year updates
└─ Email support

Enterprise (Custom)
└─ Custom features
└─ Dedicated support
└─ Volume discounts
```

### Pay-What-You-Want
- Set minimum price (e.g., $1.99)
- Suggested price (e.g., $9.99)
- Let users pay more if they want
- Works well for niche tools

### Subscription
```
Monthly: $2.99/month
Yearly: $19.99/year (2-month discount)

Includes:
- Latest version updates
- Bug fixes
- Commercial use rights
```

## License Key System (Optional)

### Benefits
- Prevent unauthorized redistribution
- Enable different feature tiers
- Track adoption

### Implementation
1. Generate unique keys for each purchase
2. Add validation to pray CLI
3. Different features per license tier
4. Automatic license validation

### Basic License Check Example
```go
func validateLicense(key string) bool {
    // Check license key validity
    // Return true/false
    // Optional: check online or offline
}
```

## Distribution Checklist

- [ ] Binaries built and tested for all platforms
- [ ] quotes.json included with each binary
- [ ] README/documentation included
- [ ] License information included
- [ ] Version number updated
- [ ] GitHub Release created (if using GitHub)
- [ ] Download links working
- [ ] Installation instructions clear
- [ ] Support contact information provided
- [ ] Commercial license terms clear

## Marketing Your Distribution

### 1. GitHub
- **Releases page**: Point users here first
- **README**: Include "Download" section
- **Actions badge**: Show build status

### 2. Package Managers
- Submit to Homebrew, Chocolatey, Snap
- Increases discoverability
- Good for free/freemium model

### 3. Your Website/Blog
- Create landing page with features
- Include testimonials
- Clear pricing
- Installation instructions

### 4. Communities
- Post in relevant subreddits (r/golang, r/ubuntu, etc.)
- Tech forums and blogs
- Discord/Slack communities
- LinkedIn/Twitter announcements

### 5. Gumroad/Itch.io
- Leverage platform's audience
- Community features
- Built-in discovery

## File Structure for Distribution

```
pray-v1.0.0-windows-amd64/
├── pray.exe
├── quotes.json
├── README.md
├── LICENSE
└── CHANGELOG.md

pray-v1.0.0-darwin-amd64/
├── pray
├── quotes.json
├── README.md
├── LICENSE
└── CHANGELOG.md

(etc. for all platforms)
```

## Security Considerations

### Code Signing (Optional)
- Sign macOS binaries with Developer ID
- Sign Windows executables with code signing cert
- Improves trust and bypasses warnings

### Checksums
Include SHA256 checksums for verification:
```bash
sha256sum pray-linux-amd64 > pray-v1.0.0-checksums.txt
```

### Privacy
- No telemetry by default
- Optional anonymous usage stats (user opt-in)
- Clear privacy policy

## Support Tiers

### Free Users
- GitHub Issues
- Community help
- Email: no guaranteed response

### Paid Users
- Email support: 24-48 hour response
- Priority bug fixes
- Update notifications
- Feature requests considered

### Enterprise Users
- Dedicated support contact
- Custom features
- Training/documentation
- SLA agreement

## Sample Distribution Timeline

**Week 1:**
- Build and test all platforms
- Create installer scripts
- Prepare documentation

**Week 2:**
- Create GitHub Release
- Set up Gumroad/seller account
- Create landing page

**Week 3:**
- Submit to package managers
- Market on social media
- Reach out to communities

**Week 4:**
- Gather feedback
- Monitor downloads
- Plan next features

## Next Steps

1. **Choose distribution platform** (recommend Gumroad for simplicity)
2. **Build all binaries**: `./build.sh all`
3. **Test on each platform**
4. **Create GitHub Release** with tag
5. **Set up Gumroad/seller account**
6. **Market to target audience**
7. **Gather feedback and iterate**

---

For questions about distribution, licensing, or marketing strategy, see [COMMERCIAL_LICENSE.md](COMMERCIAL_LICENSE.md).
