use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'DateTime::Format::Strptime',
    VERSION_FROM => 'lib/DateTime/Format/Strptime.pm', # finds $VERSION
    AUTHOR       => 'Rick Measham (rickm@cpan.org)',
    ABSTRACT     => 'Parse and format strp and strf time patterns',
    PREREQ_PM    => {
    	'DateTime'           => 0.13,
    	'DateTime::Language' => 0,
    	'DateTime::TimeZone' => 0.18,
    	'Params::Validate'   => 0,
    	'Carp'               => 0,
    	'Exporter'           => 0,
    },
);
