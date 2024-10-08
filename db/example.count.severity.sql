SELECT vulnerability_data->>'severity' AS severity,
       COUNT(*) AS count
FROM grype_vulnerabilities_json
GROUP BY vulnerability_data->>'severity';
