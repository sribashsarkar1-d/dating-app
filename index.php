<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dating App API Documentation</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #FF4B4B;
            --primary-hover: #FF2E2E;
            --bg: #0f172a;
            --surface: rgba(30, 41, 59, 0.7);
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border: rgba(255, 255, 255, 0.1);
            --method-get: #10b981;
            --method-post: #3b82f6;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg);
            color: var(--text-main);
            line-height: 1.6;
            min-height: 100vh;
            background-image: 
                radial-gradient(at 0% 0%, rgba(255, 75, 75, 0.15) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(59, 130, 246, 0.15) 0px, transparent 50%);
            background-attachment: fixed;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 4rem 2rem;
        }

        header {
            text-align: center;
            margin-bottom: 4rem;
            animation: fadeInDown 0.8s ease-out;
        }

        h1 {
            font-size: 3rem;
            font-weight: 700;
            background: linear-gradient(to right, #FF4B4B, #FF9090);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 1rem;
            letter-spacing: -1px;
        }

        p.subtitle {
            color: var(--text-muted);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto 2rem auto;
        }

        .controls {
            display: flex;
            justify-content: center;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .base-url-input {
            background: rgba(15, 23, 42, 0.8);
            border: 1px solid var(--border);
            color: white;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            width: 300px;
            font-size: 1rem;
            outline: none;
            transition: all 0.3s ease;
        }

        .base-url-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(255, 75, 75, 0.2);
        }

        .btn {
            background: linear-gradient(to right, var(--primary), var(--primary-hover));
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            font-size: 0.95rem;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 75, 75, 0.3);
        }

        .api-category {
            margin-bottom: 3rem;
            animation: fadeIn 1s ease-out;
        }

        .category-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--border);
            color: #cbd5e1;
        }

        .api-card {
            background: var(--surface);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .api-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--primary);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .api-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.2), 0 4px 6px -2px rgba(0, 0, 0, 0.1);
            border-color: rgba(255, 255, 255, 0.2);
        }

        .api-card:hover::before {
            opacity: 1;
        }

        .api-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 0.75rem;
            flex-wrap: wrap;
        }

        .method {
            font-weight: 700;
            font-size: 0.85rem;
            padding: 0.25rem 0.75rem;
            border-radius: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .method.post {
            background: rgba(59, 130, 246, 0.1);
            color: var(--method-post);
            border: 1px solid rgba(59, 130, 246, 0.2);
        }

        .method.get {
            background: rgba(16, 185, 129, 0.1);
            color: var(--method-get);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .endpoint-wrapper {
            flex-grow: 1;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .endpoint {
            font-family: monospace;
            font-size: 1.1rem;
            color: #e2e8f0;
        }

        .copy-url-btn {
            background: transparent;
            border: 1px solid rgba(255,255,255,0.2);
            color: var(--text-muted);
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.75rem;
            transition: all 0.2s ease;
        }

        .copy-url-btn:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            border-color: rgba(255,255,255,0.5);
        }

        .api-desc {
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        .api-details {
            display: none;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px dashed var(--border);
            animation: slideDown 0.3s ease-out;
        }

        .api-card.active .api-details {
            display: block;
        }

        .detail-group {
            margin-bottom: 1rem;
        }

        .detail-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .code-block {
            background: #0f172a;
            padding: 1rem;
            border-radius: 8px;
            font-family: monospace;
            font-size: 0.9rem;
            color: #38bdf8;
            border: 1px solid rgba(0,0,0,0.5);
            overflow-x: auto;
            position: relative;
        }

        .copy-code-btn {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            background: rgba(255,255,255,0.1);
            border: none;
            color: var(--text-muted);
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .copy-code-btn:hover {
            color: white;
            background: rgba(255,255,255,0.2);
        }

        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .toast {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            background: #10b981;
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
            transform: translateY(100px);
            opacity: 0;
            transition: all 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            font-weight: 500;
        }

        .toast.show {
            transform: translateY(0);
            opacity: 1;
        }

        @media (max-width: 768px) {
            .container { padding: 2rem 1rem; }
            h1 { font-size: 2.2rem; }
            .endpoint { font-size: 0.95rem; }
            .controls { flex-direction: column; }
            .base-url-input { width: 100%; }
        }
    </style>
</head>
<body>

    <div class="container">
        <header>
            <h1>Dating App API v1.0</h1>
            <p class="subtitle">Complete documentation for the REST API. Set your base URL below to easily copy full endpoint addresses.</p>
            
            <div class="controls">
                <input type="text" id="baseUrl" class="base-url-input" value="http://localhost/dating-api-point" placeholder="Enter Base URL">
                <a href="postman-collection2.json" download class="btn">
                    <svg style="width:16px;height:16px;vertical-align:middle;margin-right:6px" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
                    Download Postman Collection
                </a>
            </div>
        </header>

        <!-- REGISTRATION FLOW -->
        <div class="api-category">
            <h2 class="category-title">1. Registration Flow</h2>
            
            <div class="api-card" onclick="toggleDetails(this, event)">
                <div class="api-header">
                    <span class="method post">POST</span>
                    <div class="endpoint-wrapper">
                        <span class="endpoint" data-path="/api/send-otp.php">/api/send-otp.php</span>
                        <button class="copy-url-btn" onclick="copyUrl(this, '/api/send-otp.php', event)">Copy URL</button>
                    </div>
                </div>
                <p class="api-desc">Initiates registration by sending a 6-digit OTP to the user's email.</p>
                <div class="api-details">
                    <div class="detail-group">
                        <div class="detail-label">Request Body (JSON)</div>
                        <div class="code-block">
                            <button class="copy-code-btn" onclick="copyCode(this, event)">Copy</button>
<pre>
{
    "email": "user@example.com"
}
</pre>
                        </div>
                    </div>
                </div>
            </div>

            <div class="api-card" onclick="toggleDetails(this, event)">
                <div class="api-header">
                    <span class="method post">POST</span>
                    <div class="endpoint-wrapper">
                        <span class="endpoint" data-path="/api/verify-otp.php">/api/verify-otp.php</span>
                        <button class="copy-url-btn" onclick="copyUrl(this, '/api/verify-otp.php', event)">Copy URL</button>
                    </div>
                </div>
                <p class="api-desc">Verifies the OTP and returns a temporary registration token.</p>
                <div class="api-details">
                    <div class="detail-group">
                        <div class="detail-label">Request Body (JSON)</div>
                        <div class="code-block">
                            <button class="copy-code-btn" onclick="copyCode(this, event)">Copy</button>
<pre>
{
    "email": "user@example.com",
    "otp": "123456"
}
</pre>
                        </div>
                    </div>
                    <div class="detail-group">
                        <div class="detail-label">Response</div>
                        <div class="code-block"><pre>Returns: registration_token</pre></div>
                    </div>
                </div>
            </div>

            <div class="api-card" onclick="toggleDetails(this, event)">
                <div class="api-header">
                    <span class="method post">POST</span>
                    <div class="endpoint-wrapper">
                        <span class="endpoint" data-path="/api/upload-photo.php">/api/upload-photo.php</span>
                        <button class="copy-url-btn" onclick="copyUrl(this, '/api/upload-photo.php', event)">Copy URL</button>
                    </div>
                </div>
                <p class="api-desc">Uploads one or multiple temporary photos before final registration.</p>
                <div class="api-details">
                    <div class="detail-group">
                        <div class="detail-label">Request Body (FormData)</div>
                        <div class="code-block">
                            <button class="copy-code-btn" onclick="copyCode(this, event)">Copy</button>
<pre>
photos[] : [File 1]
photos[] : [File 2]
</pre>
                        </div>
                    </div>
                    <div class="detail-group">
                        <div class="detail-label">Response</div>
                        <div class="code-block"><pre>Returns: array of filenames</pre></div>
                    </div>
                </div>
            </div>

            <div class="api-card" onclick="toggleDetails(this, event)">
                <div class="api-header">
                    <span class="method post">POST</span>
                    <div class="endpoint-wrapper">
                        <span class="endpoint" data-path="/api/register.php">/api/register.php</span>
                        <button class="copy-url-btn" onclick="copyUrl(this, '/api/register.php', event)">Copy URL</button>
                    </div>
                </div>
                <p class="api-desc">Finalizes the registration and saves all user data inside a MySQL Transaction.</p>
                <div class="api-details">
                    <div class="detail-group">
                        <div class="detail-label">Headers</div>
                        <div class="code-block"><pre>Authorization: Bearer {registration_token}</pre></div>
                    </div>
                    <div class="detail-group">
                        <div class="detail-label">Request Body (JSON)</div>
                        <div class="code-block">
                            <button class="copy-code-btn" onclick="copyCode(this, event)">Copy</button>
<pre>
{
    "first_name": "John",
    "last_name": "Doe",
    "birth_date": "1995-08-15",
    "gender_identity_id": 1,
    "photo_filenames": ["temp_123.jpg", "temp_456.jpg"]
}
</pre>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- LOGIN FLOW -->
        <div class="api-category">
            <h2 class="category-title">2. Login Flow</h2>
            
            <div class="api-card" onclick="toggleDetails(this, event)">
                <div class="api-header">
                    <span class="method post">POST</span>
                    <div class="endpoint-wrapper">
                        <span class="endpoint" data-path="/api/login-send-otp.php">/api/login-send-otp.php</span>
                        <button class="copy-url-btn" onclick="copyUrl(this, '/api/login-send-otp.php', event)">Copy URL</button>
                    </div>
                </div>
                <p class="api-desc">Sends a secure OTP to an existing user's email for login.</p>
                <div class="api-details">
                    <div class="detail-group">
                        <div class="detail-label">Request Body (JSON)</div>
                        <div class="code-block">
                            <button class="copy-code-btn" onclick="copyCode(this, event)">Copy</button>
<pre>
{
    "email": "user@example.com"
}
</pre>
                        </div>
                    </div>
                </div>
            </div>

            <div class="api-card" onclick="toggleDetails(this, event)">
                <div class="api-header">
                    <span class="method post">POST</span>
                    <div class="endpoint-wrapper">
                        <span class="endpoint" data-path="/api/login-verify-otp.php">/api/login-verify-otp.php</span>
                        <button class="copy-url-btn" onclick="copyUrl(this, '/api/login-verify-otp.php', event)">Copy URL</button>
                    </div>
                </div>
                <p class="api-desc">Verifies login OTP and generates a secure JWT Auth Token.</p>
                <div class="api-details">
                    <div class="detail-group">
                        <div class="detail-label">Request Body (JSON)</div>
                        <div class="code-block">
                            <button class="copy-code-btn" onclick="copyCode(this, event)">Copy</button>
<pre>
{
    "email": "user@example.com",
    "otp": "123456"
}
</pre>
                        </div>
                    </div>
                    <div class="detail-group">
                        <div class="detail-label">Response</div>
                        <div class="code-block"><pre>Returns: auth_token (JWT)</pre></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- USER DATA -->
        <div class="api-category">
            <h2 class="category-title">3. User Data & Profiles</h2>
            
            <div class="api-card" onclick="toggleDetails(this, event)">
                <div class="api-header">
                    <span class="method get">GET</span>
                    <div class="endpoint-wrapper">
                        <span class="endpoint" data-path="/api/get-current-user.php">/api/get-current-user.php</span>
                        <button class="copy-url-btn" onclick="copyUrl(this, '/api/get-current-user.php', event)">Copy URL</button>
                    </div>
                </div>
                <p class="api-desc">Fetches the complete profile and photos of the logged-in user.</p>
                <div class="api-details">
                    <div class="detail-group">
                        <div class="detail-label">Headers</div>
                        <div class="code-block"><pre>Authorization: Bearer {auth_token}</pre></div>
                    </div>
                </div>
            </div>

            <div class="api-card" onclick="toggleDetails(this, event)">
                <div class="api-header">
                    <span class="method get">GET</span>
                    <div class="endpoint-wrapper">
                        <span class="endpoint" data-path="/api/get-all-users.php?page=1&limit=20">/api/get-all-users.php?page=1&limit=20</span>
                        <button class="copy-url-btn" onclick="copyUrl(this, '/api/get-all-users.php?page=1&limit=20', event)">Copy URL</button>
                    </div>
                </div>
                <p class="api-desc">Fetches a paginated list of all active users (excluding current user) with public data.</p>
                <div class="api-details">
                    <div class="detail-group">
                        <div class="detail-label">Headers</div>
                        <div class="code-block"><pre>Authorization: Bearer {auth_token}</pre></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- MASTER DATA -->
        <div class="api-category">
            <h2 class="category-title">4. Master Data</h2>
            
            <div class="api-card" onclick="toggleDetails(this, event)">
                <div class="api-header">
                    <span class="method get">GET</span>
                    <div class="endpoint-wrapper">
                        <span class="endpoint" data-path="/api/master/all-master-data.php">/api/master/all-master-data.php</span>
                        <button class="copy-url-btn" onclick="copyUrl(this, '/api/master/all-master-data.php', event)">Copy URL</button>
                    </div>
                </div>
                <p class="api-desc">Fetches all master data required for registration (genders, goals, etc.) with 5-minute caching.</p>
                <div class="api-details">
                    <div class="detail-group">
                        <div class="detail-label">Response (JSON)</div>
                        <div class="code-block"><pre>Returns: Huge JSON with all master tables data</pre></div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <div id="toast" class="toast">Copied to clipboard!</div>

    <script>
        // Set dynamic base URL initially
        document.addEventListener("DOMContentLoaded", () => {
            const currentUrl = window.location.origin + window.location.pathname.replace('/index.php', '');
            document.getElementById('baseUrl').value = currentUrl;
        });

        function toggleDetails(element, event) {
            // Prevent toggling if clicked on a button inside header
            if (event && event.target.tagName.toLowerCase() === 'button') {
                return;
            }
            element.classList.toggle('active');
        }

        function copyUrl(btn, path, event) {
            event.stopPropagation();
            let baseUrl = document.getElementById('baseUrl').value;
            // Remove trailing slash if any
            if (baseUrl.endsWith('/')) {
                baseUrl = baseUrl.slice(0, -1);
            }
            const fullUrl = baseUrl + path;
            
            navigator.clipboard.writeText(fullUrl).then(() => {
                showToast("Endpoint URL copied!");
                
                const originalText = btn.innerText;
                btn.innerText = "Copied!";
                setTimeout(() => { btn.innerText = originalText; }, 2000);
            });
        }

        function copyCode(btn, event) {
            event.stopPropagation();
            const preElement = btn.nextElementSibling;
            if (preElement) {
                const codeText = preElement.innerText.trim();
                navigator.clipboard.writeText(codeText).then(() => {
                    showToast("Code copied!");
                    
                    const originalText = btn.innerText;
                    btn.innerText = "Copied!";
                    setTimeout(() => { btn.innerText = originalText; }, 2000);
                });
            }
        }

        function showToast(msg) {
            const toast = document.getElementById('toast');
            toast.innerText = msg;
            toast.classList.add('show');
            setTimeout(() => {
                toast.classList.remove('show');
            }, 3000);
        }
    </script>
</body>
</html>
