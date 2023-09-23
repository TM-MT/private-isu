#!/bin/bash

DST_DIR=./public/image

# execute $1 in mysql
exec-query() {
	docker-compose exec -- mysql mysql -u root -proot isuconp -B --execute="$1"
}

DST='images.tsv'
WORKING_DIR='images'
exec-query 'SELECT id,mime,imgdata FROM posts' > "$DST"

mkdir -p $WORKING_DIR
while read -r ID MIME IMGDATA
do
	[[ $ID =~ ^[0-9]+$ ]] || continue
	case $MIME in
		'image/jpeg') EXT='jpg' ;;
		'image/png') EXT='png' ;;
		'image/gif') EXT='gif' ;;
		*) echo "UNKNOWN EXTENSION: " "$EXT"
	esac

	echo "$IMGDATA" | dd of="$WORKING_DIR/$ID.$EXT"
done < $DST

cp $WORKING_DIR/* "$DST_DIR"

# drop
exec-query 'ALTER TABLE posts DROP COLUMN imgdata;'
