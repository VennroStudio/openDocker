#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../utils.sh"
source "$SCRIPT_DIR/../Entity/project.sh"

EDIT_BASIC_TITLE="РЕДАКТИРОВАНИЕ ОСНОВНОЙ ИНФОРМАЦИИ"
EDIT_BASIC_DESC="name и mariadb_version"

main() {
  local name="$1"
  local old_name

  clear_screen
  echo ""
  draw_header "$EDIT_BASIC_TITLE" "$EDIT_BASIC_DESC"
  echo ""
  echo -e " ${RED}0${NC} │ Вернуться назад"
  echo ""

  if [[ -z "$name" ]]; then
    read -rp " Введите name проекта: " name
    [[ "$name" == "0" ]] && return
  fi

  if ! project_exists "$name"; then
    echo ""
    echo -e " ${RED}✗ Проект с name \"$name\" не найден${NC}"
    echo ""
    read -rp "Нажмите Enter для продолжения..."
    return
  fi

  IFS=$'\t' read -r old_mariadb_version old_ssh_host old_ssh_user old_ssh_pass old_ssh_port old_db_host old_db_port old_db_user old_db_pass old_db_name old_dump_remote old_dump_local <<EOF
$(project_get "$name")
EOF

  old_name="$name"

  echo " Текущие значения:"
  echo " name            : $old_name"
  echo " mariadb_version : $old_mariadb_version"
  echo ""

  read -rp " Новое name [$old_name]: " new_name
  [[ -z "$new_name" ]] && new_name="$old_name"
  [[ "$new_name" == "0" ]] && {
    if [[ -n "$PROJECT_EDIT_NAME_FILE" ]]; then
      printf '%s\n' "$old_name" > "$PROJECT_EDIT_NAME_FILE"
    fi
    return
  }

  echo ""
  echo " Выберите версию MariaDB (текущая: $old_mariadb_version):"
  PS3=" Введите номер: "
  local versions=("10.1" "10.6" "10.11" "11.8" "12.0")
  local mariadb_version
  select version in "${versions[@]}"; do
    mariadb_version="$version"
    break
  done
  [[ "$mariadb_version" == "0" ]] && {
    if [[ -n "$PROJECT_EDIT_NAME_FILE" ]]; then
      printf '%s\n' "$old_name" > "$PROJECT_EDIT_NAME_FILE"
    fi
    return
  }

  if ! project_update_basic "$old_name" "$new_name" "$mariadb_version"; then
    echo ""
    echo -e " ${RED}✗ Проект с name \"$new_name\" уже существует${NC}"
    echo ""
    read -rp "Нажмите Enter для продолжения..."
    if [[ -n "$PROJECT_EDIT_NAME_FILE" ]]; then
      printf '%s\n' "$old_name" > "$PROJECT_EDIT_NAME_FILE"
    fi
    return
  fi

  echo ""
  echo -e " ${GREEN}✓ Основная информация проекта обновлена${NC}"
  echo ""
  read -rp "Нажмите Enter для продолжения..."
  if [[ -n "$PROJECT_EDIT_NAME_FILE" ]]; then
    printf '%s\n' "$new_name" > "$PROJECT_EDIT_NAME_FILE"
  fi
}

main "$@"


