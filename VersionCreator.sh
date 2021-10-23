#!/usr/bin/env bash
echo "VersionCreator by Olafcio"
echo "Github: https://github.com/Olafcio1"
echo
echo -n "Version: "
read temp;
echo "Changelog (Markdown file) (type 'exit' and click Enter when you done writing changelog):"
line=1
while [ 1 ]
do
	echo -n "$line "
	read text;
 	if [[ $text == "exit" ]]
	then
		echo "Changelog saved."
		break
	else
		echo "$text">>.changelog-notdone.md
		line=$(( $line + 1 ))
	fi
done
echo
if [[ -d "Version$temp" ]]
then
	echo "This version arleady exists!"
	exit 1
else
	echo "Adding version..."
	mkdir Version$temp
	for i in `ls`
	do
		if [[ $i != "Version$temp" && $i != "VersionCreator.sh" && `echo $i | cut -c 7` != "Version" ]]
		then
			cp -R $i Version$temp/$i
		fi
	done
	mv .changelog-notdone.md Version$temp/changelog.md
	echo "Succesfuly added version!"
	exit 0
fi
