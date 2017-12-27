use Getopt::Long;
use Pod::Usage;

my $NAME = "Data Sorter";
my $VERSION = "1.0.0";

my $file;
my %keep;
my %filter;
my $columns = "";
my @sortOrder = ();
my $ignoreRows = 0;
my $descending = 0;
my $tsv = 0;
my $delimiter = ",";
my $caseInsensitive = 0;
my $help = 0;

GetOptions(
	"file:s" => \$file,
	"columns:s" => \$columns,
	"ignoreheaders:s" => \$ignoreRows,
	"descending" => \$descending,
	"caseinsensitive" => \$caseInsensitive, 
	"tsv" => \$tsv,
	"help" => \$help
);

if ($help) {
	print $NAME . ", version " . $VERSION . "\n";
	pod2usage(
		-input   => "man.pod",
		-verbose => 1,
		-exitval => 0
	);
	exit(0);
}
elsif (!$file) {
	die "Please provide a file\n";
}
elsif ($columns && $columns !~ /^[1-9]\d*(,[1-9]\d*)*$/) {
	die "columns must be numbers separated by commas\n";
}
elsif ($ignoreRows && $ignoreRows !~ /^[1-9]\d*$/) {
	die "ignoreheaders must be a number\n";
}

$file =~ /(.+)\.([^\.]*)$/i;
my $newFile = $1."-sorted.".$2;
open FILE, "< $file"  || die "Please provide a file";
open OUTFILE, "> $newFile";

if (!$columns) {
	push (@sortOrder, "1");
}
else {
	@sortOrder = split(",", $columns);
}

my $sortOrderSize = scalar(@sortOrder);
$delimiter = "\t" if ($tsv || $file =~ /\.tsv$/i);
my $i = 0;
my @unsortedOutput = ();
my $temp = "";

# Copy the to-be-sored columns to the beginning of the line
while (my $line = <FILE>) {
	if ($ignoreRows && $i < $ignoreRows) {
		print OUTFILE "$line";
		$i++;
		next;
	}
	$temp = "";
	my @splitted = split($delimiter, $line);
	foreach (@sortOrder) {
		$temp .= $splitted[$_-1] . $delimiter;
	}
	$temp .= $line;
	push (@unsortedOutput, $temp);
}
close(FILE);

# Can now sort since the to-be-sorted columns are at the beginning of the line.
my @sortedoutput = ();
if ($descending) {
	if ($caseInsensitive) {
		@sortedoutput = reverse sort {lc $a cmp lc $b} (@unsortedOutput);
	}
	else {
		@sortedoutput = reverse sort(@unsortedOutput);
	}
}
else {
	if ($caseInsensitive) {
		@sortedoutput = sort {lc $a cmp lc $b} (@unsortedOutput);
	}
	else {
		@sortedoutput = sort(@unsortedOutput);
	}
}
@unsortedOutput = ();

# Remove the desired columns from the beginning of the line to get back the original line.
foreach (@sortedoutput) {
	my @temp = split($delimiter, $_);
	my $len = scalar(@temp);
	my $newline = "";
	for (my $j = $sortOrderSize; $j < $len; $j++) {
		$newline .= $temp[$j] . $delimiter;
	}
	$newline =~ s/$delimiter$//;
	print OUTFILE $newline;
}

close(OUTFILE);
