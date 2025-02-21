# Step-by-Step Guide to Deploy DBT Docs to GitHub Pages Using GitHub Actions , Github Secrets and PAT

## Introduction

This guide provides step-by-step instructions to automate the deployment of dbt (Data Build Tool) documentation to **GitHub Pages** using **GitHub Actions** and a **Personal Access Token (PAT)**.

## Prerequisites

Before starting, ensure that you have:

- A **dbt project** stored in a **GitHub repository**.
- A **Snowflake** account (if using dbt with Snowflake).
- **GitHub Actions enabled** for your repository.
- Access to **GitHub Secrets** to store sensitive credentials.

## Step 1: Generate a GitHub Personal Access Token (PAT)

1. Go to **GitHub** and navigate to **Settings**.
2. Click on **Developer settings** > **Personal access tokens** > **Tokens (classic)**.
3. Click **Generate new token** (classic).
4. Provide a note (e.g., "GitHub Pages Deployment Token").
5. Set the expiration as required.
6. Select the following scopes:
   - `repo` (Full control of private repositories)
   - `workflow` (To trigger GitHub Actions workflows)
7. Click **Generate token** and **copy** the token.

## Step 2: Configure GitHub Secrets

1. Navigate to your **GitHub repository**.
2. Go to **Settings** > **Secrets and variables** > **Actions** > **New repository secret**.
3. Add the following secrets:
   - `GH_PAT` → **Paste the GitHub Personal Access Token** (Generated in Step 1)
   - `DBT_SNOWFLAKE_ACCOUNT` → **Snowflake Account**
   - `DBT_SNOWFLAKE_USER` → **Snowflake User**
   - `DBT_SNOWFLAKE_PASS` → **Snowflake Password**
   - `DBT_PROFILES` → **Full content of your dbt profiles.yml file**

## Step 3: Create GitHub Action Workflow File

Create a GitHub Actions workflow YAML file at `.github/workflows/deploy_dbt_docs.yml`.

### YAML File for Deployment:

```yaml
name: Deploy dbt Docs to GitHub Pages

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: "3.9"

    - name: Install dbt & Snowflake Adapter
      run: |
        pip install dbt-core dbt-snowflake

    - name: Configure dbt Profiles
      run: |
        mkdir -p ~/.dbt
        echo "${{ secrets.DBT_PROFILES }}" > ~/.dbt/profiles.yml

    - name: Install dbt Dependencies
      run: dbt deps
      
    - name: Generate dbt Docs
      run: dbt docs generate

    - name: Deploy to GitHub Pages
      uses: peaceiris/actions-gh-pages@v3
      with:
        github_token: ${{ secrets.GH_PAT }}
        publish_dir: ./target
```

## Step 4: Enable GitHub Pages

1. Go to your **GitHub repository**.
2. Navigate to **Settings** > **Pages**.
3. Under **Source**, select **GitHub Actions**.
4. Save the settings.

## Step 5: Run the Workflow

After setting up the GitHub Actions workflow:

- Commit and push the `.github/workflows/deploy_dbt_docs.yml` file.
- GitHub Actions will run automatically when you push changes to the `main` branch.
- If successful, your **dbt Docs** will be deployed to GitHub Pages.

## Step 6: Access Your dbt Docs

Once the deployment is complete, your **dbt Docs** will be available at:

```
https://<your-github-username>.github.io/<your-repo-name>/
```

## Troubleshooting

### 1. "Nothing to compare" error when merging `gh-pages`

- Check if the **`gh-pages`** branch exists.
- If not, create it manually and re-run the workflow.

### 2. "403 Permission Denied" when pushing to GitHub Pages

- Ensure `GH_PAT` is set up with `repo` and `workflow` permissions.

### 3. "Profile Not Found" Error in dbt

- Ensure `DBT_PROFILES` is correctly stored in **GitHub Secrets**.
- Verify that `profiles.yml` is correctly formatted.

## Conclusion

You have successfully automated the deployment of **dbt Docs** to **GitHub Pages** using **GitHub Actions and a Personal Access Token (PAT)**! 🎉 If you need further customization, modify the workflow file accordingly.

---

## 📌 Additional Notes

- If you want to manually trigger the workflow, go to **Actions** in GitHub and select the workflow to run it.
- Keep your **PAT** secure and avoid exposing it in public repositories.
- Modify the **workflow file** if using a dbt adapter other than Snowflake.

