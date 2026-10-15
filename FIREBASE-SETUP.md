# Turn on phone sign-in for Padayon

Phone sign-in is handled by Firebase Authentication. You set it up once, then paste 4 values into `firebase-config.js`.

1. Go to https://console.firebase.google.com and click **Add project**. Name it (for example "padayon").
2. Open **Build > Authentication > Get started > Sign-in method** and enable **Phone**.
3. Open **Project settings** (gear icon) > **Your apps** > the web icon `</>` > register an app. Copy `apiKey`, `authDomain`, `projectId`, `appId` into `firebase-config.js`.
4. Open **Authentication > Settings > Authorized domains** and add the address where you host Padayon (for example `yourname.netlify.app`). `localhost` is already allowed.
5. To try it for free, add test phone numbers under Authentication > Sign-in method > Phone. Real text messages have a limited free quota and may need Firebase's pay-as-you-go plan, so check the current Firebase pricing page.
6. Upload the complete folder to Netlify or GitHub Pages.

## Install Padayon

Padayon is an installable web app (PWA), so it does not need a separate desktop or
phone installer. Open its HTTPS address in a supported browser and use the browser's
install option. On iPhone or iPad, use Safari's **Share > Add to Home Screen**.
The app cannot be installed by opening `index.html` directly; service workers and
installation require HTTPS (or `localhost` for local testing).

The PDF.js and Firebase browser libraries are included in `vendor/` and cached with
the app. Reading and studying saved PDFs works offline after the app has loaded.
Firebase sign-in itself still needs internet and the project configuration above;
you can use Padayon without an account if Firebase has not been configured.

Notes
- Each account's files, flashcards, quizzes, plans and tasks are stored on that device only, separately per account. Use Settings > Export / Import backup to move them.
- Signing in needs internet. After that, the app works offline.
