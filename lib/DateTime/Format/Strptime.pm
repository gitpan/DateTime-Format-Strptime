package DateTime::Format::Strptime;

use strict;
use DateTime;
use DateTime::Language;
use DateTime::TimeZone;
use Params::Validate qw( validate SCALAR BOOLEAN OBJECT );
use Carp;

use Exporter;
use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK %ZONEMAP %FORMATS);

@ISA = 'Exporter';
$VERSION = '1.0101';
@EXPORT_OK = qw( &strftime &strptime );
@EXPORT = ();

%ZONEMAP = (
     'A' => '+0100',       'ACDT' => '+1030',       'ACST' => '+0930',     
   'ADT' => 'Ambiguous',   'AEDT' => '+1100',        'AES' => '+1000',     
  'AEST' => '+1000',        'AFT' => '+0430',       'AHDT' => '-0900',     
  'AHST' => '-1000',       'AKDT' => '-0800',       'AKST' => '-0900',     
  'AMST' => '+0400',        'AMT' => '+0400',      'ANAST' => '+1300',     
  'ANAT' => '+1200',        'ART' => '-0300',        'AST' => 'Ambiguous', 
    'AT' => '-0100',       'AWST' => '+0800',      'AZOST' => '+0000',     
  'AZOT' => '-0100',       'AZST' => '+0500',        'AZT' => '+0400',     
     'B' => '+0200',       'BADT' => '+0400',        'BAT' => '+0600',     
  'BDST' => '+0200',        'BDT' => '+0600',        'BET' => '-1100',     
   'BNT' => '+0800',       'BORT' => '+0800',        'BOT' => '-0400',     
   'BRA' => '-0300',        'BST' => 'Ambiguous',     'BT' => 'Ambiguous', 
   'BTT' => '+0600',          'C' => '+0300',       'CAST' => '+0930',     
   'CAT' => 'Ambiguous',    'CCT' => 'Ambiguous',    'CDT' => 'Ambiguous', 
  'CEST' => '+0200',        'CET' => '+0100',     'CETDST' => '+0200',     
 'CHADT' => '+1345',      'CHAST' => '+1245',        'CKT' => '-1000',     
  'CLST' => '-0300',        'CLT' => '-0400',        'COT' => '-0500',     
   'CST' => 'Ambiguous',   'CSuT' => '+1030',        'CUT' => '+0000',     
   'CVT' => '-0100',        'CXT' => '+0700',       'ChST' => '+1000',     
     'D' => '+0400',       'DAVT' => '+0700',       'DDUT' => '+1000',     
   'DNT' => '+0100',        'DST' => '+0200',          'E' => '+0500',     
 'EASST' => '-0500',       'EAST' => 'Ambiguous',    'EAT' => '+0300',     
   'ECT' => 'Ambiguous',    'EDT' => 'Ambiguous',   'EEST' => '+0300',     
   'EET' => '+0200',     'EETDST' => '+0300',       'EGST' => '+0000',     
   'EGT' => '-0100',        'EMT' => '+0100',        'EST' => 'Ambiguous', 
  'ESuT' => '+1100',          'F' => '+0600',        'FDT' => 'Ambiguous', 
  'FJST' => '+1300',        'FJT' => '+1200',       'FKST' => '-0300',     
   'FKT' => '-0400',        'FST' => 'Ambiguous',    'FWT' => '+0100',     
     'G' => '+0700',       'GALT' => '-0600',       'GAMT' => '-0900',     
  'GEST' => '+0500',        'GET' => '+0400',        'GFT' => '-0300',     
  'GILT' => '+1200',        'GMT' => '+0000',        'GST' => 'Ambiguous', 
    'GT' => '+0000',        'GYT' => '-0400',         'GZ' => '+0000',     
     'H' => '+0800',        'HAA' => '-0300',        'HAC' => '-0500',     
   'HAE' => '-0400',        'HAP' => '-0700',        'HAR' => '-0600',     
   'HAT' => '-0230',        'HAY' => '-0800',        'HDT' => '-0930',     
   'HFE' => '+0200',        'HFH' => '+0100',         'HG' => '+0000',     
   'HKT' => '+0800',         'HL' => 'local',        'HNA' => '-0400',     
   'HNC' => '-0600',        'HNE' => '-0500',        'HNP' => '-0800',     
   'HNR' => '-0700',        'HNT' => '-0330',        'HNY' => '-0900',     
   'HOE' => '+0100',        'HST' => '-1000',          'I' => '+0900',     
   'ICT' => '+0700',       'IDLE' => '+1200',       'IDLW' => '-1200',     
   'IDT' => 'Ambiguous',    'IOT' => '+0500',       'IRDT' => '+0430',     
 'IRKST' => '+0900',       'IRKT' => '+0800',       'IRST' => '+0430',     
   'IRT' => '+0330',        'IST' => 'Ambiguous',     'IT' => '+0330',     
   'ITA' => '+0100',       'JAVT' => '+0700',       'JAYT' => '+0900',     
   'JST' => '+0900',         'JT' => '+0700',          'K' => '+1000',     
   'KDT' => '+1000',       'KGST' => '+0600',        'KGT' => '+0500',     
  'KOST' => '+1200',      'KRAST' => '+0800',       'KRAT' => '+0700',     
   'KST' => '+0900',          'L' => '+1100',       'LHDT' => '+1100',     
  'LHST' => '+1030',       'LIGT' => '+1000',       'LINT' => '+1400',     
   'LKT' => '+0600',        'LST' => 'local',         'LT' => 'local',     
     'M' => '+1200',      'MAGST' => '+1200',       'MAGT' => '+1100',     
   'MAL' => '+0800',       'MART' => '-0930',        'MAT' => '+0300',     
  'MAWT' => '+0600',        'MDT' => '-0600',        'MED' => '+0200',     
 'MEDST' => '+0200',       'MEST' => '+0200',       'MESZ' => '+0200',     
   'MET' => 'Ambiguous',   'MEWT' => '+0100',        'MEX' => '-0600',     
   'MEZ' => '+0100',        'MHT' => '+1200',        'MMT' => '+0630',     
   'MPT' => '+1000',        'MSD' => '+0400',        'MSK' => '+0300',     
  'MSKS' => '+0400',        'MST' => '-0700',         'MT' => '+0830',     
   'MUT' => '+0400',        'MVT' => '+0500',        'MYT' => '+0800',     
     'N' => '-0100',        'NCT' => '+1100',        'NDT' => '-0230',     
   'NFT' => 'Ambiguous',    'NOR' => '+0100',      'NOVST' => '+0700',     
  'NOVT' => '+0600',        'NPT' => '+0545',        'NRT' => '+1200',     
   'NST' => 'Ambiguous',   'NSUT' => '+0630',         'NT' => '-1100',     
   'NUT' => '-1100',       'NZDT' => '+1300',       'NZST' => '+1200',     
   'NZT' => '+1200',          'O' => '-0200',       'OESZ' => '+0300',     
   'OEZ' => '+0200',      'OMSST' => '+0700',       'OMST' => '+0600',     
    'OZ' => 'local',          'P' => '-0300',        'PDT' => '-0700',     
   'PET' => '-0500',      'PETST' => '+1300',       'PETT' => '+1200',     
   'PGT' => '+1000',       'PHOT' => '+1300',        'PHT' => '+0800',     
   'PKT' => '+0500',       'PMDT' => '-0200',        'PMT' => '-0300',     
   'PNT' => '-0830',       'PONT' => '+1100',        'PST' => 'Ambiguous', 
   'PWT' => '+0900',       'PYST' => '-0300',        'PYT' => '-0400',     
     'Q' => '-0400',          'R' => '-0500',        'R1T' => '+0200',     
   'R2T' => '+0300',        'RET' => '+0400',        'ROK' => '+0900',     
     'S' => '-0600',       'SADT' => '+1030',       'SAST' => 'Ambiguous', 
   'SBT' => '+1100',        'SCT' => '+0400',        'SET' => '+0100',     
   'SGT' => '+0800',        'SRT' => '-0300',        'SST' => 'Ambiguous', 
   'SWT' => '+0100',          'T' => '-0700',        'TFT' => '+0500',     
   'THA' => '+0700',       'THAT' => '-1000',        'TJT' => '+0500',     
   'TKT' => '-1000',        'TMT' => '+0500',        'TOT' => '+1300',     
  'TRUT' => '+1000',        'TST' => '+0300',       'TUC ' => '+0000',     
   'TVT' => '+1200',          'U' => '-0800',      'ULAST' => '+0900',     
  'ULAT' => '+0800',       'USZ1' => '+0200',      'USZ1S' => '+0300',     
  'USZ3' => '+0400',      'USZ3S' => '+0500',       'USZ4' => '+0500',     
 'USZ4S' => '+0600',       'USZ5' => '+0600',      'USZ5S' => '+0700',     
  'USZ6' => '+0700',      'USZ6S' => '+0800',       'USZ7' => '+0800',     
 'USZ7S' => '+0900',       'USZ8' => '+0900',      'USZ8S' => '+1000',     
  'USZ9' => '+1000',      'USZ9S' => '+1100',        'UTZ' => '-0300',     
   'UYT' => '-0300',       'UZ10' => '+1100',      'UZ10S' => '+1200',     
  'UZ11' => '+1200',      'UZ11S' => '+1300',       'UZ12' => '+1200',     
 'UZ12S' => '+1300',        'UZT' => '+0500',          'V' => '-0900',     
   'VET' => '-0400',      'VLAST' => '+1100',       'VLAT' => '+1000',     
   'VTZ' => '-0200',        'VUT' => '+1100',          'W' => '-1000',     
  'WAKT' => '+1200',       'WAST' => 'Ambiguous',    'WAT' => '+0100',     
  'WEST' => '+0100',       'WESZ' => '+0100',        'WET' => '+0000',     
'WETDST' => '+0100',        'WEZ' => '+0000',        'WFT' => '+1200',     
  'WGST' => '-0200',        'WGT' => '-0300',        'WIB' => '+0700',     
   'WIT' => '+0900',       'WITA' => '+0800',        'WST' => 'Ambiguous', 
   'WTZ' => '-0100',        'WUT' => '+0100',          'X' => '-1100',     
     'Y' => '-1200',      'YAKST' => '+1000',       'YAKT' => '+0900',     
  'YAPT' => '+1000',        'YDT' => '-0800',      'YEKST' => '+0600',     
  'YEKT' => '+0500',        'YST' => '-0900',          'Z' => '+0000',     
);

