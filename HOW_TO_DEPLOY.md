# LayedOff — How to Launch Your Site (Free, Step by Step)

## Step 1 — Get your files
Download the `layedoff_site` folder. It contains:
- `index.html` — your entire working website
- `supabase_setup.sql` — run this once to create your database

---

## Step 2 — Set up Supabase (your free database)

1. Go to **supabase.com** → Sign up free
2. Click "New Project" → give it a name like "layedoff"
3. Wait ~2 minutes for it to set up
4. Go to **SQL Editor** → paste the entire contents of `supabase_setup.sql` → click Run
5. Go to **Project Settings → API**
6. Copy your **Project URL** and **anon public key**

---

## Step 3 — Connect your site to Supabase

Open `index.html` in any text editor (Notepad, VS Code, etc.)

Find this line near the top of the script section:
```
const DEMO={url:'YOUR_SUPABASE_URL',key:'YOUR_SUPABASE_ANON_KEY'};
```

Replace with your actual values:
```
const DEMO={url:'https://xyzxyz.supabase.co',key:'eyJhbGci...'};
```

Save the file.

---

## Step 4 — Deploy to Vercel (free hosting)

1. Go to **vercel.com** → Sign up free with GitHub
2. Go to **github.com** → Create a new repository called "layedoff"
3. Upload your `index.html` file to that repository
4. Back on Vercel → "Add New Project" → import your GitHub repo
5. Click Deploy

**Your site is live.** Vercel gives you a free URL like `layedoff.vercel.app`

---

## Step 5 — Enable Email Auth in Supabase

1. Supabase Dashboard → Authentication → Providers
2. Make sure Email is enabled (it is by default)
3. Under Email → disable "Confirm email" for now (easier for early users)

---

## You're live. Start sharing.

Post in:
- r/layoffs
- r/cscareerquestions  
- r/ExperiencedDevs
- LinkedIn (your personal story as a builder)
- Twitter/X — search "just got laid off" and reply genuinely

---

## Costs
| Item | Cost |
|------|------|
| Hosting (Vercel) | ₹0 |
| Database (Supabase free tier) | ₹0 |
| Domain (layedoff.vercel.app) | ₹0 |
| Custom domain (optional, later) | ~₹800/year |

**Total to launch: ₹0**
