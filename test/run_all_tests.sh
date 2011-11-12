thisDirectory=`echo $(cd $(dirname $0);pwd)`
luavsqPath=$thisDirectory/../tool/luavsq.lua
(
    cd $thisDirectory/../tool/
    make
) > /dev/null

files=`ls $thisDirectory/*Test.lua`

tmpTestFiles=

for filePath in $files
do
    file=`basename $filePath`
    {
        echo "require( \"lunit\" );";
        echo "dofile( \"$luavsqPath\" );";
    } > /tmp/$file
    cat $filePath | sed -e "s/^dofile.*$//g" | sed -e "s/require.*;$//g" >> /tmp/$file
    tmpTestFiles="$tmpTestFiles /tmp/$file"
done

lunit $tmpTestFiles
rm $tmpTestFiles
