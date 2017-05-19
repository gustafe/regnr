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

while ( <DATA> ) {
    chomp;
    my ( $number, $who, $date) = split(/\t/, $_);
    $data{$number} = { who => $who?$who:undef,
		       date => $date?$date:undef };
    if ( defined $date ) { push @dates, $date }
}
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
#my ($timestamp, $displaytime) ;

my $timestamp = decompose_date($latest);
# if ( $latest =~ m/(\d{4}-\d{2}-\d{2}) \d{2}:\d{2}:\d{2}/ ) {
#     $timestamp = $latest;
#     $displaytime = $1;
# } elsif ( $latest =~ m/\d{4}-\d{2}-\d{2}/ ) {
#     $timestamp = $latest . ' 00:00:00';
#     $displaytime = $latest;
# } else {
#     die "$latest isn't recognized as a valid string for time!\n";
# }

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
	
# tab separated    
#nr	whom	when
__DATA__
068	Gustaf	2015-09-16 07:27:00
067	Gustaf	2015-08-31 14:36:00
066	Gustaf, Joanna och Viking	2015-08-02 16:32:00
065	Gustaf, Joanna och Viking	2015-08-01 14:15:00
064	Gustaf, Joanna och Viking (bilen vi satt i!)	2015-07-22 15:03:00
063	Gustaf, Joanna och Viking	2015-07-22 15:01:00
062	Gustaf, Joanna och Viking	2015-07-19 14:41:43
061	Gustaf, Joanna och Viking	2015-07-17 19:35:00
060	Gustaf och Björn	2015-07-09 20:32:00
059	Gustaf	2015-07-04 11:08:00
058	Gustaf	2015-06-29 18:04:13
057	Gustaf, Joanna och Viking	2015-06-15 20:21:00
056	Gustaf och Viking	2015-05-27 18:06:00
055	Joanna, Gustaf och Viking	2015-05-24 11:55:00
054	Gustaf	2015-05-08 08:02:23
053	Gustaf	2015-04-27 12:30:00
052	Gustaf och Viking 	2015-04-17 19:12:00
051	Gustaf	2015-04-17 13:12:00
050	Gustaf	2015-04-17 13:12:00
049	Gustaf	2015-04-10 12:03:35
048	Gustaf	2015-04-08 07:28:00
047	Gustaf	2015-04-07 16:50:00
046	Gustaf	2015-04-01 10:19:43
045	Gustaf	2014-12-12 12:00:00
044	Viking, Gustaf och Joanna	2014-11-08 12:00:00
043	Viking och Gustaf	2014-09-20 16:40:00
042	Viking, Gustaf och Joanna	2014-09-14 13:45:00
041	Gustaf	2014-09-05 12:35:00
040	Gustaf	2014-09-04 12:15:00
039	Viking och Gustaf	2014-09-01 20:00:00
038	Gustaf	2014-08-30 12:15:00
037	Gustaf	2014-08-21 13:57:03
036	Joanna, Viking och Gustaf	2014-08-16 12:30:00
035	Gustaf	2014-08-11 17:05:00
034	Gustaf	2014-07-02 18:20:00
033	Gustaf	2014-06-17 19:55:00
032	Viking och Gustaf	2014-06-17 12:22:55
031	Gustaf	2014-06-12 07:30:00
030	Gustaf	2014-06-11 17:02:00
029	Gustaf	2014-06-04 17:23:00
028	Gustaf	2014-06-04 07:49:00
027	Gustaf	2014-05-23 07:23:23
026	Gustaf	2014-05-21 13:00:00
025	Gustaf	2014-05-14 17:50:00
024	Gustaf	2014-05-08 18:09:00
023	Viking, Joanna och Gustaf	2014-05-04 13:20:00
022	Gustaf	2014-05-02 12:49:00
021	Joanna, Viking och Gustaf	2014-04-26 18:12:00
020	Viking och Gustaf	2014-04-25 20:02:00
019	Gustaf	2014-04-09 12:10:21
018	Gustaf	2014-04-04 13:20:00
017	Gustaf	2014-04-04 09:30:00
016	Gustaf	2014-04-03 12:12:00
015	Gustaf	2014-03-29 14:20:06
001
002
003
004
005	Gustaf	2014-01-06 12:36:52
006
007	Gustaf	2014-01-26 13:12:54
008	Gustaf, Joanna och Viking	2014-03-08
009	Gustaf, Joanna och Viking	2014-03-08
010	Gustaf och Viking	2014-03-15 11:25:00
011	Gustaf	2014-03-18
012	Gustaf	2014-03-21 13:13:45
013	Gustaf, Joanna och Viking	2014-03-22
014	Gustaf	2014-03-28 12:20:27
069	Gustaf	2015-10-06 11:55:00
070	Gustaf	2015-10-15 07:22:00
071	Gustaf (en buss, i väntan på buss 71)	2015-10-29 17:21:00
072	Gustaf, Viking och Joanna (en taxi)	2015-11-01 17:02:00
073	Gustaf	2015-11-02 12:12:00
074	Gustaf, Viking och Joanna	2015-11-29 13:00:00
075	Gustaf, Joanna och Viking (vår hyrbil)	2015-12-19 10:00:00
076	Gustaf	2016-01-15 13:10:00
077
078	Joanna och Gustaf	2016-03-12 15:05:00
079	Joanna och Gustaf	2016-03-22 18:30:00
080	Gustaf	2016-04-27 12:45:00
081	Gustaf	2016-04-27 19:11:00
082	Gustaf	2016-05-10 07:56:00
083	Gustaf	2016-05-17 11:55:00
084	Joanna, Gustaf och Viking	2016-05-20 18:16:00
085	Viking, Joanna och Gustaf	2016-06-05 15:12:00
086	Gustaf, Viking och Joanna	2016-06-19 20:35:00
087	Gustaf	2016-06-28 12:32:00
088	Gustaf	2016-07-01 13:17:00
089	Gustaf	2016-07-11 13:07:00
090	Gustaf
091	Viking, Joanna och Gustaf	2016-07-16 13:35:00
092	Gustaf	2016-08-06 12:11:00
093	Gustaf	2016-08-10 13:55:00
094	Gustaf	2016-09-10 14:56:00
095	Joanna, Viking och Gustaf	2016-09-11
096	Gustaf, Viking och Joanna	2016-12-04 17:01:00
097	Gustaf	2017-02-03 17:44:00
098	Gustaf	2017-02-18 15:28:00
099	Gustaf	2017-02-23 17:23:00
100	Gustaf	2017-04-24 14:07:00
101	Gustaf	2017-04-26 12:20:00
102	Gustaf	2017-04-08 17:00:00
103	Viking och Gustaf	2017-05-12 17:50:00
