#perl file to move copy big only from big to lacie

#	$highres = "no";
	$highres = "yes";

chdir;
open LENGTHLIST, ">>/Volumes/LaCie Disk/sizes.txt";
open FILELIST, "< /Volumes/LaCie Disk/trackfolders.txt" or warn "no open folderslist: $!\n";
chomp ( @folderlist = <FILELIST> );

@folderlist = ( "track blah" );		#type in single name if only one needed

foreach $txt (@folderlist)
{
	print "\nPictures not found:\n";

#	open PICLIST, "< /Documents/photo project/$txt.txt";
	open PICLIST, "< /Volumes/LaCie Disk/photo project/$txt.txt" or warn "unable to open \".txt\": $!\n";
	
	chomp (@piclist = <PICLIST>);

#	$to_dir = "/Volumes/Lacie Disk/big";
	$to_dir = "/Volumes/big/toremove";
	

	open CP, "> /Volumes/LaCie Disk/cp_big_lacie.command";
	print CP "#!/bin/sh\n";

	$total_size_folder_pics = 0;
	$total_size_to_move = 0;

	foreach $picname (@piclist)
	{
		$from_dir = $picname;
		$from_dir =~ s/s(.).+/big \1/;
		$from_dir = "/Volumes/big/photos/$from_dir";
	
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
			

			
			if ( ! -e "$to_dir/$picname" )
			{
			
# one or the other, depending on same or different volume

#				print CP "cp \"$from_dir/$picname\" \"$to_dir/$picname\"\n";
				rename "$from_dir/$picname", "$to_dir/$picname"	or warn "no rename $picname:  $!\n";
				$total_size_to_move += $picsize;
			}
		}
		else
		{   print "$picname\n";	}

	}

	close CP;
	
	$total_size_folder_pics /= (1024*1024);
	$total_size_folder_pics =~ s/(\d+)(\d\d\d)\..+$/\1 \2/;
	print "\n$txt\n\tTotal size:  $total_size_folder_pics MBs\n";
	$total_size_to_move /= (1024*1024);
	$total_size_to_move =~ s/(\d+)(\d\d\d)\..+$/\1 \2/;
	print "\tTotal size to move:  $total_size_to_move MBs\nNow run end_push.plx\n";
	
	chmod 0755, "/Volumes/LaCie Disk/cp_big_lacie.command";



#	print LENGTHLIST "$txt \t$total_size_folder_pics\n";
	
}	#end foreach