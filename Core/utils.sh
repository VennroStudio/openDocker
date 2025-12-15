#!/usr/bin/env bash

# Цвета
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export CYAN='\033[0;36m'
export BLUE='\033[0;34m'
export YELLOW='\033[1;33m'
export NC='\033[0m'

# Функция: получить ширину терминала
get_terminal_width() {
  tput cols
}

# Функция: очистить экран
clear_screen() {
  clear
}

# Функция: отрисовать заголовок
draw_header() {
  local title="$1"
  local description="$2"
  local width=$(get_terminal_width)
  local title_len=${#title}
  local desc_len=${#description}
  local padding=$(( (width - title_len - 2) / 2 ))
  local desc_padding=$(( (width - desc_len - 2) / 2 ))

  # Верхняя граница
  printf "${BLUE}╔"
  printf '═%.0s' $(seq 1 $((width - 2)))
  printf "╗${NC}\n"

  # Заголовок
  printf "${BLUE}║${NC}"
  printf '%*s' $padding ''
  printf "${CYAN}${title}${NC}"
  printf '%*s' $((width - padding - title_len - 2)) ''
  printf "${BLUE}║${NC}\n"

  # Описание (если есть)
  if [ -n "$description" ]; then
    printf "${BLUE}║${NC}"
    printf '%*s' $desc_padding ''
    printf "${YELLOW}${description}${NC}"
    printf '%*s' $((width - desc_padding - desc_len - 2)) ''
    printf "${BLUE}║${NC}\n"
  fi

  # Нижняя граница
  printf "${BLUE}╚"
  printf '═%.0s' $(seq 1 $((width - 2)))
  printf "╝${NC}\n"
}
