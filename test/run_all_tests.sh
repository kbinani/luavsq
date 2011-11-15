thisDirectory=$(cd $(dirname $0);pwd)
luavsqPath=$thisDirectory/../tool/luavsq.lua
(
    cd $thisDirectory/../tool/
    make
) 1> /dev/null

files=`ls $thisDirectory/*Test.lua`

tmpTestFiles=

for filePath in $files
do
    file=`basename $filePath`
    {
        echo "require( \"lunit\" );dofile( \"$luavsqPath\" );";
        cat $filePath | sed -e "s/^dofile.*$//g" | sed -e "s/^require.*;$//g" | sed -e '1d';
    } 1> /tmp/$file
    tmpTestFiles="$tmpTestFiles /tmp/$file"
done

lunit $tmpTestFiles | sed -e "s/^\\/tmp\\///g"
rm $tmpTestFiles
