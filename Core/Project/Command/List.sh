#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../utils.sh"
source "$SCRIPT_DIR/../Entity/project.sh"

LIST_TITLE="СПИСОК ПРОЕКТОВ"
LIST_DESC="Все доступные проекты"

main() {
  clear_screen
  echo ""
  draw_header "$LIST_TITLE" "$LIST_DESC"
  echo ""

  printf '%s\n' " NAME       mariadb_version"
  printf '%s\n' "---------------------------"

  project_list | while IFS=$'\t' read -r name mariadb_version; do
    line=$(printf " %s\t%s" "$name" "$mariadb_version")
    printf '%s\n' "$line"
  done

  echo ""
  read -rp "Нажмите Enter для продолжения..."
}

main
