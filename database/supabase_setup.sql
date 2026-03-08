
-- 1. Create institutions table
CREATE TABLE institutions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create profiles table for user roles and other data
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  role TEXT NOT NULL,
  name TEXT,
  institution_id UUID REFERENCES institutions(id) ON DELETE SET NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Function to create a profile for a new user
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role, name)
  VALUES (new.id, new.email, new.raw_user_meta_data->>'role', new.raw_user_meta_data->>'name');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to call the function when a new user signs up
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- 3. Enable RLS for all tables
ALTER TABLE institutions ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 4. Create policies for RLS
-- Allow public access to institutions
CREATE POLICY "Public can read institutions" ON institutions
  FOR SELECT USING (true);

-- Allow users to see their own profile
CREATE POLICY "Users can read their own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

-- Allow authenticated users to see all profiles (adjust as needed for security)
CREATE POLICY "Authenticated users can view all profiles" ON profiles
  FOR SELECT USING (auth.role() = 'authenticated');

-- Allow users to update their own profile
CREATE POLICY "Users can update their own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- 5. Create other tables with RLS enabled
CREATE TABLE job_postings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  institution_id UUID REFERENCES institutions(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  department TEXT,
  location TEXT,
  status TEXT DEFAULT 'Draft',
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE job_postings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "HR can manage job postings for their institution" ON job_postings
  FOR ALL USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'hr' AND
    institution_id = (SELECT institution_id FROM profiles WHERE id = auth.uid())
  );
CREATE POLICY "Authenticated users can view all job postings" ON job_postings
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE TABLE candidates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  institution_id UUID REFERENCES institutions(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  skills TEXT,
  experience TEXT,
  status TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE candidates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "HR can manage candidates for their institution" ON candidates
  FOR ALL USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'hr' AND
    institution_id = (SELECT institution_id FROM profiles WHERE id = auth.uid())
  );

CREATE TABLE applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  job_id UUID REFERENCES job_postings(id) ON DELETE CASCADE,
  candidate_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'Applied',
  applied_date TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Candidates can manage their own applications" ON applications
  FOR ALL USING (auth.uid() = candidate_id);
CREATE POLICY "HR can view applications for their institution" ON applications
  FOR SELECT USING (
    (SELECT role FROM profiles WHERE id = auth.uid()) = 'hr'
  );

-- Placeholder tables for other modules. Add columns as needed.
CREATE TABLE evaluations (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), details TEXT);
ALTER TABLE evaluations ENABLE ROW LEVEL SECURITY;
CREATE TABLE workflows (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), details TEXT);
ALTER TABLE workflows ENABLE ROW LEVEL SECURITY;
CREATE TABLE workflow_steps (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), details TEXT);
ALTER TABLE workflow_steps ENABLE ROW LEVEL SECURITY;
CREATE TABLE evaluation_tools (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), details TEXT);
ALTER TABLE evaluation_tools ENABLE ROW LEVEL SECURITY;
CREATE TABLE reports (id UUID PRIMARY KEY DEFAULT uuid_generate_v4(), details TEXT);
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
