/**
 * Example vulnerable JavaScript application
 * 
 * This file contains several security vulnerabilities that can be detected
 * using the Globomantics JavaScript Security Query Pack.
 */

const express = require('express');
const app = express();
app.use(express.json());

// Example 1: Unsafe eval() usage - detected by detect-eval-use.ql
app.get('/calculate', (req, res) => {
  const formula = req.query.formula;
  
  // VULNERABLE: Using eval with user input
  const result = eval(formula); 
  
  res.json({ result });
});

// Example 2: HTTP Header Injection - detected by http-header-injection.ql
app.get('/redirect', (req, res) => {
  const redirectUrl = req.query.url;
  
  // VULNERABLE: Using user input directly in a header
  res.setHeader('Location', redirectUrl);
  res.status(302).send('Redirecting...');
});

// Example 3: Insecure Randomness - detected by insecure-randomness.ql
app.post('/register', (req, res) => {
  const username = req.body.username;
  const password = req.body.password;
  
  // VULNERABLE: Using Math.random() for security-sensitive operations
  const authToken = generateInsecureToken();
  
  res.json({ 
    success: true, 
    message: 'User registered successfully',
    token: authToken
  });
});

function generateInsecureToken() {
  // VULNERABLE: Using Math.random() for token generation
  const tokenValue = Math.random().toString(36).substring(2);
  return tokenValue;
}

// A secure alternative would be:
function generateSecureToken() {
  const crypto = require('crypto');
  return crypto.randomBytes(32).toString('hex');
}

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
}); 