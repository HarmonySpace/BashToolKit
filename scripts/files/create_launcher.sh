print_montse "Crear un lanzador"
temp2="$(create_temp)"
put_in $temp2 "[Desktop Entry]\nName=empty\nComment=empty\nExec=empty\nIcon=empty\nType=Application\n"
print_message_b "$(cat $temp2)"
wait_enter
print_montse "Ingresa el nombre de la aplicación"
add_in $temp1 "name = $(input_text "Aplicación")"
if_null "$(search_in $temp1 "name" = 2)"
print_montse "Ingresa un comentario"
add_in $temp1 "comment = $(input_text "Aplicación para ...")"
if_null "$(search_in $temp1 "comment" = 2)"
print_montse "Seleccióna el archivo a ejecutar"
add_in $temp1 "exec = $(file_browser)"
if_null "$(search_in $temp1 "exec" = 2)"
print_montse "Seleccióna el icono del lanzador"
add_in $temp1 "icon = $(file_browser)"
if_null "$(search_in $temp1 "icon" = 2)"
replace_in $temp2 $temp2 "Name=empty" "Name=$(search_in $temp1 "name" = 2)"
replace_in $temp2 $temp2 "Comment=empty" "Comment=$(search_in $temp1 "comment" = 2)"
replace_in $temp2 $temp2 "Exec=empty" "Exec=$(search_in $temp1 "exec" = 2)"
replace_in $temp2 $temp2 "Icon=empty" "Icon=$(search_in $temp1 "icon" = 2)"
cp $temp2 "$HOME/.local/share/applications/$(search_in $temp1 "name" = 2).desktop"
print_user_b "$(cat $temp2)"