%FORMATS =
    ( 'a' => sub { $_[0]->day_abbr },
      'A' => sub { $_[0]->day_name },
      'b' => sub { $_[0]->month_abbr },
      'B' => sub { $_[0]->month_name },
#      'c' => sub { $_[0]->strftime( $_[0]->{language}->preferred_datetime_format ) },
      'C' => sub { int( $_[0]->year / 100 ) },
      'd' => sub { sprintf( '%02d', $_[0]->day_of_month ) },
      'D' => sub { $_[0]->strftime( '%m/%d/%y' ) },
      'e' => sub { sprintf( '%2d', $_[0]->day_of_month ) },
      'F' => sub { $_[0]->ymd('-') },
      'g' => sub { substr( $_[0]->week_year, -2 ) },
      'G' => sub { $_[0]->week_year },
      'H' => sub { sprintf( '%02d', $_[0]->hour ) },
      'i' => sub { sprintf( '%2d', int($_[0]->day / 7)+1 )},
      'I' => sub { my $h = $_[0]->hour; $h -= 12 if $h >= 12; sprintf( '%02d', $h ) },
      'J' => sub { int(($_[0]->day - 1) / 7) + 1 },
      'j' => sub { $_[0]->day_of_year },
      'k' => sub { sprintf( '%2d', $_[0]->hour ) },
      'K' => sub { sprintf( '%02d', $_[0]->hour + 1 ) },
      'l' => sub { my $h = $_[0]->hour; $h -= 12 if $h >= 12; $h=12 if $h==0; sprintf( '%2d', $h ) },
      'L' => sub { my $h = $_[0]->hour; $h -= 12 if $h > 12; sprintf( '%2d', $h ) },
      'm' => sub { sprintf( '%02d', $_[0]->month ) },
      'M' => sub { sprintf( '%02d', $_[0]->minute ) },
      'n' => sub { "\n" }, # should this be OS-sensitive?
      'N' => \&_format_nanosecs,
      'p' => sub { $_[0]->{language}->am_pm( $_[0] ) },
      'P' => sub { lc $_[0]->{language}->am_pm( $_[0] ) },
      'q' => sub { $_[0]->{tz}->name },
      'Q' => sub { ($_[0]->year > 0) ? 'AD' : 'BC' },
      'r' => sub { $_[0]->strftime( '%I:%M:%S %p' ) },
      'R' => sub { $_[0]->strftime( '%H:%M' ) },
      's' => sub { $_[0]->epoch },
      'S' => sub { sprintf( '%02d', $_[0]->second ) },
      't' => sub { "\t" },
      'T' => sub { $_[0]->strftime( '%H:%M:%S' ) },
      'u' => sub { $_[0]->day_of_week },
      # algorithm from Date::Format::wkyr
      'U' => sub { my $dow = $_[0]->day_of_week;
                   $dow = 0 if $dow == 7; # convert to 0-6, Sun-Sat
                   my $doy = $_[0]->day_of_year - 1;
                   return int( ( $doy - $dow + 13 ) / 7 - 1 )
                 },
      'w' => sub { my $dow = $_[0]->day_of_week;
                   return $dow % 7;
                 },
      'W' => sub { my $dow = $_[0]->day_of_week;
                   my $doy = $_[0]->day_of_year - 1;
                   return int( ( $doy - $dow + 13 ) / 7 - 1 )
                 },
#      'x' => sub { $_[0]->strftime( $_[0]->{language}->preferred_date_format ) },
#      'X' => sub { $_[0]->strftime( $_[0]->{language}->preferred_time_format ) },
      'y' => sub { sprintf( '%02d', substr( $_[0]->year, -2 ) ) },
      'Y' => sub { return $_[0]->year },
      'z' => sub { DateTime::TimeZone::offset_as_string( $_[0]->offset ) },
      'Z' => sub { $_[0]->{tz}->short_name_for_datetime( $_[0] ) },
      '%' => sub { '%' },
    );

