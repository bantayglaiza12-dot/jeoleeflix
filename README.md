# JEOLEEFLIX starter

A Netflix-inspired community video site. Users submit videos; submissions stay pending until an admin approves them.

## Stack
- Next.js 14
- Supabase Auth + private Storage + Postgres
- Deployable to Vercel

## 1. Create Supabase project
1. Create a project at https://supabase.com.
2. In **SQL Editor**, run `supabase-setup.sql`.
3. In **Storage**, create a bucket named `videos` and keep it **Private**.
4. In **Authentication → Providers → Email**, enable email/password sign-in.
5. Create your account in Supabase Authentication → Users.
6. Copy your user's UUID and run:
   `update public.profiles set is_admin = true where id = 'YOUR-USER-UUID';`

## 2. Configure the app
1. Copy `.env.example` to `.env.local`.
2. Add your Supabase Project URL, anon key, and service role key from Project Settings → API.
3. Never share or expose the service role key. Do not prefix it with `NEXT_PUBLIC_`.

## 3. Run locally
```bash
npm install
npm run dev
```
Open http://localhost:3000.

## 4. Deploy to Vercel
Push this folder to a GitHub repository, import it in Vercel, and add the same three environment variables in Project Settings → Environment Variables. Redeploy after adding them.

## 5. How it works
- People create an account in Supabase Auth, then sign in on `/upload` to submit a video.
- New videos are saved with `pending` status.
- The homepage only displays `approved` videos.
- You sign in at `/admin` using the account whose profile has `is_admin = true`.
- Approve or reject each pending submission.

## Important notes before public launch
This is a starter project, not a finished large-scale streaming service. The current upload route has a 500 MB limit and is best for a small pilot. For larger videos, use resumable uploads (such as Supabase TUS uploads), add rate limits, stronger moderation/reporting tools, and configure video transcoding/streaming. Add terms, privacy information, and a copyright/report process before accepting public submissions. Consider requiring email confirmation and reviewing thumbnails/descriptions as well as the video itself.
