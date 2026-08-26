INSERT INTO iam_data.roles (role_code, role_name, risk_level) VALUES
-- High Risk / Privileged Roles
('DB_WRITE_PROD',       'Production Database Write',        'HIGH'),
('AWS_ADMIN_PROD',      'Production AWS Administrator',     'HIGH'),
('K8S_CLUSTER_ADMIN',   'Kubernetes Cluster Admin',         'HIGH'),
('FIN_INVOICE_PAY',     'Invoice Payment Processing',       'HIGH'),
('CICD_DEPLOY_PROD',    'CI/CD Production Deployment',      'HIGH'),
('PAYROLL_ADMIN',       'Payroll Administrator',            'HIGH'),

-- Medium Risk Roles
('DB_READ_PROD',        'Production Database Read',         'MEDIUM'),
('FIN_VENDOR_CREATE',   'Vendor Account Creation',          'MEDIUM'),
('HR_COMPENSATION_EDIT','HR Compensation Editor',           'MEDIUM'),
('GIT_REPO_ADMIN',      'Git Repository Administrator',     'MEDIUM'),

-- Low Risk Roles
('MKG_SOCIAL_ADMIN',    'Social Media Administrator',       'LOW'),
('JIRA_STANDARD_USER',  'Jira Standard Access',             'LOW');






INSERT INTO iam_data.employees (employee_id, full_name, department, job_title, is_active) VALUES
-- Full-Time Employees
('EMP101', 'Alice Smith',       'Marketing',                    'Content Strategist',        true),
('EMP102', 'Bob Jones',         'Database Administration',      'Senior DBA',                true),
('EMP103', 'Charlie Brown',     'Site Reliability Engineering', 'SRE Lead',                  true),
('EMP104', 'Diana Prince',      'Finance',                      'Accounts Payable Specialist',true),
('EMP105', 'Evan Wright',       'Software Engineering',        'Fullstack Developer',       true),
('EMP106', 'Fiona Gallagher',   'HR',                           'HR Operations Manager',     true),
('EMP107', 'George Clark',      'Cloud Infrastructure',         'Cloud Architect',           true),
('EMP108', 'Hannah Abbott',     'Release Management',           'Release Engineer',          true),
('EMP109', 'Ian Malcolm',       'Sales',                        'Account Executive',         true),
('EMP110', 'Julia Roberts',     'Software Engineering',        'Backend Engineer',          true),

-- Vendor & Contractor Accounts (VND- / CTR-)
('VND-901', 'Kevin Spacey',     'External Operations',          'Contract DB Consultant',    true),
('CTR-302', 'Laura Croft',      'External Development',         'Frontend Contractor',       true),
('CTR-303', 'Michael Scott',    'External QA',                  'QA Automation Specialist',  true);






INSERT INTO iam_data.employee_roles (employee_id, role_code, granted_date, last_login_date) VALUES

-- -------------------------------------------------------------------------------------------------
-- TEST CASE 1: Department Rule Violations (Privileged Roles outside allowed departments)
-- -------------------------------------------------------------------------------------------------
-- VIOLATION: Marketing employee holding DB_WRITE_PROD (Allowed: SRE, Cloud Infra, DBA)
('EMP101', 'DB_WRITE_PROD',       CURRENT_DATE - INTERVAL '180 days', CURRENT_DATE - INTERVAL '2 days'),
('EMP101', 'MKG_SOCIAL_ADMIN',    CURRENT_DATE - INTERVAL '365 days', CURRENT_DATE - INTERVAL '1 day'),

-- -------------------------------------------------------------------------------------------------
-- TEST CASE 2: Employee Dormancy Violation (>30 days unused for privileged roles)
-- -------------------------------------------------------------------------------------------------
-- VIOLATION: DBA holding DB_WRITE_PROD but hasn't logged in for 45 days (>30 day threshold)
('EMP102', 'DB_WRITE_PROD',       CURRENT_DATE - INTERVAL '400 days', CURRENT_DATE - INTERVAL '45 days'),
('EMP102', 'DB_READ_PROD',        CURRENT_DATE - INTERVAL '400 days', CURRENT_DATE - INTERVAL '1 day'),

