# SkyLog Web Update Guidance

SkyLog v2.4 documents what testers should do if the fixed beta link still shows
an older version after deployment.

## Fixed Link

```text
https://houjue919.github.io/skylog/
```

## If The App Looks Old

Ask testers to try:

1. Refresh the page.
2. Open the link in a private/incognito window.
3. Try a different browser.
4. Clear this site's browser data if the old version still appears.

## Why This Happens

Flutter Web apps can be cached by the browser so they load faster. After a new
GitHub Pages deployment, some browsers may briefly keep the previous app files.

## Tester Message

Use this short explanation:

```text
If SkyLog does not show the latest version, refresh the page or open the link in
an incognito/private window. Your test records are local to your browser.
```
