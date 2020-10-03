DIST_DIR=LD47
LOVE_DIST=builddep/love-11.3-win64 

./package.sh

rm -rf $DIST_DIR
cp -r $LOVE_DIST $DIST_DIR

cat ld47.love >> $DIST_DIR/love.exe

zip -r ld47.zip $DIST_DIR
rm -rf $DIST_DIR
