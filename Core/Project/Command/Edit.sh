#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../utils.sh"
source "$SCRIPT_DIR/../Entity/project.sh"

EDIT_TITLE="РЕДАКТИРОВАНИЕ ПРОЕКТА"
EDIT_DESC="Введите name и новые данные"

main() {
  clear_screen
  echo ""
  draw_header "$EDIT_TITLE" "$EDIT_DESC"
  echo ""
  echo -e " ${RED}0${NC} │ Вернуться назад"
  echo ""

  read -rp " Введите name проекта: " name
  [[ "$name" == "0" ]] && return

  if ! project_exists "$name"; then
    echo ""
    echo -e " ${RED}✗ Проект с name \"$name\" не найден${NC}"
    echo ""
    read -rp "Нажмите Enter для продолжения..."
    return
  fi

  # получаем старые значения
  IFS=$'\t' read -r old_mariadb_version old_ssh_host old_ssh_user old_ssh_pass old_ssh_port old_db_host old_db_port old_db_user old_db_pass old_db_name old_dump_remote old_dump_local<<EOF
$(project_get "$name")
EOF

  echo ""
  echo "Текущие значения:"
  echo " mariadb_version : $old_mariadb_version"
  echo " ssh host: $old_ssh_host"
  echo " ssh user: $old_ssh_user"
  echo " ssh pass: $old_ssh_pass"
  echo " ssh port: $old_ssh_port"
  echo " database host: $old_db_host"
  echo " database port: $old_db_port"
  echo " database user: $old_db_user"
  echo " database pass: $old_db_pass"
  echo " database name: $old_db_name"
  echo " dumps remote: $old_dump_remote"
  echo " dumps local: $old_dump_local"
  echo ""

  echo " Выберите версию MariaDB (текущая: $old_mariadb_version):"
  PS3=" Введите номер: "
  versions=("10.1" "10.6" "10.11" "11.8" "12.0")
  select version in "${versions[@]}"; do
    mariadb_version="$version"
    break
  done
  [[ "$mariadb_version" == "0" ]] && return

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

  project_update "$name" "$mariadb_version" "$ssh_host" "$ssh_user" "$ssh_password" "$ssh_port"

  echo ""
  echo -e " ${GREEN}✓ Проект \"$name\" обновлён${NC}"
  echo ""
  read -rp "Нажмите Enter для продолжения..."
}

main