$FORMATS{h} = $FORMATS{b};


sub new {
    my $class = shift;
	my %args = validate( @_, {	pattern		=> { type => SCALAR },
								time_zone	=> { type => SCALAR | OBJECT, optional => 1 },
								language	=> { type => SCALAR | OBJECT, default => 'English' },
								diagnostic	=> { type => SCALAR , default => 0 },
                             }
                       );

	# Deal with language
	unless (ref ($args{language})) {
		my $language = DateTime::Language->new(language => $args{language})
			or croak "Could not create language from $args{language}";
		$args{_language} = $language;
	} else {
		$args{_language} = $args{language};
		($args{language}) = ref($args{_language}) =~/::(\w+)[^:]+$/
	}
	
	if ($args{time_zone}) {
		unless (ref ($args{time_zone})) {
			$args{time_zone} = DateTime::TimeZone->new( name => $args{time_zone} )
				or croak "Could not create language from $args{language}";
		}
		$args{set_time_zone} = $args{time_zone};
	} else {
		$args{time_zone} = DateTime::TimeZone->new( name => 'UTC' );
		$args{set_time_zone} = '';
	}
	
	# Deal with the parser
	$args{parser} = _build_parser($args{pattern});
	if ($args{parser}=~/(%[^\/])/) {
		croak "Unidentified token in pattern: $1 in $args{parser}";
	}
	
    return bless \%args, $class;
}

sub pattern {
	my $self = shift;
	my $pattern = shift;
	
	if ($pattern) {
		my $possible_pattern = _build_parser($pattern);
		if ($possible_pattern=~/(%[^\/])/) {
			carp "Unidentified token in pattern: $1 in $pattern. Leaving old pattern intact.";
		} else {
			$self->{parser} = $possible_pattern;
			$self->{pattern} = $pattern;
		}
	}
	return $self->{pattern};	
}

sub language {
	my $self = shift;
	my $language = shift;
	
	if ($language) {
		my $possible_language = DateTime::Language->new(language => $language);
		unless ($possible_language) {
			carp "Could not create language from $language. Leaving old language intact.";
		} else {
			$self->{language} = $language;
			$self->{_language} = $possible_language;
		}
	}
	return $self->{language};	
}

sub time_zone {
	my $self = shift;
	my $time_zone = shift;
	
	if ($time_zone) {
		my $possible_time_zone = DateTime::TimeZone->new( name => $time_zone );
		unless ($possible_time_zone) {
			carp "Could not create time zone from $time_zone. Leaving old time zone intact.";
		} else {
			$self->{time_zone} = $possible_time_zone;
			$self->{set_time_zone} = $self->{time_zone};
		}
	}
	return $self->{time_zone}->name;	
}