-- -------------------------------------------------------------------------------------------------
-- TEST CASE 3: Segregation of Duties (SoD) Conflicts
-- -------------------------------------------------------------------------------------------------
-- VIOLATION (Conflict F-1): Finance employee holds BOTH Vendor Creation AND Payment Processing
('EMP104', 'FIN_VENDOR_CREATE',   CURRENT_DATE - INTERVAL '120 days', CURRENT_DATE - INTERVAL '5 days'),
('EMP104', 'FIN_INVOICE_PAY',     CURRENT_DATE - INTERVAL '60 days',  CURRENT_DATE - INTERVAL '2 days'),

-- VIOLATION (Conflict T-1): Software Engineer holds BOTH Git Repo Admin AND CI/CD Deploy Prod
('EMP105', 'GIT_REPO_ADMIN',      CURRENT_DATE - INTERVAL '200 days', CURRENT_DATE - INTERVAL '1 day'),
('EMP105', 'CICD_DEPLOY_PROD',    CURRENT_DATE - INTERVAL '90 days',  CURRENT_DATE - INTERVAL '1 day'),

-- VIOLATION (Conflict F-2): HR employee holds BOTH Payroll Admin AND HR Compensation Edit
('EMP106', 'PAYROLL_ADMIN',       CURRENT_DATE - INTERVAL '300 days', CURRENT_DATE - INTERVAL '3 days'),
('EMP106', 'HR_COMPENSATION_EDIT',CURRENT_DATE - INTERVAL '150 days', CURRENT_DATE - INTERVAL '4 days'),

-- -------------------------------------------------------------------------------------------------
-- TEST CASE 4: Valid Assignments (Control Group / Compliant Data)
-- -------------------------------------------------------------------------------------------------
-- VALID: SRE holding AWS_ADMIN_PROD and K8S_CLUSTER_ADMIN with recent logins
('EMP103', 'AWS_ADMIN_PROD',      CURRENT_DATE - INTERVAL '100 days', CURRENT_DATE - INTERVAL '1 day'),
('EMP103', 'K8S_CLUSTER_ADMIN',   CURRENT_DATE - INTERVAL '100 days', CURRENT_DATE - INTERVAL '2 days'),

-- VALID: Cloud Architect holding AWS_ADMIN_PROD
('EMP107', 'AWS_ADMIN_PROD',      CURRENT_DATE - INTERVAL '250 days', CURRENT_DATE - INTERVAL '3 days'),

-- VALID EXEMPTION: Release Management employee holding Git Admin + Deploy Prod (Exempt from T-1)
('EMP108', 'GIT_REPO_ADMIN',      CURRENT_DATE - INTERVAL '365 days', CURRENT_DATE - INTERVAL '1 day'),
('EMP108', 'CICD_DEPLOY_PROD',    CURRENT_DATE - INTERVAL '365 days', CURRENT_DATE - INTERVAL '1 day'),

-- VALID: Sales holding Low Risk Jira Access
('EMP109', 'JIRA_STANDARD_USER',  CURRENT_DATE - INTERVAL '60 days',  CURRENT_DATE - INTERVAL '10 days'),

-- -------------------------------------------------------------------------------------------------
-- TEST CASE 5: Vendor & Contractor Governance Violations
-- -------------------------------------------------------------------------------------------------
-- VIOLATION: Contractor (VND-901) assigned a HIGH risk role (K8S_CLUSTER_ADMIN)
('VND-901', 'K8S_CLUSTER_ADMIN',  CURRENT_DATE - INTERVAL '30 days',  CURRENT_DATE - INTERVAL '2 days'),

-- VIOLATION: Contractor (CTR-302) dormant for 20 days (Contractor limit is 14 days)
('CTR-302', 'JIRA_STANDARD_USER', CURRENT_DATE - INTERVAL '40 days',  CURRENT_DATE - INTERVAL '20 days'),

-- VIOLATION: Contractor (CTR-303) lifecycle exceeds 180 days (Granted 210 days ago)
('CTR-303', 'JIRA_STANDARD_USER', CURRENT_DATE - INTERVAL '210 days', CURRENT_DATE - INTERVAL '1 day');

