## Rule: Safewill GCP operations trigger

When a request is about Safewill GCP (projects, logging, monitoring, SLOs, IAM, WIF, or `gcloud`), consult and follow the `gcp-operations` skill first before using ad-hoc help.

### Enforcement
- Applies to: all Safewill GCP operations requests.
- Consequence on breach: stop and re-run the task using the `gcp-operations` skill path first.
