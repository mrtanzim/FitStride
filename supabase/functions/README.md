# Supabase Edge Functions

## Setup

1. Install Supabase CLI: https://supabase.com/docs/guides/cli
2. Login: supabase login
3. Link project: supabase link --project-ref ewudyqxqhyrqsfhdugis

## Set secrets (required before deploying)

supabase secrets set GEMINI_API_KEY=your_gemini_api_key_here

Get your Gemini API key from: https://aistudio.google.com/app/apikey

## Deploy mentor-chat function

supabase functions deploy mentor-chat

## Test locally

supabase functions serve mentor-chat --env-file .env.local
