#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../utils.sh"
source "$SCRIPT_DIR/../Entity/project.sh"

LIST_TITLE="СПИСОК ПРОЕКТОВ"
LIST_DESC="Все доступные проекты"

main() {
  clear_screen
  while true; do
    echo ""
    draw_header "$LIST_TITLE" "$LIST_DESC"
    echo ""

    printf '%s\n' " NAME       mariadb_version   STATUS"
    printf '%s\n' "------------------------------------"

    project_list | while IFS=$'\t' read -r name mariadb_version status; do
      if [[ "$status" == "true" ]]; then
        status_label="Включен"
      else
        status_label="Отключен"
      fi
      line=$(printf " %s\t%s\t%s" "$name" "$mariadb_version" "$status_label")
      printf '%s\n' "$line"
    done

    echo ""
    echo -e " ${RED}0${NC} │ Вернуться назад"
    echo ""

    read -rp " Введите name проекта для редактирования (или 0 для выхода): " selected_name

    if [[ "$selected_name" == "0" || -z "$selected_name" ]]; then
      return
    fi

    if ! project_exists "$selected_name"; then
      echo ""
      echo -e " ${RED}✗ Проект с name \"$selected_name\" не найден${NC}"
      echo ""
      read -rp "Нажмите Enter для продолжения..."
      clear_screen
      continue
    fi

    bash "$SCRIPT_DIR/../Menu/ProjectEditMenu.sh" "$selected_name"
    clear_screen
  done
}

main
