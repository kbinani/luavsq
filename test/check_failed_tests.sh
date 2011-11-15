thisDirectory=$(cd $(dirname $0);pwd)
files=`ls $thisDirectory/*Test.lua`

for file in $files
do
    (
        cd `dirname $file`
        name=`basename $file`
        result=`lunit $file | grep " failed, " | awk '{ if( $0 !~ / 0 failed, 0 errors/ ) { print; } }'`
        if [ "$result" != "" ]; then
            echo "$name $result"
        fi
    )
done
