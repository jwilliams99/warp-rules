•  Priority: HIGH
•  Never Ignore: true
•  Description:  
  ALL_GIT_COMMITS_MUST_FOLLOW_CONVENTIONAL_COMMIT_FORMAT_WITH_FACTUAL_BULLET_POINTS_AND_TICKET_NUMBER_ON_LAST_LINE
•  Format (logical lines):
◦  type(scope): description
◦  • factual change 1
◦  • factual change 2
◦  • factual change 3
◦  TICKET-NUMBER
•  Example (logical lines):
◦  feat(logging): add user_id to log format string
◦  • added [user:%(user_id)s] to defaults.yaml format string
◦  • updated fallback format in __init__.py
◦  • modified auth endpoints to use get_log_context()
◦  ENG-338
•  Allowed Types:
◦  feat
◦  fix
◦  docs
◦  style
◦  refactor
◦  test
◦  chore
•  Enforcement: mandatory