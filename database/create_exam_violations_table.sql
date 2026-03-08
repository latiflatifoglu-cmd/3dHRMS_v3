-- Create exam_violations table for logging security violations during exams
-- Run this in Supabase SQL Editor

-- Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS exam_violations (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    exam_session_id UUID,
    violation_type VARCHAR(100) NOT NULL,
    severity VARCHAR(20) DEFAULT 'medium',
    violation_details JSONB,
    details JSONB,
    reliability_penalty INTEGER DEFAULT 0,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    violation_timestamp TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    screenshot_url TEXT,
    camera_frame_url TEXT,
    is_camera_violation BOOLEAN DEFAULT FALSE,
    capture_enabled BOOLEAN DEFAULT FALSE,
    
    -- Optional: Link to candidate_assessments if needed
    assessment_id UUID,
    candidate_id UUID
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_exam_violations_session ON exam_violations(exam_session_id);
CREATE INDEX IF NOT EXISTS idx_exam_violations_type ON exam_violations(violation_type);
CREATE INDEX IF NOT EXISTS idx_exam_violations_created ON exam_violations(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_exam_violations_timestamp ON exam_violations(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_exam_violations_camera ON exam_violations(is_camera_violation);

-- Enable RLS
ALTER TABLE exam_violations ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Allow authenticated users to insert violations (candidates during exam)
DROP POLICY IF EXISTS "Allow insert violations" ON exam_violations;
CREATE POLICY "Allow insert violations" ON exam_violations
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- Allow HR and admins to view all violations
DROP POLICY IF EXISTS "Allow HR to view violations" ON exam_violations;
CREATE POLICY "Allow HR to view violations" ON exam_violations
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles p
            WHERE p.id = auth.uid()
            AND p.role IN ('admin', 'hr', 'system_admin', 'institution_admin')
        )
    );

-- Allow candidates to view their own violations
DROP POLICY IF EXISTS "Allow candidates to view own violations" ON exam_violations;
CREATE POLICY "Allow candidates to view own violations" ON exam_violations
    FOR SELECT
    TO authenticated
    USING (candidate_id = auth.uid());

-- Grant permissions
GRANT ALL ON exam_violations TO authenticated;
GRANT ALL ON exam_violations TO service_role;

-- If table already exists, add missing columns
DO $$
BEGIN
    -- Add severity column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'exam_violations' AND column_name = 'severity') THEN
        ALTER TABLE exam_violations ADD COLUMN severity VARCHAR(20) DEFAULT 'medium';
    END IF;
    
    -- Add details column (alias for violation_details)
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'exam_violations' AND column_name = 'details') THEN
        ALTER TABLE exam_violations ADD COLUMN details JSONB;
    END IF;
    
    -- Add reliability_penalty column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'exam_violations' AND column_name = 'reliability_penalty') THEN
        ALTER TABLE exam_violations ADD COLUMN reliability_penalty INTEGER DEFAULT 0;
    END IF;
    
    -- Add timestamp column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'exam_violations' AND column_name = 'timestamp') THEN
        ALTER TABLE exam_violations ADD COLUMN timestamp TIMESTAMPTZ DEFAULT NOW();
    END IF;
    
    -- Add violation_timestamp column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'exam_violations' AND column_name = 'violation_timestamp') THEN
        ALTER TABLE exam_violations ADD COLUMN violation_timestamp TIMESTAMPTZ DEFAULT NOW();
    END IF;
    
    -- Add screenshot_url column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'exam_violations' AND column_name = 'screenshot_url') THEN
        ALTER TABLE exam_violations ADD COLUMN screenshot_url TEXT;
    END IF;
    
    -- Add camera_frame_url column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'exam_violations' AND column_name = 'camera_frame_url') THEN
        ALTER TABLE exam_violations ADD COLUMN camera_frame_url TEXT;
    END IF;
    
    -- Add is_camera_violation column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'exam_violations' AND column_name = 'is_camera_violation') THEN
        ALTER TABLE exam_violations ADD COLUMN is_camera_violation BOOLEAN DEFAULT FALSE;
    END IF;
    
    -- Add capture_enabled column
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'exam_violations' AND column_name = 'capture_enabled') THEN
        ALTER TABLE exam_violations ADD COLUMN capture_enabled BOOLEAN DEFAULT FALSE;
    END IF;
END $$;

-- Verify table creation
SELECT 'exam_violations table created/updated successfully' AS status;