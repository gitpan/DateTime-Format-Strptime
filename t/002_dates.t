# t/002_basic.t - check module dates in various formats

use Test::More tests => 9;
use DateTime::Format::Strptime;

my $object = DateTime::Format::Strptime->new(
	pattern => '%D',
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
	['%l:%M:%S %p', '12:34:56 PM'],

	# Complex dates
	['%Y;%j = %Y-%m-%d', '2003;56 = 2003-02-25'],
	[q|%d %b '%y = %Y-%m-%d|, q|25 Feb '03 = 2003-02-25|],
);

foreach (@tests) {
	my ($pattern, $data) = @$_;
	$object->pattern($pattern);
	ok($object->parse_datetime( $data )->strftime($pattern) eq $data, $pattern);
}