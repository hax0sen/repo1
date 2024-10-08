-- Create a table with a JSONB column for SBOM
CREATE TABLE syft_sbom_json (
    id SERIAL PRIMARY KEY,
    sbom_data jsonb
);

-- Insert JSON data into the table (using \copy in psql or a script)
COPY syft_sbom_json(sbom_data) 
FROM '/output/syft-sbom.json';

-- Create a table with JSONB column for vulnerability reports
CREATE TABLE grype_vulnerabilities_json (
    id SERIAL PRIMARY KEY,
    vulnerability_data jsonb
);

-- Insert JSON data into the table
COPY grype_vulnerabilities_json(vulnerability_data) 
FROM '/output/grype-vulnerability-report.json';
