
alias pull='find "$(pwd)" -type d -depth 1 | xargs -I {} bash -c "if git -C {} rev-parse ; then echo \"Pulling {}\" ; git -C {} pull --rebase &> /dev/null ; fi"'

twitch() {
	if ! hash livestreamer 2>/dev/null; then
		echo "Installing livestreamer"
		sudo pip install livestreamer
	fi

    livestreamer twitch.tv/$1 source
}
