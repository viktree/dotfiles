#!/bin/zsh
#

patch_spotify(){
	spicetify upgrade
	spicetify restore backup apply
}