sub parse_datetime {
    my ( $self, $time_string ) = @_;
	
	local $^W = undef;

	# Variables from the parser
	my (	$dow_name, 		$month_name,	$century, 		$day, 
			$hour_24, 		$hour_12, 		$doy, 			$month, 
			$minute, 		$ampm, 			$second, 		$week_sun_0, 
			$dow_sun_0,		$dow_mon_1,		$week_mon_1,	$year_100,
			$year,			$iso_week_year_100,				$iso_week_year,
			$epoch,			$tz_offset,		$timezone,		$tz_olsen,
			$nanosecond,
			
			$doy_dt,		$epoch_dt, 		$use_timezone,
		);
			
	# Variables for DateTime
	my (	$Year,			$Month,			$Day,
			$Hour,			$Minute,		$Second,		$Nanosecond,
		) = ();
	
	# Locale-ize the parser
	my $locale_parser = $self->{parser};
		my $ampm_list = join('|', @{$self->{_language}->am_pm_list});
		$ampm_list .= '|' . lc $ampm_list;
		$locale_parser=~s/LOCALE:AMPM/$ampm_list/g;		
		
	# Run the parser
	eval($locale_parser);

	if ($self->{diagnostic}) {
		print qq|
		
Entered     = $time_string
Parser		= $locale_parser
		
dow_name    = $dow_name
month_name  = $month_name
century     = $century
day         = $day
hour_24     = $hour_24
hour_12     = $hour_12
doy         = $doy
month       = $month
minute      = $minute
ampm        = $ampm
second      = $second
nanosecond  = $nanosecond
week_sun_0  = $week_sun_0
dow_sun_0   = $dow_sun_0
dow_mon_1   = $dow_mon_1
week_mon_1  = $week_mon_1
year_100    = $year_100
year        = $year		
tz_offset   = $tz_offset
tz_olsen    = $tz_olsen
timezone    = $timezone
epoch       = $epoch
iso_week_year     = $iso_week_year
iso_week_year_100 = $iso_week_year_100

		|;
	
	}

	croak "Your datetime does not match your format." 
		if (
			($self->{parser}=~/\$dow_name\b/ and $dow_name eq '') or 
			($self->{parser}=~/\$month_name\b/ and $month_name eq '') or 
			($self->{parser}=~/\$century\b/ and $century eq '') or 
			($self->{parser}=~/\$day\b/ and $day eq '') or 
			($self->{parser}=~/\$hour_24\b/ and $hour_24 eq '') or 
			($self->{parser}=~/\$hour_12\b/ and $hour_12 eq '') or 
			($self->{parser}=~/\$doy\b/ and $doy eq '') or 
			($self->{parser}=~/\$month\b/ and $month eq '') or 
			($self->{parser}=~/\$minute\b/ and $minute eq '') or 
			($self->{parser}=~/\$ampm\b/ and $ampm eq '') or 
			($self->{parser}=~/\$second\b/ and $second eq '') or 
			($self->{parser}=~/\$nanosecond\b/ and $nanosecond eq '') or 
			($self->{parser}=~/\$week_sun_0\b/ and $week_sun_0 eq '') or 
			($self->{parser}=~/\$dow_sun_0\b/ and $dow_sun_0 eq '') or 
			($self->{parser}=~/\$dow_mon_1\b/ and $dow_mon_1 eq '') or 
			($self->{parser}=~/\$week_mon_1\b/ and $week_mon_1 eq '') or 
			($self->{parser}=~/\$year_100\b/ and $year_100 eq '') or 
			($self->{parser}=~/\$year\b/ and $year eq '') or
			($self->{parser}=~/\$tz_offset\b/ and $tz_offset eq '') or
			($self->{parser}=~/\$tz_olsen\b/ and $tz_olsen eq '') or
			($self->{parser}=~/\$timezone\b/ and $timezone eq '') or
			($self->{parser}=~/\$epoch\b/ and $epoch eq '')
		); 
		
	# Create a timezone to work with
	if ($tz_offset) {
		$use_timezone = $tz_offset;
	}
	
	if ($timezone) {
		croak "I don't recognise the timezone $timezone." unless $ZONEMAP{$timezone};
		croak "The timezone '$timezone' is ambiguous." if $ZONEMAP{$timezone} eq 'Ambiguous' and not ($tz_offset or $tz_olsen);
		croak "Your timezones ('$tz_offset' and '$timezone') do not match." if $tz_offset and $ZONEMAP{$timezone} ne 'Ambiguous' and $ZONEMAP{$timezone} != $tz_offset;
		$use_timezone = $ZONEMAP{$timezone} if $ZONEMAP{$timezone} ne 'Ambiguous';
	}
	
	if ($tz_olsen) {
		$tz_olsen = ucfirst lc $tz_olsen;
		$tz_olsen =~ s|/(\w)|/\U$1|;
		my $tz = DateTime::TimeZone->new( name => $tz_olsen );
		croak "I son't recognise the time zone '$tz_olsen'." unless $tz;
		$use_timezone = $tz;
	}
	
	$use_timezone = $self->{time_zone} unless ($use_timezone);
	
	print "Using timezone $use_timezone.\n" if $self->{diagnostic};
		
	# If there's an epoch, we're done. Just need to check all the others
	if ($epoch) {
		$epoch_dt = DateTime->from_epoch( epoch => $epoch, time_zone => $use_timezone );

		$Year      = $epoch_dt->year;
		$Month     = $epoch_dt->month;
		$Day       = $epoch_dt->day;

		$Hour      = $epoch_dt->hour;
		$Minute    = $epoch_dt->minute;
		$Second    = $epoch_dt->second;
		$Nanosecond= $epoch_dt->nanosecond;
		
		print $epoch_dt->strftime("Epoch: %D %T.%N\n") if $self->{diagnostic};
	}

	# Work out the year we're working with:
	if ($year_100) {
		if ($century) {
			$Year = (($century * 100) - 0) + $year_100;
		} else {
			if ($year >= 69 and $year <= 99) {
				$Year = 1900 + $year_100;
			} else {
				$Year = 2000 + $year_100;
			}
		}
	}
	if ($year) {
		croak "Your two year values ($year_100 and $year) do not match." if ($Year && ($year != $Year));
		$Year = $year;
	}
	croak "Your year value does not match your epoch." if $epoch_dt and $Year and $Year != $epoch_dt->year;
	
	
	# Work out which month we want
	# Month names
	if ($month_name) {
		croak "There is no use providing a month name ($month_name) without providing a year." unless $Year;
		my $month_count  = 0;
		my $month_number = 0;
		foreach my $month (@{$self->{_language}->month_names}) {
			$month_count++;
			if (lc $month eq lc $month_name) {
				$month_number = $month_count;
				last;
			}
		}
		unless ($month_number) {
			my $month_count = 0;
			foreach my $month (@{$self->{_language}->month_abbreviations}) {
				$month_count++;
				if (lc $month eq lc $month_name) {
					$month_number = $month_count;
					last;
				}
			}
		}
		unless ($month_number) {
			croak "$month_name is not a recognised month in this language.";
		}
		$Month = $month_number;
	}
	if ($month) {
		croak "There is no use providing a month without providing a year." unless $Year;
		croak "$month is too large to be a month of the year." unless $month <= 12;
		croak "Your two month values ($month_name and $month) do not match." if $Month and $month != $Month;
		$Month = $month;
	}
	croak "Your month value does not match your epoch." if $epoch_dt and $Month and $Month != $epoch_dt->month;
	if ($doy) {
		croak "There is no use providing a day of the year without providing a year." unless $Year;
		$doy_dt = DateTime->new(year=>$Year, day=>$doy, time_zone => $use_timezone);
		my $month = $doy_dt->month;
		croak "Your day of the year ($doy - in ".$doy_dt->month_name.") is not in your month ($Month)" if $Month and $month != $Month;
		$Month = $month;
	}
	croak "Your day of the year does not match your epoch." if $epoch_dt and $doy_dt and $doy_dt->doy != $epoch_dt->doy;
	
	
	# Day of the month
	croak("$day is too large to be a day of the month.") unless $day <= 31;
	croak("Your day of the month ($day) does not match your day of the year.") if $doy_dt and $day and $day != $doy_dt->day;
	$Day = ($day) 
		? $day
		: ($doy_dt)
			? $doy_dt->day
			: '';
	if ($Day) {
		croak "There is no use providing a day without providing a month and year." unless $Year and $Month;
		my $dt = DateTime->new(year=>$Year, month=>$Month, day=>$Day, time_zone => $use_timezone); 
		croak "There is no day $Day in $dt->month_name, $Year" 
			unless $dt->month == $Month;
	}
	croak "Your day of the month does not match your epoch." if $epoch_dt and $Day and $Day != $epoch_dt->day;
	
	
	# Hour of the day
	croak("$hour_24 is too large to be an hour of the day.") unless $hour_24 <= 23; #OK so leap seconds will break!
	croak("$hour_12 is too large to be an hour of the day.") unless $hour_12 <= 12;
	croak "You must specify am or pm for 12 hour clocks ($hour_12|$ampm)." if ($hour_12 && (! $ampm));
	if ($ampm=~/p/i) {
		if ($hour_12) {
			$hour_12 += 12 if $hour_12 and $hour_12 != 12;
		}
		croak("Your am/pm value ($ampm) does not match your hour ($hour_24)") if $hour_24 and $hour_24 < 12;
	} elsif ($ampm=~/a/i) {
		if ($hour_12) {
			$hour_12 = 0 if $hour_12 == 12;
		}
		croak("Your am/pm value ($ampm) does not match your hour ($hour_24)") if $hour_24 >= 12;
	}
	if ($hour_12 and $hour_24) {
		croak "You have specified mis-matching 12 and 24 hour clock information" unless $hour_12 == $hour_24;
		$Hour = $hour_24;
	} elsif ($hour_12) {
		$Hour = $hour_12;
	} elsif ($hour_24) {
		$Hour = $hour_24;
	}
	croak "Your hour does not match your epoch." if $epoch_dt and $Hour and $Hour != $epoch_dt->hour;
	print "Set hour to $Hour.\n" if $self->{diagnostic}; 
	
	# Minutes
	croak("$minute is too large to be a minute.") unless $minute <= 59;
	$Minute = $minute;
	croak "Your minute does not match your epoch." if $epoch_dt and $Minute and $Minute != $epoch_dt->minute;
	print "Set minute to $Minute.\n" if $self->{diagnostic}; 
	
	
	# Seconds
	croak("$second is too large to be a second.") unless $second <= 59; #OK so leap seconds will break!
	$Second = $second;
	croak "Your second does not match your epoch." if $epoch_dt and $Second and $Second != $epoch_dt->second;
	print "Set second to $Second.\n" if $self->{diagnostic}; 
	
	
	# Nanoeconds
	croak("$nanosecond is too large to be a nanosecond.") unless length($nanosecond) <= 9;
	$Nanosecond = $nanosecond;
	$Nanosecond .= '0' while length($Nanosecond) < 9;
#	Epoch doesn't return nanoseconds
#	croak "Your nanosecond does not match your epoch." if $epoch_dt and $Nanosecond and $Nanosecond != $epoch_dt->nanosecond;
	print "Set nanosecond to $Nanosecond.\n" if $self->{diagnostic}; 
	
    my $potential_return = DateTime->new(
    	year		=> ($Year		|| 1),
    	month		=> ($Month		|| 1),
    	day			=> ($Day		|| 1),

    	hour		=> ($Hour		|| 0),
    	minute		=> ($Minute     || 0),
    	second		=> ($Second     || 0),
    	nanosecond	=> ($Nanosecond || 0),
    	
    	language	=>	$self->{language},
    	time_zone	=>	$use_timezone,
	);
	
	croak ("Your day of the week ($dow_mon_1) does not match the date supplied: ".$potential_return->ymd) if $dow_mon_1 and $potential_return->dow != $dow_mon_1;

	croak ("Your day of the week ($dow_sun_0) does not match the date supplied: ".$potential_return->ymd) if $dow_sun_0 and ($potential_return->dow % 7) != $dow_sun_0;

	if ($dow_name) {
		my $dow_count  = 0;
		my $dow_number = 0;
		foreach my $dow (@{$self->{_language}->day_names}) {
			$dow_count++;
			if (lc $dow eq lc $dow_name) {
				$dow_number = $dow_count;
				last;
			}
		}
		unless ($dow_number) {
			my $dow_count = 0;
			foreach my $dow (@{$self->{_language}->day_abbreviations}) {
				$dow_count++;
				if (lc $dow eq lc $dow_name) {
					$dow_number = $dow_count;
					last;
				}
			}
		}
		unless ($dow_number) {
			croak "$dow_name is not a recognised day in this language.";
		}
		croak ("Your day of the week ($dow_name) does not match the date supplied: ".$potential_return->ymd) if $dow_number and $potential_return->dow != $dow_number;
	}
	
	croak ("Your week number ($week_sun_0) does not match the date supplied: ".$potential_return->ymd) if $week_sun_0 and $potential_return->strftime('%U') != $week_sun_0;
	croak ("Your week number ($week_mon_1) does not match the date supplied: ".$potential_return->ymd) if $week_mon_1 and $potential_return->strftime('%W') != $week_mon_1;
	croak ("Your ISO week year ($iso_week_year) does not match the date supplied: ".$potential_return->ymd) if $iso_week_year and $potential_return->strftime('%G') != $iso_week_year;
	croak ("Your ISO week year ($iso_week_year_100) does not match the date supplied: ".$potential_return->ymd) if $iso_week_year_100 and $potential_return->strftime('%g') != $iso_week_year_100;
	
	# Move into the timezone in the object - if there is one
	print "Potential Datetime: " . $potential_return->strftime("%F %T %z %Z") . "\n" if $self->{diagnostic};
	print "Setting timezone: " . $self->{set_time_zone} . "\n" if $self->{diagnostic};
	$potential_return->set_time_zone($self->{set_time_zone}) if $self->{set_time_zone};
	print "Actual Datetime: " . $potential_return->strftime("%F %T %z %Z") . "\n" if $self->{diagnostic};
	
	return $potential_return;
}

