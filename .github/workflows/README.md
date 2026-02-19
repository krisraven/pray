# GitHub Actions Workflows

## Build and Release Workflow

Automatically builds and releases the Pray CLI tool for all supported platforms.

### How It Works

1. **Trigger:** Push a git tag starting with `v` (e.g., `v1.0.0`)
2. **Build:** Compiles for all 9 platform/architecture combinations in parallel
3. **Archive:** Creates platform-specific archives (`.zip` for Windows, `.tar.gz` for Unix)
4. **Release:** Creates a GitHub Release with all binaries as downloadable assets

### Creating a Release

#### 1. Update Version (Optional)
Edit your version info in the code if needed.

#### 2. Create a Git Tag
```bash
git tag v1.0.0
git push origin v1.0.0
```

Or use GitHub web interface:
- Go to your repository
- Click "Releases" → "Create a new release"
- Enter tag name (e.g., `v1.0.0`)
- Add release notes
- Click "Publish release"

#### 3. Workflow Runs Automatically
- GitHub Actions automatically detects the new tag
- Builds for all platforms (takes 5-10 minutes)
- Creates a release with all binaries

### Release Asset Structure

```
pray-windows-amd64.zip
├── pray.exe
└── quotes.json

pray-darwin-amd64.tar.gz
├── pray
└── quotes.json

(etc. for all platforms)
```

### Versioning Convention

Use semantic versioning for tags:
- `v1.0.0` - Major release (breaking changes)
- `v1.1.0` - Minor release (new features)
- `v1.0.1` - Patch release (bug fixes)

### Monitoring Builds

1. Go to your repository on GitHub
2. Click the "Actions" tab
3. Watch the workflow run in real-time
4. Check "Build Release" workflow for status

### Troubleshooting

**Workflow doesn't trigger:**
- Make sure the tag starts with `v` (case-sensitive)
- Verify you pushed the tag: `git push origin v1.0.0`

**Build fails:**
- Check the "Actions" tab for error logs
- Common issues:
  - Go version mismatch
  - Missing quotes.json file
  - Syntax errors in main.go

**Release not created:**
- GitHub token should be auto-generated
- Check Actions tab for specific errors
- Verify GITHUB_TOKEN has `contents: write` permission

### Manual Builds

To build locally without GitHub Actions:
```bash
./build.sh all
```

See [README.md](../../README.md) for more details.

### Customization

Edit `build-release.yml` to:
- Change Go version (currently 1.21)
- Add new platforms
- Change archive format
- Modify release notes template
- Add additional build steps

### Platform Details

| Platform | Runner | Architecture | Notes |
|----------|--------|-------------|-------|
| Windows | windows-latest | amd64, 386, arm64 | Builds on Windows |
| macOS Intel | macos-13 | amd64 | Builds on macOS 13 |
| macOS Apple Silicon | macos-latest | arm64 | Builds on M1+ Macs |
| Linux | ubuntu-latest | amd64, 386, arm, arm64 | Cross-compiles |

All builds are fast (~1-2 min each) and run in parallel.
