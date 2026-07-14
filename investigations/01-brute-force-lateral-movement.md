# Investigation: Brute Force with Lateral Movement

**Scenario:** Brute Force with Lateral Movement (built-in attack playbook)
**Date investigated:** July 2026
**Analyst:** Damien Martinez
**Status:** Resolved — True Positive

## Scenario Summary

Simulates an external attacker brute-forcing SSH credentials against a perimeter host, gaining access, then using the compromised host to move laterally toward internal servers using stolen credentials.

## Detection Gap Identified

On initial run of this scenario, the raw log events populated correctly in the Log Viewer, but **zero alerts fired** — the platform ships with no pre-built correlation rules. This is a deliberate part of the exercise: writing the detection logic is the analyst's responsibility, not something handed to you out of the box.

## Rule Written

To close this gap, I wrote a threshold-based correlation rule (see `rules/brute-force-rule.json`):

- **Logic:** Alert when 10 or more `login_failure` events occur from the same `source_ip` within a 60-second window
- **Severity:** High
- **MITRE mapping:** T1110.001 (Password Guessing)

## Alert Fired

After deploying the rule and re-running the scenario, the correlation engine correctly grouped and flagged the attack:

| Field | Value |
|---|---|
| Rule | Brute Force - Repeated Auth Failures |
| Group (source IP) | 203.0.113.42 |
| Matched events | 10 |
| Severity | Medium (platform default scoring — see notes) |
| Status | New → Investigating → Resolved |

## Investigation Findings

Reviewing the matched events and the surrounding timeline in the Log Viewer:

1. **Reconnaissance/brute force phase:** `203.0.113.42` sent rapid, sequential `login_failure` events against host `10.1.1.50` (hostname `bastion-01`), cycling through a common username dictionary (`root`, `admin`, `ubuntu`, `postgres`, `jenkins`, `deploy`, `sysadmin`, and others) — consistent with automated credential-guessing tooling rather than manual login attempts.

2. **Successful compromise:** Immediately following the failed attempts, a `login_success` event was logged for the `deploy` account via `sshd` on `bastion-01`. The raw event log includes the message `"Successful SSH login after brute force"`, confirming the account was compromised via the preceding attack.
   - **Why this matters:** `bastion-01` functioning as a jump/bastion host makes this a high-impact compromise — the attacker now has a foothold with likely access into the broader internal network. The `deploy` account being a service account (rather than a named human user) is also notable, since service accounts often carry broad permissions and are less closely monitored for anomalous interactive logins.

3. **Lateral movement (T1021.004):** Following the compromise, subsequent activity from the newly-controlled host was reviewed for connections to additional internal hosts, consistent with the scenario's described lateral movement phase.

## MITRE ATT&CK Mapping

| Tactic | Technique | Observed Behavior |
|---|---|---|
| Credential Access | T1110.001 — Password Guessing | Repeated login failures across a username dictionary from a single external IP |
| Lateral Movement | T1021.004 — Remote Services: SSH | Use of the compromised bastion host to pivot toward internal systems |

## Assessment

**True positive.** The pattern (high-frequency failures across many usernames, immediately followed by success, from a single external-facing IP against a bastion host) is not consistent with legitimate user behavior such as a forgotten password.

## Recommended Response

1. Block source IP `203.0.113.42` at the perimeter firewall.
2. Force an immediate credential rotation for the `deploy` service account.
3. Audit all activity originating from `bastion-01` since the time of compromise for further lateral movement or data access.
4. Review whether the `deploy` account requires interactive SSH login capability at all — service accounts should be restricted to only the access they functionally need.
5. Consider adding a secondary detection rule for "successful login immediately following a threshold-triggering failure burst," which would flag the compromise moment itself with higher confidence than the failure burst alone.

## Notes / Lessons Learned

- Default rule severity of "Medium" undersells the risk once the successful login and bastion-host context are factored in — in a real environment I would tune this rule's severity upward, or add a compound rule that escalates severity automatically when a `login_success` follows a matched threshold group.
- This investigation reinforced why alert triage requires reading the full event context, not just the rule that fired — the raw event's `message` field ("Successful SSH login after brute force") and `hostname` field (`bastion-01`) were both critical details the alert summary alone didn't surface.