sub parse_duration {
    croak "DateTime::Format::Strptime doesn't do durations.";
}

sub _format($$) {
	my ($output,$size) = @_;
	$output=~s/^[ 0]+//;
	if ($size >= length($output)) {
		return sprintf("%${size}d",$output) if ($output=~/^\d+$/);
		return sprintf("%${size}s",$output)
	} else {
		return substr($output,-1 * $size) if ($output=~/^\d+$/);
		return substr($output, 0, $size);
	}
}

sub format_datetime {
    my ( $self, $dt ) = @_;
	
	local $^W = undef;

    # make a copy or caller's scalars get munged
    my $f = $self->{pattern};
	$f =~  s/
				%(\d+)N
			/
				$FORMATS{N}->($dt, $1)
			/sgex;
	$f =~  s/
				%(\-?\d+)?([%a-zA-Z])
			/
				$FORMATS{$2} ? ($1) ? _format($FORMATS{$2}->($dt),$1) : $FORMATS{$2}->($dt) : $1.$2
			/sgex;
	return $f
}

sub format_duration {
    croak "DateTime::Format::Strptime doesn't do durations.";
}

sub _format_nanosecs
{
    my $self = shift;
    my $precision = shift;

    my $ret = sprintf( "%09d", $self->{rd_nanosecs} );
    return $ret unless $precision;   # default = 9 digits

    # rd_nanosecs might contain a fractional separator
    my ( $int, $frac ) = split /[.,]/, $self->{rd_nanosecs};
    $ret .= $frac if $frac;

    return substr( $ret, 0, $precision );
}



