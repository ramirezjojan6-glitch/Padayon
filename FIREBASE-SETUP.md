# Turn on email sign-in for Padayon

Email/password sign-in is handled by Firebase Authentication and works on Firebase's no-cost Spark plan. Set it up once, then paste 4 values into `firebase-config.js`.

1. Go to https://console.firebase.google.com and open the Padayon project (`padayon-ac669`).
2. Open **Build > Authentication > Sign-in method** and enable **Email/Password**.
3. Open **Project settings** (gear icon) > **Your apps** > the web app. Copy `apiKey`, `authDomain`, `projectId`, and `appId` into `firebase-config.js` if they are not already there.
4. Open **Authentication > Settings > Authorized domains** and add the address where you host Padayon (for example `yourname.netlify.app`). `localhost` is already allowed.
5. Upload the complete folder to Netlify or GitHub Pages.

Padayon supports creating an account, signing in with email and password, and requesting a password reset. Phone sign-in is still available as an alternate, but real SMS may require billing and is not needed for email/password sign-in.

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
- Each account's files, flashcards, quizzes, plans and tasks are stored on that device only, separately per account; signing in on another device does not automatically sync them. Use Settings > Export / Import backup to move them.
- Signing in needs internet. After that, the app works offline.
