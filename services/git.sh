#!/bin/bash

# git status
function git_status (){
  print_divider
  print_warning "Tu estatus de la rama actual"
  git status
  print_divider
  git_check_unpushed
  print_divider
  return 0
}

# git unpushed check
function git_check_unpushed (){
  UNPUSHED_GCH=$(git diff --name-only)
  if [[ -z "$unpushed_files" ]]; then
    # No unpushed changes found.
    print_warning "No hay cambios registrados"
    return 0
  else
    # Unpushed changes found. Capture the list for user message.
    print_error"Tiene cambios por subir"
    print_message "$unpushed_files"
    print_error "Por favor, sube estos cambios antes de cambiar de rama"
    exit 1
  fi
}

# git branchs
## git check all branch
function git_get_branches (){
  print_divider
  print_key "All your branches"
  git branch --list | grep -v "\*" | paste -s -d " "
  print_divider
}
## git change branchs
function git_change_branch (){
  git_status
  print_message "Selecciona la rama a cambiar ->"
  CHOOSE_CH=$(choose_one $(git branch --list | grep -v "\*"))
  try_catch "take a others branchs"
  if_null $CHOOSE_CH
  print_message "Rama seleccionada"
  print_user "$CHOOSE_CH"
  git switch "$CHOOSE_CH"
  try_catch "change to $CHOOSE_CH"
  print_key "Cambio de rama exitosa"
}
## git create a branch
function git_create_branch (){
  print_key "Crear nueva Rama"
  print_message "Ingrese el nombre de la rama"
  NAME_CR=$(input_text "nueva rama")
  try_catch "take a new branch name"
  if_null $NAME_CR
  print_user "$NAME_CR"
  print_key "Rama de origen"
  print_message "Seleccione la rama de origen"
  CHOOSE_CR=$(choose_one $(git branch --list | cut -c3-) "Huérfana")
  try_catch "origin branch"
  if_null $CHOOSE_CR
  print_message "Rama origen"
  print_user "$CHOOSE_CR"
  if [[ "$CHOOSE_CR" = "Huérfana" ]]; then
    print_key "Creando rama Huérfana"
    PARAM_CR="--orphan"
  else
    print_key "Cambiando a la rama origen"
    PARAM_CR=""
  fi
  git switch $PARAM_CR "$CHOOSE_CR"
  try_catch "change to origin"
  git switch -c "$NAME_CR"
  try_catch "branch created"
}
## git delete a branch
function git_delete_branch (){
  print_key "Eliminar una rama"
  print_message "Seleccione la rama a eliminar"
  print_warning "¡Rama actual no disponible!"
  CHOOSE_DE=$(choose_one $(git branch --list | grep -v "\*"))
  try_catch "take a branch"
  if_null $CHOOSE_DE
  print_message "Rama seleccionada para eliminar"
  print_key "$CHOOSE_DE"
  print_message "Confirma"
  CONTINUE_DE=$(confirm_yn "Estas seguro de eliminar")
  try_catch "take a confirmation"
  if_null $CONTINUE_DE
  if [[ "$CONTINUE_DE" = "yes" ]]; then
    git branch -d $CHOOSE_DE
    try_catch "branch deleted"
  else
    print_error "Eliminación cancelada"
  fi
}

# git config
## git config account
function git_config_account (){
  git config "--${1}" user.name "${2}"
  try_catch "git user config"
  git config "--${1}" user.email "${3}"
  try_catch "git email config"
}

# export default
export GIT_SERVICES_LOADED=true
