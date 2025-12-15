#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../utils.sh"
source "$SCRIPT_DIR/../Entity/project.sh"

PROJECT_EDIT_MENU_TITLE="РЕДАКТИРОВАНИЕ ПРОЕКТА"
PROJECT_EDIT_MENU_DESC="Выберите, что редактировать"

main() {
  local project_name="$1"
  local tmp_name_file="$SCRIPT_DIR/../.project_edit_name"

  if [[ -z "$project_name" ]]; then
    echo -e " ${RED}✗ Не передано name проекта для редактирования${NC}"
    read -rp "Нажмите Enter для продолжения..."
    return 1
  fi

  if ! project_exists "$project_name"; then
    echo -e " ${RED}✗ Проект с name \"$project_name\" не найден${NC}"
    read -rp "Нажмите Enter для продолжения..."
    return 1
  fi

  while true; do
    local status status_label toggle_label
    status="$(project_get_status "$project_name")"
    if [[ "$status" == "true" ]]; then
      status_label="Статус: Включен"
      toggle_label="Отключить проект"
    else
      status_label="Статус: Отключен"
      toggle_label="Включить проект"
    fi

    clear_screen
    echo ""
    draw_header "$PROJECT_EDIT_MENU_TITLE" "Проект: $project_name • $status_label"
    echo ""
    echo " 1 │ $toggle_label"
    echo " 2 │ Редактировать основную информацию"
    echo " 3 │ Редактировать SSH"
    echo " 4 │ Редактировать database"
    echo " 5 │ Редактировать path dumps"
    echo ""
    echo -e " ${RED}0${NC} │ Вернуться к списку проектов"
    echo ""

    read -rp " Выберите действие: " choice

    case "$choice" in
      1)
        project_toggle_status "$project_name"
        ;;
      2)
        export PROJECT_EDIT_NAME_FILE="$tmp_name_file"
        bash "$SCRIPT_DIR/../Command/EditBasic.sh" "$project_name"
        if [[ -f "$tmp_name_file" ]]; then
          local new_name
          read -r new_name < "$tmp_name_file"
          rm -f "$tmp_name_file"
          if [[ -n "$new_name" ]]; then
            project_name="$new_name"
          fi
        fi
        ;;
      3) bash "$SCRIPT_DIR/../Command/EditSsh.sh" "$project_name" ;;
      4) bash "$SCRIPT_DIR/../Command/EditDatabase.sh" "$project_name" ;;
      5) bash "$SCRIPT_DIR/../Command/EditDumps.sh" "$project_name" ;;
      0) return ;;
    esac
  done
}

main "$@"


