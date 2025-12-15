#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../utils.sh"
source "$SCRIPT_DIR/../Entity/project.sh"

EDIT_DUMPS_TITLE="РЕДАКТИРОВАНИЕ PATH DUMPS"
EDIT_DUMPS_DESC="Пути к дампам"

main() {
  local name="$1"

  clear_screen
  echo ""
  draw_header "$EDIT_DUMPS_TITLE" "$EDIT_DUMPS_DESC"
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

  IFS=$'\t' read -r mariadb_version ssh_host ssh_user ssh_pass ssh_port db_host db_port db_user db_pass db_name old_dump_remote old_dump_local <<EOF
$(project_get "$name")
EOF

  echo " Текущие значения dumps:"
  echo " remote : $old_dump_remote"
  echo " local  : $old_dump_local"
  echo ""

  read -rp " Новый remote path [$old_dump_remote]: " dumps_remote
  [[ -z "$dumps_remote" ]] && dumps_remote="$old_dump_remote"
  [[ "$dumps_remote" == "0" ]] && return

  read -rp " Новый local path [$old_dump_local]: " dumps_local
  [[ -z "$dumps_local" ]] && dumps_local="$old_dump_local"
  [[ "$dumps_local" == "0" ]] && return

  project_update_dumps "$name" "$dumps_remote" "$dumps_local"

  echo ""
  echo -e " ${GREEN}✓ Пути к дампам проекта обновлены${NC}"
  echo ""
  read -rp "Нажмите Enter для продолжения..."
}

main "$@"


