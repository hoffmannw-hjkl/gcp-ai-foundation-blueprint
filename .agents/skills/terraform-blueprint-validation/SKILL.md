---
name: terraform-blueprint-validation
description: >-
  Validates, formats, and audits Terraform modules and live GCP infrastructure drift for gcp-ai-foundation-blueprint.
  Use when the user asks to "validate terraform", "check drift", "run terraform plan", "deploy blueprint",
  "audit WAF or IAM security", or "fix 403 ADC authentication errors".
---

# Terraform Blueprint Validation (`M1L1 Skills Framework` Compliant)

**Skill Patterns Combined**: *Tool Wrapper Skill* (Slide 13) • *Auth Recipe* (Slide 18) • *Generator / Experience Before Theory* (Slide 14) • *Reviewer Checklist* (Slide 15) • *Workflow Skill* (Slide 16).

---

## 1. Tool Wrapper & Auth Recipes (Slides 13 & 18)

Always use the pre-built Terraform binary and filter verbose output with `-no-color`:

```bash
TERRAFORM="/usr/local/google/home/hoffmannw/bin/terraform"
```

### Usage & Auth Recipe (Preventing 401/403 `USER_PROJECT_DENIED` Errors)
On Cloudtop environments, the default Application Default Credentials (ADC) belong to `insecure-cloudtop-shared-user`, which triggers `403 Caller does not have required permission to use project wh-ai-blueprint-a363`.
**Always inject the active `gcloud` OAuth access token** when running `plan` or `apply`:

```bash
GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token) $TERRAFORM plan -no-color | tail -n 25
```

---

## 2. Experience Before Theory — Known Gotchas (Slide 14)

The following production gotchas were discovered through real failures and must always be enforced:

1. **Cloud Billing Budget Perpetual Plan Diff (`modules/finops-budget`)**:
   - *Gotcha*: Passing `projects = ["projects/${var.project_id}"]` causes GCP Billing API to normalize the string to the numeric project number (`projects/695831602877`), creating a perpetual `1 to change` diff on every `terraform plan`.
   - *Rule*: Always reference `projects/${data.google_project.project.number}` in `google_billing_budget`.
2. **Cloud Armor WAF Blocking PDF Uploads (`modules/security-waf`)**:
   - *Gotcha*: Raw PDF binary streams trip OWASP CRS `xss-v33-stable` and `protocolattack-v33-stable` body inspection rules with HTTP `403 body_denied_by_security_policy`.
   - *Rule*: Always prepend the `excluded_upload_paths` CEL exclusion (`!(request.path.startsWith('/api/documents/upload')) && ...`) to OWASP rules.
3. **Backup & DR `google-beta` Provider (`versions.tf`)**:
   - *Gotcha*: `modules/backup-dr` uses `provider = google-beta`. Without an explicit `provider "google-beta"` block configured with `user_project_override = true` and `billing_project`, enabling `enable_backup_dr = true` fails on Argolis.

---

## 3. Multi-Step Validation Workflow (Slide 16)

Run the bundled verification script (or execute the steps sequentially):

```bash
./.agents/skills/terraform-blueprint-validation/scripts/verify.sh
```

### Step-by-Step Procedure
1. **Format & Static Validation**:
   ```bash
   $TERRAFORM fmt -recursive -check
   $TERRAFORM init -backend=false
   $TERRAFORM validate
   ```
2. **Live Zero-Drift Check (if authenticated to GCP)**:
   ```bash
   GOOGLE_OAUTH_ACCESS_TOKEN=$(gcloud auth print-access-token) $TERRAFORM plan -detailed-exitcode -no-color
   ```
   *(Exit code `0` confirms zero infrastructure drift).*

---

## 4. Reviewer Assessment Checklist (Slide 15)

Before approving any CL or PR on `gcp-ai-foundation-blueprint`, verify:
- [ ] Every variable in `variables.tf` has both `type` and `description` (`go/terraform-style`).
- [ ] Data-plane IAM bindings use resource-scoped resources (`google_storage_bucket_iam_member`, `google_bigquery_dataset_iam_member`, `google_iap_web_iam_member`) rather than `google_project_iam_member`.
- [ ] All `google_storage_bucket` resources enforce `public_access_prevention = "enforced"` and `uniform_bucket_level_access = true`.
- [ ] `README.md`, `README-EN.md`, and `terraform.tfvars.example` reflect any added or modified variables/outputs.
