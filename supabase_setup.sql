-- TSG Payslip Generator – Supabase Schema
-- Run this script in the Supabase SQL Editor:
--   https://supabase.com/dashboard/project/<your-project>/sql/new
--
-- Tables created:
--   employees   – active and soft-deleted employee master records
--   delete_logs – audit trail of soft-delete actions

-- ─── Employees ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS employees (
  id          TEXT        PRIMARY KEY,
  name        TEXT        NOT NULL,
  doj         TEXT,
  position    TEXT,
  account     TEXT,
  company     TEXT,
  logo        TEXT,
  active      BOOLEAN     DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-update updated_at on every row change
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS employees_updated_at ON employees;
CREATE TRIGGER employees_updated_at
  BEFORE UPDATE ON employees
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ─── Delete Logs ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS delete_logs (
  id          BIGSERIAL   PRIMARY KEY,
  emp_id      TEXT        NOT NULL,
  name        TEXT,
  deleted_at  TEXT,
  action      TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ─── Row Level Security (optional but recommended) ───────────────────────────
-- The app uses Google OAuth client-side only.  If you want to restrict
-- direct API access to these tables, enable RLS and add policies:
--
-- ALTER TABLE employees   ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE delete_logs ENABLE ROW LEVEL SECURITY;
--
-- For a fully internal/trusted deployment you may leave RLS disabled and
-- rely on the anon key being kept private (not published publicly).
