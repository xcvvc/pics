# starting with directories big, small, thumb
# starting with "lance to print.txt" file with 
# all the photos listed in "ssomething.jpg"
#
# to have gotten here, ran xmlgrab.plx to make .txt
# and ran cp_bd.plx and photoshop to make s and t files
# cp_bd.plx prints out total pictures size, so
#
# this makes dirs and piclists for each
# dvd or cd disk
#
# uses rename, so no .command file created
# cp_bd.plx may or may not have moved tif png along with jpg resolutions
#
# moves small or thumb, only moves big pics
# for big, small, and thumb picture files
#
chdir;
$pic_home = "/Volumes/LaCie Disk";		#location of big small thumb are and disk dirs to be

					

$capacity = 4700000000;  #700 000 000 for cds

$disksize = $capacity;
$title = "Favorite Photos\nCovering p q r t u v w through negative pages c73";
$team = "favorites";								# specify disk name

	$highres = 'yes';
#	$highres = 'no';

open PICLIST, "< /Volumes/LaCie Disk/photo project/lance to print.txt" or die "unable to open \"lance to print\": $!\n";

chomp (@picname = <PICLIST>);

sub by_scan_date	{

	# a sort routine for film page numbers that goes f-z then a-e
	# page 215 in "learning perl" book
	
	if
	(($a lt "sf" ) && ($b ge "sf" )) { 1 } elsif				# switch
	(($a ge "sf" ) && ($b lt "sf" )) { -1 } elsif				# no switch
	($a lt $b ) { -1 } elsif ( $a gt $b ) { 1 } else {0}		# usual ascii
	
}

@picname = sort by_scan_date @picname;
@picname = reverse @picname;			# put most recent scans to top of list

# read a file from @piclist
# lookup size of file in big dir
# add size
# check if done with disk
# read another file

foreach $picname (@picname)
{
	$picname =~ s/s(.+)\.jpg/\1/;
	
	$small = "s$picname.jpg";
	$thumb = "t$picname.jpg";
		
	$small_size = -s "$pic_home/small/$small";
	$thumb_size = -s "$pic_home/small/$thumb";
	
	$found = 'no';
		
if (-e "$pic_home/big/$picname.psd") { $picname = "$picname.psd"; $found = 'yes'; }
if (-e "$pic_home/big/$picname.tif") { $picname = "$picname.tif"; $found = 'yes'; }
if (-e "$pic_home/big/$picname.png") { $picname = "$picname.png"; $found = 'yes'; }

	if ($highres eq 'no' || $found eq 'no')	
	{
if (-e "$pic_home/big/$picname.jpg") { $picname = "$picname.jpg"; $found = 'yes'; }		
	}
	
	if ( $found eq 'yes' )
	{
		$picsize = -s "$pic_home/big/$picname";
		
		$disksize += $picsize + $small_size + $thumb_size;
		if ($disksize > $capacity)
		{
			$disknum++;

print "\t$pic_home/$team\_$disknum\n";

mkdir "$pic_home/$team\_$disknum", 0755 or warn "no opendir:  $!\n";
close PICS;
open PICS, ">$pic_home/$team\_$disknum/piclist.txt"or warn "no open $disknum: $!\n";

print PICS "$title - disk $disknum\n";
			
			$disksize = $picsize + $small_size + $thumb_size;
		}
		print PICS "$picname\n";
		print "$picname\t $picsize\t $disksize\n";	

print	"rename \"$pic_home/big/$picname\", \"$pic_home/$team\_$disknum/$picname\n\""; 
#print	"rename \"$pic_home/small/$small\", \"pic_home/$team\_$disknum/$small\n\"";
#print 	"rename \"$pic_home/thumb/$thumb\", \"pic_home/$team\_$disknum/$thumb\"";
	}
}			#end foreach $picname
		

$disksize /= 1048576;
$disksize =~ s/\.\d+//;
print "\ndisk = $disknum\n"; 
print "size = $disksize megs\n";	

#		print CP "cp \"$from_dir/$picname\" \"$to_dir/$picname\"\n";
		

