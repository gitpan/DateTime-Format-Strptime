# t/004_croak.t - make sure we croak when we should

use Test::More tests => 20;
use DateTime::Format::Strptime;

$DateTime::Format::Strptime::CROAK = 0;
diag("Turned Croak Off");

my $object = DateTime::Format::Strptime->new(
	pattern => '%Y %D',
	time_zone => 'Australia/Melbourne',
	language => 'English',
	diagnostic => 0,
);

isa_ok(DateTime::Format::Strptime->new(pattern => '%Y'), 'DateTime::Format::Strptime','Legal Pattern in constructor should return DateTime::Format::Strptime object');
is($DateTime::Format::Strptime::errmsg , undef, "Error message should be undef");

is(DateTime::Format::Strptime->new(pattern => '%Y %X'), undef, "Illegal Pattern in constructor should return undef");
is($DateTime::Format::Strptime::errmsg , 'Unidentified token in pattern: %X in %Y %X', "Error message should reflect illegal pattern");

is($object->pattern("%X") , undef, "Illegal Pattern should return undef");
is($DateTime::Format::Strptime::errmsg , 'Unidentified token in pattern: %X in %X. Leaving old pattern intact.', "Error message should reflect illegal pattern");

is($object->parse_datetime("Not a datetime") , undef, "Non-matching date time string should return undef");
is($DateTime::Format::Strptime::errmsg , 'Your datetime does not match your pattern.', "Error message should reflect non-matching datetime");

is($object->parse_datetime("2002 11/30/03") , undef, "Ambiguous date time string should return undef");
is($DateTime::Format::Strptime::errmsg , 'Your two year values (03 and 2002) do not match.', "Error message should reflect Ambiguous date time string");


$DateTime::Format::Strptime::CROAK = 1;
diag("Turned Croak On");

my $return;
eval { $return = DateTime::Format::Strptime->new(pattern => '%Y') };
isa_ok($return, 'DateTime::Format::Strptime','Legal Pattern in constructor should return object and not croak');
is($@, '', "Croak message should be empty");

eval { DateTime::Format::Strptime->new(pattern => '%Y %X') };
isnt($@, undef, "Illegal pattern in constructor should croak");
is(substr($@,0,-4), "Unidentified token in pattern: %X in %Y %X at t/004_croak.t line", "Croak message should reflect illegal pattern");

{   # Make warn die so $@ is set. There's probably a better way.
	local $SIG{__WARN__} = sub { die "WARN: $_[0]" };
	eval { $object->pattern("%X") };
}
isnt($@ , '', "Illegal Pattern should carp");
is(substr($@,0,-4), 'WARN: Unidentified token in pattern: %X in %X. Leaving old pattern intact. at t/004_croak.t line', "Croak message should reflect illegal pattern");

eval { $object->parse_datetime("Not a datetime") };
isnt($@ , '', "Non-matching date time string should croak");
is(substr($@,0,-4), "Your datetime does not match your pattern. at t/004_croak.t line", "Croak message should reflect non-matching datetime");

eval { $object->parse_datetime("2002 11/30/03") };
isnt($@ , '', "Ambiguous date time string should croak");
is(substr($@,0,-4), "Your two year values (03 and 2002) do not match. at t/004_croak.t line", "Croak message should reflect Ambiguous date time string");
