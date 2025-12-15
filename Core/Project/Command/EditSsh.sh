#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../utils.sh"
source "$SCRIPT_DIR/../Entity/project.sh"

EDIT_SSH_TITLE="РЕДАКТИРОВАНИЕ SSH"
EDIT_SSH_DESC="Доступ по SSH"

main() {
  local name="$1"

  clear_screen
  echo ""
  draw_header "$EDIT_SSH_TITLE" "$EDIT_SSH_DESC"
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

  IFS=$'\t' read -r mariadb_version old_ssh_host old_ssh_user old_ssh_pass old_ssh_port old_db_host old_db_port old_db_user old_db_pass old_db_name old_dump_remote old_dump_local <<EOF
$(project_get "$name")
EOF

  echo " Текущие значения SSH:"
  echo " host : $old_ssh_host"
  echo " user : $old_ssh_user"
  echo " pass : $old_ssh_pass"
  echo " port : $old_ssh_port"
  echo ""

  read -rp " Новый SSH host [$old_ssh_host]: " ssh_host
  [[ -z "$ssh_host" ]] && ssh_host="$old_ssh_host"
  [[ "$ssh_host" == "0" ]] && return

  read -rp " Новый SSH user [$old_ssh_user]: " ssh_user
  [[ -z "$ssh_user" ]] && ssh_user="$old_ssh_user"
  [[ "$ssh_user" == "0" ]] && return

  read -rp " Новый SSH password [$old_ssh_pass]: " ssh_password
  [[ -z "$ssh_password" ]] && ssh_password="$old_ssh_pass"
  [[ "$ssh_password" == "0" ]] && return

  read -rp " Новый SSH port [$old_ssh_port]: " ssh_port
  [[ -z "$ssh_port" ]] && ssh_port="$old_ssh_port"
  [[ "$ssh_port" == "0" ]] && return

  project_update_ssh "$name" "$ssh_host" "$ssh_user" "$ssh_password" "$ssh_port"

  echo ""
  echo -e " ${GREEN}✓ SSH-параметры проекта обновлены${NC}"
  echo ""
  read -rp "Нажмите Enter для продолжения..."
}

main "$@"


