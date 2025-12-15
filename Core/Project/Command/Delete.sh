#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../utils.sh"
source "$SCRIPT_DIR/../Entity/project.sh"

DELETE_TITLE="УДАЛЕНИЕ ПРОЕКТА"
DELETE_DESC="Введите name для удаления"

main() {
  clear_screen
  echo ""
  draw_header "$DELETE_TITLE" "$DELETE_DESC"
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

  project_delete "$name"

  echo ""
  echo -e " ${GREEN}✓ Проект \"$name\" удалён${NC}"
  echo ""
  read -rp "Нажмите Enter для продолжения..."
}

main
