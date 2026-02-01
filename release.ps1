# release.ps1 - Automated release script for doctest plugin
# Creates and pushes version tags in format vYYYY.MM.DD[a-z]

param(
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Get today's date in version format
$dateVersion = Get-Date -Format "yyyy.MM.dd"
$baseTag = "v$dateVersion"

# Get existing tags for today
$existingTags = git tag -l "$baseTag*" 2>$null | Sort-Object

if ($existingTags) {
    Write-Host "Existing tags for today:" -ForegroundColor Yellow
    $existingTags | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    
    # Find the next suffix
    $lastTag = $existingTags | Select-Object -Last 1
    
    if ($lastTag -eq $baseTag) {
        # First release was without suffix, next is 'a'
        $newTag = "${baseTag}a"
    } elseif ($lastTag -match "^v\d{4}\.\d{2}\.\d{2}([a-z])$") {
        # Increment the suffix letter
        $lastSuffix = $matches[1]
        $nextSuffix = [char]([int][char]$lastSuffix + 1)
        if ($nextSuffix -gt 'z') {
            Write-Error "Too many releases today! (exceeded 'z' suffix)"
            exit 1
        }
        $newTag = "$baseTag$nextSuffix"
    } else {
        Write-Error "Unexpected tag format: $lastTag"
        exit 1
    }
} else {
    # No releases today yet - use base tag without suffix
    $newTag = $baseTag
}

Write-Host ""
Write-Host "New release tag: " -NoNewline
Write-Host $newTag -ForegroundColor Green
Write-Host ""

# Check for uncommitted changes
$status = git status --porcelain
if ($status) {
    Write-Host "Warning: You have uncommitted changes:" -ForegroundColor Yellow
    $status | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    Write-Host ""
    
    if (-not $Force) {
        $response = Read-Host "Continue anyway? (y/N)"
        if ($response -ne 'y' -and $response -ne 'Y') {
            Write-Host "Aborted." -ForegroundColor Red
            exit 1
        }
    }
}

# Check if we're on main branch
$currentBranch = git branch --show-current
if ($currentBranch -ne 'main') {
    Write-Host "Warning: You're on branch '$currentBranch', not 'main'" -ForegroundColor Yellow
    
    if (-not $Force) {
        $response = Read-Host "Continue anyway? (y/N)"
        if ($response -ne 'y' -and $response -ne 'Y') {
            Write-Host "Aborted." -ForegroundColor Red
            exit 1
        }
    }
}

# Ensure we're up to date with remote
Write-Host "Fetching latest from origin..." -ForegroundColor Cyan
git fetch origin --tags

# Check if local is behind remote
$behind = git rev-list --count "HEAD..origin/$currentBranch" 2>$null
if ($behind -gt 0) {
    Write-Host "Warning: Local branch is $behind commit(s) behind origin/$currentBranch" -ForegroundColor Yellow
    
    if (-not $Force) {
        $response = Read-Host "Pull changes first? (Y/n)"
        if ($response -ne 'n' -and $response -ne 'N') {
            git pull origin $currentBranch
        }
    }
}

if ($DryRun) {
    Write-Host ""
    Write-Host "[DRY RUN] Would execute:" -ForegroundColor Magenta
    Write-Host "  git tag $newTag" -ForegroundColor Gray
    Write-Host "  git push origin $newTag" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Run without -DryRun to create the release." -ForegroundColor Cyan
    exit 0
}

# Confirm release
Write-Host ""
$response = Read-Host "Create and push tag '$newTag'? (y/N)"
if ($response -ne 'y' -and $response -ne 'Y') {
    Write-Host "Aborted." -ForegroundColor Red
    exit 1
}

# Create and push the tag
Write-Host ""
Write-Host "Creating tag $newTag..." -ForegroundColor Cyan
git tag $newTag

Write-Host "Pushing tag to origin..." -ForegroundColor Cyan
git push origin $newTag

Write-Host ""
Write-Host "Release $newTag created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "GitHub Actions will now:" -ForegroundColor Cyan
Write-Host "  1. Build the TXZ package" -ForegroundColor Gray
Write-Host "  2. Generate the PLG file" -ForegroundColor Gray  
Write-Host "  3. Create a GitHub Release" -ForegroundColor Gray
Write-Host ""
Write-Host "Monitor progress at:" -ForegroundColor Cyan
Write-Host "  https://github.com/mstrhakr/unraid-plugin-docs/actions" -ForegroundColor Blue
Write-Host ""
Write-Host "Release will be available at:" -ForegroundColor Cyan
Write-Host "  https://github.com/mstrhakr/unraid-plugin-docs/releases/tag/$newTag" -ForegroundColor Blue
