ASEPRITE_BIN=~/.steam/steam/steamapps/common/Aseprite/aseprite

OUT_DIR=out

if [[ "$1" == "clean" ]]; then
    echo "Cleaning..."
    rm -rf $OUT_DIR
    exit 0
fi

mkdir -p $OUT_DIR

echo "Building sprites..."
for f in assets/*.aseprite; do
    out=$OUT_DIR/assets/$(basename $f .aseprite).png
    $ASEPRITE_BIN $f -b --save-as $out
done

echo "Building sound..."
cp assets/*.mp3 $OUT_DIR/assets/