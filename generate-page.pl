#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw (max);
my %data;
my @dates;

sub decompose_date {
    my ($datestring) = @_;
    if ( $datestring =~ m/(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})/)  {
	return { date => $1, time => $2 };
    } elsif ( $datestring =~ m/\d{4}-\d{2}-\d{2}/ ) {
	return { date => $datestring, time => '00:00:00' };
    } else {
	die "can't recognize datestring: $datestring\n";
    }
}

open F, "<data.txt" or die "can't open file data.txt: $!";

while ( <F> ) {
    chomp;
    my ( $number, $who, $date) = split(/\t/, $_);
    $data{$number} = { who => $who?$who:undef,
		       date => $date?$date:undef };
    if ( defined $date ) { push @dates, $date }
}
close F;
my $next = max (keys %data) + 1;
@dates = sort {$b cmp $a} @dates;
my $offset = $next%5;
print "</script>
<style>
li:nth-child(5n+$offset) {
    background: \#ececec;
}
</style>
</head>
<body>
";

my $latest = shift @dates;
if ( $next == 1000 ) {
    print "<h1>Alla nummer har hittats!</h1>\n";
} else {
    printf("<h1>Nästa nummer: %03d</h1>\n", $next);
}

### print the time since last found

my $timestamp = decompose_date($latest);

printf("<p>Förra numret hittades <span id='latest' title='%s'>%s</span>.</p>\n", $timestamp->{date} . ' '. $timestamp->{time}, $timestamp->{date});
print "<p><ul>\n";
foreach my $number ( sort {$b <=> $a } keys %data ) {
    my ($who, $datestring) = ( $data{$number}->{who}, $data{$number}->{date} );
    
    if ( defined $who and defined $datestring ) {
	my $ymd = decompose_date($datestring)->{date};
	printf("<li>%03d hittades %s av %s</li>\n", $number, $ymd,$who);
    } elsif ( defined $who ) {
	printf("<li>%03d hittades av %s</li>\n", $number, $who);
    } elsif ( defined $datestring ) {
	my $ymd = decompose_date($datestring)->{date};
	printf("<li>%03d hittades %s</li>\n", $number, $ymd);
    } else {
	printf("<li>%03d har hittats</li>\n", $number);
    }
}
print "</ul></p>\n"
