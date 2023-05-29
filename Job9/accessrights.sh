#! /bin/bash
csv_file="/home/faustina/Start/shell.exe/Job9/Shell_Userlist.csv"

remove_spaces() {
    local str="$1"
    echo "${str}" | awk '{$1=$1};1'
}

create_update_user() {
    read
    while IFS=, read -r id prenom nom passwd role || [ -n "$id" ]; do
        name=$(remove_spaces "$prenom")_$(remove_spaces "$nom")
        role=$(remove_spaces "$role")

        if [ "$role" = "Admin" ]; then
            group="root"
        else
            group="users"
        fi

	if id "$name" >/dev/null 2>&1 ; then
        sudo usermod "$name" -u "$id" -p "$4" -aG "$group"
	else
	sudo useradd "$name" -u "$id" -p "$4" -g "$group"
	fi
    done <"$csv_file"
}


check_changes() {
    current_timestamp=$(stat -c %Y "$csv_file")
    previous_timestamp=$(cat "/var/tmp/previous_csv_timestamp" 2>/dev/null || echo 0)

    if [ "$previous_timestamp" = "$current_timestamp" ]; then
        exit 0
    else
	echo "$current_timestamp" > "/var/tmp/previous_csv_timestamp"
	create_update_user
    fi
}

check_changes >> /var/log/accessrights.log 2>&1
