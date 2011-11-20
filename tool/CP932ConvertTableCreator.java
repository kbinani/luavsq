import java.io.*;
import java.net.*;
import java.util.*;

/**
 * unicode.orgからcp932 => utf8の文字コードマップをダウンロードし、
 * utf-8からcp932への変換テーブルを表現するluaスクリプトを作成する
 */
class CP932ConvertTableCreator
{
    public static void main( String[] args )
        throws Exception
    {
        String url = "http://www.unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP932.TXT";
        File cp932map = File.createTempFile( "cp932", ".txt" );
        download( url, cp932map.getAbsolutePath() );
        TreeMap<String, String> rawMap = getTable( cp932map.getAbsolutePath() );

        TreeMap<Integer, TreeMap<Integer, int[]>> map = getTableDetail( rawMap );

        printDetailMap( map, System.out );
    }

    private static void printDetailMap( TreeMap<Integer, TreeMap<Integer, int[]>> map, PrintStream stream )
        throws Exception
    {
        stream.println( "{" );
        for( Iterator<Integer> i = map.keySet().iterator(); i.hasNext(); ){
            int firstByte = i.next().intValue();
            stream.println( "    [" + firstByte + "] = {" );
            stream.print( "        " );
            int count = 0;
            for( Iterator<Integer> j = map.get( firstByte ).keySet().iterator(); j.hasNext(); ){
                count++;
                if( count % 25 == 0 ){
                    stream.println( "" );
                    stream.print( "        " );
                }
                int secondByte = j.next().intValue();
                stream.print( "[" + secondByte + "] = { " );
                int[] cp932bytes = map.get( firstByte ).get( secondByte );
                for( int k = 0; k < cp932bytes.length - 1; k++ ){
                    stream.print( cp932bytes[k] + ", " );
                }
                stream.print( cp932bytes[cp932bytes.length - 1] + " }, " );
            }
            stream.println( "" );
            stream.println( "    }," );
        }
        stream.println( "};" );
    }

    /**
     * utf8の文字コードとcp932の文字コードの紐付けを格納したマップから、
     * firstByte, secondByteに階層化されたマップを取得する
     * 例えば、
     *     { "814A" => "309B" }
     * を
     *     { 0x81 => { 0x4a => { 0x30, 0x9B } } }
     * に変換する
     */
    private static TreeMap<Integer, TreeMap<Integer, int[]>> getTableDetail( TreeMap<String, String> map )
    {
        TreeMap<Integer, TreeMap<Integer, int[]>> result = new TreeMap<Integer, TreeMap<Integer, int[]>>();
        for( Iterator<String> itr = map.keySet().iterator(); itr.hasNext(); ){
            String utf8 = itr.next();
            String cp932 = map.get( utf8 );
            int[] utf8bytes = null;
            int[] cp932bytes = null;
            try{
                utf8bytes = getBytesFromString( utf8 );
                cp932bytes = getBytesFromString( cp932 );
            }catch( Exception e ){
                e.printStackTrace();
                continue;
            }

            if( false == result.containsKey( utf8bytes[0] ) ){
                result.put( utf8bytes[0], new TreeMap<Integer, int[]>() );
            }
            result.get( utf8bytes[0] ).put( utf8bytes[1], cp932bytes );
        }
        return result;
    }

    /**
     * "01ff"などの16進数の数値を、intの配列に変換する
     * @param String hex 16進数の数値。ただし、桁数は2または4のみ
     * @return int[]
     */
    private static int[] getBytesFromString( String hex )
        throws Exception
    {
        if( hex.length() == 2 ){
            String firstByteString = hex.substring( 0, 2 );
            int firstByte = Integer.parseInt( firstByteString, 16 );
            int[] result = { firstByte };
            return result;
        }else if( hex.length() == 4 ){
            String firstByteString = hex.substring( 0, 2 );
            String secondByteString = hex.substring( 2 );
            int firstByte = Integer.parseInt( firstByteString, 16 );
            int secondByte = Integer.parseInt( secondByteString, 16 );
            int[] result = { firstByte, secondByte };
            return result;
        }else{
            throw new Exception( "hexの長さは2または4でないといけない" );
        }
    }

    /**
     * unicode.orgからダウンロードしたcp932 => UTF8のマッピング文書を読み込み、
     * utf8 => cp832のマップを連想配列として取得する
     * @param String file
     * @retrun TreeMap<String, String>
     */
    private static TreeMap<String, String> getTable( String file )
    {
        TreeMap<String, String> map = new TreeMap<String, String>();
        BufferedReader reader = null;
        try{
            reader = new BufferedReader( new InputStreamReader( new FileInputStream( file ), "UTF8" ) );
            while( reader.ready() ){
                String line = reader.readLine();
                if( line.startsWith( "#" ) ){
                    continue;
                }
                String[] tokens = line.split( "\t" );
                if( tokens.length < 2 ){
                    continue;
                }
                String utf8 = tokens[1];
                utf8 = utf8.replace( " ", "" );
                if( utf8.length() == 0 ){
                    continue;
                }
                utf8 = utf8.substring( 2 );
                String cp932 = tokens[0].substring( 2 );
                map.put( utf8, cp932 );
            }
        }catch( Exception e ){
        }finally{
            if( reader != null ){
                try{
                    reader.close();
                }catch( Exception e ){}
            }
        }
        return map;
    }

    /**
     * 指定されたURLのハイパーテキストを、指定されたファイルパスに保存する
     * @param String url
     * @param String destinationFilePath
     */
    public static void download( String url, String destinationFilePath )
    {
        try{
            URL rawUrl = new URL( url );
            URLConnection conn = rawUrl.openConnection();
            InputStream in = conn.getInputStream();

            File file = new File( destinationFilePath );
            FileOutputStream out = new FileOutputStream( file, false );
            byte[] bytes = new byte[512];
            while( true ){
                int ret = in.read( bytes );
                if( ret == 0 ){
                    break;
                }
                out.write( bytes, 0, ret );
            }
            out.close();
            in.close();
        }catch( Exception e ){
        }
    }
}
