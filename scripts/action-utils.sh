#!/bin/bash

validate_account_and_personal_access_key() {
  if [ -z "$HUBSPOT_ACCOUNT_ID" ]; then
    echo "Error: HUBSPOT_ACCOUNT_ID environment variable or account_id input is required but was not set"
    exit 1
  fi

  if [ -z "$HUBSPOT_PERSONAL_ACCESS_KEY" ]; then
    echo "Error: HUBSPOT_PERSONAL_ACCESS_KEY environment variable or personal_access_key input is required but was not set"
    exit 1
  fi

  return 0
}

# Resolves and validates a project directory path, then changes into that directory
# Arguments:
#   $1 - Project directory path (relative or absolute)
# Outputs:
#   Sets PROJECT_DIR variable with the resolved absolute path
#   Changes current working directory to the project directory
#   Exits with error if directory or hsproject.json not found
resolve_project_dir() {
  local input_path="$1"

  # Convert to absolute path if relative
  if [[ "$input_path" != /* ]]; then
    PROJECT_DIR="$GITHUB_WORKSPACE/$input_path"
  else
    PROJECT_DIR="$input_path"
  fi

  if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Project directory not found at path: $PROJECT_DIR"
    exit 1
  fi

  if [ ! -f "$PROJECT_DIR/hsproject.json" ]; then
    echo "Error: hsproject.json not found in directory: $PROJECT_DIR"
    exit 1
  fi

  # Change to the project directory
  cd "$PROJECT_DIR" || {
    echo "Error: Failed to change to project directory: $PROJECT_DIR"
    exit 1
  }
}

# Runs a HubSpot CLI command and handles its output
# Arguments:
#   $1 - The HubSpot CLI command to run
#   $2 - Whether to expect and parse JSON output (true/false)
# Outputs:
#   Sets COMMAND_OUTPUT variable with the raw output
#   Sets PARSED_OUTPUT variable with the parsed JSON (if JSON parsing is enabled and successful)
#   Returns the command's exit code
run_hs_command() {
  local command="$1"
  local expect_json="${2:-false}"

    command="$command --network-debug"

  # Run command and capture output
  COMMAND_OUTPUT=$($command)
  local exit_code=$?

  if [ $exit_code -ne 0 ]; then
    echo "Error: Command failed with output:"
    echo "$COMMAND_OUTPUT"
    exit $exit_code
  fi

  # Parse JSON if enabled
  if [ "$expect_json" = "true" ]; then
    if echo "$COMMAND_OUTPUT" | jq . >/dev/null 2>&1; then
      PARSED_OUTPUT=$(echo "$COMMAND_OUTPUT" | jq '.')
      return 0
    else
      echo "Error: Failed to parse JSON output: $COMMAND_OUTPUT"
      exit 1
    fi
  fi

  return 0
}



# Sets a GitHub Actions output from JSON, using the global PARSED_OUTPUT variable
# Automatically exits with code 1 if a required output is missing
# Arguments:
#   $1 - The output name to set
#   $2 - The JSON path to extract
#   $3 - Whether the output is optional (true/false), defaults to false
set_output_from_json() {
  local output_name="$1"
  local json_path="$2"
  local is_optional="${3:-false}"

  if [ -z "$PARSED_OUTPUT" ]; then
    echo "Error: No JSON output available. Make sure run_hs_command was called first."
    exit 1
  fi

  # Extract the value using jq
  local value
  value=$(echo "$PARSED_OUTPUT" | jq -r "$json_path")

  # Check if value exists and is not null
  if [ "$value" = "null" ] || [ -z "$value" ]; then
    if [ "$is_optional" = "true" ]; then
      return 0
    else
      echo "Error: Required output '$output_name' not found in JSON at path: $json_path"
      exit 1
    fi
  fi

  # Set the output
  echo "$output_name=$value" >> $GITHUB_OUTPUT

  return 0
}
