# 🚀 Container Security Demo with Lacework Inline Scanner

This repository demonstrates how to integrate the **Lacework FortiCNAPP Inline Scanner** into a GitHub Actions CI pipeline to scan Docker images for vulnerabilities, enforce security policies, and block risky images from being published.

---

## 📦 About

This demo shows how to:
- Scan Docker images automatically during PRs
- Comment scan results directly on pull requests
- Enforce vulnerability policies (warn or block)
- Push only secure images to GitHub Container Registry (GHCR)

---

## 🧪 Try It Yourself

### ✅ Use This Repo as a Template

1. Click **"Use this template"** at the top-right of this repo.
2. Name your new repository.
3. Clone it or start editing online.

---

## 🔐 Configure the Lacework Integration

Before you can scan images, create an **Inline Scanner integration** in Lacework:

1. Go to your Lacework console.
2. Navigate to: `Settings` → `Container Registries`.
3. Click **+ Add New**, and choose **Inline Scanner**.
4. After creating it, click the entry to reveal your **access token**.

Set the following secrets in your GitHub repo under `Settings` → `Secrets and variables` → `Actions`:

| Secret             | Description                                     |
|--------------------|-------------------------------------------------|
| `LW_ACCOUNT_NAME`  | Your tenant name (e.g. `<tenant>.lacework.net`) |
| `LW_ACCESS_TOKEN`  | The access token from the scanner integration   |

---

## 🛡️ Set Up Protected Branches

To enforce secure workflows:

1. Go to **Settings > Branches**.
2. Add a branch protection rule for `main`.
3. Enable:
   - ✅ Require pull request before merging
   - ✅ Require status checks to pass
   - ✅ Include your Lacework scan job name (e.g., `build-scan-push`)

---

## 🔄 Full Vulnerability-to-Fix Workflow

### 🔹 Step 1: Trigger a Vulnerable Image Scan

In your `Dockerfile`, set a known vulnerable base:

```Dockerfile
FROM alpine:3.10
```

Commit this to a new branch and open a pull request.

---

### 🔹 Step 2: Observe PR Scan Results

The GitHub Action will:
- Build the image
- Scan it with Lacework
- Comment the scan results on the PR

![image](https://github.com/user-attachments/assets/a9d8f4a9-cb82-44a9-8b71-947003783afd)

---

### 🔹 Step 3: Block Builds via Policy

To make GitHub Action **fail on policy violations**:

1. In the Lacework console, go to `Policies` and filter for `Vulnerabilities: Build Time`.
2. Locate `LW_CONTAINER_POLICY_3: Critical, fixable CVEs`.
3. set **Action on failure** to `Block`

Now, when you push to the PR again (e.g. minor edit), the scan will:
- Still comment results
- Now **fail the CI job**
- Block merging

![image](https://github.com/user-attachments/assets/1d36ee72-3028-4b33-9a67-b6172f20f565)


---

### 🔹 Step 4: Fix the Vulnerability

Update the `Dockerfile` to a patched base image:

```Dockerfile
FROM alpine:3.19
```

This version includes a fixed version of `zlib` and other patched packages.

Push the change. The scan should:
- Detect no policy violations
- Pass the job
- Allow merging the PR

![image](https://github.com/user-attachments/assets/492ffa6d-1f54-4980-ac4a-e5364bd37554)

**Note**: there are still vulnerabilities found, but none in violation of my FortiCNAPP Policy set in Block for Criticial CVE's with available Fixes.

---

### 🔹 Step 5: Merge and Trigger Image Push

Once merged to `main`, GitHub Actions will:
- Re-scan the image
- Log in to GHCR
- Push it with tags like `:latest`, `:v1.0.0`, and the commit SHA

![image](https://github.com/user-attachments/assets/6ba745c4-b50c-4744-a9ea-2e6bc660b99a)

---

## 🧼 Best Practices

- Scans run for **every PR**, but images are pushed **only on merge to `main`**.
- Comments are posted regardless of scan pass/fail.
- Builds are blocked if policy detects fixable critical CVEs.

---

## 📚 References

- [Lacework Inline Scanner Docs](https://docs.fortinet.com/document/lacework-forticnapp/latest/administration-guide/209175/integrate-the-lacework-forticnapp-inline-scanner-with-ci-pipelines#integrate-with-github-actions)

---

## 🧰 Need Help?

Open an issue in this repo or contact your internal security team to set up Lacework integrations and policies.
