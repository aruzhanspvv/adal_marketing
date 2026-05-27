# Social Media Traffic Tracking Setup — Developer Instructions

**Goal:** Track which social media platform drives traffic to adelagent.ai using short redirect links + PostHog (already installed).

**Summary:** We need to add a `_redirects` file so that clean URLs like `adelagent.ai/ig` redirect to our homepage with UTM tracking parameters. PostHog already captures UTM params automatically — no new tracking code needed.

---

## Step 1: Add Redirect File

Create a file called `_redirects` in the `public/` folder of the React app.

**File path:** `public/_redirects`

**File contents:**

```
/ig  /?utm_source=instagram  302
/li  /?utm_source=linkedin   302
/x   /?utm_source=twitter    302
/tt  /?utm_source=tiktok     302

/*   /index.html  200
```

**Important notes:**
- The `/*  /index.html  200` line at the bottom keeps React Router working. It must be LAST.
- The redirect rules above it take priority.
- `302` means temporary redirect (so we can change destinations later without caching issues).
- If there's already a `_redirects` file in `public/`, just add the 4 social lines ABOVE the existing `/*` catch-all rule.

---

## Step 2: Deploy

Push to git / redeploy on Render. That's it.

---

## Step 3: Verify It Works

After deploy:
1. Open an incognito/private browser window
2. Visit `adelagent.ai/ig`
3. You should land on the homepage
4. Check PostHog → Activity → Live Events
5. Find the `$pageview` event → click it → check properties
6. Confirm you see: `utm_source: instagram`

Repeat for `/li`, `/x`, `/tt` to verify all 4 work.

---

## What This Does (for context)

```
User taps "adelagent.ai/ig" in our Instagram bio
  → Render catches the /ig route
  → Redirects to adelagent.ai/?utm_source=instagram
  → User lands on homepage (never sees the UTM stuff)
  → PostHog automatically logs utm_source=instagram
  → We see "this visit came from Instagram" in our dashboard
```

---

## That's All — No Other Code Changes Needed

PostHog is already installed and already reads UTM parameters from the URL automatically. We just need the `_redirects` file so the short links work.

---

## Quick Reference

| Bio link we'll use | Redirects to | PostHog will show |
|---|---|---|
| adelagent.ai/ig | adelagent.ai/?utm_source=instagram | utm_source: instagram |
| adelagent.ai/li | adelagent.ai/?utm_source=linkedin | utm_source: linkedin |
| adelagent.ai/x | adelagent.ai/?utm_source=twitter | utm_source: twitter |
| adelagent.ai/tt | adelagent.ai/?utm_source=tiktok | utm_source: tiktok |
