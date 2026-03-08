-- Add is_camera_violation column to exam_violations table
-- This column indicates if the violation is related to camera functionality
-- Run this in Supabase SQL Editor

-- Add the column if it doesn't exist
ALTER TABLE exam_violations 
ADD COLUMN IF NOT EXISTS is_camera_violation BOOLEAN DEFAULT FALSE;

-- Create an index for filtering camera violations
CREATE INDEX IF NOT EXISTS idx_exam_violations_camera ON exam_violations(is_camera_violation);

-- Verify the column was added
SELECT 'is_camera_violation column added successfully' AS status;
