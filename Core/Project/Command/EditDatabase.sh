#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../utils.sh"
source "$SCRIPT_DIR/../Entity/project.sh"

EDIT_DB_TITLE="РЕДАКТИРОВАНИЕ DATABASE"
EDIT_DB_DESC="Параметры базы данных"

main() {
  local name="$1"

  clear_screen
  echo ""
  draw_header "$EDIT_DB_TITLE" "$EDIT_DB_DESC"
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

  IFS=$'\t' read -r mariadb_version ssh_host ssh_user ssh_pass ssh_port old_db_host old_db_port old_db_user old_db_pass old_db_name old_dump_remote old_dump_local <<EOF
$(project_get "$name")
EOF

  echo " Текущие значения database:"
  echo " host : $old_db_host"
  echo " port : $old_db_port"
  echo " user : $old_db_user"
  echo " pass : $old_db_pass"
  echo " name : $old_db_name"
  echo ""

  read -rp " Новый DB host [$old_db_host]: " db_host
  [[ -z "$db_host" ]] && db_host="$old_db_host"
  [[ "$db_host" == "0" ]] && return

  read -rp " Новый DB port [$old_db_port]: " db_port
  [[ -z "$db_port" ]] && db_port="$old_db_port"
  [[ "$db_port" == "0" ]] && return

  read -rp " Новый DB user [$old_db_user]: " db_user
  [[ -z "$db_user" ]] && db_user="$old_db_user"
  [[ "$db_user" == "0" ]] && return

  read -rp " Новый DB password [$old_db_pass]: " db_pass
  [[ -z "$db_pass" ]] && db_pass="$old_db_pass"
  [[ "$db_pass" == "0" ]] && return

  read -rp " Новый DB name [$old_db_name]: " db_name
  [[ -z "$db_name" ]] && db_name="$old_db_name"
  [[ "$db_name" == "0" ]] && return

  project_update_database "$name" "$db_host" "$db_port" "$db_user" "$db_pass" "$db_name"

  echo ""
  echo -e " ${GREEN}✓ Параметры database проекта обновлены${NC}"
  echo ""
  read -rp "Нажмите Enter для продолжения..."
}

main "$@"


