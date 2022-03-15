#	$lacie = "/Volumes/LaCie Disk/Desktop Folder";
#	open (XML, "<$lacie/txt/exAlbumData.xml") or warn "open exAlbum file:  $!\n";
chdir;
open (XML, "<Pictures/iPhoto Library/AlbumData.xml") or warn "no open Album file:  $!\n";

print "loading xml file\n";

while (<XML>){	$big.=$_;	}

#		<dict>
#			<key>AlbumId</key>
#			<integer>4361</integer>
#			<key>AlbumName</key>
#			<string>a00_07</string>
#			<key>KeyList</key>
#			<array>
#				<string>3922</string>
#				<string>3924</string>
#				<string>3926</string>
#				<string>3928</string>
#				<string>3930</string>
#				<string>3932</string>

print "listing photo list(s)\n";

#	open ALBUMS, "<Documents/allfolderlist.txt";
#	open ALBUMS, "< Documents/trackfolders.txt";
#	chomp (@albumlist = <ALBUMS>);

	@albumlist = ( "relays", "relay missed", "relay fav missed", "stanford", "cal", "ucla", "davis", "relay fav", "fresno missed" );			#if just a few lists

@albumlist = ( "track" );

foreach $myAlbum (@albumlist)

{
	open PICS, ">Documents/photo project/$myAlbum.txt";
	print "$myAlbum \n";

	if ($big =~ 
	m%<string>$myAlbum</string>\s+.+\s+<array>\s+((<string>\d+</string>\s+)+)% )
	{	
		$keyList = $1;
		$keyList =~ s%<string>(\d+)</string>\s+%$1 %g;
		@key = split / /,$keyList;
	}



	for $key ( @key )
	{
#				the {21} is to skip over 21 lines
		if ( $big =~ m%<key>$key</key>\s+(.+\s+){21}(.+)%	)
		{
			$found = $1;

			if ( $found =~ m%/([\da-zA-Z]+\.jpg)% )
			{
				$pic = "$1";
				print PICS "$pic\n";
			}
		}	
	}

	close PICS;



#<key>2171</key>
#		<dict>
#			<key>MediaType</key>
#			<string>Image</string>
#			<key>Caption</key>
#			<string>sw52g07</string>
#			<key>Comment</key>
#			<string></string>
#			<key>Aspect Ratio</key>
#			<real>1.520000</real>
#			<key>Rating</key>
#			<integer>0</integer>
#			<key>Roll</key>
#			<integer>28</integer>
#			<key>DateAsTimerInterval</key>
#			<real>132798925.000000</real>
#			<key>ModDateAsTimerInterval</key>
#			<real>160943094.000000</real>
#			<key>MetaModDateAsTimerInterval</key>
#			<real>160944351.178350</real>
#			<key>ImagePath</key>
#			<string>/Users/lance/Pictures/iPhoto Library/2005/03/17/sw52g07.jpg</string>
#			<key>ThumbPath</key>
#			<string>/Users/lance/Pictures/iPhoto Library/2005/03/17/Thumbs/2171.jpg</string>
#		</dict>

} #end albumlist loop



print "now run combine_lists.plx to merge photo lists into one txt file for cp\n";