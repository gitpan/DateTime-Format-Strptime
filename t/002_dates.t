# t/002_basic.t - check module dates in various formats

use Test::More tests => 17;
use DateTime::Format::Strptime;

my $object = DateTime::Format::Strptime->new(
	pattern => '%D',
#	time_zone => 'Australia/Melbourne',
	diagnostic => 0,
);

my @tests = (
	# Simple dates
	['%Y-%m-%d',	'1998-12-31'],
	['%y-%m-%d', '98-12-31'],
	['%Y years, %j days', '1998 years, 312 days'],
	['%b %d, %Y', 'Jan 24, 2003'],
	['%B %d, %Y', 'January 24, 2003'],

	# Simple times
	['%H:%M:%S', '23:45:56'],
	['%l:%M:%S %p', '11:34:56 PM'],
	
	# With Nanoseconds
	['%H:%M:%S.%N', '23:45:56.123456789'],
	['%H:%M:%S.%6N', '23:45:56.123456'],
	['%H:%M:%S.%3N', '23:45:56.123'],

	# Timezones
	['%H:%M:%S %z', '23:45:56 +1000'],
	['%H:%M:%S %Z', '23:45:56 AEST', '23:45:56 '],
	['%H:%M:%S %z %Z', '23:45:56 +1000 AEST', '23:45:56 +1000 '],

	# Complex dates
	['%Y;%j = %Y-%m-%d', '2003;56 = 2003-02-25'],
	[q|%d %b '%y = %Y-%m-%d|, q|25 Feb '03 = 2003-02-25|],
);

foreach (@tests) {
	my ($pattern, $data, $expect) = @$_;
	$expect ||= $data;
	$object->pattern($pattern);
	is($object->format_datetime( $object->parse_datetime( $data ) ), $expect, $pattern);
}

SKIP: {
	skip "You don't have the latest DateTime. Older version have a bug whereby 12am and 12pm are shown as 0am and 0pm. You should upgrade.", 1 
		unless $DateTime::VERSION >= 0.11;
	$object->pattern('%l:%M:%S %p');
	is($object->format_datetime( $object->parse_datetime( '12:34:56 AM' ) ), 
		'12:34:56 AM', '%l:%M:%S %p');
}

$object->time_zone('Australia/Perth');
$object->pattern('%Y %H:%M:%S %q');
is($object->format_datetime( $object->parse_datetime( '2003 23:45:56 Australia/Melbourne' ) ), '2003 20:45:56 Australia/Perth', $object->pattern);