sub _build_parser {
	my $regex = my $field_list = shift;
	my @fields = $field_list =~ m/(%\d*.)/g;
	$field_list = join('',@fields);

	# I'm absoutely certain there's a better way to do this:
	$regex=~s|([/.-])|\\$1|g;
	
	$regex =~ s/%T/%H:%M:%S/g;
	$field_list =~ s/%T/%H%M%S/g;
	# %T is the time as %H:%M:%S.

	$regex =~ s/%r/%I:%M:%S %p/g; 
	$field_list =~ s/%r/%I%M%S%p/g; 
	#is the time as %I:%M:%S %p.

	$regex =~ s/%R/%H:%M/g;
	$field_list =~ s/%R/%H%M/g;
	#is the time as %H:%M.

	$regex =~ s|%D|%m\\/%d\\/%y|g;
	$field_list =~ s|%D|%m%d%y|g;
	#is the same as %m/%d/%y.

	$regex =~ s|%F|%Y\\-%m\\-%d|g;
	$field_list =~ s|%F|%Y%m%d|g;
	#is the same as %Y-%m-%d - the ISO date format.

	$regex =~ s/%a/(\\w+)/gi; 
	$field_list =~ s/%a/#dow_name#/gi; 
	# %a is the day of the week, using the locale's weekday names; either the abbreviated or full name may be specified.
	# %A is the same as %a.

	$regex =~ s/%[bBh]/(\\w+)/g;
	$field_list =~ s/%[bBh]/#month_name#/g;
	#is the month, using the locale's month names; either the abbreviated or full name may be specified.
	# %B is the same as %b.
	# %h is the same as %b.

	#s/%c//g; 
	#is replaced by the locale's appropriate date and time representation.

	$regex =~ s/%C/([\\d ]?\\d)/g;
	$field_list =~ s/%C/#century#/g;
	#is the century number [0,99]; leading zeros are permitted by not required.

	$regex =~ s/%[de]/([\\d ]?\\d)/g;
	$field_list =~ s/%[de]/#day#/g;
	#is the day of the month [1,31]; leading zeros are permitted but not required.
	#%e is the same as %d.

	$regex =~ s/%[Hk]/([\\d ]?\\d)/g; 
	$field_list =~ s/%[Hk]/#hour_24#/g; 
	#is the hour (24-hour clock) [0,23]; leading zeros are permitted but not required.
	# %k is the same as %H 

	$regex =~ s/%g/([\\d ]?\\d)/g; 
	$field_list =~ s/%g/#iso_week_year_100#/g; 
	# The year corresponding to the ISO week number, but without the century (0-99). 

	$regex =~ s/%G/(\\d{4})/g; 
	$field_list =~ s/%G/#iso_week_year#/g; 
	# The year corresponding to the ISO week number. 

	$regex =~ s/%[Il]/([\\d ]?\\d)/g; 
	$field_list =~ s/%[Il]/#hour_12#/g; 
	#is the hour (12-hour clock) [1-12]; leading zeros are permitted but not required.
	# %l is the same as %I.

	$regex =~ s/%j/(\\d{1,3})/g; 
	$field_list =~ s/%j/#doy#/g; 
	#is the day of the year [1,366]; leading zeros are permitted but not required.

	$regex =~ s/%m/([\\d ]?\\d)/g; 
	$field_list =~ s/%m/#month#/g; 
	#is the month number [1-12]; leading zeros are permitted but not required.

	$regex =~ s/%M/([\\d ]?\\d)/g;
	$field_list =~ s/%M/#minute#/g;
	#is the minute [0-59]; leading zeros are permitted but not required.

	$regex =~ s/%[nt]/\\s+/g; 
	$field_list =~ s/%[nt]//g; 
	# %n is any white space.
	# %t is any white space.

	$regex =~ s/%p/(LOCALE:AMPM)/gi;
	$field_list =~ s/%p/#ampm#/gi;
	# %p is the locale's equivalent of either A.M./P.M. indicator for 12-hour clock.

	$regex =~ s/%s/(\\d+)/g; 
	$field_list =~ s/%s/#epoch#/g; 
	# %s is the seconds since the epoch

	$regex =~ s/%S/([\\d ]?\\d)/g; 
	$field_list =~ s/%S/#second#/g; 
	# %S is the seconds [0-61]; leading zeros are permitted but not required.

	$regex =~ s/%(\d*)N/($1) ? "(\\d{$1})" : "(\\d+)"/eg; 
	$field_list =~ s/%\d*N/#nanosecond#/g; 
	# %N is the nanoseconds (or sub seconds really)

	$regex =~ s/%U/([\\d ]?\\d)/g; 
	$field_list =~ s/%U/#week_sun_0#/g; 
	# %U is the week number of the year (Sunday as the first day of the week) as a decimal number [0-53]; leading zeros are permitted but not required.

	$regex =~ s/%w/([0-6])/g;
	$field_list =~ s/%w/#dow_sun_0#/g;
	# is the weekday as a decimal number [0-6], with 0 representing Sunday.

	$regex =~ s/%u/([1-7])/g;
	$field_list =~ s/%u/#dow_mon_1#/g;
	# is the weekday as a decimal number [1-7], with 1 representing Monday - a la DateTime.

	$regex =~ s/%W/([\\d ]?\\d)/g;
	$field_list =~ s/%W/#week_mon_1#/g;
	#is the week number of the year (Monday as the first day of the week) as a decimal number [0,53]; leading zeros are permitted but not required.

	$regex =~ s/%y/([\\d ]?\\d)/g;
	$field_list =~ s/%y/#year_100#/g;
	# is the year within the century. When a century is not otherwise specified, values in the range 69-99 refer to years in the twentieth century (1969 to 1999 inclusive); values in the range 0-68 refer to years in the twenty-first century (2000-2068 inclusive). Leading zeros are permitted but not required.

	$regex =~ s/%Y/(\\d{4})/g;
	$field_list =~ s/%Y/#year#/g;
	# is the year including the century (for example, 1998).

	$regex =~ s|%q|(\\w+\\/\\w+)|g;
	$field_list =~ s/%q/#tz_olsen#/g;
	# Olsen Time zone.

	$regex =~ s|%z|([+-]\\d{4})|g;
	$field_list =~ s/%z/#tz_offset#/g;
	# Timezone Offset.

	$regex =~ s|%Z|(\\w+)|g;
	$field_list =~ s/%Z/#timezone#/g;
	# The short timezone name.

	$regex =~ s/%%/%/g;
	$field_list =~ s/%%//g;
	# is replaced by %.

	$field_list=~s/#([a-z0-9_]+)#/\$$1, /gi;
	$field_list=~s/,\s*$//;

	return qq|($field_list) = \$time_string =~ /$regex/|;
}

