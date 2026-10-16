# Set up Padayon sign-in and cloud sync

Email/password sign-in works on Firebase's no-cost Spark plan. Automatic sync needs both Cloud Firestore (study data) and Cloud Storage (PDF files). Storage may require a billing-enabled Firebase plan; review the current Firebase pricing and set budget alerts before enabling it.

1. Go to https://console.firebase.google.com and open the Padayon project (`padayon-ac669`).
2. Under **Build > Authentication > Sign-in method**, enable **Email/Password**.
3. Under **Build > Firestore Database**, create a database. Choose a location and start in production mode.
4. Under **Build > Storage**, create the default storage bucket. If Firebase requires upgrading to the Blaze plan, check the pricing first; file uploads and downloads can incur charges.
5. Copy the bucket name shown in **Storage** or **Project settings > Your apps** into the `storageBucket` field in `firebase-config.js`, replacing `YOUR_STORAGE_BUCKET`.
6. Set the Firestore rules to allow each signed-in user to access only their own records:

   ```text
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId}/records/{recordId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

7. Set the Storage rules to protect each user's PDFs:

   ```text
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /users/{userId}/files/{fileName} {
         allow read, write: if request.auth != null
           && request.auth.uid == userId
           && (request.resource == null
             || (request.resource.size < 100 * 1024 * 1024
               && request.resource.contentType == 'application/pdf'));
       }
     }
   }
   ```

8. Under **Authentication > Settings > Authorized domains**, add the site host (for example `ramirezjojan6-glitch.github.io`). `localhost` is already allowed.
9. Deploy the complete folder to GitHub Pages or your host, then sign in to the same account on each device. The first sync uploads existing data from that account on that device.

Padayon supports creating an account, signing in with email and password, and requesting a password reset. Phone sign-in is still available as an alternate, but real SMS may require billing and is not needed for email/password sign-in.

Cloud sync stores records under the Firebase Authentication user's UID, uploads PDFs to that user's Storage folder, and keeps a local IndexedDB copy for offline use. Offline changes are queued and sent when the device reconnects. Sync errors appear in Settings; keep using **Export backup** as an independent backup. Data previously saved under a different account or as a guest is not automatically moved—export it and import it after signing into the intended account.

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
- Each account's files, flashcards, quizzes, plans and tasks sync when Firebase Firestore and Storage are configured; otherwise they remain on that device. Use Settings > Export / Import backup to move them.
- Signing in needs internet. After that, the app works offline.
