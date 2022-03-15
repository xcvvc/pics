# perl prog to combine .txt files in folderlist to one list for copying pic files
#


open FOLDERS, "< /Volumes/LaCie Disk/folderlist.txt" or warn "no open folderlist: $!\n";
chomp (@folders = <FOLDERS>);

foreach $folder (@folders)
{
	open PICLIST, "</Volumes/LaCie Disk/Photo Project/$folder.txt" or warn "no open txt: $!\n";
	chomp (@piclist = <PICLIST>);

	push @list_small_pics, @piclist;
}
@list_small_pics = sort @list_small_pics;

open LONG, ">/Volumes/LaCie Disk/colleges.txt" or warn "no open colleges:  $!\n";
foreach $pic (@list_small_pics)
{
	print LONG "$pic\n";
}


print "Now ready to do the cp_big_lacie.plx.\n";