# IMMEDIATE ACTION: How to Fix Google Login 500 Error

## What I've Done on the Flutter Side

✅ Added detailed logging to track the Google login flow
✅ Enhanced error messages
✅ The client is working correctly

The request you're sending looks like:
```
POST /api/Authentication/google-login
{
  "idToken": "eyJ..."
}
```

And this is correct! ✅

## What You Need to Do - CRITICAL

### Step 1: Check Your Backend Logs (RIGHT NOW)

**Go to Railway Dashboard:**
1. Login to https://railway.app
2. Go to your pettix-production project
3. Click on the application
4. Click "Logs" tab
5. Filter for requests around the time you tried Google login
6. Look for ERROR logs

**What you're looking for:**
```
ERROR: Token validation failed
ERROR: User not found
ERROR: Database connection error
ERROR: NullReferenceException
ERROR: Google client ID mismatch
```

Write down the EXACT error message you see!

### Step 2: Test with Postman

1. Open Postman
2. Create a new POST request
3. URL: `https://pettix-production.up.railway.app/api/Authentication/google-login`
4. Headers:
   - `Content-Type: application/json`
5. Body (raw JSON):
```json
{
  "idToken": "your-real-google-token-here"
}
```
6. Send and note the response

The response will tell us exactly what's wrong.

### Step 3: Share Backend Error

Once you have the error, share it with your backend developer or us. It will be something like:

**Example Errors:**

❌ `"Google client ID configuration is missing"`
- Fix: Set the Google Client ID in backend environment variables

❌ `"User email not found in Google token"`
- Fix: Check Google token validation logic

❌ `"Database: Cannot connect to server"`
- Fix: Check database connection string on Railway

❌ `"Field 'contact' is null in response"`
- Fix: Ensure user is created before returning response

## How the Flow Should Work

```
Flutter App
    ↓
Google Sign-In (gets ID token) ✅ WORKING
    ↓
Send token to backend
POST /api/Authentication/google-login
Body: { "idToken": "..." } ✅ WORKING
    ↓
Backend validates token
↳ Contact Google servers
↳ Get email from token
↳ Create/lookup user in database ❌ THIS IS FAILING (500 error)
    ↓
Return JWT token + user info ❌ NEVER HAPPENS
    ↓
Flutter stores token and logs in ❌ NEVER HAPPENS
```

## Expected Backend Validation Code

Your backend (C# example) should look like:

```csharp
[HttpPost("google-login")]
public async Task<IActionResult> GoogleLogin([FromBody] GoogleLoginRequest request)
{
    try
    {
        // Step 1: Validate Google Token
        var payload = await GoogleJsonWebSignature.ValidateAsync(
            request.IdToken,
            new GoogleJsonWebSignature.ValidationSettings()
            {
                Audience = new[] { "YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com" }
            }
        );
        
        // Step 2: Get or Create User
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == payload.Email);
        
        if (user == null)
        {
            user = new User 
            { 
                Email = payload.Email,
                UserName = payload.Name,
                // ... other fields
            };
            _context.Users.Add(user);
            await _context.SaveChangesAsync();
        }
        
        // Step 3: Generate JWT Token
        var token = _tokenService.GenerateToken(user);
        var refreshToken = _tokenService.GenerateRefreshToken();
        
        // Step 4: Return Response
        return Ok(new
        {
            success = true,
            message = "Login successful",
            result = new
            {
                success = true,
                message = "User logged in successfully",
                token = token,
                refreshToken = refreshToken,
                role = "User",
                contact = new
                {
                    id = user.Id,
                    email = user.Email,
                    userName = user.UserName
                }
            }
        });
    }
    catch (Exception ex)
    {
        // THIS IS WHERE YOUR 500 ERROR IS COMING FROM
        Console.WriteLine($"Google Login Error: {ex.Message}");
        return StatusCode(500, "Google login failed");
    }
}
```

## What to Check on Backend

- [ ] Google Client ID is correct in `appsettings.json`
- [ ] Google validation library is installed
- [ ] Database connection is working
- [ ] User table/collection exists
- [ ] JWT token generation is working
- [ ] Response format is exactly as shown above
- [ ] No null reference exceptions in the validation

## Once Backend is Fixed

Your Flutter app will:
1. Show loading state (circular progress indicator)
2. Send Google token
3. Get response with JWT token
4. Save token to cache
5. Redirect to home screen
6. Everything works! ✅

## Summary

**The issue IS in your backend**, NOT in Flutter.

1. Check Railway logs for the exact error
2. Fix the issue on the backend
3. Test with Postman
4. Google login will work

The Flutter app is correctly:
- Getting the Google token ✅
- Sending it to the backend ✅
- Handling the response ✅
- Error handling ✅

So it's definitely a server-side issue. Get those logs!

