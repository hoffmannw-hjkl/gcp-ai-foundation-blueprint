# Specialized AI Agents & Skills — `gcp-ai-foundation-blueprint`

This repository implements the **Google Cloud Elevate 2026 & EMEA SPARK** AI-Native Software Engineering architecture. It includes specialized subagents (`.agents/agents/`) and on-demand procedural skills (`.agents/skills/`) discovered automatically by **Jetski**, **Antigravity**, and **Gemini CLI**.

---

## 🤖 Specialized Repository Subagents (`.agents/agents/`)

| Subagent Name | Role & Specialization | When to Invoke (`invoke_subagent`) |
| :--- | :--- | :--- |
| **[`secops-auditor`](.agents/agents/secops-auditor.md)** | **Senior Cloud Security & SaferGCP Auditor** | Before committing `.tf` changes: audits resource-scoped IAM bindings, Argolis zero-public-IP rules, Cloud Armor OWASP WAF rules, and CMEK encryption. |
| **[`finops-advisor`](.agents/agents/finops-advisor.md)** | **Cloud FinOps & Architecture Profile Advisor** | When sizing deployments (`Serverless Demo` vs `Enterprise Production`), tuning GCS storage classes, or configuring Cloud Billing budget alerts. |
| **[`dr-chaos-architect`](.agents/agents/dr-chaos-architect.md)** | **Resilience, Backup-DR & Multi-Region Architect** | When modifying `modules/backup-dr` or `modules/compute-gke`: verifies WORM Backup Vaults (`google-beta`), GKE Backup addon sync, and deletion protection. |

---

## 🛠️ Repository Skills (`.agents/skills/`)

| Skill Name | Path | Description |
| :--- | :--- | :--- |
| **`terraform-blueprint-validation`** | [`.agents/skills/terraform-blueprint-validation/SKILL.md`](.agents/skills/terraform-blueprint-validation/SKILL.md) | Automated workflow for `terraform fmt`, `terraform validate`, `GOOGLE_OAUTH_ACCESS_TOKEN` zero-drift `terraform plan`, and bilingual README sync. |
