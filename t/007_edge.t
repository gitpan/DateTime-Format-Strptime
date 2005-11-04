#!perl -w

# t/007_edge.t - these tests are for edge case bug report errors

use Test::More tests => 10;
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


#diag("1.0601 - Timezone defaults to UTC .. shoudld be floating")
{
	my $parser = DateTime::Format::Strptime->new(
		pattern   => '%F %T',
		locale    => 'en',
		on_error  => 'undef',
	);
	isa_ok($parser, 'DateTime::Format::Strptime');
	my $parsed = $parser->parse_datetime('2005-11-05 09:33:00');
	isa_ok($parsed, 'DateTime');
	is($parsed->time_zone->name,'floating');
}


#diag("1.0601 - Olson Time Zones - %O");
{
	my $parser = DateTime::Format::Strptime->new(
		pattern   => '%F %T %O',
		on_error  => 'undef',
	);
	isa_ok($parser, 'DateTime::Format::Strptime');
	my $parsed = $parser->parse_datetime('2005-11-05 09:33:00 Australia/Melbourne');
	isa_ok($parsed, 'DateTime');
	is($parsed->time_zone->name,'Australia/Melbourne', 'Time zone determined from string');
	is($parsed->epoch,'1131143580', 'Time zone applied to string');
}



sub test {
	my %arg = @_;

	my $strptime = DateTime::Format::Strptime->new(
		pattern   => $arg{pattern}   || '%F %T',
		locale    => $arg{locale}    || 'en',
		time_zone => $arg{time_zone} || 'UTC',
		diagnostic=> $arg{diagnostic}|| 0,
		on_error  => 'undef',
	);
	isa_ok($strptime, 'DateTime::Format::Strptime');

	my $parsed = $strptime->parse_datetime($arg{input});
	isa_ok($parsed, 'DateTime');

	is($parsed->epoch,$arg{epoch});
}
