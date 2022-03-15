# starting wit long lists of pictures without .tif extensions
# lists have been divided into a, b, c, etc.
# take list, pic name and look up big photo size

# only s named small files should be in iPhoto
# and and s has been removed from photo name in list file.

$pic_home = "/Volumes/LaCie Disk";			#remember no closing /
#$pic_home = "/Users/lg/Pictures";

 open (XML, "</Users/lg/Pictures/iPhoto Library/AlbumData.xml") or die "no  open .xml file:  $!\n";

@bigdirlist = ("a00to49", "a50to99", "b00to49", "b50to99", "big c"); 



$capacity = 4700000000;  #700 000 000	use 4700000000 for dvd
$disksize = $capacity;

$title = "Modesto Relays\nYears up to 2008";
$team = "relays";								# specify disk name

 print "loading file\n";
 while (<XML>){	$big.=$_; }

$myAlbum = $team;							# specify Album name
if ($big =~ 
m%<string>$myAlbum</string>\s+.+\s+<array>\s+((<string>\d+</string>\s+)+)% )
{	
	$keyList = $1;
	$keyList =~ s%<string>(\d+)</string>\s+%$1 %g;
	@key = split / /,$keyList;
}


for $key ( @key )
{
	if ( $big =~ m%<key>$key</key>\s+(.+\s+){21}(.+)%	)
	{
		$found = $1;
		if ( $found =~ /([ts34567]\w+\.jpg)/ )		#adjust year, but only 's' files present
		{
			$pic = "$1";
			push ( @picname, $pic);
		}
	}	
}


sub by_scan_date	{

	# a sort routine for film page numbers that goes p-z then a-o
	
	if
	(($a lt "sp" ) && ($b ge "sp" )) { 1 } elsif				# switch
	(($a ge "sp" ) && ($b lt "sp" )) { -1 } elsif				# no switch
	($a lt $b ) { -1 } elsif ( $a gt $b ) { 1 } else {0}		# usual ascii
	
}

@picname = sort by_scan_date @picname;

for $picname (@picname )
{
	print "$picname\t";
}

# read a file from @piclist
# lookup size of file in big dir
# add size
# check if done with disk
# read another file


for $picname ( @picname )
{
	if ($picname =~ /s.+/)					#get full small name
	{
		$picname =~ s/s(\w+)\.jpg/$1/;				#get page and frame name

		for $sublist ( @bigdirlist )
		{
			$bigdir = "$pic_home/$sublist";	
						
if ( -e "$bigdir/$picname.png" ) { $picsize  = -s "$bigdir/$picname.png";	last; }			
if ( -e "$bigdir/$picname.jpg" ) { $picsize  = -s "$bigdir/$picname.jpg";	last; }
			
		}
			
		$disksize += $picsize + 1000000;
		if ($disksize > $capacity)
		{
			$disknum++;
print "\t$pic_home/$team\_$disknum\n";
mkdir "$pic_home/$team\_$disknum", 0755 or warn "opendir:  $!\n";
open PICS, ">$pic_home/$team\_$disknum/piclist.txt"or warn "open $disknum: $!\n";
print PICS "$title - disk $disknum\n";
			
			$disksize = $picsize + 900000;
		}
		print PICS "$picname\n";
		print "$picname\t $picsize\t $disksize\n";	
	}
}

$disksize /= 1048576;
$disksize =~ s/\.\d+//;
print "\ndisk = $disknum";
print "\nsize = $disksize megs\n";	