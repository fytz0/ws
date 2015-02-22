ws {
	ws.sh
	wsrc
	install.sh
}

man {
	ws.1
	wsrc.5
}

git { README.md COPYING }

doc {
	README.md
	ws.1
	wsrc.5
}

cmd_test - "nano --mouse" {
	README.me
	COPYING
}
