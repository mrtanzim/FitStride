class AppConfig {
  static const appName = 'FORGE';
  static const supabaseUrl = 'https://ewudyqxqhyrqsfhdugis.supabase.co';
  static const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3dWR5cXhxaHlycXNmaGR1Z2lzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTIzODkyNTYsImV4cCI6MjEwNzk2NTI1Nn0.CE3Vpd5Do9hDpdGwJQ3oxU3A5rQi205_2VdhxRriXhM';
  // Gemini key passed via --dart-define=GEMINI_API_KEY=... at build/run time
  static const geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
}
