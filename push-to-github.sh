#!/bin/bash
# Script to push the Globomantics JavaScript Pack to GitHub

# Set colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}  Push Globomantics JavaScript Pack to GitHub${NC}"
echo -e "${BLUE}====================================================${NC}"

# Verify the GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${YELLOW}GitHub CLI not found. Please install it first.${NC}"
    echo "Visit: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated with GitHub CLI
echo -e "${GREEN}Checking GitHub CLI authentication...${NC}"
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}You need to authenticate with GitHub CLI.${NC}"
    echo "Run: gh auth login"
    exit 1
fi

# Verify git is initialized
if [ ! -d .git ]; then
    echo -e "${GREEN}Initializing git repository...${NC}"
    git init
fi

# Add all files to git
echo -e "${GREEN}Adding files to git...${NC}"
git add .

# Commit changes
echo -e "${GREEN}Committing changes...${NC}"
git commit -m "Initial commit of Globomantics JavaScript Security Pack"

# Create a new repository on GitHub
echo -e "${GREEN}Creating a new repository on GitHub...${NC}"
echo -e "${YELLOW}Enter the name for your GitHub repository (default: globomantics-js-pack):${NC}"
read -r repo_name
repo_name=${repo_name:-globomantics-js-pack}

echo -e "${GREEN}Creating repository: ${repo_name}${NC}"
gh repo create "${repo_name}" --public --source=. --push

echo -e "${GREEN}Repository has been created and code pushed successfully!${NC}"
echo -e "Visit your repository at: https://github.com/$(gh api user | jq -r .login)/${repo_name}"

echo -e "${GREEN}Setting up GitHub Actions...${NC}"
echo "GitHub Actions workflows are included in .github/workflows directory."
echo "They will run automatically on your next push or pull request."

echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}  Next Steps:${NC}"
echo -e "${BLUE}====================================================${NC}"
echo "1. Visit your repository on GitHub"
echo "2. Go to the Actions tab to monitor workflow runs"
echo "3. Check the Security tab after CodeQL has run"
echo "4. Clone the repository to other machines with:"
echo "   gh repo clone $(gh api user | jq -r .login)/${repo_name}"
echo -e "${BLUE}====================================================${NC}"

exit 0 