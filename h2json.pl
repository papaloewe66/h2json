use warnings;
use strict;
use JSON;

my $file = shift @ARGV;
die "Usage: $0 filename\n" if not $file or not -f $file;

# input headerfile
open my $fh, '<', $file or die "Can't open $file: $!";
chomp(my @lines = <$fh>);
close $fh;

my $pattern;
my $patternfile = shift @ARGV;
if (not $patternfile) {
    # default pattern 
    # requested pattern
    # pattern for counter as precondition 
    # pattern "#define definename<NUMBER>definename <NUMBER>"
    $pattern = {
        'start' => 'start([0-9]+)adr',
        'end' => 'end([0-9]+)adr',
        'length' => 'length([0-9]+)'
    };
}
else {
    $pattern = decode_json(File2Text($patternfile));
}

my @segment;
foreach (@lines) {
    if (/^\s*#\s*define\s+number\s+([0-9]+)/) {
        if ($1 > 0) {
            foreach (@lines) {
                foreach my $key (keys (%$pattern)) {
                    if (/^\s*#\s*define\s+$pattern->{$key}\s+([0-9]+)/) {
                        $segment[$1]{$key} = $2 ;
                    }
                }
            }
        }
        last;
    }
}

$file =~ s/.h/.json/g;
open $fh, '>', $file or die "Can't open $file: $!";
print $fh to_json( {segment => \@segment},{ascii => 1,pretty => 1});
close $fh;

sub File2Text {
    my ($filename) = @_;
    my $txt = do {    
        open(my $fh, "<:encoding(UTF-8)", $filename)
            or die("Can't open \"$filename\": $!\n");# open for reading
        local $/;                                # slurp entire file
        <$fh>;                                   # read and return file content
    };
    return $txt;
}