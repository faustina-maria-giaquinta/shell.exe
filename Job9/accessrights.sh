#! /bin/bash
remove_spaces() {
    local str="$1"
    echo "${str}" | awk '{$1=$1};1'
}
{
    read
    while IFS=, read -r id prenom nom passwd role || [ -n "$id" ]; do
        name=$(remove_spaces "$prenom")_$(remove_spaces "$nom")
        role=$(remove_spaces "$role")

        if [ "$role" = "Admin" ]; then
            group="root"
        else
            group="users"
        fi
        sudo useradd "$name" -u "$id" -p "$4" -g "$group"

    done
} <Shell_Userlist.csv
