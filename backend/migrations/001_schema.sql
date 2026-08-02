CREATE TABLE IF NOT EXISTS app_users(
  id BIGSERIAL PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,role TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS workflow_cases(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,reference TEXT UNIQUE NOT NULL,subject TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,payload JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_events(
  id BIGSERIAL PRIMARY KEY,event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),actor TEXT NOT NULL,action TEXT NOT NULL,object_type TEXT NOT NULL,object_reference TEXT NOT NULL,detail TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS saved_analyses(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,actor TEXT NOT NULL,analysis_type TEXT NOT NULL,inputs JSONB NOT NULL,result JSONB NOT NULL,provider TEXT NOT NULL,model TEXT,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS integration_state(
  id TEXT PRIMARY KEY,name TEXT NOT NULL,category TEXT NOT NULL,mode TEXT NOT NULL,status TEXT NOT NULL,last_tested TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_workflow ON workflow_cases(workflow_id);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_due ON workflow_cases(due_date);
CREATE INDEX IF NOT EXISTS idx_audit_events_time ON audit_events(event_time DESC);

CREATE TABLE IF NOT EXISTS "op_division_order"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_well" TEXT NOT NULL,
  "data_owner" TEXT NOT NULL,
  "data_decimalInterest" NUMERIC(16,2) NOT NULL,
  "data_titleBasis" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_division_order_due ON "op_division_order"(due_date);

CREATE TABLE IF NOT EXISTS "op_production_sales"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_property" TEXT NOT NULL,
  "data_productionMonth" TEXT NOT NULL,
  "data_producedVolume" NUMERIC(16,2) NOT NULL,
  "data_soldVolume" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_production_sales_due ON "op_production_sales"(due_date);

CREATE TABLE IF NOT EXISTS "op_pricing"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_product" TEXT NOT NULL,
  "data_salesMonth" TEXT NOT NULL,
  "data_paidPrice" NUMERIC(16,2) NOT NULL,
  "data_benchmarkPrice" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_pricing_due ON "op_pricing"(due_date);

CREATE TABLE IF NOT EXISTS "op_deduction"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_lease" TEXT NOT NULL,
  "data_deductionType" TEXT NOT NULL,
  "data_deductionAmount" NUMERIC(16,2) NOT NULL,
  "data_leaseLanguage" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_deduction_due ON "op_deduction"(due_date);

CREATE TABLE IF NOT EXISTS "op_royalty_statement"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_statementId" TEXT NOT NULL,
  "data_grossValue" NUMERIC(16,2) NOT NULL,
  "data_ownerDecimal" NUMERIC(16,2) NOT NULL,
  "data_netPaid" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_royalty_statement_due ON "op_royalty_statement"(due_date);

CREATE TABLE IF NOT EXISTS "op_suspense"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_owner" TEXT NOT NULL,
  "data_suspenseReason" TEXT NOT NULL,
  "data_suspendedAmount" NUMERIC(16,2) NOT NULL,
  "data_resolutionNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_suspense_due ON "op_suspense"(due_date);

CREATE TABLE IF NOT EXISTS "op_onrr"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_leaseNumber" TEXT NOT NULL,
  "data_salesMonth" TEXT NOT NULL,
  "data_royaltyValue" NUMERIC(16,2) NOT NULL,
  "data_reportingNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_onrr_due ON "op_onrr"(due_date);

CREATE TABLE IF NOT EXISTS "op_claim"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_claimId" TEXT NOT NULL,
  "data_operator" TEXT NOT NULL,
  "data_claimedAmount" NUMERIC(16,2) NOT NULL,
  "data_claimNarrative" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_claim_due ON "op_claim"(due_date);

CREATE TABLE IF NOT EXISTS "op_property_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_property" TEXT NOT NULL,
  "data_lease" TEXT NOT NULL,
  "data_operator" TEXT NOT NULL,
  "data_product" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_property_register_due ON "op_property_register"(due_date);

CREATE TABLE IF NOT EXISTS "op_owner_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_owner" TEXT NOT NULL,
  "data_ownerNumber" TEXT NOT NULL,
  "data_paymentStatus" TEXT NOT NULL,
  "data_titleStatus" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_owner_register_due ON "op_owner_register"(due_date);

CREATE TABLE IF NOT EXISTS "op_purchaser_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_purchaser" TEXT NOT NULL,
  "data_contract" TEXT NOT NULL,
  "data_pricingBasis" TEXT NOT NULL,
  "data_settlementCycle" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_purchaser_register_due ON "op_purchaser_register"(due_date);

CREATE TABLE IF NOT EXISTS "op_index_register"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_index" TEXT NOT NULL,
  "data_location" TEXT NOT NULL,
  "data_product" TEXT NOT NULL,
  "data_indexPrice" NUMERIC(16,2) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_index_register_due ON "op_index_register"(due_date);
