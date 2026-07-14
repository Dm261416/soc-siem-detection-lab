# SOC / SIEM Detection Lab

A hands-on SOC analyst lab focused on detection engineering, correlation rule writing, and incident investigation using a self-hosted SIEM platform.

## What this demonstrates

- Deploying and operating a multi-container SIEM stack (Flask, React, MongoDB, Redis, Nginx) via Docker Compose
- Writing threshold-based correlation rules to detect attacker behavior from raw log data
- Investigating fired alerts: pivoting on source IP, destination host, and account to reconstruct an attack chain
- Mapping detections and investigation findings to MITRE ATT&CK tactics and techniques
- Debugging real-world environment issues (dependency lockfile conflicts, container crash loops, config migration between tool versions)

## Platform

This lab runs on the open-source **SIEM Dashboard** project by [CarterPerez-dev](https://github.com/CarterPerez-dev/Cybersecurity-Projects) (`PROJECTS/intermediate/siem-dashboard`), which provides:
- A log ingestion and normalization pipeline
- A real-time correlation engine
- YAML-based attack scenario playbooks mapped to MITRE ATT&CK
- A React dashboard for log review, rule management, and alert triage

**My work on top of this platform**, documented in this repo:
- Correlation rules written from scratch (the platform ships with zero pre-built rules — writing detection logic is the point of the exercise)
- Full incident investigation write-ups for each attack scenario
- Environment troubleshooting and configuration fixes required to get the stack running

## Repo structure

```
rules/            Correlation rules I wrote, in the format the platform's rule engine accepts
investigations/   Full write-ups for each attack scenario: detection, analysis, MITRE mapping, response
screenshots/      Supporting screenshots from the dashboard (alerts, log viewer, rule config)
```

## Scenarios covered

| # | Scenario | MITRE Techniques | Status |
|---|----------|------------------|--------|
| 1 | Brute Force with Lateral Movement | T1110.001, T1021.004 | Complete |
| 2 | Data Exfiltration via DNS Tunneling | T1046, T1005, T1048.003, T1071.004 | Planned |
| 3 | Phishing to C2 Beaconing | T1566.001, T1204.002, T1059.001, T1071.001, T1573.002 | Planned |
| 4 | Privilege Escalation and Persistence | T1068, T1136.001, T1053.005, T1070.002 | Planned |

## Skills demonstrated

`SIEM operations` · `correlation rule engineering` · `log analysis` · `MITRE ATT&CK mapping` · `incident investigation` · `Docker / containerized infrastructure` · `troubleshooting production-like environment issues`
