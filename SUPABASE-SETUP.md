# Set up Padayon with Supabase

Padayon uses Supabase Auth, Postgres and private Storage for account sync and PDF files. The Supabase Free plan does not require adding a billing account, but has usage limits and may change. Check the current Supabase pricing and limits before relying on it as the only copy of important files. Export backups regularly.

## Create and configure the Supabase project

1. Create a project at [supabase.com/dashboard](https://supabase.com/dashboard). Choose a region near your users (Singapore is a good option for the Philippines). Save the database password somewhere secure.
2. In **Project Settings > API**, copy the **Project URL** and the **anon / publishable key**.
3. Put those public browser values in `supabase-config.js`, replacing `YOUR_SUPABASE_PROJECT_URL` and `YOUR_SUPABASE_ANON_KEY`. Never put a `service_role` or secret key in this app.
4. Open **SQL Editor**, create a query, paste the contents of `supabase-schema.sql`, and run it. This creates the records table, per-user row security, private `user-files` bucket and per-user Storage policies.
5. In **Authentication > URL Configuration**, add your hosted app URL to the allowed redirect URLs. In **Authentication > Providers**, make sure Email is enabled. Supabase may require users to confirm their email before the first sign-in.
6. Host the complete app over HTTPS. The local `file://` preview is only for exploring the interface; Supabase auth redirects, service workers and cross-device use require a hosted site.
7. Create an account, upload a PDF and check **Settings > Cloud sync**. Sign in to the same account on another device to verify that files and study data load there.

The app stores PDF objects in the private `user-files` bucket at `{user-id}/files/{file-id}.pdf` and record metadata in `public.user_records`. Row-level security and Storage policies only allow the authenticated user to access records and objects under their own user ID. The SQL configures a 50 MiB per-PDF limit to match the Supabase Free plan's file-size restriction.

Offline edits remain in the device's IndexedDB and sync queue, and are uploaded when connectivity returns. While Padayon is open, it checks for changes from other devices every minute and when you return to the app; updates sync sooner when you open the app or tap **Settings > Sync now**. Sign out clears the local account data after pending changes sync; if sync is unavailable, sign-out is blocked to protect the only copy. Keep using **Settings > Export backup** as a separate backup.

Existing Firebase/guest data is not automatically transferred to Supabase. Before switching, sign in to the old account or use guest mode on the device that has the data, export a backup, then sign into the new Supabase account and import that backup.

## Install Padayon

Padayon is an installable web app (PWA). Open its HTTPS address in a supported browser and use the browser's install option. On iPhone or iPad, use Safari's **Share > Add to Home Screen**. Reading and studying saved PDFs works offline after the app and files have loaded.

Notes:
- Supabase's anon/publishable key is expected to be present in browser code; the database and Storage policies provide access control. Never use a service-role key in the app.
- Account sign-in and cloud sync require internet. Already-saved files and edits remain usable offline and sync when the device reconnects.
