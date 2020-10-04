DIST_DIR=EuclidsTomb
LOVE_DIST=builddep/love-11.3-win64 

./package.sh

rm -rf $DIST_DIR
cp -r $LOVE_DIST $DIST_DIR

cp -r lua_modules $DIST_DIR/
mv $DIST_DIR/{love.exe,EuclidsTomb.exe}
cat EuclidsTomb.love >> $DIST_DIR/EuclidsTomb.exe

zip -r EuclidsTomb.zip $DIST_DIR
rm -rf $DIST_DIR
