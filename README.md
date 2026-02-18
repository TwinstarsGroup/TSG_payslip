# TSG Payslip Generator

A web-based payslip generator application with Google OAuth authentication for admin access.

## Features

- **Google OAuth Authentication**: Secure admin login using Google accounts
- **Employee Master Management**: Add, update, and manage employee records
- **Payslip Generation**: Generate professional PDF payslips
- **Data Export/Import**: Backup and restore employee data
- **Auto-logout**: Automatic session timeout after 10 minutes of inactivity
- **Soft Delete**: Employee records can be soft-deleted with audit logs

## Setup Instructions

### 1. Google OAuth Configuration

To enable Google Sign-In authentication:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google+ API
4. Go to **Credentials** → **Create Credentials** → **OAuth 2.0 Client ID**
5. Configure the OAuth consent screen if prompted
6. Choose **Web application** as the application type
7. Add authorized JavaScript origins (e.g., `http://localhost:8080` for local testing)
8. Copy the **Client ID**
9. Open `index.html` and replace `YOUR_GOOGLE_CLIENT_ID` with your actual Client ID:
   ```html
   <div id="g_id_onload"
        data-client_id="YOUR_ACTUAL_CLIENT_ID_HERE"
        ...>
   ```

### 2. Running the Application

#### Option 1: Using Python's HTTP Server
```bash
python3 -m http.server 8080
```
Then open your browser to `http://localhost:8080/index.html`

#### Option 2: Using Node.js http-server
```bash
npx http-server -p 8080
```
Then open your browser to `http://localhost:8080/index.html`

#### Option 3: Direct File Access
Simply open `index.html` in your web browser. However, Google OAuth may require serving from a web server.

## Usage

### Admin Login
1. Click on the Google Sign-In button on the admin login page
2. Sign in with your Google account
3. Once authenticated, you'll have access to all admin features

### Adding Employees
1. Fill in the employee details in the "Employee Master Entry" section
2. Click "Save / Update Employee"
3. Employee data is stored locally in your browser

### Generating Payslips
1. Select an employee from the dropdown
2. Enter the salary period and salary components
3. Click "Calculate" to compute the net salary
4. Click "Download PDF" to generate and download the payslip

### Clearing Form Data
- Click the "🗑️ Clear All Fields" button at the bottom of the Payslip Generator section
- Confirm the action to clear all form fields

### Data Backup
- Use the "Export Data (Backup)" button to download a JSON backup of all employee records
- Use the "Import Data (Restore)" button to restore from a backup file

## Security Notes

### Client-Side Authentication Limitations
⚠️ **Important**: This application uses client-side JWT token parsing without server-side verification. This means:
- Token authenticity is not verified cryptographically
- Any Google account can sign in (no domain restrictions by default)
- This is suitable for demo/personal use only

### Production Security Recommendations
For production use, you should:
1. Implement server-side token verification using Google's token verification endpoint
2. Restrict access to specific email domains (e.g., only allow `@yourcompany.com` emails)
3. Store sensitive data in a secure backend database instead of localStorage
4. Implement proper HTTPS for all communications
5. Add rate limiting and additional security measures

### Email Domain Restriction Example
To restrict access to specific domains, add this to the `handleCredentialResponse` function:
```javascript
const allowedDomains = ['yourcompany.com', 'yourdomain.com'];
const emailDomain = currentAdminEmail.split('@')[1];
if (!allowedDomains.includes(emailDomain)) {
  alert('Access denied: Your email domain is not authorized');
  sessionStorage.removeItem("adminAuth");
  sessionStorage.removeItem("adminEmail");
  return;
}
```

## Data Storage

- All employee data is stored in the browser's `localStorage`
- Data persists only in the current browser on the current device
- Clearing browser data will delete all employee records
- **Important**: Always backup your data regularly using the Export feature

## Browser Compatibility

- Modern browsers with ES6 support
- Google Chrome (recommended)
- Mozilla Firefox
- Microsoft Edge
- Safari

## Technical Stack

- Pure HTML/CSS/JavaScript (no build process required)
- [jsPDF](https://github.com/parallax/jsPDF) for PDF generation
- [Google Identity Services](https://developers.google.com/identity/gsi/web) for authentication
- localStorage for data persistence

## Support

For issues or questions, please open an issue in the GitHub repository.

## License

This project is open source and available under the [MIT License](LICENSE).
