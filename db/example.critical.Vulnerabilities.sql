SELECT vulnerability_data->>'name' AS name,
       vulnerability_data->>'version' AS version,
       vulnerability_data->>'vulnerability_id' AS vulnerability_id,
       vulnerability_data->>'severity' AS severity
FROM grype_vulnerabilities_json
WHERE vulnerability_data->>'severity' = 'Critical';
