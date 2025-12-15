#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../utils.sh"

PROJECT_MENU_TITLE="МЕНЮ ПРОЕКТОВ"
PROJECT_MENU_DESC="Выберите действие"

main() {
  while true; do
    clear_screen
    echo ""
    draw_header "$PROJECT_MENU_TITLE" "$PROJECT_MENU_DESC"
    echo ""
    echo " 1 │ Список проектов"
    echo " 2 │ Создать проект"
    echo " 3 │ Редактировать проект"
    echo " 4 │ Удалить проект"
    echo ""
    echo -e " ${RED}0${NC} │ Вернуться назад"
    echo ""

    read -rp " Выберите действие: " choice

    case "$choice" in
      1) bash "$SCRIPT_DIR/../Command/List.sh" ;;
      2) bash "$SCRIPT_DIR/../Command/Create.sh" ;;
      3) bash "$SCRIPT_DIR/../Command/Edit.sh" ;;
      4) bash "$SCRIPT_DIR/../Command/Delete.sh" ;;
      0) return ;;
    esac
  done
}

main
