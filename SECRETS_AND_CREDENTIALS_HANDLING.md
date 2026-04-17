•  Priority: CRITICAL
•  Importance: EXTREME
•  Never Ignore: true
•  Description: NEVER_COMMIT_SECRETS_CREDENTIALS_OR_SENSITIVE_DATA
•  Prohibited in Commits:
◦  api_keys
◦  passwords
◦  private_keys
◦  access_tokens
◦  database_credentials
•  Required Practices:
◦  use_environment_variables
◦  use_secrets_management_service
◦  verify_env_example_file_exists
◦  check_gitignore_for_sensitive_files
•  Pre-Commit Checks:
◦  scan_for_hardcoded_credentials
◦  verify_no_sensitive_patterns