# Exportable functions:

sub strftime {
	my ($pattern, $dt) = @_;
	return $dt->strftime($pattern);
}

sub strptime {
	my ($pattern, $time_string) = @_;
	return DateTime::Format::Strptime->new( pattern => $pattern )->parse_datetime($time_string);
}


1;
__END__

=head1 NAME

DateTime::Format::Strptime - Parse and format strp and strf time patterns

=head1 SYNOPSIS

  use DateTime::Format::Strptime;

  my $Strp = new DateTime::Format::Strptime(
  				pattern 	=> '%T',
  				language	=> 'English',
  				time_zone	=> 'Melbourne/Australia',
  			);
  			
  my $dt = $Strp->parse_datetime('23:16:42');

  $Strp->format_datetime($dt);
	# 23:16:42

=head1 DESCRIPTION

This module replicates most of Strptime for DateTime. Strptime is the
unix command that is the reverse of Strftime. While Strftime takes a
DateTime and outputs it in a given format, Strptime takes a DateTime and
a format and returns the DateTime object associated.

=head1 CONSTRUCTOR

=over 4

=item * new( format=>$strptime_pattern )

Creates the format object. You must specify a pattern, you can also
specify a C<time_zone> and C<language>. If you specify a time zone,
then any resulting DateTime object will be in that time zone. If you
do not specify a time_zone paramter, but there is a time zone in the
string you pass to parse_datetime, then the resulting DateTime will
use that time zone.

