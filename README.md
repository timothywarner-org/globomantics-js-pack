# Globomantics JavaScript Security Query Pack

A comprehensive CodeQL learning package for identifying security vulnerabilities in JavaScript applications. This repository is designed for educational purposes as part of Tim Warner's Pluralsight GHAS CodeQL training class.

## Repository Structure

- **CodeQL Query Pack**: Custom queries for JavaScript security vulnerabilities
- **Express Test App**: A deliberately vulnerable Express.js application for testing
- **Documentation**: Guides for using CodeQL and analyzing results
- **Scripts**: Helper scripts for running CodeQL analysis and GitHub integration

## Contents

### 1. CodeQL Query Pack

Three custom security queries for JavaScript:

- **Detect Eval Use** (`queries/javascript/detect-eval-use.ql`): Identifies potentially dangerous uses of `eval()`, `Function()` constructor, and similar functions that can lead to code injection.

- **HTTP Header Injection** (`queries/javascript/http-header-injection.ql`): Detects when user-controlled data flows into HTTP headers without proper sanitization.

- **Insecure Randomness** (`queries/javascript/insecure-randomness.ql`): Flags instances where `Math.random()` is used in security-sensitive contexts instead of cryptographically secure alternatives.

The queries are organized in a suite (`queries/javascript/security-suite.qls`) for easy execution.

### 2. Express Test Application

A deliberately vulnerable Express.js application (`express-testapp/`) that contains:

- **Eval vulnerabilities**: Multiple instances of `eval()` and `Function` constructor usage
- **HTTP header injection**: Direct user input used in response headers
- **Insecure randomness**: `Math.random()` used for tokens and security contexts
- **Path traversal**: Unsanitized file paths
- **Command injection**: Unsanitized input to exec
- **XSS vulnerabilities**: Unsanitized rendering in EJS templates
- **JWT vulnerabilities**: Weak secrets and insecure configuration
- **Prototype pollution**: Recursive object merging without checks
- **Insecure file upload**: Missing file type validation
- **Hardcoded credentials**: In user models and authentication

All vulnerabilities are clearly marked with comments for educational purposes.

### 3. Documentation

- **Query Development Guide** (`docs/query-development-guide.md`): How to write custom CodeQL queries
- **CodeQL Workflow Guide** (`docs/codeql-workflow.md`): Understanding the CodeQL workflow
- **SARIF Viewer Guide** (`docs/sarif-viewer-guide.md`): Working with SARIF results effectively

### 4. Exercises

- **Template Query** (`exercises/template-query.ql`): Starting point for creating your own queries
- **Exercise Tasks** (`exercises/README.md`): Guided exercises for learning CodeQL
- **Example Exercise** (`exercises/exposed-secrets-exercise.ql`): Sample exercise for finding hardcoded secrets

### 5. Scripts and Automation

- **CodeQL Analysis Scripts**: 
  - For Linux/Mac (`run-codeql-analysis.sh`)
  - For Windows (`run-codeql-analysis.bat`)
  - Both with detailed step-by-step documentation and colorized output

- **GitHub Push Script** (`push-to-github.sh`): 
  - Creates and pushes to a GitHub repository
  - Sets up GitHub Actions automatically
  - Handles authentication through GitHub CLI

- **GitHub Actions Workflow** (`.github/workflows/codeql-analysis.yml`):
  - Creates CodeQL database
  - Runs the custom query suite
  - Uploads results as SARIF
  - Stores the database as an artifact

### 6. Project Configuration

- **MIT License** (`LICENSE`): Open-source licensing
- **Node.js gitignore** (`.gitignore`): Comprehensive ignore patterns
- **Git Attributes** (`.gitattributes`): Ensures consistent line endings
- **CodeQL Configuration**:
  - `codeql-pack.yml`: Metadata for sharing and importing the pack
  - `qlpack.yml`: Dependencies and CodeQL configuration

## Getting Started

### Prerequisites

- [CodeQL CLI](https://github.com/github/codeql-cli-binaries/releases) installed
- Node.js and npm (for the Express test app)
- Git
- [GitHub CLI](https://cli.github.com/) (optional, for pushing to GitHub)

### Quick Start

1. Clone this repository:
   ```bash
   git clone [repository-url]
   cd globomantics-js-pack
   ```

2. Run the CodeQL analysis script:
   ```bash
   # On Linux/Mac
   ./run-codeql-analysis.sh
   
   # On Windows
   run-codeql-analysis.bat
   ```

3. To explore the vulnerable Express application:
   ```bash
   cd express-testapp
   npm install
   npm start
   ```

4. Push to GitHub to enable GitHub Advanced Security:
   ```bash
   ./push-to-github.sh
   ```

## Using the Query Pack

### Local Analysis

```bash
# Create a CodeQL database for any JavaScript project
codeql database create mydb --language=javascript --source-root=/path/to/source

# Run the security suite
codeql database analyze mydb globomantics/javascript-security-queries:security-suite.qls --format=sarif-latest --output=results.sarif

# Run individual queries
codeql database analyze mydb globomantics/javascript-security-queries:queries/javascript/detect-eval-use.ql --format=sarif-latest --output=eval-results.sarif
```

### GitHub Integration

1. Push your code to GitHub
2. Enable GitHub Advanced Security
3. CodeQL will automatically run using the workflow in `.github/workflows/codeql-analysis.yml`
4. View results in the Security tab of your repository

## SARIF Reports

This project includes tooling to generate and view SARIF (Static Analysis Results Interchange Format) reports:

1. Generated by both GitHub Actions and local CLI scripts
2. Converted to CSV for easier viewing (`codeql bqrs decode`)
3. Detailed guide for viewing and interpreting reports in `docs/sarif-viewer-guide.md`
4. VS Code SARIF viewer extension recommended for local analysis

## Express Test App Vulnerabilities

The intentionally vulnerable Express application includes:

### Server-side Vulnerabilities
- **Eval Usage**: `/calculate` endpoint and template processing
- **HTTP Header Injection**: `/redirect` endpoint 
- **Insecure Randomness**: Token generation in multiple places
- **Command Injection**: Admin ping functionality
- **Path Traversal**: File download functionality 
- **Weak Authentication**: Easily bypassed admin checks
- **Hardcoded Secrets**: JWT secrets, encryption keys
- **Insecure File Operations**: Unsanitized log files
- **Prototype Pollution**: API configuration endpoint

### Client-side Vulnerabilities
- **XSS**: Unsanitized template rendering
- **Local Storage Misuse**: Password storage in browser
- **Insecure Cookies**: Missing secure and httpOnly flags
- **Global Variable Exposure**: Sensitive data in global scope
- **External Script Loading**: Without integrity checking

## Learning Resources

- [CodeQL Documentation](https://codeql.github.com/docs/)
- [GitHub Advanced Security Documentation](https://docs.github.com/en/github/getting-started-with-github/about-github-advanced-security)
- [Pluralsight GHAS Training Courses](https://www.pluralsight.com/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

The Express Test App contains INTENTIONAL security vulnerabilities for educational purposes only. DO NOT use this code in production environments. 