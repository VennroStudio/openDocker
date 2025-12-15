#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROJECTS_FILE="$SCRIPT_DIR/../../../data/projects.json"
JQ_BIN="$SCRIPT_DIR/../../../bin/jq"

project_ensure_file() {
  if [[ ! -f "$PROJECTS_FILE" ]] || [[ ! -s "$PROJECTS_FILE" ]]; then
    mkdir -p "$(dirname "$PROJECTS_FILE")"
    printf '{}' > "$PROJECTS_FILE"
  fi
}

project_exists() {
  local name="$1"
  [[ -f "$PROJECTS_FILE" ]] || return 1
  "$JQ_BIN" -e "has(\"$name\")" "$PROJECTS_FILE" > /dev/null 2>&1
}

project_create() {
  local name="$1" mariadb_version="$2" ssh_host="$3" ssh_user="$4" ssh_password="$5" ssh_port="$6"
  database_host="$7" database_port="$8" database_user="$9" database_password="${10}" database_name="${11}"
  dumps_remote="${12}" dumps_local="${13}"


  project_ensure_file

  if project_exists "$name"; then
    return 1
  fi

  "$JQ_BIN" \
    --arg name "$name" \
    --arg mariadb_version "$mariadb_version" \
    --arg ssh_host "$ssh_host" \
    --arg ssh_user "$ssh_user" \
    --arg ssh_password "$ssh_password" \
    --arg ssh_port "$ssh_port" \
    --arg database_host "$database_host" \
    --arg database_port "$database_port" \
    --arg database_user "$database_user" \
    --arg database_password "$database_password" \
    --arg database_name "$database_name" \
    --arg dumps_remote "$dumps_remote" \
    --arg dumps_local "$dumps_local" \
    '. + {($name): {
      name: $name,
      mariadb_version: $mariadb_version,
      ssh: {
        host: $ssh_host,
        user: $ssh_user,
        password: $ssh_password,
        port: $ssh_port
      },
      database: {
        host: ($database_host // null),
        port: ($database_port // null),
        user: ($database_user // null),
        password: ($database_password // null),
        name: ($database_name // null)
      },
      dumps: {
        remote: ($dumps_remote // null),
        local: ($dumps_local // null)
      }
    }}' \
    "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"

  mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
}

project_create_basic() {
  local name="$1" mariadb_version="$2"

  project_create "$name" "$mariadb_version" "" "" "" "" "" "" "" "" "" "" ""
}

project_update() {
    local name="$1" mariadb_version="$2" ssh_host="$3" ssh_user="$4" ssh_password="$5" ssh_port="$6"
    database_host="$7" database_port="$8" database_user="$9" database_password="${10}" database_name="${11}"
    dumps_remote="${12}" dumps_local="${13}"

    "$JQ_BIN" \
      --arg name "$name" \
      --arg mariadb_version "$mariadb_version" \
      --arg ssh_host "$ssh_host" \
      --arg ssh_user "$ssh_user" \
      --arg ssh_password "$ssh_password" \
      --arg ssh_port "$ssh_port" \
      --arg database_host "$database_host" \
      --arg database_port "$database_port" \
      --arg database_user "$database_user" \
      --arg database_password "$database_password" \
      --arg database_name "$database_name" \
      --arg dumps_remote "$dumps_remote" \
      --arg dumps_local "$dumps_local" \
      '. + {($name): {
        name: $name,
        mariadb_version: $mariadb_version,
        ssh: {
          host: $ssh_host,
          user: $ssh_user,
          password: $ssh_password,
          port: $ssh_port
        },
        database: {
          host: ($database_host // null),
          port: ($database_port // null),
          user: ($database_user // null),
          password: ($database_password // null),
          name: ($database_name // null)
        },
        dumps: {
          remote: ($dumps_remote // null),
          local: ($dumps_local // null)
        }
      }}' \
    "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"

  mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
}

project_delete() {
  local name="$1"

  "$JQ_BIN" \
    --arg name "$name" \
    'del(.[$name])' \
    "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"

  mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
}

project_list() {
  project_ensure_file

  "$JQ_BIN" -r '
    to_entries[]
    | "\(.key)\t\(.value.mariadb_version)"
  ' "$PROJECTS_FILE"
}

project_get() {
  local name="$1"
  "$JQ_BIN" -r --arg name "$name" '
    .[$name] | [
      .mariadb_version,
      .ssh.host,
      .ssh.user,
      .ssh.password,
      .ssh.port,
      .database.host,
      .database.port,
      .database.user,
      .database.password,
      .database.name,
      .dumps.remote,
      .dumps.local
    ] | @tsv
  ' "$PROJECTS_FILE"
}

project_update_basic() {
  local old_name="$1" new_name="$2" mariadb_version="$3"

  project_ensure_file

  if [[ "$old_name" != "$new_name" ]] && project_exists "$new_name"; then
    return 1
  fi

  "$JQ_BIN" \
    --arg old_name "$old_name" \
    --arg new_name "$new_name" \
    --arg mariadb_version "$mariadb_version" \
    '
    if $old_name == $new_name then
      .[$old_name].name = $new_name
      | .[$old_name].mariadb_version = $mariadb_version
    else
      . as $root
      | $root[$old_name] as $proj
      | . + {($new_name): ($proj | .name = $new_name | .mariadb_version = $mariadb_version)}
      | del(.[$old_name])
    end
    ' \
    "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"

  mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
}

project_update_ssh() {
  local name="$1" ssh_host="$2" ssh_user="$3" ssh_password="$4" ssh_port="$5"

  project_ensure_file

  "$JQ_BIN" \
    --arg name "$name" \
    --arg ssh_host "$ssh_host" \
    --arg ssh_user "$ssh_user" \
    --arg ssh_password "$ssh_password" \
    --arg ssh_port "$ssh_port" \
    '
    .[$name].ssh.host = $ssh_host
    | .[$name].ssh.user = $ssh_user
    | .[$name].ssh.password = $ssh_password
    | .[$name].ssh.port = $ssh_port
    ' \
    "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"

  mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
}

project_update_database() {
  local name="$1" database_host="$2" database_port="$3" database_user="$4" database_password="$5" database_name="$6"

  project_ensure_file

  "$JQ_BIN" \
    --arg name "$name" \
    --arg database_host "$database_host" \
    --arg database_port "$database_port" \
    --arg database_user "$database_user" \
    --arg database_password "$database_password" \
    --arg database_name "$database_name" \
    '
    .[$name].database.host = ($database_host // null)
    | .[$name].database.port = ($database_port // null)
    | .[$name].database.user = ($database_user // null)
    | .[$name].database.password = ($database_password // null)
    | .[$name].database.name = ($database_name // null)
    ' \
    "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"

  mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
}

project_update_dumps() {
  local name="$1" dumps_remote="$2" dumps_local="$3"

  project_ensure_file

  "$JQ_BIN" \
    --arg name "$name" \
    --arg dumps_remote "$dumps_remote" \
    --arg dumps_local "$dumps_local" \
    '
    .[$name].dumps.remote = ($dumps_remote // null)
    | .[$name].dumps.local = ($dumps_local // null)
    ' \
    "$PROJECTS_FILE" > "${PROJECTS_FILE}.tmp"

  mv "${PROJECTS_FILE}.tmp" "$PROJECTS_FILE"
}

