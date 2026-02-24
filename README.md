# TSG Payslip Generator

A web-based payslip generator application with Google OAuth authentication for admin access.

## Features

- **Google OAuth Authentication**: Secure admin login using Google accounts
- **Employee Master Management**: Add, update, and manage employee records
- **Payslip Generation**: Generate professional PDF payslips
- **Supabase Integration**: Cloud persistence – data is shared across browsers/devices
- **Data Export/Import**: Backup and restore employee data (JSON)
- **Auto-logout**: Automatic session timeout after 10 minutes of inactivity
- **Soft Delete**: Employee records can be soft-deleted with audit logs
- **TwinStar Default Logo**: Built-in company logo available via "Use Default Logo" button

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
9. Open `index.html` and replace the existing `data-client_id` value with your actual Client ID:
   ```html
   <div id="g_id_onload"
        data-client_id="YOUR_ACTUAL_CLIENT_ID_HERE"
        ...>
   ```

### 2. Supabase Setup (Optional – enables cloud persistence)

When Supabase is configured the app stores data in the cloud instead of `localStorage`.
Data is then accessible from any browser or device.

#### a) Create a Supabase project

1. Sign up at [supabase.com](https://supabase.com) and create a new project.
2. Go to **SQL Editor** in your project dashboard and run the schema script:
   ```
   supabase_setup.sql   ← provided in this repository
   ```
   This creates the `employees` and `delete_logs` tables.

#### b) Configure credentials

```bash
# 1. Copy the example config
cp config.example.js config.js

# 2. Edit config.js and fill in your project values
#    (Find them at: Settings → API in your Supabase dashboard)
nano config.js
```

`config.js` contents:
```javascript
var SUPABASE_URL      = 'https://your-project-ref.supabase.co';
var SUPABASE_ANON_KEY = 'your-anon-key-here';
```

> **Note**: `config.js` is listed in `.gitignore` and must **never** be committed.
> The app falls back to `localStorage` automatically if `config.js` is absent or contains empty strings.

### 3. Running the Application

The app **must** be served from a web server (not opened as `file://`) so that:
- Google OAuth works correctly
- `config.js` and `assets/logo.svg` can be loaded

#### Option A: Python built-in server
```bash
python3 -m http.server 8080
```
Then open: `http://localhost:8080`

#### Option B: Node.js http-server
```bash
npx http-server -p 8080
```
Then open: `http://localhost:8080`

## Usage

### Admin Login
1. Click on the Google Sign-In button on the admin login page
2. Sign in with your `@twinstarsgroup.com` Google account
3. Once authenticated, you'll have access to all admin features

### Adding Employees
1. Fill in the employee details in the "Employee Master Entry" section
2. Click **"Use Default Logo"** to load the TwinStar logo, or paste your own Base64 image
3. Click "Save / Update Employee"

### Generating Payslips
1. Select an employee from the dropdown
2. Enter the salary period and salary components
3. Click "Calculate" to compute the net salary
4. Click "Download PDF" to generate and download the payslip

### Clearing Form Data
- Click the "🗑️ Clear All Fields" button at the bottom of the Payslip Generator section
- Confirm the action to clear all form fields

### Data Backup / Restore
- Use **"Export Data (Backup)"** to download a JSON backup of all employee records
- Use **"Import Data (Restore)"** to restore from a backup file
  (Works with both localStorage and Supabase)

## Security Notes

### Client-Side Authentication Limitations
⚠️ **Important**: This application uses client-side JWT token parsing without server-side verification. This means:
- Token authenticity is not verified cryptographically
- This is suitable for internal/demo use only

### Production Security Recommendations
For production use, you should:
1. Implement server-side token verification using Google's token verification endpoint
2. Restrict access to specific email domains (already restricted to `twinstarsgroup.com`)
3. Enable Row Level Security (RLS) in Supabase (see comments in `supabase_setup.sql`)
4. Implement proper HTTPS for all communications
5. Add rate limiting and additional security measures

## Data Storage

| Mode | When active | Notes |
|------|-------------|-------|
| **Supabase** | `config.js` is present with valid credentials | Shared across browsers/devices |
| **localStorage** | `config.js` absent or empty credentials | Browser-local only; export regularly |

The storage indicator in the data-warning card shows which mode is active after login.

## Asset: TwinStar Logo

The TwinStar Group logo is stored as `assets/logo.svg`.  
In the Employee Master form, click **"Use Default Logo"** to load and convert it to a
PNG data URL suitable for embedding in generated PDF payslips.

## Browser Compatibility

- Modern browsers with ES6 + async/await support
- Google Chrome (recommended)
- Mozilla Firefox
- Microsoft Edge
- Safari

## Technical Stack

- Pure HTML/CSS/JavaScript (no build process required)
- [jsPDF 2.5.1](https://github.com/parallax/jsPDF) for PDF generation
- [Google Identity Services](https://developers.google.com/identity/gsi/web) for authentication
- [@supabase/supabase-js 2.49.1](https://github.com/supabase/supabase-js) for cloud persistence
- `localStorage` fallback when Supabase is not configured

## Support

For issues or questions, please open an issue in the GitHub repository.

## License

This project is open source and available under the [MIT License](LICENSE).
