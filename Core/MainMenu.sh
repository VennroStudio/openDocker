#!/usr/bin/env bash

# Подключаем общие функции
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Глобальные переменные
MENU_TITLE="ГЛАВНОЕ МЕНЮ"
MENU_DESC=""

# Функция: главное меню
show_main_menu() {
  while true; do
    clear_screen
    echo ""
    draw_header "$MENU_TITLE" "$MENU_DESC"
    echo ""
    echo -e "  ${GREEN}1${NC} │ Проекты"
    echo -e "  ${RED}0${NC} │ Выход"
    echo ""
    printf "  ${YELLOW}→${NC} "
    read -r choice

    case $choice in
      1)
        bash "$SCRIPT_DIR/Project/Menu/ProjectMenu.sh"
        ;;
      0)
        clear_screen
        echo -e "\n  ${GREEN}До свидания!${NC}\n"
        exit 0
        ;;
      *)
        echo -e "  ${RED}✗ Неверный выбор!${NC}"
        sleep 1
        ;;
    esac
  done
}

# Запуск
show_main_menu
