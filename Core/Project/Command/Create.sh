#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../../utils.sh"
source "$SCRIPT_DIR/../Entity/project.sh"

CREATE_TITLE="СОЗДАНИЕ ПРОЕКТА"
CREATE_DESC="Заполните данные"

main() {
  clear_screen
  echo ""
  draw_header "$CREATE_TITLE" "$CREATE_DESC"
  echo ""
  echo -e " ${RED}0${NC} │ Вернуться назад"
  echo ""

  read -rp " Введите name (ключ): " name
  [[ "$name" == "0" ]] && return

  if project_exists "$name"; then
    echo ""
    echo -e " ${RED}✗ Проект с name \"$name\" уже существует${NC}"
    echo ""
    read -rp "Нажмите Enter для продолжения..."
    return
  fi

  echo "  Выберите версию MariaDB:"
  PS3=" Введите номер: "
  versions=("10.1" "10.6" "10.11" "11.8" "12.0")
  select version in "${versions[@]}"; do
    mariadb_version="$version"
    break
  done
  [[ "$mariadb_version" == "0" ]] && return

  project_create_basic "$name" "$mariadb_version" || {
    echo ""
    echo -e " ${RED}✗ Ошибка при создании проекта${NC}"
    echo ""
    read -rp "Нажмите Enter для продолжения..."
    return
  }

  echo ""
  echo -e " ${GREEN}✓ Проект \"$name\" создан${NC}"
  echo ""
  read -rp "Нажмите Enter для продолжения..."
}

main