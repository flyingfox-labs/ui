SHARED_DIR := "shared"
UI_DIR := "ui"
UI_WEB_DIR := "ui_web"
THEME_FILE_NAME := "theme.css"

_list:
    @just --list

# Update theme
update:
    @cp {{ SHARED_DIR }}/{{ THEME_FILE_NAME }} {{ UI_DIR }}/src/{{ THEME_FILE_NAME }}
    @cp {{ SHARED_DIR }}/{{ THEME_FILE_NAME }} {{ UI_WEB_DIR }}/src/{{ THEME_FILE_NAME }}
    @cp {{ UI_DIR }}/src/ui/index.css {{ UI_WEB_DIR }}/src/ui_index.css
