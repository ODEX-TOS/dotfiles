#!/usr/bin/env bash

# ----------------------------------------------------------------------------
# --- Simple screenshot script using maim
# --
# -- Accepts `area` and `full` string args
# --
# -- For more details check `man maim`
# --
# -- @author manilarome &lt;gerome.matilla07@gmail.com&gt;
# -- @author Tom Meyers &lt;tom@odex.begt;
# -- @copyright 2020 manilarome
# -- @copyright 2020 Tom Meyers
# -- @script snapshot
# ----------------------------------------------------------------------------


screenshot_dir="$HOME/Pictures/Screenshots/"
COLOR="${2:-none}"

echo "Selected color: $COLOR"

# Check save directory
# Creates it if it doesn't exist
function check_dir() {
	if [ ! -d "$screenshot_dir" ];
	then
		mkdir -p "$screenshot_dir"
	fi
}

# Main function
function shot() {

	check_dir

	file_loc="${screenshot_dir}$(date +%Y%m%d_%H%M%S).png"
	
	maim_command="$1"
	notif_message="$2"

	# Execute maim command if a third option is provided maim will be piped into it
	if [[ ! -z "$3" ]]; then
		${maim_command} | $3 "${file_loc}"
	else
		${maim_command} "${file_loc}"
	fi

	# Exit if the user cancels the screenshot
	# So it means there's no new screenshot image file
	if [ ! -f "${file_loc}" ]; then
		exit
	fi

	# Copy to clipboard
	xclip -selection clipboard -t image/png -i "${screenshot_dir}"/`ls -1 -t "${screenshot_dir}" | head -1` &

	notify-send 'Snap!' "${notif_message}" -a 'Screenshot tool' -i "${file_loc}"
}

# Check the args passed
if [ -z "$1" ] || ([ "$1" != 'full' ] && [ "$1" != 'area' ] && [ "$1" != 'window' ]);
then
	echo "
	Requires an argument:
	area 	- Area screenshot
	full 	- Fullscreen screenshot
	window  - Take a screenshot of a window (optionaly provide a color for the background)

	Example:
	./snapshot area
	./snapshot full
	./snapshot window
	./snapshot window #FFFFFF
	"
elif [ "$1" = 'full' ];
then
	msg="Full screenshot saved and copied to clipboard!"
	shot 'maim -u -m 1' "${msg}"
elif [ "$1" = 'area' ];
then
	msg='Area screenshot saved and copied to clipboard!'
	shot 'maim -u -s -n -m 1' "${msg}"
elif [ "$1" = 'window' ];
then
	msg='Window screenshot saved and copied to clipboard!'
	# TODO: add a margin around the window so that the background is better visible
	shot 'maim -st 9999999 -B -m 1 -u' "${msg}" "convert - ( +clone -background black -shadow 80x3+8+8 ) +swap -background $COLOR -layers merge +repage"
fi

