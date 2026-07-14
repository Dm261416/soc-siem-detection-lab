# push-to-github.ps1
# Run this from inside the soc-siem-detection-lab folder after you've:
#   1. Created an EMPTY repo on GitHub (no README, no .gitignore, no license)
#      named: soc-siem-detection-lab
#   2. Downloaded/copied all the files this script sits next to into this folder

Write-Host "Checking for git..." -ForegroundColor Cyan
git --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "Git not found. Install it first: https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}

Write-Host "`nInitializing git repo..." -ForegroundColor Cyan
git init

Write-Host "`nAdding all files..." -ForegroundColor Cyan
git add .

Write-Host "`nCommitting..." -ForegroundColor Cyan
git commit -m "Add SOC SIEM detection lab: brute force rule and investigation writeup"

Write-Host "`nSetting branch to main..." -ForegroundColor Cyan
git branch -M main

$repoUrl = Read-Host "Paste your GitHub repo URL (e.g. https://github.com/dm261416/soc-siem-detection-lab.git)"

Write-Host "`nAdding remote..." -ForegroundColor Cyan
git remote add origin $repoUrl

Write-Host "`nPushing to GitHub..." -ForegroundColor Cyan
git push -u origin main

Write-Host "`nDone! Check your repo on GitHub." -ForegroundColor Green
