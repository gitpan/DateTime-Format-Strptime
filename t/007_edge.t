#!perl -w

# t/007_edge.t - these tests are for edge case bug report errors

use Test::More tests => 3;
use DateTime;
use DateTime::Format::Strptime;

#diag("1.0600 - Midnight assumption");
test(
	pattern   => "%a %b %e %T %Y",
	time_zone => 'Asia/Manila',
	locale    => 'en_PH',
	input     => 'Wed Mar 22 01:00:00 1978',
	epoch     => '259344000',
);






sub test {
	my %arg = @_;

	my $strptime = DateTime::Format::Strptime->new(
		pattern   => $arg{pattern}   || '%F %T',
		locale    => $arg{locale}    || 'en',
		time_zone => $arg{time_zone} || 'UTC',
		on_error  => 'undef',
	);
	isa_ok($strptime, 'DateTime::Format::Strptime');

	my $parsed = $strptime->parse_datetime($arg{input});
	isa_ok($parsed, 'DateTime');

	is($parsed->epoch,$arg{epoch});
}
