#perl file to move copy big and small from bd to lacie

#	$highres = "no";
	$highres = "yes";

chdir;
print "\n";
#	open PICLIST, "<Documents/photo project/tract.txt";
open PICLIST, "</Volumes/LaCie Disk/photo project/lance to print.txt" or warn "unable to open \"lance to print\": $!\n";

chomp (@piclist = <PICLIST>);

$to_dir = "/Volumes/Lacie Disk/big";

open CP, "> /Volumes/LaCie Disk/cp_bd.command";
print CP "#!/bin/sh\n";

$total_size_folder_pics = 0;

foreach $picname (@piclist)
{
	$from_dir = $picname;
	$from_dir =~ s/s(.).+/big \1/;
	$from_dir = "/Volumes/bd/$from_dir";
	
	$picname =~ s/s(.+)\.jpg/\1/;
	
	$small_size = -s "$pic_home/small/s$picname.jpg";
	$thumb_size = -s "$pic_home/small/t$picname.jpg";
	
	$found = 'no';
		
if (-e "$from_dir/$picname.psd") { $picname = "$picname.psd"; $found = 'yes'; }
if (-e "$from_dir/$picname.tif") { $picname = "$picname.tif"; $found = 'yes'; }
if (-e "$from_dir/$picname.png") { $picname = "$picname.png"; $found = 'yes'; }

	if ($highres eq 'no' || $found eq 'no' )			# page 142 in Learning Perl text
	{
if (-e "$from_dir/$picname.jpg") { $picname = "$picname.jpg"; $found = 'yes'; }
	}
	
	if ( $found eq 'yes' )
	{
		$picsize = -s "$from_dir/$picname";
		$total_size_folder_pics += $picsize + $small_size + $thumb_size;
		
		print CP "cp \"$from_dir/$picname\" \"$to_dir/$picname\"\n";		
#		rename "$from_dir/$picname", "$to_dir/$picname"	or warn "no rename $picname:  $!\n";
	}
	else
	{   print "$picname\n";	}

}

close CP;
$total_size_folder_pics /= (1024*1024);
print "\n	Total size:  $total_size_folder_pics\n";
chmod 0755, "~/Documents/cp_bd.command";
