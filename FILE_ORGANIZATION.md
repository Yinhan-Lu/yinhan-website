# File Organization & Security Guidelines

## 📁 Where to Put Your Files

### ✅ Public Files (Will be uploaded to GitHub)

#### CVs and Resumes
- **Location**: `assets/pdf/`
- **Example**: `assets/pdf/Yinhan_Lu_CV.pdf`
- **Note**: These will be publicly accessible at `https://yinhanlu.me/assets/pdf/your-cv.pdf`

#### Photos
- **Location**: `assets/img/`
- **Example**: `assets/img/prof_pic.jpg`

#### Other Public Documents
- **Location**: `assets/pdf/` or `assets/docs/`

### ❌ Private Files (Should NOT be in repository)

#### Transcripts
- **Do NOT put in repository** - Contains sensitive grade information
- **Recommended**: Keep in a separate folder outside the repository
- **Example wrong location**: ❌ `transcript_2025_10.pdf` (root directory)
- **Correct**: Store outside git repo, like `~/Documents/Personal/transcripts/`

#### Backup Files
- Automatically ignored by `.gitignore`
- **Pattern**: `*.bak`, `*.json.bak`
- **Note**: Delete these files regularly

#### Temporary Scripts
- Automatically ignored by `.gitignore`
- **Pattern**: `deploy-manual.sh`, `*_CHANGES.md`, `HOW_TO_UPDATE.md`

## 🔒 Security Features

### .gitignore Protection
The `.gitignore` file automatically prevents these files from being uploaded:

```gitignore
# Sensitive/Personal files
/*.pdf                    # PDFs in root directory
transcript*.pdf          # Any transcript files
*_transcript.pdf        # Alternative naming
*.bak                   # Backup files

# Allow only CVs in correct location
!assets/pdf/*.pdf       # Exception for CV folder
```

### Deploy Script Security Check
The `deploy-quick.sh` script includes automatic security checks:

1. ✅ Scans for PDFs in wrong locations
2. ✅ Detects transcript files anywhere in repo
3. ✅ Finds backup files
4. ✅ Warns you before deployment
5. ✅ Allows you to cancel if issues found

## 📝 How to Use

### Moving Files to Correct Locations

```bash
# Move CV to correct location
mv your_cv.pdf assets/pdf/Yinhan_Lu_CV.pdf

# Move transcript OUT of repository
mv transcript_2025_10.pdf ~/Documents/Personal/

# Delete backup files
rm *.bak
```

### Before Deploying

1. Run the deploy script: `./deploy-quick.sh`
2. Security check will run automatically
3. If warnings appear, fix the issues or confirm to continue
4. Review changes before confirming deployment

## 🚨 What if Sensitive Files Were Already Uploaded?

If you accidentally uploaded sensitive files to GitHub:

1. **Remove from git history**:
   ```bash
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch transcript_2025_10.pdf' \
     --prune-empty --tag-name-filter cat -- --all
   ```

2. **Force push** (⚠️ dangerous - make backup first):
   ```bash
   git push origin --force --all
   ```

3. **Better**: Contact GitHub support to purge the file from their servers

## 📋 Checklist Before Each Deployment

- [ ] CV is in `assets/pdf/` directory
- [ ] No transcripts in repository
- [ ] No backup files (*.bak)
- [ ] No temporary files in root directory
- [ ] Run `./deploy-quick.sh` and pass security check

## 🎯 Summary

**Remember**:
- ✅ CVs go in `assets/pdf/` - they're meant to be public
- ❌ Transcripts stay OUT of git - they're private
- 🔒 Security script will catch mistakes
- 🛡️ `.gitignore` provides double protection
