# perl prog to make college photo disks March 2005
# author lance gold tahitinu@holonet.net
# place this .plx file in sub dir of team disk, where "piclist.txt" is found
# example of input picture name:  "w28fa10.jpg" - means page w28 and frame 10a

$full_top_path = "/Users/lg";
$top_dir = "Pictures";
$teamdir = "$top_dir/sonoma_1";
$big_dir = "$top_dir/sonoma";
$small_dir = "$big_dir/s-sonoma";
$thumb_dir = "$big_dir/t-sonoma";

#piclist.txt is in home directory -- the subdir of team disk
# $disktitle is first line of file, $diskhead is second line

open (INF, "< piclist.txt") || die "can't open it: $!";

$disktitle = <INF>;
chomp $disktitle;
$diskhead = <INF>;
chomp $diskhead;

open (OUT, "> start.html") || die "can't open it: $!";
print OUT<<top_of_html

<html>
<head>
<title>$disktitle</title>
<i><b><center><big>$diskhead
</big></center></b></i>
</head>
<body>
<br>
<table width=\"95%\">
<tr>
<td colspan=3 align=center>archive</td>

</tr>

top_of_html
;

print OUT<<top_of_table

<tr><td colspan=3><hr></td></tr>
<tr>

top_of_table
;

$column=1;

while (<INF>)
{

# pattern matching:  $1 is first three char, $2 is rest

	/(w\d\d)([fg].)\.(jpg|png)/;
	
	$page = $1;
	$frame = $2;
	$ext = $3;
	$big = "$page$frame.$ext";
	$small = "s$page$frame.jpg";
	$thumb = "t$page$frame.jpg";
	
	
print OUT<<middle_of_html

	<td>

	<table>
	<tbody>
	<tr>

	<td colspan=3 align=center>
	<img src="pics/$thumb"></td>
	</tr><tr>
	<td align=right>page $page</td>
	<td align=center>-</td>
	<td align=left>frame $frame</td>
	</tr><tr>
	<td align=right>show</td>
	<td align=center><a href="pics/$small">small</td>
	<td align=left><a href="pics/$big">big</td>

	</tr>

	</tbody>
	</table>

	</td>
	

middle_of_html
;

	$column++;
	if($column > 3)
	{
		$column=1;
		print OUT "</tr><tr><td colspan=3><hr></td></tr>";
	}
}

close INF;


print OUT<<end_of_html

</table>

<br>
<div><small>Note that not much spot removal was done.
So you may want to spend time with your photo software's
'rubber stamp' tool erasing the spots that appear from dust on the 
negatives.  Adjustments to color may be needed also. Your patience is
greatly appreciated.
</small></div>

</body>
</html>

end_of_html
;

#copy additional files to subdirectory

close INF;

open (INF, "< piclist.txt") || die "can't open it: $!";
open (BATCHOUT, "> moveback.command") || die "can't open it;  $!";
open (BATCHIN, "> move1st.command") || die "can't open it,  $!";

print BATCHIN "#!/bin/sh\n";
print BATCHIN "cd\n";
print BATCHIN "mkdir $teamdir/pics\n";
 
print BATCHOUT "#!/bin/sh\n";
print BATCHOUT "cd\n";

#skip over first two records <head> <title> in input file
<INF>;
<INF>;

while (<INF>)
{
	chomp;

	chdir "$full_top_path/$big_dir";				# needed for perl working dir -e use
	
	if
	( -e "$_.jpg" ) { $big = "$_.jpg"; } elsif
	( -e "$_.png" ) { $big = "$_.png"; } else { print "unable to find big $_ file.\n"; }

	$small = "s$_.jpg";
	$thumb = "t$_.jpg";
	
#note the unix (mac os x) file syntax here with forward slashes /, not double \\s

	print BATCHIN "mv $small_dir/$small $teamdir/pics/$small\n";
	print BATCHIN "mv $thumb_dir/$thumb $teamdir/pics/$thumb\n";
	print BATCHIN "mv $big_dir/$big $teamdir/pics/$big\n";

	print BATCHOUT "mv $teamdir/pics/$small $small_dir/$small\n";
	print BATCHOUT "mv $teamdir/pics/$thumb $thumb_dir/$thumb\n";
	print BATCHOUT "mv $teamdir/pics/$big $big_dir/$big\n";
	
}

print BATCHIN "cat piclist.txt\n";

close INF;
close BATCHIN;
close BATCHOUT;
