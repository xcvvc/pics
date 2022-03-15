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
#
# moves small or thumb, only moves big pics
# for big, small, and thumb picture files
#

$pic_home = "/Volumes/LaCie Disk";		#location of big small thumb are and disk dirs to be

$title = "Favorite Photos\nCovering p q r t u v w through negative pages c73 and ";
$team = "favorites";								# specify disk name

#	$highres = "yes";
	$highres = "no";

open PICLIST, "</Volumes/LaCie Disk/photo project/lance to print.txt" or warn "unable to open lance to print: $!\n";

chomp (@picname = <PICLIST>);

sub by_scan_date	{

	# a sort routine for film page numbers that goes p-z then a-o
	# page 215 in "learning perl" book
	
	if
	(($a lt "sp" ) && ($b ge "sp" )) { 1 } elsif				# switch
	(($a ge "sp" ) && ($b lt "sp" )) { -1 } elsif				# no switch
	($a lt $b ) { -1 } elsif ( $a gt $b ) { 1 } else {0}		# usual ascii
	
}

@picname = sort by_scan_date @picname;
@picname = reverse @picname;			# put most recent scans to top of list

# read a file from @piclist
# lookup size of file in big dir
# add size
# check if done with disk
# read another file


mkdir "$pic_home/$team", 0755 or warn "no opendir:  $!\n";
open PICS, ">$pic_home/$team/piclist.txt"or warn "no open $team: $!\n";
print PICS "$title\n";
			
foreach $picname (@picname)	
{
		print PICS "$picname\n";	
		$small = $picname;
		$thumb = $picname;
		$thumb ~= s/^s/t/;		# matches begining of string page 108 in Learning Perl text
		$picname ~= s/^s(.+)\.jpg/\1/;

		$found = 'no';
		
if (-e "$pic_home/big/$picname.psd") { $picname = "$picname.psd"; $found = 'yes'; }
if (-e "$pic_home/big/$picname.tif") { $picname = "$picname.tif"; $found = 'yes'; }
if (-e "$pic_home/big/$picname.png") { $picname = "$picname.png"; $found = 'yes'; }

	if ($highres('no') || $found('no') )			# page 142 in Learning Perl text
	{
if (-e "$pic_home/big/$picname.jpg") { $picname = "$picname.jpg"; $found = 'yes'; }
	}
	
	if ( $found eq 'yes' )
	{		
print	"rename \"$pic_home/big/$picname\", \"$pic_home/$team/$picname\" or warn \"no rename $picname: $!\n\""; 
print	"rename \"$pic_home/small/$small\", \"pic_home/$team/$small\" or warn \"no rename $small: $!\n\"";
print 	"rename \"$pic_home/thumb/$thumb\", \"pic_home/$team/$thumb\" or warn \"no rename $thumb: $!\n\"";

	}