=back

=head1 METHODS

This class offers the following methods.

=over 4

=item * parse_datetime($string)

Given a string in the format specified in the constructor, this method
will return a new C<DateTime> object.

If given a string that doesn't match the format, the formatter will
croak.

=item * format_datetime($datetime)

Given a C<DateTime> object, this methods returns a string formatted in
the object's format.

=item * language($language)

When given a language, this method sets its language appropriately.

This method returns the current language. (After processing as above)

=item * pattern($strptime_pattern)

When given a format, this method sets the object's format.

This method returns the current format. (After processing as above)

=item * time_zone($time_zone)

When given a name, offset or DateTime::TimeZone object, this method
sets the object's format. This effects the DateTime object returned
by parse_datetime

This method returns the current format. (After processing as above)

=back

=head1 EXPORTS

There are no methods exported by default, however the following are
available:

=over 4

=item * strptime($strptime_pattern, $string)

Given a format and a string this function will return a new C<DateTime>
object.

=item * strftime($strftime_pattern, $datetime)

Given a format and a C<DateTime> object this function will return a
formatted string.

=back

=head1 STRPTIME PATTERN TOKENS

The following tokens are allowed in the format string for strptime
(parse_datetime):

=over 4

=item * %%

The % character.

=item * %a or %A

The weekday name according to the current locale, in abbreviated form or
the full name.

=item * %b or %B or %h

The month name according to the current locale, in abbreviated form or
the full name.

=item * %C

The century number (0-99).

=item * %d or %e

The day of month (1-31).

=item * %D

Equivalent to %m/%d/%y. (This is the American style date, very confusing
to non-Americans, especially since %d/%m/%y is	widely used in Europe.
The ISO 8601 standard format is %Y-%m-%d.)

=item * %g

The year corresponding to the ISO week number, but without the century
(0-99).

=item * %G

The year corresponding to the ISO week number.

=item * %H

The hour (0-23).

=item * %I

The hour on a 12-hour clock (1-12).

=item * %j

The day number in the year (1-366).

=item * %m

The month number (1-12).

=item * %M

The minute (0-59).

=item * %n

Arbitrary whitespace.

=item * %N

Nanoseconds. For other sub-second values use C<%[number]N>.

=item * %p

The equivalent of AM or PM according to the language in use. (See
L<DateTime::Language>)

=item * %q

The time zone name from the Olsen database. Example 'Australia/Melbourne'

=item * %r

Equivalent to %I:%M:%S %p.

=item * %R

Equivalent to %H:%M.

=item * %s

Number of seconds since the Epoch.

=item * %S

The second (0-60; 60 may occur for leap seconds. See
L<DateTime::LeapSecond>).

=item * %t

Arbitrary whitespace.

=item * %T

Equivalent to %H:%M:%S.

=item * %U

The week number with Sunday the first day of the week (0-53). The first
Sunday of January is the first day of week 1.

=item * %u

The weekday number (1-7) with Monday = 1. This is the DateTime standard.

=item * %w

The weekday number (0-6) with Sunday = 0.

=item * %W

The week number with Monday the first day of the week (0-53). The first
Monday of January is the first day of week 1.

=item * %y

The year within century (0-99). When a century is not otherwise
specified, values in the range 69-99 refer to years in the twen- tieth
century (1969-1999); values in the range 00-68 refer to years in the
twenty-first century (2000-2068).

=item * %Y

The year, including century (for example, 1991).

=item * %z

An RFC-822/ISO 8601 standard time zone specification. (For example
+1100) [See note below]

=item * %Z

The timezone name. (For example EST -- which is ambiguous) [See note
below]

=back

=head1 NOTES

=item * strftime

All references to strftime are now handled internally.

=head1 SUPPORT

Support for this module is provided via the datetime@perl.org email
list. See http://lists.perl.org/ for more details.

Alternatively, log them via the CPAN RT system via the web or email:

http:// bug-datetime-format-strptime@rt.cpan.org

This makes it much easier for me to track things and thus means your
problem is less likely to be neglected.

=head1 LICENSE AND COPYRIGHT

Copyright E<169> Rick Measham, 2003. All rights reserved.

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

The full text of the licenses can be found in the F<LICENCE> file
included with this module.

=head1 AUTHOR

Rick Measham <rickm@cpan.org>

=head1 SEE ALSO

C<datetime@perl.org> mailing list.

http://datetime.perl.org/

L<perl>, L<DateTime>

=cut
